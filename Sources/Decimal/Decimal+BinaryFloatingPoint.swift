// swiftlint:disable empty_count

// MARK: - BinaryFloatingPoint

extension BinaryFloatingPoint {
  fileprivate static var exponentBias: Int { (1 << (Self.exponentBitCount - 1)) - 1 }

  // Swift binary floating point conforms to IEEE-754 2008, which means that
  // the highest 'significand' bit designates 'signaling' or not.
  // Remaining bits are the payload.
  // In IEEE-754 1985 it was 'left to the implementor’s discretion'.
  fileprivate static var nanPayloadWidth: Int { Self.significandBitCount - 1 }
  fileprivate static var nanPayloadMask: Self.RawSignificand { (1 << Self.nanPayloadWidth) - 1 }
}

// MARK: - UInt384

/// Result of reciprocal multiplication.
private struct UInt384 {

  fileprivate typealias Word = UInt128.Word

  fileprivate private(set) var high: UInt128
  fileprivate private(set) var low: UInt256

  fileprivate var w0: Word { self.high.w0 }
  fileprivate var w1: Word { self.high.w1 }
  fileprivate var w2: Word { self.low.w0 }

  fileprivate init(multiplying lhs: UInt128, by rhs: UInt256) {
    assert(Word.bitWidth == UInt256.Word.bitWidth)
    (self.high, self.low) = rhs.multipliedFullWidth(by: lhs)
  }

  fileprivate mutating func multiplyBy10() {
    let (lowCarry, low) = self.low.multipliedFullWidth(by: 10 as UInt128)
    let (highCarry, partialHigh) = self.high.multipliedFullWidth(by: 10 as UInt64)
    assert(highCarry == 0)
    let (high, overflow) = partialHigh.addingReportingOverflow(lowCarry)
    assert(!overflow)

    self.low = low
    self.high = high
  }

  fileprivate static func <<= (n: inout Self, count: Int) {
    assert(0 <= count && count <= Word.bitWidth)

    if count != 0 {
      let rhsCount = Word.bitWidth - count
      n.high.w0 = (n.high.w0 << count) | (n.high.w1 &>> rhsCount)
      n.high.w1 = (n.high.w1 << count) | (n.low.w0 &>> rhsCount)
      n.low.w0 = (n.low.w0 << count) | (n.low.w1 &>> rhsCount)
      n.low.w1 = (n.low.w1 << count) | (n.low.w2 &>> rhsCount)
      n.low.w2 = (n.low.w2 << count) | (n.low.w3 &>> rhsCount)
      n.low.w3 = (n.low.w3 << count)
    }
  }

  fileprivate static func >>= (n: inout Self, count: Int) {
    assert(0 <= count && count <= Word.bitWidth)

    if count != 0 {
      let lhsCount = Word.bitWidth - count
      n.low.w3 = (n.low.w2 << lhsCount) | (n.low.w3 >> count)
      n.low.w2 = (n.low.w1 << lhsCount) | (n.low.w2 >> count)
      n.low.w1 = (n.low.w0 << lhsCount) | (n.low.w1 >> count)
      n.low.w0 = (n.high.w1 << lhsCount) | (n.low.w0 >> count)
      n.high.w1 = (n.high.w0 << lhsCount) | (n.high.w1 >> count)
      n.high.w0 = n.high.w0 >> count
    }
  }
}

// MARK: - Roundbound

/// Get 'halfway' rounding digits.
private func getRoundbound(
  isNegative: Bool,
  isSignificandOdd: Bool,
  rounding: DecimalFloatingPointRoundingRule
) -> UInt128 {
  let rnd_mode: Int
  switch rounding {
  case .toNearestOrEven: rnd_mode = 0
  case .down: rnd_mode = 1
  case .up: rnd_mode = 2
  case .towardZero: rnd_mode = 3
  case .toNearestOrAwayFromZero: rnd_mode = 4
  }

  let s = isNegative ? 1 : 0
  let index = (rnd_mode << 2) + ((s & 1) << 1) + (isSignificandOdd ? 1 : 0)
  return BinaryFloatingPointTables.bid_roundbound_128[index]
}

// MARK: - BinaryToDecimal

/// Logic for the `BinaryFloatingPoint` -> `Decimal` conversion.
/// `Decimal32` and `Decimal64` logic is the same, but `Decimal128` is different.
private protocol BinaryToDecimal: DecimalMixin {

  /// Look for the following comment: "(312 is the shift value for these tables)".
  static var reciprocalShift: Int { get }
  /// Is the value trivially greater than `9.99… * 10^emax`?
  ///
  /// ```
  /// 2^e * 2^112 > 10^emax * 10^d
  /// e >= ceil((emax + d) * log_2(10) - 112) = maxExponent
  /// ```
  static var maxExponent: Int { get }
  /// `BinaryFloatingPointTables.bid_coefflimits_bidXX`
  static var bid_coefflimits: [UInt128] { get }

