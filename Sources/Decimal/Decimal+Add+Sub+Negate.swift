extension DecimalMixin {

  // MARK: - Negate

  internal mutating func _negate() {
    // If the input is not canonical, then we will return non-canonical value.
    // Oh well…
    let bid = self.bid ^ Self.signMask
    self = Self(unchecked: bid)
  }

  // MARK: - Sub

  internal func _subtracting(
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // Change sign, but not for NaN.
    let o = other._isNaN ? other : Self(unchecked: other.bid ^ Self.signMask)
    return self._adding(other: o, rounding: rounding, status: &status)
  }

  // MARK: - Add

  internal func _adding(
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // formatOf-addition(source1, source2)
    //
    // The operation addition(x, y) computes x + y.
    // The preferred exponent is min(Q(x), Q( y)).
    //
    // 6.1 Infinity arithmetic
    // Operations on infinite operands are usually exact and therefore signal no
    // exceptions, including, among others:
    // ― addition(∞, x), addition(x, ∞), subtraction(∞, x), or subtraction(x, ∞),
    //   for finite x
    //
    // 7.2 Invalid operation
    // For operations producing results in floating-point format, the default
    // result of an operation that signals the invalid operation exception shall
    // be a quiet NaN that should provide some diagnostic information (see 6.2).
    //
    // These operations are:
    // ― addition or subtraction or fusedMultiplyAdd: magnitude subtraction of
    //   infinities, such as: addition(+∞, −∞)

    if self._isNaN || other._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, other, status: &status)
    }

    if self._isInfinite && other._isInfinite {
      if self._isNegative == other._isNegative {
        // +inf + +inf = +inf
        // -inf + -inf = -inf
        return Self(canonical: (self.bid & Self.signMask) | Self.infinityMask)
      }

      // Different signs: inf + -inf = ?
      status.set(.isInvalidOperation)
      return ._nan
    }

    // inf + y = inf
    if self._isInfinite {
      return Self(canonical: (self.bid & Self.signMask) | Self.infinityMask)
    }

    // x + inf = inf
    if other._isInfinite {
      return Self(canonical: (other.bid & Self.signMask) | Self.infinityMask)
    }

    let lhs = self._unpackFiniteOrZero()
    let rhs = other._unpackFiniteOrZero()

    // From now on we will share our code with FMA. This makes the 'add' more
    // complicated, but this code is way too fragile to copy-paste it around.

    return Self._addFiniteOrZero(
      lhs: (
        sign: lhs.sign,
        signedExponent: lhs.exponent.signed,
        significand: lhs.significand.canonical
      ),
      rhs: (
        sign: rhs.sign,
        signedExponent: rhs.exponent.signed,
        significand: rhs.significand.canonical
      ),
      rounding: rounding,
      status: &status
    )
  }

  // MARK: - Finite or zero

  internal typealias AddFiniteOrZero = (
    sign: Sign,
    signedExponent: Int,
    significand: BID
  )

  internal static func _addFiniteOrZero(
    lhs: AddFiniteOrZero,
    rhs: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    let isLhsZero = lhs.significand == 0
    let isRhsZero = rhs.significand == 0

    // 0 + 0 = 0 with minimum exponent.
    if isLhsZero && isRhsZero {
      // The preferred exponent is min(Q(x), Q(y)).
      return Self._additionExactZero(
        lhsSign: lhs.sign,
        rhsSign: rhs.sign,
        signedExponent: Swift.min(lhs.signedExponent, rhs.signedExponent),
        rounding: rounding
      )
    }

    // 0 + y = canonical y
    // The preferred exponent is min(Q(x), Q(y)), so we can only do this when
    // 'self' has bigger exponent.
    if isLhsZero && lhs.signedExponent >= rhs.signedExponent {
      return Self._canonical(rhs)
    }

    // x + 0 = canonical x
    if isRhsZero && rhs.signedExponent >= lhs.signedExponent {
      return Self._canonical(lhs)
    }

    // Sort arguments by exponent. We can do this because:
    //
    // 10.4 Literal meaning and value-changing optimizations
    //
    // A language implementation preserves the literal meaning of the source code
    // by, for example:
    // ― Applying the properties of real numbers to floating-point expressions
    //   only when they preserve numerical results and flags raised:
    //   ― Applying the commutative law only to operations, such as addition and
    //     multiplication, for which neither the numerical values of the results,
    //     nor the representations of the results, depend on the order of the operands.
    let lhsHasBiggerExponent = lhs.signedExponent >= rhs.signedExponent
    var big = lhsHasBiggerExponent ? lhs : rhs
    let small = lhsHasBiggerExponent ? rhs : lhs
    assert(big.signedExponent >= small.signedExponent)

    // One of the exponents dominates the other.
    //
    // Example for precision 5:
    // - big  123E6 = 12300E4 = 123 000 000
    // - small 12E0 =                    12
    // - sum        =           123 000 012 = 12300E4
    if small.signedExponent + Self.precisionInDigits < big.signedExponent {
      // Rescale 'big' to fill all 'precision' digits.
      // This will also take care of: The preferred exponent is min(Q(x), Q(y)).
      big = Self._quantizeToUseAllDecimalDigits(big)

      // Same check as above.
      // Are they comparable after the quantization?
      if small.signedExponent + Self.precisionInDigits < big.signedExponent {
        return Self._additionWithBigExponentDiscrepancy(
          quantizedBigExponent: big,
          smallExponent: small,
          rounding: rounding,
          status: &status
        )
      }
    }

    // Bring 'big' to the exponent of 'small'.
    let bigInSmallExponent: DoubleBID = {
      let exponentDiff = big.signedExponent - small.signedExponent
      let pow10: BID = Tables.getPowerOf10(exponent: exponentDiff)
      let m = big.significand.multipliedFullWidth(by: pow10)
      return DoubleBID(high: m.high, low: m.low)
    }()

    // Now we can just add 'bigInSmallExponent + small.significand' and the final
    // result will be: 'resultInSmallExponent * 10^small.exponent'.
    let (resultSign, resultInSmallExponent) = Self._addSignificands(
      lhsSign: big.sign,
      lhs: bigInSmallExponent,
      rhsSign: small.sign,
      rhs: small.significand
    )

    // Special case for '0', because of the sign requirements.
    // Note that this is an exact '0', so the rule applies here.
    // Rounded '0' does not get the special treatment.
    if resultInSmallExponent == 0 {
      return Self._additionExactZero(
        lhsSign: lhs.sign,
        rhsSign: rhs.sign,
        signedExponent: small.signedExponent,
        rounding: rounding
      )
    }

    // We have our result: 'resultInSmallExponent * 10^small.exponent'.
    // Simplest case it when 'resultInSmallExponent' fits inside 'Self.precisionInDigits'.
    // (This is for performance, as operating on DoubleBID is slower than on BID.)
    var exponent = small.signedExponent

    let isResultSignificandSmall = resultInSmallExponent.high == 0
      && resultInSmallExponent.low <= Self.maxDecimalDigits

    // This one is for FMA. Addition will always be in range.
    let isResultExponentInRange = Self.minSignedExponent <= exponent
      && exponent <= Self.maxSignedExponent

    if isResultSignificandSmall && isResultExponentInRange {
      return Self._packWithoutChecks(
        sign: resultSign,
        significand: resultInSmallExponent.low,
        signedExponent: exponent
      )
    }

    // Now we have to bring 'resultInSmallExponent' into 'Self.precisionInDigits'
    // potentially rounding and modifying exponent.
    let roundingDigitCount = Self._getRoundingDigitCount(resultInSmallExponent)
    exponent += roundingDigitCount

    return Self._pack(
      sign: resultSign,
      significand: resultInSmallExponent,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }

  private static func _canonical(_ a: AddFiniteOrZero) -> Self {
    return Self._packWithoutChecks(
      sign: a.sign,
      significand: a.significand,
      signedExponent: a.signedExponent
    )
  }

  private static func _quantizeToUseAllDecimalDigits(
    _ a: AddFiniteOrZero
  ) -> AddFiniteOrZero {
    let (significand, signedExponent, _) = Self._quantizeToUseAllDecimalDigits(
      significand: a.significand,
      signedExponent: a.signedExponent
    )

    return AddFiniteOrZero(
      sign: a.sign,
      signedExponent: signedExponent,
      significand: significand
    )
  }

  internal typealias AddSignificandsResult = (sign: Sign, significand: DoubleBID)

  internal static func _addSignificands(
    lhsSign: Sign,
    lhs: DoubleBID,
    rhsSign: Sign,
    rhs: BID
  ) -> AddSignificandsResult {
    return Self._addSignificands(
      lhsSign: lhsSign,
      lhs: lhs,
      rhsSign: rhsSign,
      rhs: DoubleBID(high: 0, low: rhs)
    )
  }

  internal static func _addSignificands(
    lhsSign: Sign,
    lhs: DoubleBID,
    rhsSign: Sign,
    rhs: DoubleBID
  ) -> AddSignificandsResult {
    if lhsSign == rhsSign {
      //  123000E7 +  777E7 =  123777E7
      // -123000E7 + -777E7 = -123777E7
      return (lhsSign, lhs + rhs)
    }

    // We have different signs.
    // We need to subtract: 'bigger magnitude - smaller magnitude'.
    // Sign will be taken from 'bigger magnitude'.

    if lhs >= rhs {
      return (lhsSign, lhs - rhs)
    }

    return (rhsSign, rhs - lhs)
  }

  // MARK: - Exact zero

  /// Important: this only applies if the zero is EXACT!!1
  internal static func _additionExactZero(
    lhsSign: Sign,
    rhsSign: Sign,
    signedExponent: Int,
    rounding: DecimalFloatingPointRoundingRule
  ) -> Self {
    // IEEE-754 -> 6.3 The sign bit
    // When the sum of two operands with opposite signs (or the difference of
    // two operands with like signs) is exactly zero, the sign of that sum
    // (or difference) shall be +0 in all rounding-direction attributes except
    // roundTowardNegative; under that attribute, the sign of an exact zero sum
    // (or difference) shall be −0.
    // However, x + x = x − (−x) retains the same sign as x even when x is zero.
    let sign: Sign = {
      let isSameSign = lhsSign == rhsSign

      switch rounding {
      case .down where !isSameSign:
        return .minus
      case .up, .down, .towardZero, .toNearestOrEven, .toNearestOrAwayFromZero:
        // If we have the same sign then: 'retains the same sign as x' apply.
        return isSameSign ? lhsSign : .plus
      }
    }()

    let clampedExponent = clamp(
      signedExponent,
      min: Self.minSignedExponent,
      max: Self.maxSignedExponent
    )

    let biased = Self._addBias(exponent: clampedExponent)
    return Self(canonical: sign | biased << Self.exponentShift_00_01_10)
  }

  // MARK: - Big exponent discrepancy

  /// Call `Self._quantizeToUseAllDecimalDigits(bigExponent)` before calling this
  /// method!
  internal static func _additionWithBigExponentDiscrepancy(
    quantizedBigExponent big: AddFiniteOrZero,
    smallExponent small: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // For example:
    //  Precision = Self.maxDecimalDigits = 5
    //  big   = 12312E9 = 12312 000 000 000
    //  small = 56789E3 =        56 789 000
    //
    // Small exponent is <9-5 which is <4.

#if DEBUG
    // Big.exponent below 'minSignedExponent'?
    // If 'big.signedExponent < Self.minSignedExponent' then how did we arrive
    // to 'big exponent discrepancy'? Small would have to be even smaller.
    //
    // Big.exponent above 'maxSignedExponent'?
    // We are 'ok' with 'big.signedExponent > Self.maxSignedExponent' because
    // big is quantized to fill the whole 'precision' (see the next assert).
    // In such case we join Buzz Lightyear in the journey to 'infinity' and beyond.
    assert(big.signedExponent >= Self.minSignedExponent, "big.exponent < min?")

    // In just a sec we will be doing rounding with, so we need it quantized.
    Self._assertQuantizedToAllDecimalDigits(
      significand: big.significand,
      signedExponent: big.signedExponent
    )

    let __smallDigitCount = Self._getDecimalDigitCount(small.significand)
    assert(
      __smallDigitCount + small.signedExponent < big.signedExponent,
      "Small exponent discrepancy?"
    )
#endif

    let sign = big.sign

    if small.significand == 0 {
      // We can return canonical 'big', because '_quantizeToUseAllDecimalDigits'
      // was called before this method. This lowered exponent to as close as
      // possible to the preferred one.
      // Though it is still possible that 'big.exponent > maxSignedExponent' (FMA).
      if big.signedExponent > Self.maxSignedExponent {
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      }

      return Self._packWithoutChecks(
        sign: sign,
        significand: big.significand,
        signedExponent: big.signedExponent
      )
    }

    // 'small' has 'something' -> returning 'big' is 'inexact'.
    status.set(.isInexact)

    // leastNormalMagnitude - small = underflow
    if big.signedExponent == Self.minSignedExponent {
      let leastNormal = Self._leastNormalMagnitudeSignificand
      let isBelowNormal = big.significand < leastNormal
      let isNormalTowardZero = big.significand == leastNormal && big.sign != small.sign

      if isBelowNormal || isNormalTowardZero {
        status.set(.isUnderflow)
      }
    }

    var significand = big.significand
    var exponent = big.signedExponent
    var direction = AdditionWithBigExponentDiscrepancy_RoundingDirection.none

    switch rounding {
    case .up:
      // +big + +small = away from 0, significand +1
      // +big + -small = big
      // -big + +small = toward 0, significand -1
      // -big + -small = big
      if big.sign.isMinus && small.sign.isPlus { direction = .towardZero }
      if big.sign.isPlus && small.sign.isPlus { direction = .awayFromZero }

    case .down:
      // +big + +small = big
      // +big + -small = toward 0, significand -1
      // -big + +small = big
      // -big + -small = away from 0, significand +1
      if big.sign.isPlus && small.sign.isMinus { direction = .towardZero }
      if big.sign.isMinus && small.sign.isMinus { direction = .awayFromZero }

    case .towardZero:
      // +big + +small = big
      // +big + -small = toward 0, significand -1
      // -big + +small = toward 0, significand -1
      // -big + -small = big
      if big.sign != small.sign { direction = .towardZero }

    case .toNearestOrEven,
         .toNearestOrAwayFromZero:
      // What happens here is that we are changing the ulp ('big' is power of 10).
      // This rounding has to be done with lower number ulp which will round it
      // to the lower number. This is because ulp for powers of radix is kind of
      // asymmetrical toward/away from zero.
      //
      // let lhs = Decimal32("+1000000E+8")!
      // let rhs = Decimal32("-5000001")!
      // lhs._adding(other: rhs, rounding: .toNearestOrEven, status: &s)
      //
      // 1 000 000|000 000 00 // 1000000E+8
      //           -50 000 01 // -5000001
      // 9 999 999| 00 000 00  // 9999999E+7 <-- expected result
      //         1| 00 000 00  //       1E+7 <-- ulp of 9999999E+7
      //                                         you have to divide it by 2
      //
      // Is this the only case when we have to do the rounding?
      // Probably.
      // Before calling this method we did '_quantizeToUseAllDecimalDigits'.
      // - if this filled all digits -> this is our case
      // - if this has NOT filled all digits -> exponent did not allow us
      //                                     -> no 'big exponent discrepancy'
      let lowerPowerOf10Ulp = (Self.maxDecimalDigits + 1) / 2

      if
          // Small is just after big
          big.signedExponent == small.signedExponent + Self.precisionInDigits + 1
          // Different signs
          && big.sign != small.sign
          // Max power of 10 (we quantized 'big' before calling this method)
          && (significand == (Self.maxDecimalDigits + 1) / 10)
          // We trigger rounding on the lower number. On exactly halfway:
          // - orEven - current 'significand' is even -> not applicable
          // - orAwayFromZero - current 'significand' is 'more away' -> not applicable
          && (small.significand > lowerPowerOf10Ulp) {
        significand = Self.maxDecimalDigits
        exponent -= 1
      }
    }

    return Self._additionWithBigExponentDiscrepancy_roundAndPack(
      sign: sign,
      signedExponent: exponent,
      quantizedSignificand: significand,
      additionRounding: direction,
      rounding: rounding,
      status: &status
    )
  }
}

