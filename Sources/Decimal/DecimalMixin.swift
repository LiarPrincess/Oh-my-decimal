import Cbid

// swiftlint:disable line_length

/// Internal protocol for all of the helpers.
///
/// All of the functions start with `_` to avoid clashes with `public` methods
/// from `DecimalFloatingPoint`.
internal protocol DecimalMixin {

  associatedtype BID: BinaryIntegerDecimal

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
  /// This is the exponent for the `9.999… * 10^maxUnbiasedExponent` form
  /// (notice the decimal separator position).
  /// Most of the time you want `9999… * 10^(emax-p+1)`.
  static var maxUnbiasedExponent: Int { get }

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

  static var fnIsZero: (BID) -> Int32 { get }
  static var fnIsFinite: (BID) -> Int32 { get }
  static var fnIsInfinite: (BID) -> Int32 { get }
  static var fnIsCanonical: (BID) -> Int32 { get }
  static var fnIsNormal: (BID) -> Int32 { get }
  static var fnIsSubnormal: (BID) -> Int32 { get }
  static var fnIsNaN: (BID) -> Int32 { get }
  static var fnIsSignalingNaN: (BID) -> Int32 { get }
  static var fnIsNegative: (BID) -> Int32 { get }

  static var fnToString: (CCharBuffer?, BID, IDEC_flagsPtr?) -> Void { get }
  static var fnFromString: (CCharBuffer?, IDEC_round, IDEC_flagsPtr?) -> BID { get }

  static var fnToDenselyPackedDecimal: (BID) -> BID { get }
  static var fnFromDenselyPackedDecimal: (BID) -> BID { get }

  static var fnScaleB: (BID, Int, IDEC_round, IDEC_flagsPtr?) -> BID { get }