  /// Multiply binary significand by reciprocal to get the decimal exponent,
  /// significand and rounding digits.
  static func _multiplyByReciprocal(
    binaryExponent e: Int,
    binarySignificandPackedToImplicitBit c: UInt128
  ) -> ReciprocalMultiplyResult
}

extension BinaryToDecimal {

  fileprivate typealias ReciprocalMultiplyResult = (
    e_out: Int,
    c_prov: BID,
    roundingDigits: UInt128
  )

  /// `Private` because the existence of this protocol in an implementation detail.
  fileprivate static func _initFromFloat<T: BinaryFloatingPoint>(
    _ d: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self where T.RawSignificand: FixedWidthInteger {
    if d.isNaN {
      return Self._fromFloatNaN(d, status: &status)
    }

    let sign: Sign = d.sign == .minus ? .minus : .plus

    if d.isInfinite {
      return Self(canonical: sign | Self.infinityMask)
    }

    if d.isZero {
      // ±0E0
      let e = BID(Self.exponentBias)
      return Self(canonical: sign | e << Self.exponentShift_00_01_10)
    }

    // =========================================================================
    // Intel code starts here.
    // Minor changes were made mostly to replace hard-coded values with names
    // for readability. Comments are taken from 'binary64_to_bid64'.
    // See the original Intel code for more details.
    // =========================================================================

    // We want this representation: d = c0 * 2^e
    // Where 'c0' contains the implicit '1'.
    var e: Int
    var c0 = d.significandBitPattern
    var t: Int

    if d.isNormal {
      // Pretend that this is binary:
      // - input = 1.234E10
      //   - signed exponent = 10
      //   - significand fraction bits = 234
      //   - significand with implicit 1 = 1.234
      // - output: 1234E(10-3) = 1234E7

      // Add implicit 1 to fractional significand.
      c0 |= 1 << T.significandBitCount
      // signedExponent = d.exponentBitPattern - T.exponentBias
      e = Int(d.exponentBitPattern) - T.exponentBias - T.significandBitCount
      t = c0.trailingZeroBitCount
    } else {
      status.set(.isBinaryFloatingPointSubnormal)
      assert(d.exponentBitPattern == 0)

      // Pretend that this is binary:
      // - T.significandBitCount = 4
      // - T.rawSignificandBitWidth = 4
      // - input = 0.0123 with exponentBitPattern = 0
      //   - significand fraction bits = 0123
      // - l = 1 - (4-3-1) = 1 - 0 = 1
      // - signed exponent = -4
      // - output: 123E(-4-1+1) = 123E-4
      //
      // Btw. '0.123E0', is also subnormal, but is is much easier -> worse example.

      // l = number of 0 bits from the start of the significand.
      //     -1 is because we want to fill the implicit bit.
      //
      // Example for Float:
      // l = LZ - (rawSignificandBitWidth - significandBitCount - 1)
      //   = LZ - (32 - 23 - 1)
      //   = LZ - 8
      //
      // xx xxxxx xxxxx xxxxx xxxxx xxxxx xxxxx - RawSignificand (32 x)
      //           isss sssss sssss sssss sssss - full significand (23 s, 1 implicit)
      //                BBBBB BBBBB BBBBB BBBBB - example (12 leading zeros, 20 bits)
      //           BBBB BBBBB BBBBB BBBBB B     - result (l = 12-(32-23-1) = 12-8 = 4)
      //
      // Btw. The following line also works on 'FLoat80' (which is not an obvious thing).
      let l = c0.leadingZeroBitCount - (T.RawSignificand.bitWidth - T.significandBitCount - 1)
      // Shift subnormal significand to the significand high bits (including implicit).
      c0 <<= l
      // signedExponent = 0 - T.exponentBias = -T.exponentBias
      e = -T.exponentBias - T.significandBitCount - l + 1
      t = 0
    }

    // [Comment from binary64_to_bid64]
    // Now -1126<=e<=971
    //   971 for max normal
    // -1074 for min normal
    // -1126 for min subnormal

    // [Comment from binary64_to_bid64]
    // Treat like a quad input for uniformity, so (2^{113-53} * c * r) >> 312
    // (312 is the shift value for these tables) which can be written as
    // (2^68 c * r) >> 320, lopping off exactly 320 bits = 5 words. Thus we put
    // input coefficient as the high part of c (<<64) shifted by 4 bits (<<68)
    //
    // Remember to compensate for the fact that exponents are integer for quad

    // 320 because after the reciprocal multiplication we will have UInt320.
    let align320 = 320 - Self.reciprocalShift
    let significandBitCountWithImplicit1 = T.significandBitCount + 1

    assert(T.RawSignificand.bitWidth <= UInt64.bitWidth, "What floating point is this?")
    var c = UInt128(high: 0, low: UInt64(truncatingIfNeeded: c0))
    let shift = 113 - significandBitCountWithImplicit1 + align320
    c <<= shift

    t += (113 - significandBitCountWithImplicit1)
    e -= (113 - significandBitCountWithImplicit1) // Now e belongs [-1186;911].

    // [Comment from binary64_to_bid64]
    // Check for "trivial" overflow, when 2^e * 2^112 > 10^emax * 10^d.
    // We actually check if e >= ceil((emax + d) * log_2(10) - 112)
    // This could be intercepted later, but it's convenient to keep tables smaller
    if e >= Self.maxExponent {
      status.set(.isOverflowInexact)
      return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
    }

    // [Comment from binary64_to_bid64]
    // Now filter out all the exact cases where we need to specially force
    // the exponent to 0. We can let through inexact cases and those where the
    // main path will do the right thing anyway, e.g. integers outside coeff range.
    //
    // First check that e <= 0, because if e > 0, the input must be >= 2^113,
    // which is too large for the coefficient of any target decimal format.
    // We write a = -(e + t)
    //
    // (1) If e + t >= 0 <=> a <= 0 the input is an integer; treat it specially
    //     iff it fits in the coefficient range. Shift c' = c >> -e, and
    //     compare with the coefficient range; if it's in range then c' is
    //     our coefficient, exponent is 0. Otherwise we pass through.
    //
    // (2) If a > 0 then we have a non-integer input. The special case would
    //     arise as c' / 2^a where c' = c >> t, i.e. 10^-a * (5^a c'). Now
    //     if a > 48 we can immediately forget this, since 5^49 > 10^34.
    //     Otherwise we determine whether we're in range by a table based on
    //     a, and if so get the multiplier also from a table based on a.
    //
    // Note that when we shift, we need to take into account the fact that
    // c is already 8 places to the left in preparation for the reciprocal
    // multiplication; thus we add 8 to all the shift counts
    if e <= 0 {
      assert(Self.maxDecimalDigits <= UInt128.max)
      let maxDecimalDigits = UInt128(truncatingIfNeeded: Self.maxDecimalDigits)
      let a = -(e + t)

      if a <= 0 {
        let cint = c >> (align320 - e)

        if cint <= maxDecimalDigits {
          let s = BID(truncatingIfNeeded: cint)
          return Self._packWithoutChecks(sign: sign, significand: s, signedExponent: 0)
        }
      } else if a <= 48 {
        let pow5 = Self.bid_coefflimits[a]
        let cint = c >> (align320 + t)

        if cint <= pow5 {
          let pow5 = BinaryFloatingPointTables.bid_power_five[a]
          let (cc, overflow) = cint.multipliedReportingOverflow(by: pow5)
          assert(!overflow)
          assert(cc <= maxDecimalDigits)

          let s = BID(truncatingIfNeeded: cc)
          return Self._packWithoutChecks(sign: sign, significand: s, signedExponent: -a)
        }
      }
    }

    var (e_out, c_prov, roundingDigits) = Self._multiplyByReciprocal(
      binaryExponent: e,
      binarySignificandPackedToImplicitBit: c
    )

    // [Comment from binary64_to_bid64]
    // Test inexactness and underflow
    if roundingDigits != 0 {
      status.set(.isInexact)

      if c_prov < (Self.maxDecimalDigits + 1) / 10 {
        status.set(.isUnderflow)
      }
    }

    // [Comment from binary64_to_bid64]
    // Round using round-sticky words
    // If we spill over into the next decade, correct
    let roundbound = getRoundbound(
      isNegative: sign.isMinus,
      isSignificandOdd: c_prov.isOdd,
      rounding: rounding
    )

    if roundingDigits > roundbound {
      c_prov += 1

      // Make it canonical if needed.
      if c_prov == Self.maxDecimalDigits + 1 {
        c_prov /= 10
        e_out += 1
      }
    }

    // [Comment from binary64_to_bid64]
    // Check for overflow
    let maxBiasedExponent = Self._addBias(exponent: Self.maxSignedExponent)

    if e_out > maxBiasedExponent {
      status.set(.isOverflowInexact)
      return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
    }

    assert(0 <= e_out && e_out <= (1 << Self.exponentWidth))
    let biasedExponent = BID(e_out)

    return Self._packWithoutChecks(
      sign: sign,
      significand: c_prov,
      biasedExponent: biasedExponent
    )
  }

  private static func _fromFloatNaN<T: BinaryFloatingPoint>(
    _ d: T,
    status: inout DecimalStatus
  ) -> Self {
    if d.isSignalingNaN {
      status.set(.isInvalidOperation)
    }

    let nonCanonicalPayload: BID
    let binaryPayloadWidth = T.nanPayloadWidth
    let binaryPayload = d.significandBitPattern & T.nanPayloadMask

    if binaryPayloadWidth <= Self.nanPayloadWidth {
      // Decimal payload is wider: cast to BID, and then shift to high bits.
      // For example: Double to Decimal128.
      let shift = Self.nanPayloadWidth - binaryPayloadWidth
      nonCanonicalPayload = BID(truncatingIfNeeded: binaryPayload) << shift
    } else {
      // Decimal payload is shorter: shift to fit, and then cast to BID.
      // For example: Double to Decimal32, Decimal64.
      let shift = binaryPayloadWidth - Self.nanPayloadWidth
      nonCanonicalPayload = BID(truncatingIfNeeded: binaryPayload >> shift)
    }

    let sign: BID = d.sign == .minus ? Self.signMask : 0
    let payload = nonCanonicalPayload <= Self.nanPayloadCanonicalMax ?
      nonCanonicalPayload :
      0

    return Self(canonical: sign | Self.nanQuietMask | payload)
  }

  /// Shared code for `Self._multiplyByReciprocal` for `Decimal32` and `Decimal64`.
  ///
  /// # minExponent
  /// Is the value trivially less than than `0.25 * 10^emin`?
  ///
  /// ```
  /// 2^e * 2^113 <= 10^emin * 1/4
  /// e <= floor(emin * log_2(10) - 115) = minExponent
  /// ```
  ///
  /// # Tables
  ///
  /// ```
  /// BinaryFloatingPointTables.bid_breakpoints_bidXX
  /// BinaryFloatingPointTables.bid_exponents_bidXX
  /// BinaryFloatingPointTables.bid_multipliers1_bidXX
  /// BinaryFloatingPointTables.bid_multipliers2_bidXX
  /// ```
  fileprivate static func _fromFloatMultiplyByReciprocal_decimal32_decimal64(
    binaryExponent e: Int,
    binarySignificandPackedToImplicitBit c: UInt128,
    minExponent: Int,
    bid_breakpoints: (Int) -> UInt128,
    bid_exponents: (Int) -> Int,
    bid_multipliers1: (Int) -> UInt256,
    bid_multipliers2: (Int) -> UInt256
  ) -> ReciprocalMultiplyResult {
    // [Comment from binary64_to_bid64]
    // Check for "trivial" underflow, when 2^e * 2^113 <= 10^emin * 1/4,
    // so test e <= floor(emin * log_2(10) - 115)
    // In this case just fix ourselves at that value for uniformity.
    //
    // This is important not only to keep the tables small but to maintain the
    // testing of the round/sticky words as a correct rounding method
    let e = Swift.max(e, minExponent)

    // 'Self.minExponent' is negative, so we have to subtract.
    assert(minExponent < 0)
    let index = e - minExponent

    // [Comment from binary64_to_bid64]
    // Now look up our exponent e, and the breakpoint between e and e+1
    let m_min = bid_breakpoints(index)
    var e_out = bid_exponents(index)

    // [Comment from binary64_to_bid64]
    // Choose exponent and reciprocal multiplier based on breakpoint
    let r: UInt256

    if c <= m_min {
      r = bid_multipliers1(index)
    } else {
      r = bid_multipliers2(index)
      e_out += 1
    }

    // [Comment from binary64_to_bid64]
    // Do the reciprocal multiplication
    let z = UInt384(multiplying: c, by: r)

    let z5 = z.w0
    assert(z5 <= Self.maxDecimalDigits)
    let c_prov = BID(truncatingIfNeeded: z5)

    let z4 = z.w1
    let z3 = z.w2
    let roundingDigits = UInt128(z4, z3)

    return ReciprocalMultiplyResult(
      e_out: e_out,
      c_prov: c_prov,
      roundingDigits: roundingDigits
    )
  }
}

// MARK: - Float to Decimal32

extension Decimal32: BinaryToDecimal {

