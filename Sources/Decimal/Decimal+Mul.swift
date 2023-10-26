extension DecimalMixin {

  internal func _multiplied(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // formatOf-multiplication(source1, source2)
    //
    // The operation multiplication(x, y) computes x × y.
    // The preferred exponent is Q(x) + Q( y).
    //
    // 6.1 Infinity arithmetic
    // Operations on infinite operands are usually exact and therefore signal no
    // exceptions, including, among others:
    // ― multiplication(∞, x) or multiplication(x, ∞) for finite or infinite x ≠ 0
    //
    // 7.2 Invalid operation
    // For operations producing results in floating-point format, the default
    // result of an operation that signals the invalid operation exception shall
    // be a quiet NaN that should provide some diagnostic information (see 6.2).
    //
    // These operations are:
    // b) multiplication: multiplication(0, ∞) or multiplication(∞, 0)

    if self._isNaN || other._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, other, status: &status)
    }

    let sign = self._sign ^ other._sign

    if self._isInfinite {
      if other._isZero {
        status.set(.isInvalidOperation)
        return ._nan
      }

      return Self(canonical: sign | Self.infinityMask)
    }

    if other._isInfinite {
      if self._isZero {
        status.set(.isInvalidOperation)
        return ._nan
      }

      return Self(canonical: sign | Self.infinityMask)
    }

    let lhs = self._unpackFiniteOrZero()
    let rhs = other._unpackFiniteOrZero()
    let exponentSum = lhs.exponent.signed + rhs.exponent.signed

    if lhs.significand.isZero || rhs.significand.isZero {
      let clampedExponent = clamp(
        exponentSum,
        min: Self.minSignedExponent,
        max: Self.maxSignedExponent
      )
      let biased = Self._addBias(exponent: clampedExponent)
      return Self(canonical: sign | biased << Self.exponentShift_00_01_10)
    }

    let significand = Self._mulSignificands(lhs, rhs)

    // We have our result: 'significand * 10^exponentSum'.
    // Simplest case it when 'significand' fits inside 'Self.precisionInDigits'.
    // (This is for performance, as operating on DoubleBID is slower than on BID.)
    if significand.high == 0 && significand.low <= Self.maxDecimalDigits {
      // This assertion is more of a curiosity. It does not really matter.
      // Even for 0 the sign follows the normal rules:
      // Double.leastNonzeroMagnitude * (-Double.leastNonzeroMagnitude) // -0.0
      assert(significand.low != 0, "We already handled 0?")

      return Self._pack(
        sign: sign,
        significand: significand.low,
        signedExponent: exponentSum,
        roundingDigitCount: 0,
        rounding: rounding,
        status: &status
      )
    }

    // Now we have to bring 'mul' into 'Self.precisionInDigits' potentially
    // rounding and modifying exponent.
    let roundingDigitCount = Self._getRoundingDigitCount(significand)
    let exponent = lhs.exponent.signed
      + rhs.exponent.signed
      + roundingDigitCount

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }

  internal static func _mulSignificands(
    _ lhs: FiniteUnpack,
    _ rhs: FiniteUnpack
  ) -> DoubleBID {
    return Self._mulSignificands(
      lhs.significand.canonical,
      rhs.significand.canonical
    )
  }

  internal static func _mulSignificands(
    _ lhs: BID,
    _ rhs: BID
  ) -> DoubleBID {
    let m = lhs.multipliedFullWidth(by: rhs)
    return DoubleBID(high: m.high, low: m.low)
  }
}
