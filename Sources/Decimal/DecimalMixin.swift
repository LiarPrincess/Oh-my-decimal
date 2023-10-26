// swiftlint:disable line_length

/// Internal protocol for all of the helpers.
///
/// All of the functions start with `_` to avoid clashes with `public` methods
/// from `DecimalFloatingPoint`.
internal protocol DecimalMixin {

  associatedtype BID: BinaryIntegerDecimal
  /// Two times wider than a normal BID. Much wow!
  associatedtype DoubleBID: DoubleWidthBinaryIntegerDecimal where DoubleBID.Half == BID

  // Layout:
  // |Field     |Sign|Combination|Trailing significand|
  // |Short name|S   |G          |T                   |
  // |Width     |1   |w+5        |t=J*10 bits         |
  //
  // See IEEE-754 2008:
  // - 3.5.2 Encodings
  // - Table 3.6 — Decimal interchange format parameters

  /// IEEE-754: G, combination field; width: w+5 where w = biased exponent width
  ///
  /// A `w+5` bit combination field `G` encoding classification and, if the encoded
  /// datum is a finite number, the exponent `q` and four significand bits
  /// (1 or 3 of which are implied). The biased exponent `E` is a `w+2` bit quantity
  /// `q + bias`, where the value of the first two bits of the biased exponent taken
  /// together is either 0, 1, or 2.
  static var combinationWidth: Int { get }
  /// IEEE-754: `bias = emax + p − 2`
  static var exponentBias: Int { get }
  /// IEEE-754: `emax = 3×2^(w−1)`
  ///
  /// - Important:
  /// This is the exponent for the `9.999… * 10^emax` form (notice the decimal
  /// separator position). Most of the time you want `9999… * 10^(emax-p+1)`,
  /// so use `Self.maxSignedExponent` instead.
  static var emax: Int { get }

  /// IEEE-754: t, trailing significand field width in bits
  ///
  /// A t-bit trailing significand field `T` that contains `J*10 bits` and contains
  /// the bulk of the significand. When this field is combined with the leading
  /// significand bits from the combination field, the format encodes a total
  /// of `p = 3*J+1` decimal digits.
  static var trailingSignificandWidth: Int { get }
  /// IEEE-754: p, precision in digits
  static var precisionInDigits: Int { get }
  /// The maximum value of the binary-encoded significand is 10^(3×J + 1) −1.
  ///
  /// This is used in `greatestFiniteMagnitude`, but also while checking the
  /// canonical value of encoded significand (it has to be below those digits).
  ///
  /// For example `9_999_999_999_999_999` (`9` repeated `Self.precisionInDigits` times).
  /// Group by 3 digits to easy spot `J`.
  static var maxDecimalDigits: BID { get }
  /// Decimal digits for pi (count: `Self.precisionInDigits`).
  ///
  /// For example `3_141_592_653_589_793`.
  /// Group by 3 digits to easy spot `J`.
  ///
  /// Parse https://www.piday.org/million to ensure the correct rounding of last digit.
  static var piDecimalDigits: BID { get }

  var bid: BID { get }

  /// Use `init(canonical)` instead.
  init(unchecked bid: BID)
}

extension DecimalMixin {

  /// IEEE-754: `emin = 1 − emax`
  internal static var emin: Int { 1 - Self.emax }

  /// Min exponent in `9999E-123` form. Biased `0`.
  internal static var minSignedExponent: Int {
    // Biased exponent = 0
    // Signed exponent = Biased exponent - bias = -bias
    return -Self.exponentBias
  }

  /// Max exponent in `9999E+123` form. `emax - p + 1`.
  internal static var maxSignedExponent: Int {
    // Go from `1.23… * 10^exponent`
    // to      `123…  * 10^(exponent - Self.precisionInDigits + 1)`.
    return Self.emax - Self.precisionInDigits + 1
  }

  // MARK: - Width

  /// IEEE-754: k, storage width in bits
  internal static var bitWidth: Int { BID.bitWidth }
  /// IEEE-754: s, 1-bit sign S
  internal static var signWidth: Int { 1 }
  /// IEEE-754: w = combination field (G) width - 5
  internal static var combinationExponentWidth: Int { Self.combinationWidth - 5 }
  /// Highest 2 bits of combination.
  internal static var combinationHighBitsWidth: Int { 2 }

  // MARK: - Masks

  internal static var signMask: BID { 1 << (Self.bitWidth - Self.signWidth) }
  /// All `1` in `T`.
  internal static var trailingSignificandMask: BID { (1 << Self.trailingSignificandWidth) - 1 }