  // We do not want to expose our private protocol (because it is an
  // implementation detail), so we need to re-export `init`.
  internal static func _init<T: BinaryFloatingPoint>(
    _ d: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self where T.RawSignificand: FixedWidthInteger {
    return Self._initFromFloat(d, rounding: rounding, status: &status)
  }

  fileprivate static let reciprocalShift = 320
  fileprivate static let maxExponent = 211
  fileprivate static let bid_coefflimits = BinaryFloatingPointTables.bid_coefflimits_bid32

  fileprivate static func _multiplyByReciprocal(
    binaryExponent e: Int,
    binarySignificandPackedToImplicitBit c: UInt128
  ) -> ReciprocalMultiplyResult {
    return Self._fromFloatMultiplyByReciprocal_decimal32_decimal64(
      binaryExponent: e,
      binarySignificandPackedToImplicitBit: c,
      minExponent: -450,
      bid_breakpoints: BinaryFloatingPointTables.bid_breakpoints_bid32,
      bid_exponents: BinaryFloatingPointTables.bid_exponents_bid32,
      bid_multipliers1: BinaryFloatingPointTables.bid_multipliers1_bid32,
      bid_multipliers2: BinaryFloatingPointTables.bid_multipliers2_bid32
    )
  }
}

// MARK: - Float to Decimal64

extension Decimal64: BinaryToDecimal {

