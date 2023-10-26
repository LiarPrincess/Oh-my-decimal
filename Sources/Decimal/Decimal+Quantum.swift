extension DecimalMixin {

  // MARK: - Quantum

  internal var _quantum: Self {
    // From IEEE-754 2019:
    // sourceFormat quantum(source)
    //
    // If x is finite number, the operation quantum(x) is the number represented
    // by (0, q, 1) where q is the exponent of x. If x is infinite, quantum(x)
    // is +∞ with no exception.
    //
    // The preferred exponent is Q(x).

    if self._isInfinite {
      return Self._infinity
    }

    if self._isNaN {
      return Self._nan
    }

    // Can you just shift the exponent with 00_01_10 encoding?
    // Yes.
    //
    // The only problem would be if:
    // - we have 11 encoding (2 highest combination bits)
    // - high exponent bits are 11
    //
    // Then after shifting we would end up with 11 encoding instead of 00_01_10.
    // Fortunately this bit pattern (1111 in high combination) is reserved for
    // infinity which we already handled.

    let unpack = self._unpackFiniteOrZero()
    let exponent = unpack.exponent.biased

    let exponentHighBits11: BID = 0b11 << (Self.exponentWidth - 2)
    assert(
      (exponent & exponentHighBits11) != exponentHighBits11,
      "quantum: exponent should not be 0b11xxx"
    )

    // Significand is 1
    return Self(canonical: exponent << Self.exponentShift_00_01_10 | 1)
  }

  // MARK: - Same quantum

  internal func _sameQuantum(other: Self) -> Bool {
    if self._isNaN || other._isNaN {
      return self._isNaN && other._isNaN
    }

    if self._isInfinite || other._isInfinite {
      return self._isInfinite && other._isInfinite
    }

    let selfUnpack = self._unpackFiniteOrZero()
    let otherUnpack = other._unpackFiniteOrZero()
    return selfUnpack.exponent == otherUnpack.exponent
  }

  // MARK: - Quantize

  internal func _quantize(
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // sourceFormat quantize(source, source)
    //
    // For finite decimal operands x and y of the same format, quantize(x, y) is
    // a floating-point number in the same format that has, if possible, the same
    // numerical value as x and the same quantum as y.
    //
    // If the exponent is being increased, rounding according to the applicable
    // rounding-direction attribute might occur: the result is a different
    // floating-point representation and the inexact exception is signaled if the
    // result does not have the same numerical value as x.
    //
    // If the exponent is being decreased and the significand of the result would
    // have more than p digits, the invalid operation exception is signaled and
    // the result is NaN.
    //
    // If one or both operands are NaN, the rules in 6.2 are followed.
    //
    // Otherwise if only one operand is infinite then the invalid operation
    // exception is signaled and the result is NaN.
    //
    // If both operands are infinite then the result is canonical ∞ with the sign
    // of x. quantize does not signal underflow or overflow.
    //
    // The preferred exponent is Q(y).

    // If one or both operands are NaN, the rules in 6.2 are followed.
    if self._isNaN || other._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, other, status: &status)
    }

    // If both operands are infinite then the result is canonical ∞ with the
    // sign of x.
    if self._isInfinite && other._isInfinite {
      return Self(canonical: (self.bid & Self.signMask) | Self.infinityMask)
    }

    // Otherwise if only one operand is infinite then the invalid operation
    // exception is signaled and the result is NaN.
    if self._isInfinite || other._isInfinite {
      status.set(.isInvalidOperation)
      return ._nan
    }

    // We can't just pack(self.significand, other.exponent) because that would
    // change the value. We have to actually re-scale our significand.

    let selfUnpack = self._unpackFiniteOrZero()
    let sign = selfUnpack.sign

    let otherUnpack = other._unpackFiniteOrZero()
    let otherExponent = otherUnpack.exponent

    // Zero or non-canonical
    if selfUnpack.significand.isZero {
      return Self._packWithoutChecks(sign: sign, significand: 0, exponent: otherExponent)
    }

    let significand = selfUnpack.significand.canonical
    let selfExponent = selfUnpack.exponent

    if selfExponent == otherExponent {
      return self
    }

    if selfExponent < otherExponent {
      // Increase exponent by dividing significand.
      // - rounding might occur - the result is a different floating-point
      // - inexact exception is signaled if the result != x
      let removedDigitCount = otherExponent.signed - selfExponent.signed

      if removedDigitCount >= Self.precisionInDigits {
        // We are removing the whole 'significand' and making it (rounded) 0.
        assert(significand != 0, "We already checked it?")
        let s: BID

        switch rounding {
        case .up: s = sign.isPlus ? 1 : 0
        case .down: s = sign.isMinus ? 1 : 0
        case .towardZero: s = 0
        case .toNearestOrEven,
             .toNearestOrAwayFromZero:
          if removedDigitCount == Self.precisionInDigits {
            let halfway = (Self.maxDecimalDigits + 1) / 2
            let isAboveHalfway = significand > halfway
            // Significand is 0 = even
            let isHalfway = significand == halfway && rounding == .toNearestOrAwayFromZero
            s = isAboveHalfway || isHalfway ? 1 : 0
          } else {
            s = 0
          }
        }

        status.set(.isInexact) // We checked for 'significand.isZero' before
        return Self._packWithoutChecks(sign: sign, significand: s, exponent: otherExponent)
      }

      return Self._pack(
        sign: sign,
        significand: significand,
        signedExponent: otherExponent.signed,
        roundingDigitCount: removedDigitCount,
        rounding: rounding,
        status: &status
      )
    }

    // Decrease exponent by increasing the significand.
    // If the significand of the result would have more than p digits:
    // - the invalid operation exception is signaled
    // - result is NaN
    assert(selfExponent > otherExponent)

    // We will add this many '0' to significand, 5 -> 5000 etc…
    let addedZeroCount = selfExponent.signed - otherExponent.signed

    if addedZeroCount >= Self.precisionInDigits {
      status.set(.isInvalidOperation)
      return ._nan
    }

    let pow10: BID = Tables.getPowerOf10(exponent: addedZeroCount)
    let (low, ov) = significand.multipliedReportingOverflow(by: pow10)

    if ov || low > Self.maxDecimalDigits {
      status.set(.isInvalidOperation)
      return ._nan
    }

    return Self._packWithoutChecks(sign: sign, significand: low, exponent: otherExponent)
  }

  // MARK: - Quantize to…

  /// Increase significand to get to `newExponent`.
  ///
  /// Returns number of digits in new significand. It may NOT be
  /// `Self.precisionInDigits` if that would make exponent lower than min value.
  internal static func _quantizeToLowerExponent<T: BinaryIntegerDecimal>(
    significand: T,
    oldSignedExponent oldExponent: Int,
    newSignedExponent newExponent: Int
  ) -> (significand: T, signedExponent: Int, digitCount: Int) {
    assert(oldExponent >= newExponent)

    if significand == 0 {
      return (significand, newExponent, Tables.zeroDecimalDigitCount)
    }

    let digitCount = Tables.getDecimalDigitCount(significand)

    // Biased exponent can't go <0!
    // In such case we will go as far as we can.
    // So, instead of multiplying by 10_000, we will multiply by 100.
    let addedDigitCount = Swift.min(
      Self.precisionInDigits - digitCount, // How much more can our significand hold?
      oldExponent + Self.exponentBias, // How low can exponent go?
      oldExponent - newExponent // Get to new exponent
    )

    return Self._quantizeTo(
      significand: significand,
      signedExponent: oldExponent,
      digitCount: digitCount,
      addedDigitCount: addedDigitCount
    )
  }

  internal static func _quantizeToUseAllDecimalDigits(
    significand: Significand,
    exponent: Exponent
  ) -> (significand: BID, signedExponent: Int, digitCount: Int) {
    return Self._quantizeToUseAllDecimalDigits(
      significand: significand.canonical,
      signedExponent: exponent.signed
    )
  }

  /// Increase significand to fill all `maxDecimalDigits` while decreasing exponent.
  ///
  /// Returns number of digits in new significand. It may NOT be
  /// `Self.precisionInDigits` if that would make exponent lower than min value.
  ///
  /// Example for Decimal32 (maxDecimalDigits = 7):
  /// - Input:  `123 * 10^10`
  /// - Output: `123_0000 * 10^6`
  internal static func _quantizeToUseAllDecimalDigits<T: BinaryIntegerDecimal>(
    significand: T,
    signedExponent: Int
  ) -> (significand: T, signedExponent: Int, digitCount: Int) {
    if significand == 0 {
      return (significand, signedExponent, Tables.zeroDecimalDigitCount)
    }

    let digitCount = Tables.getDecimalDigitCount(significand)

    // Biased exponent can't go <0!
    // In such case we will go as far as we can.
    // So, instead of multiplying by 10_000, we will multiply by 100.
    let addedDigitCount = Swift.min(
      Self.precisionInDigits - digitCount, // How much we need?
      signedExponent + Self.exponentBias // How low can exponent go?
    )

    return Self._quantizeTo(
      significand: significand,
      signedExponent: signedExponent,
      digitCount: digitCount,
      addedDigitCount: addedDigitCount
    )
  }

  /// Common for `_quantizeTo…`.
  private static func _quantizeTo<T: BinaryIntegerDecimal>(
    significand: T,
    signedExponent: Int,
    digitCount: Int,
    addedDigitCount: Int
  ) -> (significand: T, signedExponent: Int, digitCount: Int) {
    // For 'DoubleBID' the 'addedDigitCount' may be below 0.
    // For example:
    // - precision = 16
    // - significand has 30 digits
    // - addedDigitCount = 16 - 30 = -14
    if addedDigitCount <= 0 {
      return (significand, signedExponent, digitCount)
    }

    let pow10: T = Tables.getPowerOf10(exponent: addedDigitCount)
    let s = significand * pow10
    // Multiplication by 10 only adds '0' after the number.
    // If we started with '9' we are now '9000000…', which should be 'ok'.
    assert(s <= Self.maxDecimalDigits)

    let e = signedExponent - addedDigitCount
    return (s, e, digitCount + addedDigitCount)
  }

  // MARK: - Assert

  /// Are all 'precision' digits filled?
  internal static func _assertQuantizedToAllDecimalDigits(
    significand: BID,
    signedExponent: Int
  ) {
#if DEBUG
    let (__significandQuant, __exponentQuant, _) = Self._quantizeToUseAllDecimalDigits(
      significand: significand,
      signedExponent: signedExponent
    )
    assert(__significandQuant == significand, "significand not quantified?")
    assert(__exponentQuant == signedExponent, "exponent not quantified?")
#endif
  }
}
