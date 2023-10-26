extension DecimalMixin {

  internal func _remainder(
    dividingBy other: Self,
    status: inout DecimalStatus
  ) -> Self {
    return self._remainder(dividingBy: other, status: &status, isNear: true)
  }

  internal func _truncatingRemainder(
    dividingBy other: Self,
    status: inout DecimalStatus
  ) -> Self {
    return self._remainder(dividingBy: other, status: &status, isNear: false)
  }

  private func _remainder(
    dividingBy other: Self,
    status: inout DecimalStatus,
    isNear: Bool
  ) -> Self {
    // sourceFormat remainder(source, source)
    //
    // When y ≠ 0, the remainder r = remainder(x, y) is defined for finite x
    // and y regardless of the rounding-direction attribute by the mathematical
    // relation r = x−y×n , where n is the integer nearest the exact number x/y;
    // whenever |n−x/y| = ½ , then n is even. Thus, the remainder is always exact.
    //
    // If r=0, its sign shall be that of x. remainder(x, ∞) is x for finite x.
    //
    // The preferred exponent is min(Q(x), Q(y)).
    //
    // 6.1 Infinity arithmetic
    // Operations on infinite operands are usually exact and therefore signal no
    // exceptions, including, among others:
    // ― remainder(x, ∞) for finite normal x
    //
    // The exceptions that do pertain to infinities are signaled only when:
    // ― remainder(subnormal, ∞) signals underflow.
    //
    // 7.2 Invalid operation
    // For operations producing results in floating-point format, the default
    // result of an operation that signals the invalid operation exception shall
    // be a quiet NaN that should provide some diagnostic information (see 6.2).
    // These operations are:
    // f) remainder(x, y), when y is zero or x is infinite and neither is NaN

    if self._isNaN || other._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, other, status: &status)
    }

    // inf % rhs = nan
    if self._isInfinite {
      status.set(.isInvalidOperation)
      return Self._nan
    }

    let lhs = self._unpackFiniteOrZero()

    // lhs % inf = canonical lhs
    if other._isInfinite {
      return Self(canonical: lhs)
    }

    let rhs = other._unpackFiniteOrZero()

    // lhs % 0 = nan
    // In case of '0 % 0 = ?' the 'rhs = 0' takes precedence over the 'lhs' rule.
    if rhs.significand.isZero {
      status.set(.isInvalidOperation)
      return Self._nan
    }

    // 0 % rhs = 0 if y != 0
    if lhs.significand.isZero {
      // The preferred exponent is min(Q(x), Q(y)).
      let sign = self.bid & Self.signMask
      let exponent = Swift.min(lhs.exponent.biased, rhs.exponent.biased)
      return Self(canonical: sign | exponent << Self.exponentShift_00_01_10)
    }

    var sign = lhs.sign

    // 5E5 / 5E20 = 0 rem 5E5
    if lhs.exponent <= rhs.exponent {
      // Important: self has the preferred exponent!
      let exponentDiff = rhs.exponent.signed - lhs.exponent.signed

      // lhs < rhs, and even quantization will not help.
      if exponentDiff > Self.precisionInDigits {
        return Self(canonical: lhs)
      }

      // Quantize 'rhs' to 'lhs'.
      let pow10: BID = Tables.getPowerOf10(exponent: exponentDiff)
      let rhsScaledSignificand = Self._mulSignificands(rhs.significand.canonical, pow10)
      let lhsSignificand = lhs.significand.canonical

      // If 'rhs' is more than 2 times larger than 'rhs' then just return 'lhs'.
      if rhsScaledSignificand.high != 0 || rhsScaledSignificand.low > (lhsSignificand << 1) {
        return Self(canonical: lhs)
      }

      // Unsigned integer remainder
      let rhsSignificand = rhsScaledSignificand.low
      var (quotient, remainder) = lhsSignificand.quotientAndRemainder(dividingBy: rhsSignificand)

      if isNear {
        Self._remRoundQuotientAwayFromZeroIfNeeded(
          sign: &sign,
          quotient: quotient,
          remainder: &remainder,
          rhsSignificand: rhsSignificand
        )
      }

      return Self._packWithoutChecks(
        sign: sign,
        significand: remainder,
        exponent: lhs.exponent
      )
    }

    let rhsSignificand = rhs.significand.canonical
    var quotient: BID = 0
    var remainder = lhs.significand.canonical
    var exponentDiff = lhs.exponent.signed - rhs.exponent.signed
    assert(exponentDiff > 0, "We already checked 'lhs.exponent <= rhs.exponent'?")

    while exponentDiff > 0 {
      // Scale 'remainder' up to 'Self.precisionInDigits + 2' digits.
      let remainderDigitCount = Self._getDecimalDigitCount(remainder)
      var remainderScale = Self.precisionInDigits + 2 - remainderDigitCount

      if remainderScale <= exponentDiff {
        exponentDiff -= remainderScale
      } else {
        // Just use the remaining 'exponentDiff'
        remainderScale = exponentDiff
        exponentDiff = 0
      }

      remainder *= Tables.getPowerOf10(exponent: remainderScale)
      (quotient, remainder) = remainder.quotientAndRemainder(dividingBy: rhsSignificand)

      // Is this an exact division?
      if remainder == 0 {
        return Self._packWithoutChecks(
          sign: sign,
          significand: 0,
          exponent: rhs.exponent
        )
      }
    }

    if isNear {
      Self._remRoundQuotientAwayFromZeroIfNeeded(
        sign: &sign,
        quotient: quotient,
        remainder: &remainder,
        rhsSignificand: rhsSignificand
      )
    }

    return Self._packWithoutChecks(
      sign: sign,
      significand: remainder,
      exponent: rhs.exponent
    )
  }

  /// `n` has to be an integer NEAREST the exact number x/y:
  /// - `remainder` is more than half of `rhs` -> increase `n`
  /// - `remainder` is exactly half of `rhs` and `n` is odd -> make `n` even
  private static func _remRoundQuotientAwayFromZeroIfNeeded(
    sign: inout Sign,
    quotient: BID,
    remainder: inout BID,
    rhsSignificand: BID
  ) {
    let remainder2 = remainder + remainder
    let isRoundingQuotientAwayFromZero = remainder2 > rhsSignificand
      || (remainder2 == rhsSignificand && quotient.isOdd)

    if isRoundingQuotientAwayFromZero {
      remainder = rhsSignificand - remainder
      sign = sign.isPlus ? .minus : .plus
    }
  }
}