  // We do not want to expose our private protocol (because it is an
  // implementation detail), so we need to re-export `init`.
  internal static func _init<T: BinaryFloatingPoint>(
    _ d: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self where T.RawSignificand: FixedWidthInteger {
    return Self._initFromFloat(d, rounding: rounding, status: &status)
  }

  fileprivate static let reciprocalShift = 312
  fileprivate static let maxExponent = 1168
  fileprivate static let bid_coefflimits = BinaryFloatingPointTables.bid_coefflimits_bid64

  fileprivate static func _multiplyByReciprocal(
    binaryExponent e: Int,
    binarySignificandPackedToImplicitBit c: UInt128
  ) -> ReciprocalMultiplyResult {
    return Self._fromFloatMultiplyByReciprocal_decimal32_decimal64(
      binaryExponent: e,
      binarySignificandPackedToImplicitBit: c,
      minExponent: -1437,
      bid_breakpoints: BinaryFloatingPointTables.bid_breakpoints_bid64,
      bid_exponents: BinaryFloatingPointTables.bid_exponents_bid64,
      bid_multipliers1: BinaryFloatingPointTables.bid_multipliers1_bid64,
      bid_multipliers2: BinaryFloatingPointTables.bid_multipliers2_bid64
    )
  }
}

// MARK: - Float to Decimal128

extension Decimal128: BinaryToDecimal {

