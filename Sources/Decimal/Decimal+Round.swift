extension DecimalMixin {

  // MARK: - Round

  /// `roundToIntegralExact`
  /// If the rounding occurs then `isInexact` flag is raised. <-- IMPORTANT!
  internal func _round(
    _ rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // ==============================================
    // === Description for 'roundToIntegralExact' === <- We implement this!
    // ==============================================
    // For the following operation, the rounding direction is the applicable
    // rounding-direction attribute. This operation signals the invalid operation
    // exception for a signaling NaN operand, and for a numerical operand,
    // signals the inexact exception if the result does not have the same
    // numerical value as x.
    //
    // ― sourceFormat roundToIntegralExact(source)
    // roundToIntegralExact(x) rounds x to an integral value according to the
    // applicable rounding-direction attribute.
    //
    // The preferred exponent is max(Q(source), 0), even when the inexact
    // exception is signaled.
    //
    // ==========================================
    // === Description for 'roundToIntegral…' ===
    // ==========================================
    // 5.9 Details of operations to round a floating-point datum to integral value
    //
    // Several operations round a floating-point number to an integral valued
    // floating-point number in the same format.
    //
    // The rounding is analogous to that specified in Clause 4, but the rounding
    // chooses only from among those floating-point numbers of integral values
    // in the format. These operations convert zero operands to zero results of
    // the same sign, and infinite operands to infinite results of the same sign.
    //
    // For the following operations, the rounding direction is specified by the
    // operation name and does not depend on a rounding-direction attribute.
    // These operations shall not signal any exception except for signaling NaN
    // input.
    //
    // The preferred exponent is max(Q(source), 0).

    if self._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, status: &status)
    }

    let sign = self._sign

    if self._isInfinite {
      return Self(canonical: sign | Self.infinityMask)
    }

    let unpack = self._unpackFiniteOrZero()
    let exponent = unpack.exponent
    let significand = unpack.significand.canonical

    // Zero is already rounded, but make it canonical.
    // The preferred exponent is max(Q(source), 0).
    if significand == 0 {
      let e = Swift.max(exponent.biased, BID(Self.exponentBias))
      return Self(canonical: sign | e << Self.exponentShift_00_01_10)
    }

    // Yer a W̵i̵z̵z̵a̵r̵d̵ Int, Harry.
    if exponent.signed >= 0 {
      return Self._packWithoutChecks(
        sign: sign,
        significand: significand,
        exponent: exponent
      )
    }

    let digitCount = Self._getDecimalDigitCount(significand)

    // Ultra small values like -1 < x < 1 go to -1, 0 or 1.
    if exponent.signed <= -digitCount {
      status.set(.isInexact)

      switch rounding {
      case .up:
        return sign.isPlus ? Self._one : Self._minusZero
      case .down:
        return sign.isPlus ? Self._zero : Self._minusOne
      case .towardZero:
        return sign.isPlus ? Self._zero : Self._minusZero

      case .toNearestOrEven, .toNearestOrAwayFromZero:
        // 567E-3 = 0.567 -> 1
        if exponent.signed == -digitCount {
          let pow10: BID = Tables.getPowerOf10(exponent: digitCount)
          let halfway = pow10 / 2

          // '0' is even -> we don't need a special case for halfway 'toNearestOrEven'.
          if significand > halfway
            || (rounding == .toNearestOrAwayFromZero && significand == halfway) {
            return sign.isPlus ? Self._one : Self._minusOne
          }
        }

        return sign.isPlus ? Self._zero : Self._minusZero
      }
    }

    // At this point we know that we have a fraction (exponent < 0).
    assert(-digitCount < exponent.signed && exponent.signed < 0)

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: 0,
      roundingDigitCount: -exponent.signed,
      rounding: rounding,
      status: &status
    )
  }

  // MARK: - Infinitely big/small

  /// Remember to: `status.set(.isOverflowInexact)`  if needed.
  internal static func _roundInfinitelyBigValue(
    sign: Sign,
    rounding: DecimalFloatingPointRoundingRule
  ) -> Self {
    // IEEE-754 -> 7.4 Overflow
    // a) roundTiesToEven and roundTiesToAway carry all overflows to ∞ with the
    //    sign of the intermediate result.
    // b) roundTowardZero carries all overflows to the format’s largest finite
    //    number with the sign of the intermediate result.
    // c) roundTowardNegative carries positive overflows to the format’s largest
    //    finite number, and carries negative overflows to −∞.
    // d) roundTowardPositive carries negative overflows to the format’s most
    //    negative finite number, and carries positive overflows to +∞.

    // Infinity or greatestFiniteMagnitude.
    let isInfinity: Bool

    switch rounding {
    case .up: isInfinity = sign.isPlus
    case .down: isInfinity = sign.isMinus
    case .towardZero: isInfinity = false
    case .toNearestOrEven: isInfinity = true
    case .toNearestOrAwayFromZero: isInfinity = true
    }

    if isInfinity {
      return Self(canonical: sign | Self.infinityMask)
    }

    let magnitude = Self._greatestFiniteMagnitude
    return Self(canonical: sign | magnitude.bid)
  }

  /// Remember to: `status.set(.isUnderflowInexact)` if needed.
  internal static func _roundInfinitelySmallValue(
    sign: Sign,
    preferredSignedExponentForZero: Int,
    rounding: DecimalFloatingPointRoundingRule
  ) -> Self {
    // LeastNonzeroMagnitude or zero.
    let isLeastNonzeroMagnitude: Bool

    switch rounding {
    case .up:
      isLeastNonzeroMagnitude = sign.isPlus
    case .down:
      isLeastNonzeroMagnitude = sign.isMinus
    case .towardZero,
         .toNearestOrEven,
         .toNearestOrAwayFromZero:
      // 0 is 'closer'.
      isLeastNonzeroMagnitude = false
    }

    if isLeastNonzeroMagnitude {
      let magnitude = Self._leastNonzeroMagnitude
      return Self(canonical: sign | magnitude.bid)
    }

    let biased = Self._addBias(exponent: preferredSignedExponentForZero)
    return Self(canonical: sign | biased << Self.exponentShift_00_01_10)
  }
}