  /// G[0] = 0, G[1] = 0
  internal static var combinationHighBits00Mask: BID { 0b00 << (Self.bitWidth - Self.signWidth - 2) }
  /// G[0] = 0, G[1] = 1
  internal static var combinationHighBits01Mask: BID { 0b01 << (Self.bitWidth - Self.signWidth - 2) }
  /// G[0] = 1, G[1] = 0
  internal static var combinationHighBits10Mask: BID { 0b10 << (Self.bitWidth - Self.signWidth - 2) }
  /// G[0] = 1, G[1] = 1
  internal static var combinationHighBits11Mask: BID { 0b11 << (Self.bitWidth - Self.signWidth - 2) }

  internal static var infinityMask:     BID { 0b11_1100 << (Self.bitWidth - Self.signWidth - 6) }
  internal static var nanQuietMask:     BID { 0b11_1110 << (Self.bitWidth - Self.signWidth - 6) }
  internal static var nanSignalingMask: BID { 0b11_1111 << (Self.bitWidth - Self.signWidth - 6) }

  /// If G0 through G4 are 11111, then v is NaN regardless of S.
  /// Furthermore, if G5 is 1, then r is sNaN; otherwise r is qNaN.
  ///
  /// The remaining bits of G are ignored, and T constitutes the NaN’s payload,
  /// which can be used to distinguish various NaNs.
  /// The NaN payload is encoded similarly to finite numbers described below,
  /// with G treated as though all bits were zero. The payload corresponds to
  /// the significand of finite numbers, interpreted as an integer with a maximum
  /// value of 10^(3×J) − 1, and the exponent field is ignored (it is treated as
  /// if it were zero).
  /// A NaN is in its preferred (canonical) representation if the bits G6 through
  /// Gw + 4 are zero and the encoding of the payload is canonical.
  internal static var nanPayloadWidth: Int { Self.trailingSignificandWidth }
  internal static var nanPayloadMask:  BID { Self.trailingSignificandMask }

  /// The maximum value of the binary-encoded significand is the same as that of
  /// the corresponding decimal-encoded significand; that is, 10^(3×J + 1) −1
  /// (or 10^(3×J) −1 when T is used as the payload of a NaN).
  ///
  /// If the value exceeds the maximum, the significand c is non-canonical and
  /// the value used for c is zero.
  internal static var nanPayloadCanonicalMax: BID { Self.maxDecimalDigits / 10 }

  // MARK: - Encoding

  // From IEEE-754 - 3.5.2 Encodings 3.52.0:
  //
  // If G[0] and G[1] together are one of 00, 01, or 10:
  // - biased exponent E is formed from G[0] through G[w+1]
  // - significand is formed from bits G[w+2] through the end of the encoding (including T).
  //
  // If G[0] and G[1] together are 11 and not NaN or Infinity:
  // - biased exponent E is formed from G[2] through G[w+3]
  // - significand is formed by prefixing the 4 bits (0b1000 | G[w+4]) to T.

  // exponentWidth is always w+2. Example for Decimal64 (w=8):
  // - 00, 01, 10 - G[0] through G[w+1= 9]: 0123456789 <= 10 digits
  // - 11         - G[2] through G[w+3=11]: 2345678901 <= 10 digits
  internal static var exponentWidth: Int { Self.combinationExponentWidth + 2 }
  internal static var exponentMask: BID { (1 << Self.exponentWidth) - 1 }
  /// From G[0] through G[w+1].
  internal static var exponentShift_00_01_10: Int { Self.bitWidth - Self.signWidth - Self.exponentWidth }
  /// From G[w+2] to end (including T).
  internal static var significandMask_00_01_10: BID { (1 << exponentShift_00_01_10) - 1 }
  /// From G[2] through G[w+3].
  /// In 11 we have sign, 2 high combination bits followed `Self.exponentWidth`
  /// bits of exponent.
  internal static var exponentShift_11: Int { Self.bitWidth - Self.signWidth - Self.combinationHighBitsWidth - Self.exponentWidth }
  internal static var prefix100_11: BID { 1 << (Self.trailingSignificandWidth + 3) }
  /// From G[w+4]) to end (including T).
  internal static var significandMask_11: BID { (1 << exponentShift_11) - 1 }

  // MARK: - Inits

  internal init(canonical bid: BID) {
    self = Self(unchecked: bid)
    self.assertIsCanonical()
  }

  internal init(canonical unpack: FiniteUnpack) {
    self = Self._packWithoutChecks(
      sign: unpack.sign,
      significand: unpack.significand.canonical,
      exponent: unpack.exponent
    )
    self.assertIsCanonical()
  }