  // We do not want to expose our private protocol (because it is an
  // implementation detail), so we need to re-export `init`.
  internal static func _init<T: BinaryFloatingPoint>(
    _ d: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self where T.RawSignificand: FixedWidthInteger {
    return Self._initFromFloat(d, rounding: rounding, status: &status)
  }

  fileprivate static let reciprocalShift = 305
  // No overflow possible.
  fileprivate static let maxExponent = Int.max
  fileprivate static let bid_coefflimits = BinaryFloatingPointTables.bid_coefflimits_bid128

  fileprivate static func _multiplyByReciprocal(
    binaryExponent e: Int,
    binarySignificandPackedToImplicitBit c: UInt128
  ) -> ReciprocalMultiplyResult {
    // [Comment from binary80_to_bid128]
    // Input exponent can stretch between the maximal and minimal
    // exponents (remembering we force normalization): -16607 <= e <= 16271

    // [Comment from binary80_to_bid128]
    // Compute the estimated decimal exponent e_out; the provisional exponent
    // will be either "e_out" or "e_out-1" depending on later significand check
    // NB: this is the *biased* exponent
    var e = e
    let e_plus = e + 42152
    var e_out = (((19728 * e_plus) + ((19779 * e_plus) >> 16)) >> 16) - 6512

    // [Comment from binary80_to_bid128]
    // Set up pointers into the bipartite table
    var e_hi = 11232 - e_out
    let e_lo = e_hi & 127
    e_hi = e_hi >> 7

    // [Comment from binary80_to_bid128]
    // Look up the inner entry first
    var r = BinaryFloatingPointTables.bid_innertable_sig(e_lo)
    var f = BinaryFloatingPointTables.bid_innertable_exp(e_lo)

    // [Comment from binary80_to_bid128]
    // If we need the other entry, multiply significands and add exponents
    if e_hi != 39 {
      let s_prime = BinaryFloatingPointTables.bid_outertable_sig(e_hi)
      f += 256 + BinaryFloatingPointTables.bid_outertable_exp(e_hi)
      let (t_prime, _) = r.multipliedFullWidth(by: s_prime)
      r = t_prime + 1
    }

    var z = UInt384(multiplying: c, by: r)

    // [Comment from binary80_to_bid128]
    // Make adjustive shift, ignoring the lower 128 bits
    e = -(241 + Int(e) + Int(f))
    z >>= e

    // [Comment from binary80_to_bid128]
    // Now test against 10^33 and so decide on adjustment
    // I feel there ought to be a smarter way of doing the multiplication
    if z.high < (Decimal128.maxDecimalDigits + 1) / 10 {
      z.multiplyBy10()
      e_out -= 1
    }

    assert(z.high <= Self.maxDecimalDigits)
    let c_prov = BID(truncatingIfNeeded: z.high)

    let z3 = z.low.w0
    let z2 = z.low.w1
    let roundingDigits = UInt128(z3, z2)

    return ReciprocalMultiplyResult(
      e_out: e_out,
      c_prov: c_prov,
      roundingDigits: roundingDigits
    )
  }
}

// MARK: - DecimalToBinary

internal protocol DecimalToBinary: BinaryFloatingPoint {

