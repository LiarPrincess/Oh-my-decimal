// MARK: - From Int

extension DecimalMixin {

  /// Will set 'isInexact' flag on status if needed.
  internal static func _init<T: BinaryInteger>(
    _ int: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    guard let magnitude = UInt64(exactly: int.magnitude) else {
      preconditionFailure("\(Self.self) does not support integers over 64 bits.")
    }

    let isNegative = int < (0 as T)
    let sign: Sign = isNegative ? .minus : .plus

    // Exact without rounding digits?
    if let s = BID(exactly: magnitude), s <= Self.maxDecimalDigits {
      return Self._packWithoutChecks(
        sign: sign,
        significand: s,
        signedExponent: 0
      )
    }

    let digitCount = Tables.getDecimalDigitCount(magnitude)
    let roundingDigitCount = digitCount - Self.precisionInDigits
    let signedExponent = roundingDigitCount

    return Self._pack(
      sign: sign,
      significand: magnitude,
      signedExponent: signedExponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }
}

// MARK: - To Int

extension FixedWidthInteger {
  // A Boolean value indicating whether this type is an unsigned integer type.
  fileprivate static var isUnsigned: Bool { !self.isSigned }
}

extension DecimalMixin {

  /// Method for Intel tests.
  internal func _toInt<T: FixedWidthInteger>(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> T {
    // This method does not set the 'isInexact' flag.
    var s = DecimalStatus()
    let result: T = self._toExactlyInt(rounding: rounding, status: &s)

    // Copy flags, except for 'isInexact'.
    s.clear(.isInexact)
    status.set(s)

    return result
  }

  /// Method for Intel tests.
  /// - `status.isInexact` - result is not 'exact'
  /// - `status.isInvalidOperation` - unrepresentable value
  internal func _toExactlyInt<T: FixedWidthInteger>(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> T {
    if !self._isFinite {
      return Self._toUnrepresentableInt(status: &status)
    }

    let unpack = self._unpackFiniteOrZero()

    if unpack.significand.isZero {
      return 0
    }

    precondition(
      T.bitWidth <= 64,
      "\(Self.self) does not support integers over 64 bits."
    )

    let exponent = unpack.exponent.signed
    let significand = unpack.significand.canonical
    let digitCount = Self._getDecimalDigitCount(significand)

    let totalDigitCount = digitCount + exponent

    // Is magnitude between 0 and 1?
    // 123E-3 = 0.123  -> 0
    // 123E-4 = 0.0123 -> 0 etc.
    // The exact result depends on the rounding.
    if totalDigitCount <= 0 {
      let int = Self._toRoundedIntWithMagnitudeLessThan1(
        sign: unpack.sign,
        exponent: exponent,
        significand: significand,
        significandDigitCount: digitCount,
        rounding: rounding
      )

      assert(-1 <= int && int <= 1, "-1, 0, 1")

      if T.isUnsigned && int == -1 {
        return Self._toUnrepresentableInt(status: &status)
      }

      status.set(.isInexact)
      return T(int)
    }

    // Negative decimal to unsigned Int? -> nope.
    // Except for -1 < d < 0, because those depend on rounding, but we already
    // handled them.
    if T.isUnsigned && unpack.sign.isMinus {
      return Self._toUnrepresentableInt(status: &status)
    }

    // Do you even l̵i̵f̵t̵ fit? 1E1000 into UInt8 -> nope.
    // For signed 2-complement types -> negative numbers have greater range.
    let maxMagnitude = Swift.max(T.min.magnitude, T.max.magnitude)
    let maxDigitCount = Tables.getDecimalDigitCount(maxMagnitude)

    if totalDigitCount > maxDigitCount {
      return Self._toUnrepresentableInt(status: &status)
    }

    typealias Magnitude = T.Magnitude
    assert(0 < totalDigitCount && totalDigitCount <= maxDigitCount)

    // We have the correct digit count, but we can still overflow.
    // 123E0 -> 123, no rounding
    // 999E0 as UInt8 -> nope
    if exponent == 0, let m = Magnitude(exactly: significand) {
      return Self._toInt(sign: unpack.sign, magnitude: m, status: &status)
    }

    // 123E1 = 1230, no rounding
    if exponent > 0 {
      // Both 'significand' and 'pow10' are representable (separately),
      // because we checked the total digit count.
      let s = Magnitude(truncatingIfNeeded: significand)
      let pow10: Magnitude = Tables.getPowerOf10(exponent: exponent)
      let (m, overflow) = s.multipliedReportingOverflow(by: pow10)

      // Overflow when:
      // 90E1 -> UInt8
      // mul = 990 > UInt8.max = 255
      // Note that but both 990 and 255 have 3 digits.
      if !overflow {
        return Self._toInt(sign: unpack.sign, magnitude: m, status: &status)
      }
    }

    // 123E-1 = 12.3 -> 12, with rounding
    if exponent < 0 {
      let pow10: BID = Tables.getPowerOf10(exponent: -exponent)
      var (quotient, remainder) = significand.quotientAndRemainder(dividingBy: pow10)

      let isRoundingAway = Self._isRoundingAwayFromZero(
        sign: unpack.sign,
        significand: quotient,
        roundingDigits: remainder,
        halfway: pow10 / 2,
        rounding: rounding
      )

      if isRoundingAway {
        quotient += 1
      }

      // Cast fails for:
      // 9999999E-4 -> UInt8 towardZero
      // quotient = 999
      // UInt8.max = 255
      if let m = Magnitude(exactly: quotient) {
        return Self._toInt(
          sign: unpack.sign,
          magnitude: m,
          status: &status,
          isExact: remainder == 0
        )
      }
    }

    return Self._toUnrepresentableInt(status: &status)
  }

  private static func _toInt<T: FixedWidthInteger>(
    sign: Sign,
    magnitude: T.Magnitude,
    status: inout DecimalStatus,
    isExact: Bool = true
  ) -> T {
    let isNegative = sign.isMinus

    // This path handles all of the unsigned numbers (and some of the signed).
    if magnitude <= T.max.magnitude {
      if !isExact {
        status.set(.isInexact)
      }

      let n = T(truncatingIfNeeded: magnitude)
      return isNegative ? (-1 * n) : n
    }

    assert(T.isSigned)
    if isNegative && magnitude == T.min.magnitude {
      if !isExact {
        status.set(.isInexact)
      }

      return T.min
    }

    // Magnitude is not representable as a signed type.
    // For example 500 (UInt8) as Int8.
    return Self._toUnrepresentableInt(status: &status)
  }

  /// Round `|decimal| < 1`.
  private static func _toRoundedIntWithMagnitudeLessThan1(
    sign: Sign,
    exponent: Int,
    significand: BID,
    significandDigitCount digitCount: Int,
    rounding: DecimalFloatingPointRoundingRule
  ) -> Int {
    let isPositive = sign.isPlus

    switch rounding {
    case .up:
      //  0.1 -> 1
      // -0.1 -> 0
      return isPositive ? 1 : 0

    case .down:
      //  0.1 -> 0
      // -0.1 -> error
      return isPositive ? 0 : -1

    case .towardZero:
      //  0.1 -> 0
      // -0.1 -> 0
      return 0

    case .toNearestOrEven,
         .toNearestOrAwayFromZero:
      // 123E-10 = 0.0_000_000_123 -> 0
      // Exponent is negative so we have to '-exponent'.
      let exponentAbs = -exponent

      if digitCount < exponentAbs {
        return 0
      }

      // 123E-3 = 0.123
      assert(digitCount == exponentAbs)
      let pow10: BID = Tables.getPowerOf10(exponent: exponentAbs)
      let halfway = pow10 / 2

      if significand < halfway {
        return 0
      }

      // Halfway with 'toNearestOrEven' is '0'.
      if rounding == .toNearestOrEven && significand == halfway {
        return 0
      }

      // We are either:
      // - toNearestOrEven - '> halfway'
      // - toNearestOrAwayFromZero - '>= halfway'
      //
      // This means rounding away from '0'.
      return isPositive ? 1 : -1
    }
  }

  private static func _toUnrepresentableInt<T: FixedWidthInteger>(
    status: inout DecimalStatus
  ) -> T {
    status.set(.isInvalidOperation)
    return 1 << (T.bitWidth - 1)
  }
}