internal enum AdditionWithBigExponentDiscrepancy_RoundingDirection {
  case awayFromZero
  case towardZero
  case none
}

extension DecimalMixin {

  /// This method does not handle underflow BEFORE rounding!
  /// But how can you underflow with big exponent discrepancy?
  /// Is the 2nd exponent even smaller?
  internal static func _additionWithBigExponentDiscrepancy_roundAndPack(
    sign: Sign,
    signedExponent: Int,
    quantizedSignificand significand: BID,
    additionRounding: AdditionWithBigExponentDiscrepancy_RoundingDirection,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
#if DEBUG
    // We can deal with overflow, but not with underflow.
    assert(signedExponent >= Self.minSignedExponent, "exponent < min?")

    // In just a sec we will be doing rounding, so we need it quantized.
    Self._assertQuantizedToAllDecimalDigits(
      significand: significand,
      signedExponent: signedExponent
    )
#endif

    var significand = significand
    var exponent = signedExponent

    switch additionRounding {
    case .awayFromZero:
      significand += 1

      // Make it canonical if needed.
      if significand == Self.maxDecimalDigits + 1 {
        significand /= 10
        exponent += 1
      }

    case .towardZero:
      // The preferred exponent is min(Q(x), Q(y)).
      // If 'significand == 0' -> we can't subtract. But it would also mean
      // that '0' has bigger exponent, which should be handled before calling
      // this method.
      assert(
        significand != 0,
        "0 has bigger exponent -> fast-path before we even call this method"
      )

      significand -= 1

      // 1 000 000 000 000 000E7 - 1 =   999 999 999 999 999E+7
      //                but should be: 9 999 999 999 999 999E+6
      //
      // This situation is referred as EXPONENT_DECREASE_SPECIAL_CASE below.
      if significand == Self.maxDecimalDigits / 10 {
        significand = Self.maxDecimalDigits
        exponent -= 1
      }

    case .none:
      break
    }

#if DEBUG
    // We are AFTER the rounding, our new state may be underflow/overflow.
    // Btw. this seems like a double rounding, but:
    //
    // - overflow  will try to decrease the exponent by increasing significand.
    //   Since significand was quantized to all decimal digits then there is
    //   no more space to do this. The edge cases that change the number of
    //   digits were handled inside the 'ifs':
    //   - 999 + 1 -> 100, exponent++
    //   - 100 - 1 -> 999, exponent--
    //
    // - underflow - 'pack' will try to increase exponent by decreasing the
    //   significand.
    //   - ADD - in the worst case 'small' was 'leastNonzeroMagnitude'.
    //     Big exponent discrepancy means that even after the rounding toward 0
    //     we are still able to avoid underflow (by a lot).
    //
    //     let lhs = Decimal32("1000000E\(-101 + 8)")!
    //     let rhs = Decimal32.leastNonzeroMagnitude
    //     let result = lhs.subtracting(rhs, rounding: .towardZero, status: &status)
    //     print(result, status) // 9999999E-94, isInexact
    //
    //   - FMA
    //     - if 'add' is 'smaller' -> same case as 'add' above.
    //     - if 'mul' is 'smaller' (possibly way out of exponent range, E-9999999)
    //         - if exponent is the same as before rounding -> no underflow.
    //         - if we decreased the exponent - EXPONENT_DECREASE_SPECIAL_CASE.
    //
    //           let lhs = Decimal32("-1000000E-101")!
    //           let result = lhs.addingProduct(
    //             .leastNonzeroMagnitude, // 1E-101
    //             .leastNonzeroMagnitude, // 1E-101
    //             rounding: .towardZero,
    //             status: &status
    //           )
    //
    //           The result after the 1st rounding is: 9999999E-102
    //           This is underflow: -102 < -101, we need to remove the last 9:
    //
    //           Rounding               |Positive    |Negative     |Status
    //           up                     |1000000E-101| -999999E-101|underflow, inexact
    //           down                   | 999999E-101|-1000000E-101|underflow, inexact
    //           towardZero             | 999999E-101| -999999E-101|underflow, inexact
    //           toNearestOrEven        |1000000E-101|-1000000E-101|underflow, inexact
    //           toNearestOrAwayFromZero|1000000E-101|-1000000E-101|underflow, inexact
    if exponent < Self.minSignedExponent {
      // (FMA only)
      // Underflow, the last '9' will be used for rounding -> always away.
      assert(significand == Self.maxDecimalDigits)
    } else {
      // It was quantized before rounding, it should stay this way.
      Self._assertQuantizedToAllDecimalDigits(
        significand: significand,
        signedExponent: exponent
      )
    }
#endif

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: 0,
      rounding: rounding,
      status: &status
    )
  }
}