  /// [Decimal -> binary floating point]
  /// Smaller exponent is rounded to this exponent.
  static var minExponent: Int { get }
  /// [Decimal -> binary floating point]
  /// Greater equal exponent returns rounded infinity.
  static var maxExponent: Int { get }

  /// [Decimal -> binary floating point]
  /// Float: 0; Double: 6; Float80: 10
  static var reciprocalShift: Int { get }
  /// [Decimal -> binary floating point]
  /// Float: 0; Double: 0; Float80: 47
  static var afterReciprocalMultiplicationShift: Int { get }

  /// [Decimal -> binary floating point]
  /// BinaryFloatingPointTables.bid_breakpoints_binaryXX
  static var bid_breakpoints_binary: (Int) -> UInt128 { get }
  /// [Decimal -> binary floating point]
  /// BinaryFloatingPointTables.bid_exponents_binaryXX
  static var bid_exponents_binary: (Int) -> Int { get }
  /// [Decimal -> binary floating point]
  /// BinaryFloatingPointTables.bid_multipliers1_binaryXX
  static var bid_multipliers1_binary: (Int) -> UInt256 { get }
  /// [Decimal -> binary floating point]
  /// BinaryFloatingPointTables.bid_multipliers2_binaryXX
  static var bid_multipliers2_binary: (Int) -> UInt256 { get }
}

extension DecimalToBinary {

  internal static func _initFromDecimal(
    _ d: Decimal32,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    return Self._initFromDecimal(
      d,
      kUnpackModifier: 8,
      alignShift: 89,
      rounding: rounding,
      status: &status
    )
  }

  internal static func _initFromDecimal(
    _ d: Decimal64,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    return Self._initFromDecimal(
      d,
      kUnpackModifier: 10,
      alignShift: 59,
      rounding: rounding,
      status: &status
    )
  }

  internal static func _initFromDecimal(
    _ d: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    return Self._initFromDecimal(
      d,
      kUnpackModifier: 15,
      alignShift: 0,
      rounding: rounding,
      status: &status
    )
  }