// MARK: - Round with digits

internal struct _RoundWithDigitsResult<BID: BinaryIntegerDecimal> {
  internal enum After {
    case aboveMaxDecimalDigits
    case value(BID)
  }

  internal let beforeRounding: BID
  internal let afterRounding: After
  internal let isInexact: Bool
}

extension DecimalMixin {

  internal typealias RoundWithDigitsResult = _RoundWithDigitsResult<BID>

  /// Got some `significand`?
  /// Got some `roundingDigits`?
  /// Here is the answer.
  ///
  /// After removing `roundingDigits` the `significand` HAS to be
  /// `<= Self.maxDecimalDigits`!
  internal static func _round<T: BinaryIntegerDecimal>(
    sign: Sign,
    significand: T,
    roundingDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule
  ) -> RoundWithDigitsResult {
    Self._assertSignificandLessEqualMaxDecimalDigits(
      significand: significand,
      roundingDigitCount: roundingDigitCount
    )

    if roundingDigitCount == 0 {
      let s = BID(significand)
      return RoundWithDigitsResult(
        beforeRounding: s,
        afterRounding: .value(s),
        isInexact: false
      )
    }

    let pow10: T = Tables.getPowerOf10(exponent: roundingDigitCount)
    let (quotient, roundingDigits) = significand.quotientAndRemainder(dividingBy: pow10)

    // The main precondition for this function guarantees that this is a valid cast.
    let beforeRounding = BID(quotient)
    let halfway = pow10 / 2 // the same as: pow10 / 10 * 5

    let isRoundingAwayFromZero = Self._isRoundingAwayFromZero(
      sign: sign,
      significand: beforeRounding,
      roundingDigits: roundingDigits,
      halfway: halfway,
      rounding: rounding
    )

    let isMax = beforeRounding == Self.maxDecimalDigits

    let after: RoundWithDigitsResult.After = isRoundingAwayFromZero && isMax ?
      .aboveMaxDecimalDigits :
      .value(beforeRounding + (isRoundingAwayFromZero ? 1 : 0))

    return RoundWithDigitsResult(
      beforeRounding: beforeRounding,
      afterRounding: after,
      isInexact: roundingDigits != 0
    )
  }

  /// Round `significand` based on digits after it (`roundingDigits`).
  ///
  /// - `roundingDigits` - digits on which we decide whether to round or not.
  /// - `halfway` - halfway point for `toNearestOrEven` and `toNearestOrAwayFromZero`.
  internal static func _isRoundingAwayFromZero<T: BinaryIntegerDecimal>(
    sign: Sign,
    significand: BID,
    roundingDigits: T,
    halfway: T,
    rounding: DecimalFloatingPointRoundingRule
  ) -> Bool {
    switch rounding {
    case .up:
      return sign.isPlus && roundingDigits != 0
    case .down:
      return sign.isMinus && roundingDigits != 0
    case .towardZero:
      return false
    case .toNearestOrEven:
      let isAbove = roundingDigits > halfway
      let isHalfwayOdd = roundingDigits == halfway && significand.isOdd
      return isAbove || isHalfwayOdd
    case .toNearestOrAwayFromZero:
      return roundingDigits >= halfway
    }
  }
}