  private func assertIsCanonical() {
#if DEBUG
    // *Teknikly* we do not need this '#if', but just to be sure that the
    // compiler does not emit anything.
    assert(self._isCanonical, "Not canonical: \(self) (\(Self.self)).")
#endif
  }

  // MARK: - Decimal digit count

  /// Number of decimal digits in a given value.
  internal static func _getDecimalDigitCount(_ significand: Significand) -> Int {
    return Self._getDecimalDigitCount(significand.canonical)
  }

  /// Number of decimal digits in a given value.
  ///
  /// Assumption: `significand <= Self.maxDecimalDigits`.
  internal static func _getDecimalDigitCount(_ significand: BID) -> Int {
    assert(significand <= Self.maxDecimalDigits, "Significand bigger than expected.")
    let result = Tables.getDecimalDigitCount(significand)
    assert(result <= Self.precisionInDigits, "Significand longer than expected.")
    return result
  }

  /// - `digitCount` - total number of digits in a value.
  /// - `roundingDigitCount` - number of digits that have to be used as 'rounding'
  ///    to get to 'Self.precisionInDigits'.
  internal typealias DoubleBIDDigitCount = (
    digitCount: Int,
    roundingDigitCount: Int
  )

  /// Number of decimal digits in a given value.
  internal static func _getDecimalDigitCount(_ significand: DoubleBID) -> DoubleBIDDigitCount {
    let digitCount = Tables.getDecimalDigitCount(significand)
    let roundingDigitCount = digitCount - Self.precisionInDigits
    return (digitCount, Swift.max(0, roundingDigitCount))
  }

  /// How many digits do we have to remove from `DoubleBID` to fit in
  /// `Self.precisionInDigits`?
  internal static func _getRoundingDigitCount(_ significand: DoubleBID) -> Int {
    if significand.high == 0 && significand.low <= Self.maxDecimalDigits {
      return 0
    }

    let digitCount = Self._getDecimalDigitCount(significand)
    return digitCount.roundingDigitCount
  }

  // MARK: - Bias

  internal static func _addBias(exponent: Int) -> BID {
    // Exponents are small, so in general the overflow should not occur.
    let int = exponent + Self.exponentBias
    return BID(int)
  }

  internal static func _removeBias(biasedExponent: BID) -> Int {
    let int = Int(biasedExponent)
    return int - Self.exponentBias
  }

  // MARK: - NaN arguments

  /// Result when one of the operands is NaN.
  /// IEEE-754 -> 6.2 Operations with NaNs
  ///
  /// Under default exception handling, any operation signaling an invalid
  /// operation exception and for which a floating-point result is to be
  /// delivered shall deliver a quiet NaN.
  ///
  /// Signaling NaNs shall be reserved operands that, under default exception
  /// handling, signal the invalid operation exception (see 7.2) for every
  /// general-computational and signaling-computational operation except for
  /// the conversions described in 5.12.
  ///
  /// For an operation with quiet NaN inputs, other than maximum and minimum
  /// operations, if a floating-point result is to be delivered the result shall
  /// be a quiet NaN which should be one of the input NaNs. If the trailing
  /// significand field of a decimal input NaN is canonical then the bit pattern
  /// of that field shall be preserved if that NaN is chosen as the result NaN.
  internal static func _nanResult_viaIEEE754_section62(
    _ nan: Self,
    status: inout DecimalStatus
  ) -> Self {
    assert(nan._isNaN, "6.2 Operations with --> NaNs <--")

    if nan._isSignalingNaN {
      status.set(.isInvalidOperation)
    }

    // Make payload canonical.
    let sign = nan.bid & Self.signMask
    let payload = nan._unpackNaN()
    return Self(canonical: sign | Self.nanQuietMask | payload.canonical)
  }

  internal static func _nanResult_viaIEEE754_section62(
    _ nan0: Self,
    _ nan1: Self,
    status: inout DecimalStatus
  ) -> Self {
    assert(nan0._isNaN || nan1._isNaN, "6.2 Operations with --> NaNs <--")

    if nan0._isSignalingNaN || nan1._isSignalingNaN {
      status.set(.isInvalidOperation)
    }

    if nan0._isNaN {
      return Self._nanResult_viaIEEE754_section62(nan0, status: &status)
    }

    return Self._nanResult_viaIEEE754_section62(nan1, status: &status)
  }

  // MARK: - Other

  internal func _isSet(_ mask: BID) -> Bool {
    return (self.bid & mask) == mask
  }
}