  static var fnToFloat: (BID, IDEC_round, IDEC_flagsPtr?) -> Float { get }
  static var fnFromFloat: (Float, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnToDouble: (BID, IDEC_round, IDEC_flagsPtr?) -> Double { get }
  static var fnFromDouble: (Double, IDEC_round, IDEC_flagsPtr?) -> BID { get }
#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)
  static var fnToFloat80: (BID, IDEC_round, IDEC_flagsPtr?) -> Float80 { get }
  static var fnFromFloat80: (Float80, IDEC_round, IDEC_flagsPtr?) -> BID { get }
#endif

  static var fnNegate: (BID) -> BID { get }
  static var fnAbs: (BID) -> BID { get }
  static var fnAdd: (BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnSub: (BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnMul: (BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnDiv: (BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnRem: (BID, BID, IDEC_flagsPtr?) -> BID { get }
  static var fnPow: (BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnSquareRoot: (BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnFusedMulAdd: (BID, BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }

  static var fnIsEqual: (BID, BID, IDEC_flagsPtr?) -> Int32 { get }
  static var fnIsLess: (BID, BID, IDEC_flagsPtr?) -> Int32 { get }
  static var fnIsLessEqual: (BID, BID, IDEC_flagsPtr?) -> Int32 { get }
  static var fnTotalOrder: (BID, BID) -> Int32 { get }
  static var fnMinimum: (BID, BID, IDEC_flagsPtr?) -> BID { get }
  static var fnMaximum: (BID, BID, IDEC_flagsPtr?) -> BID { get }
  static var fnMinimumMagnitude: (BID, BID, IDEC_flagsPtr?) -> BID { get }
  static var fnMaximumMagnitude: (BID, BID, IDEC_flagsPtr?) -> BID { get }

  static var fnFloatingPointClass: (BID) -> Int32 { get }

  static var fnNextUp: (BID, IDEC_flagsPtr?) -> BID { get }
  static var fnNextDown: (BID, IDEC_flagsPtr?) -> BID { get }

  static var fnQuantize: (BID, BID, IDEC_round, IDEC_flagsPtr?) -> BID { get }
  static var fnSameQuantum: (BID, BID) -> Int32 { get }
  static var fnQuantum: (BID, IDEC_flagsPtr?) -> BID { get }

  static var fnRoundToNearestOrEven: (BID, IDEC_flagsPtr?) -> BID { get }
  static var fnRoundToNearestOrAwayFromZero: (BID, IDEC_flagsPtr?) -> BID { get }
  static var fnRoundUp: (BID, IDEC_flagsPtr?) -> BID { get }
  static var fnRoundDown: (BID, IDEC_flagsPtr?) -> BID { get }
  static var fnRoundTowardZero: (BID, IDEC_flagsPtr?) -> BID { get }
}

extension DecimalMixin {

  /// IEEE-754: `emin = 1 − emax`
  internal static var minUnbiasedExponent: Int { 1 - Self.maxUnbiasedExponent }

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

  internal static var nanPayloadMask: BID {
    // If G0 through G4 are 11111, then v is NaN regardless of S.
    // Furthermore, if G5 is 1, then r is sNaN; otherwise r is qNaN.
    //
    // The remaining bits of G are ignored, and T constitutes the NaN’s payload,
    // which can be used to distinguish various NaNs.
    // The NaN payload is encoded similarly to finite numbers described below,
    // with G treated as though all bits were zero. The payload corresponds to
    // the significand of finite numbers, interpreted as an integer with a maximum
    // value of 10^(3×J) − 1, and the exponent field is ignored (it is treated as
    // if it were zero).
    // A NaN is in its preferred (canonical) representation if the bits G6 through
    // Gw + 4 are zero and the encoding of the payload is canonical.
    return Self.trailingSignificandMask
  }

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
  internal static var exponentShift_00_01_10: Int { Self.bitWidth - Self.signWidth - exponentWidth }
  /// From G[w+2] to end (including T).
  internal static var significandMask_00_01_10: BID { (1 << exponentShift_00_01_10) - 1 }
  /// From G[2] through G[w+3].
  /// In 11 we have sign, 2 high combination bits followed `Self.exponentWidth`
  /// bits of exponent.
  internal static var exponentShift_11: Int { Self.bitWidth - Self.signWidth - Self.combinationHighBitsWidth - Self.exponentWidth }
  internal static var prefix100_11: BID { 1 << (Self.trailingSignificandWidth + 3) }
  /// From G[w+4]) to end (including T).
  internal static var significandMask_11: BID { (1 << exponentShift_11) - 1 }

  // MARK: - Helpers

  internal init(canonical bid: BID) {
    self = Self(unchecked: bid)
    assert(self._isCanonical, "Not canonical: \(self) (\(Self.self)).")
  }

  internal func _isSet(_ mask: BID) -> Bool {
    return (self.bid & mask) == mask
  }

  /// Get NaN payload with IEEE-754 max value check.
  internal var _nanPayload: BID {
    // Remove the NaN payload based on IEEE-754:
    //   The maximum value of the binary-encoded significand is the same as
    //   that of the corresponding decimal-encoded significand; that is,
    //   10^(3×J + 1) −1 (or 10^(3×J) −1 when T is used as the payload of a NaN).
    //   If the value exceeds the maximum, the significand c is non-canonical
    //   and the value used for c is zero.
    let bits = self.bid & Self.nanPayloadMask
    let maxSignificand = Self.maxDecimalDigits / 10 // 10^(3×J) −1
    return bits > maxSignificand ? 0 : bits
  }

  /// 1 -> 0; 7 -> 2; 8 -> 3 etc.
  internal static func _log2(nonZero n: BID) -> Int {
    precondition(n != 0, "Log2(0)")
    return BID.bitWidth - n.leadingZeroBitCount - 1
  }

  /// Number of decimal digits in a given value.
  /// The one based on `bid_estimate_decimal_digits`.
  internal static func _getDecimalDigitCount(significand: BID) -> Int {
    // We can't log2(0).
    if significand == 0 {
      return 1
    }

    if significand > Self.maxDecimalDigits / 10 {
      return Self.precisionInDigits
    }

    let pow2 = Self._log2(nonZero: significand)
    var digitCount = Tables.pow2ToDecimalDigitCount[pow2]
    let minForNextDigit = Tables.pow10[digitCount].w.0

    if significand >= minForNextDigit {
      digitCount += 1
    }

    assert(digitCount <= Self.precisionInDigits)
    return digitCount
  }

  /// Number of decimal digits in a given value.
  /// The one based on `bid_nr_digits`.
  internal static func _getDecimalDigitCount2(significand: BID) -> Int {
    // We can't log2(0).
    if significand == 0 {
      return 1
    }

    let maxSignificand_00_01_10: BID = 1 << Self.exponentShift_00_01_10

    if significand >= maxSignificand_00_01_10 {
      return Self.precisionInDigits
    }

    let pow2 = Self._log2(nonZero: significand)
    let entry = Tables.decimalDigitCount[pow2]
    let result = entry.getDigitCount(significand: significand)

    assert(result <= Self.precisionInDigits)
    return result
  }

  /// Go from `1.23… * 10^exponent`
  /// to      `123…  * 10^(exponent - Self.precisionInDigits + 1)`.
  internal static func _moveDecimalSeparatorRight(exponent: Int) -> Int {
    // This is a trivial operation, but it occurs frequently, so we will move
    // it into a separate function for documentation.
    return exponent - Self.precisionInDigits + 1
  }

  internal static func _addBias(exponent: Int) -> BID {
    let int = exponent + Self.exponentBias
    return BID(int) // Exponents are small, no overflow possible
  }

  internal static func _removeBias(biasedExponent: BID) -> Int {
    let int = Int(biasedExponent)
    return int - Self.exponentBias
  }

  // MARK: - CBid interop

  internal func _test(_ fn: (BID) -> Int32) -> Bool {
    let result = fn(self.bid)
    return result != 0
  }

  internal func _test(_ fn: (BID, BID) -> Int32, other: Self) -> Bool {
    let result = fn(self.bid, other.bid)
    return result != 0
  }

  internal func _convert(_ fn: (BID) -> BID) -> Self {
    let result = fn(self.bid)
    return Self(unchecked: result)
  }

  internal func _convert(
    _ fn: (BID, IDEC_flagsPtr) -> BID,
    status: inout ExceptionStatus
  ) -> Self {
    let result = fn(self.bid, &status.value)
    return Self(unchecked: result)
  }

  internal func _convert(
    _ fn: (BID, IDEC_round, IDEC_flagsPtr) -> BID,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let result = fn(self.bid, rounding.value, &status.value)
    return Self(unchecked: result)
  }

  internal func _binaryOp(
    _ fn: (BID, BID, IDEC_flagsPtr) -> BID,
    other: Self,
    status: inout ExceptionStatus
  ) -> Self {
    let result = fn(self.bid, other.bid, &status.value)
    return Self(unchecked: result)
  }

  internal func _binaryOp(
    _ fn: (BID, BID, IDEC_round, IDEC_flagsPtr) -> BID,
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let result = fn(self.bid, other.bid, rounding.value, &status.value)
    return Self(unchecked: result)
  }

  internal func _ternaryOp(
    _ fn: (BID, BID, BID, IDEC_round, IDEC_flagsPtr) -> BID,
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let result = fn(self.bid, lhs.bid, rhs.bid, rounding.value, &status.value)
    return Self(unchecked: result)
  }

  internal func _compareOp(
    _ fn: (BID, BID, IDEC_flagsPtr) -> Int32,
    other: Self,
    status: inout ExceptionStatus
  ) -> Bool {
    let result = fn(self.bid, other.bid, &status.value)
    return result != 0
  }
}