  /// `Private` because the existence of this protocol in an implementation detail.
  private static func _initFromDecimal<T: DecimalMixin>(
    _ d: T,
    kUnpackModifier: Int,
    alignShift: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    let isNegative = d._isNegative

    if d._isNaN {
      return Self._fromDecimalNaN(d, status: &status)
    }

    if d._isInfinite {
      return isNegative ? -Self.infinity : Self.infinity
    }

    let unpack = d._unpackFiniteOrZero()

    if unpack.significand.isZero {
      return isNegative ? -Self.zero : Self.zero
    }

    // =========================================================================
    // Intel code starts here.
    // Minor changes were made mostly to replace hard-coded values with names
    // for readability. Comments are taken from 'binary64_to_bid64'.
    // See the original Intel code for more details.
    // =========================================================================

    var e = unpack.exponent.signed
    var c0 = unpack.significand.canonical
    var k = d._isSet(T.combinationHighBits11Mask) ? 0 : c0.leadingZeroBitCount - kUnpackModifier
    c0 <<= k

    // [Comment from bid64_to_binary64]
    // Correct to 2^112 <= c < 2^113 with corresponding exponent adding 113-54=59
    // In fact shift a further 6 places ready for reciprocal multiplication
    // Thus (113-54)+6=65, a shift of 1 given that we've already upacked in c.w[1]
    assert(T.bitWidth <= UInt128.bitWidth, "What decimal is this?")
    var c = UInt128(truncatingIfNeeded: c0)
    let shift = alignShift + Self.reciprocalShift
    c <<= shift
    k += alignShift

    // [Comment from bid64_to_binary64]
    // Check for "trivial" overflow, when 10^e * 1 > 2^{sci_emax+1}, just to
    // keep tables smaller (it would be intercepted later otherwise).
    //
    // (Note that we may have normalized the coefficient, but we have a
    //  corresponding exponent postcorrection to account for; this can
    //  afford to be conservative anyway.)
    //
    // We actually check if e >= ceil((sci_emax + 1) * log_10(2))
    // which in this case is 2 >= ceil(1024 * log_10(2)) = ceil(308.25) = 309
    if e >= Self.maxExponent {
      status.set(.isOverflowInexact)
      return Self._roundInfinitelyBigValue(isNegative: isNegative, rounding: rounding)
    }

    // [Comment from bid64_to_binary64]
    // Also check for "trivial" underflow, when 10^e * 2^113 <= 2^emin * 1/4,
    // so test e <= floor((emin - 115) * log_10(2))
    // In this case just fix ourselves at that value for uniformity.
    //
    // This is important not only to keep the tables small but to maintain the
    // testing of the round/sticky words as a correct rounding method
    e = Swift.max(e, Self.minExponent)

    // 'Self.minExponent' is negative, so we have to subtract.
    assert(Self.minExponent < 0)
    let index = e - Self.minExponent

    // [Comment from bid64_to_binary64]
    // Look up the breakpoint and approximate exponent
    let m_min = Self.bid_breakpoints_binary(index)
    let e_outTable = Self.bid_exponents_binary(index)
    var e_out = e_outTable - k

    // [Comment from bid64_to_binary64]
    // Choose provisional exponent and reciprocal multiplier based on breakpoint
    let r: UInt256

    if c <= m_min {
      r = Self.bid_multipliers1_binary(index)
    } else {
      r = Self.bid_multipliers2_binary(index)
      e_out += 1
    }

    // [Comment from bid64_to_binary64]
    // Do the reciprocal multiplication
    var z = UInt384(multiplying: c, by: r)

    // This is for Float80:
    // Intel does shift right by 47, we will do shift left by 64-47=17.
    // This way we will end up wit the same code as for other types.
    // We could have done it before reciprocal multiplication, but then we
    // would have to shift 'm_min' anyway.
    z <<= Self.afterReciprocalMultiplicationShift

    // [Comment from bid64_to_binary64]
    // Check for exponent underflow and compensate by shifting the product
    // Cut off the process at precision+2, since we can't really shift further
    if e_out < 1 {
      // 3 because = implicit bit + 2
      var d = Swift.min(1 - e_out, Self.significandBitCount + 3)

      if d >= UInt384.Word.bitWidth {
        d -= UInt384.Word.bitWidth
        z >>= UInt384.Word.bitWidth
      }

      e_out = 1

      if d > 0 {
        z >>= d
      }
    }

    let z5 = z.w0
    var c_prov = z5
    let implicitBit: UInt128.Word = 1 << Self.significandBitCount

    // [Comment from bid64_to_binary64]
    // Round using round-sticky words
    // If we spill into the next binade, correct
    // Flag underflow where it may be needed even for |result| = SNN
    let roundbound = getRoundbound(
      isNegative: isNegative,
      isSignificandOdd: c_prov.isOdd,
      rounding: rounding
    )

    let z4 = z.w1
    let z3 = z.w2
    let roundingDigits = UInt128(high: z4, low: z3)

    if roundingDigits > roundbound {
      // 'Float80' uses 'UInt64' which can overflow.
      let add = c_prov.addingReportingOverflow(1)
      c_prov = add.partialValue

      // Did the addition overflow the significand?
      if add.overflow || c_prov == (implicitBit << 1) {
        c_prov = implicitBit
        e_out += 1
      } else if c_prov == implicitBit && e_out == 1 {
        // TODO: [Decimal -> binary, underflow] Minor differences from Intel
        let hasUnderflow: Bool

        // 0 000 toNearestOrEven
        // 1 001 down
        // 2 010 up
        // 3 011 toward zero
        // 4 100 toNearestTiesAway
        switch rounding {
        case .up: hasUnderflow = !isNegative && z4 < (1 << 63)
        case .down: hasUnderflow = isNegative && z4 < (1 << 63)
        case .towardZero: hasUnderflow = false
        case .toNearestOrEven, .toNearestOrAwayFromZero: hasUnderflow = z4 < (3 << 62)
        }

        if hasUnderflow {
          status.set(.isUnderflow)
        }
      }
    }

    // [Comment from bid64_to_binary64]
    // Check for overflow
    let fullExponent = (1 << Self.exponentBitCount) - 1

    if e_out >= fullExponent {
      status.set(.isOverflowInexact)
      return Self._roundInfinitelyBigValue(isNegative: isNegative, rounding: rounding)
    }

    // [Comment from bid64_to_binary64]
    // Modify exponent for a tiny result, otherwise lop the implicit bit
    if c_prov < implicitBit {
      e_out = 0
    } else {
      c_prov &= implicitBit - 1
    }

    // [Comment from bid64_to_binary64]
    // Set the inexact and underflow flag as appropriate
    if roundingDigits != 0 {
      status.set(.isInexact)

      if e_out == 0 {
        status.set(.isUnderflow)
      }
    }

    let exponentBitPattern = RawExponent(truncatingIfNeeded: e_out)
    let significandBitPattern = RawSignificand(truncatingIfNeeded: c_prov)

    return Self(
      sign: isNegative ? .minus : .plus,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: significandBitPattern
    )
  }

  private static func _fromDecimalNaN<T: DecimalMixin>(
    _ d: T,
    status: inout DecimalStatus
  ) -> Self {
    if d._isSignalingNaN {
      status.set(.isInvalidOperation)
    }

    let payload: RawSignificand
    let decimalUnpack = d._unpackNaN()
    let decimalPayload = decimalUnpack.canonical
    let decimalPayloadWidth = T.nanPayloadWidth

    if decimalPayloadWidth <= Self.nanPayloadWidth {
      // Decimal payload is wider: shift to fit in narrower binary payload.
      // For example: Decimal128 to Double.
      let shift = Self.nanPayloadWidth - decimalPayloadWidth
      payload = RawSignificand(truncatingIfNeeded: decimalPayload >> shift)
    } else {
      // Decimal payload is shorter: shift to fill high bits in wider binary payload.
      // For example: Decimal32 or Decimal64 to Double.
      let shift = decimalPayloadWidth - Self.nanPayloadWidth
      payload = RawSignificand(truncatingIfNeeded: decimalPayload << shift)
    }

    let highPayload: RawSignificand = 1 << (Self.significandBitCount - 1)
    let significandBitPattern = highPayload | payload

    return Self(
      sign: d._isNegative ? .minus : .plus,
      exponentBitPattern: (1 << Self.exponentBitCount) - 1, // All bits 1
      significandBitPattern: significandBitPattern
    )
  }

  private static func _roundInfinitelyBigValue(
    isNegative: Bool,
    rounding: DecimalFloatingPointRoundingRule
  ) -> Self {
    // Infinity or greatestFiniteMagnitude.
    let isInfinity: Bool

    switch rounding {
    case .up: isInfinity = !isNegative
    case .down: isInfinity = isNegative
    case .towardZero: isInfinity = false
    case .toNearestOrEven: isInfinity = true
    case .toNearestOrAwayFromZero: isInfinity = true
    }

    let magnitude = isInfinity ? Self.infinity : Self.greatestFiniteMagnitude
    return isNegative ? -magnitude : magnitude
  }
}

// MARK: - Decimal to Float

extension Float: DecimalToBinary {
  internal static let minExponent = -80
  internal static let maxExponent = 39
  internal static let reciprocalShift = 0
  internal static let afterReciprocalMultiplicationShift = 0

  internal static let bid_breakpoints_binary = BinaryFloatingPointTables.bid_breakpoints_binary32
  internal static let bid_exponents_binary = BinaryFloatingPointTables.bid_exponents_binary32
  internal static let bid_multipliers1_binary = BinaryFloatingPointTables.bid_multipliers1_binary32
  internal static let bid_multipliers2_binary = BinaryFloatingPointTables.bid_multipliers2_binary32
}

// MARK: - Decimal to Double

extension Double: DecimalToBinary {
  internal static let minExponent = -358
  internal static let maxExponent = 309
  internal static let reciprocalShift = 6
  internal static let afterReciprocalMultiplicationShift = 0

  internal static let bid_breakpoints_binary = BinaryFloatingPointTables.bid_breakpoints_binary64
  internal static let bid_exponents_binary = BinaryFloatingPointTables.bid_exponents_binary64
  internal static let bid_multipliers1_binary = BinaryFloatingPointTables.bid_multipliers1_binary64
  internal static let bid_multipliers2_binary = BinaryFloatingPointTables.bid_multipliers2_binary64
}

// MARK: - Decimal to Float80

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

extension Float80: DecimalToBinary {
  internal static let minExponent = -4985
  internal static let maxExponent = 4933
  internal static let reciprocalShift = 0
  internal static let afterReciprocalMultiplicationShift = 17

  internal static let bid_breakpoints_binary = BinaryFloatingPointTables.bid_breakpoints_binary80
  internal static let bid_exponents_binary = BinaryFloatingPointTables.bid_exponents_binary80
  internal static let bid_multipliers1_binary = BinaryFloatingPointTables.bid_multipliers1_binary80
  internal static let bid_multipliers2_binary = BinaryFloatingPointTables.bid_multipliers2_binary80
}

#endif
