// swiftlint:disable shorthand_operator

extension DecimalMixin {

  private typealias FmaMul = (
    sign: Sign,
    signedExponent: Int,
    /// Exponent for the 'Self.precisionInDigits' part of the 'significand',
    /// because 'self.signedExponent' includes the rounding digits!
    ///
    /// Basically: `self.signedExponent + self.roundingDigitCount`.
    ///
    /// Example for precision = 7:
    /// - mul:                     1234567890E10 (more digits than precision!)
    /// - without rounding digits:    1234567E13
    signedExponentWithoutRoundingDigits: Int,
    /// Significand with rounding digits after.
    significand: DoubleBID,
    /// Number of decimal digits in `significand`.
    digitCount: Int,
    /// Number of decimal digits in `significand` that are used for rounding.
    roundingDigitCount: Int
  )

  /// 🧛🏻 Bad things happen here!
  internal static func _fusedMultiplyAdd(
    mulLhs: Self,
    mulRhs: Self,
    add: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // formatOf-fusedMultiplyAdd(source1, source2, source3)
    //
    // The operation fusedMultiplyAdd(x, y, z) computes (x × y) + z as if with
    // unbounded range and precision, rounding only once to the destination format.
    //
    // No underflow, overflow, or inexact exception (see 7) can arise due to the
    // multiplication, but only due to the addition; and so fusedMultiplyAdd
    // differs from a multiplication operation followed by an addition operation.
    //
    // The preferred exponent is min(Q(x) + Q(y), Q(z)).
    //
    // Every general-computational and quiet-computational operation involving
    // one or more input NaNs, none of them signaling, shall signal no exception,
    // except fusedMultiplyAdd might signal the invalid operation exception (see 7.2).
    //
    // 7.2 Invalid operation
    // For operations producing results in floating-point format, the default
    // result of an operation that signals the invalid operation exception shall
    // be a quiet NaN that should provide some diagnostic information (see 6.2).
    //
    // These operations are:
    // ― fusedMultiplyAdd(0, ∞, c) or fusedMultiplyAdd(∞, 0, c) unless c is a
    //   quiet NaN; if c is a quiet NaN then it is implementation defined whether
    //   the invalid operation exception is signaled
    //
    // 6.3 The sign bit 6.30
    // When (a × b) + c is exactly zero, the sign of fusedMultiplyAdd(a, b, c)
    // shall be determined by the rules above for a sum of operands. When the
    // exact result of (a × b) + c is non-zero yet the result of fusedMultiplyAdd
    // is zero because of rounding, the zero result takes the sign of the exact
    // result.

    if mulLhs._isNaN || mulRhs._isNaN || add._isNaN {
      return Self._fmaNaN(mulLhs, mulRhs, add, status: &status)
    }

    if mulLhs._isInfinite || mulRhs._isInfinite || add._isInfinite {
      return Self._fmaInfinity(mulLhs, mulRhs, add, status: &status)
    }

    // Shadow the inputs, because we will not need them anymore.
    let mulLhs = mulLhs._unpackFiniteOrZero()
    let mulRhs = mulRhs._unpackFiniteOrZero()

    let addUnpack = add._unpackFiniteOrZero()
    var add = AddFiniteOrZero(
      sign: addUnpack.sign,
      signedExponent: addUnpack.exponent.signed,
      significand: addUnpack.significand.canonical
    )

    let isMulZero = mulLhs.significand.isZero || mulRhs.significand.isZero
    let mulSign = mulLhs.sign ^ mulRhs.sign
    let mulExponent = mulLhs.exponent.signed + mulRhs.exponent.signed

    // (0 * rhs) + ±0 = 0
    if isMulZero && add.significand == 0 {
      // The preferred exponent is min(Q(x) + Q(y), Q(z)).
      // There are some special rules about the sign of this thingie.
      return Self._additionExactZero(
        lhsSign: mulSign,
        rhsSign: add.sign,
        signedExponent: Swift.min(mulExponent, add.signedExponent),
        rounding: rounding
      )
    }

    // (0 * rhs) + add
    if isMulZero {
      return Self._fmaMulIsZero(
        mulExponent: mulExponent,
        add: add,
        rounding: rounding,
        status: &status
      )
    }

    // What about 'if add.isZero {…}'?
    // We can't just call 'multiply' because it has different preferred exponent.
    // Also, it would round, and if the addition has lower exponent (preferred
    // exponent for FMA) then we would have to quantize the rounded value!
    // Double rounding! Oh no!

    // Everything we know about the multiplication result.
    // From now on use this value instead of 'mulSign' and 'mulExponent'.
    // This is just a normal Decimal with significand and exponent.
    // It has some 'roundingDigits' digits after the significand.
    let mul: FmaMul = {
      let significand = Self._mulSignificands(mulLhs, mulRhs)
      assert(significand != 0, "Multiplication of 2 finite (non 0) numbers gave 0?")

      // We have multiplication result: 'significand * 10^mulExponent'.
      // Let's bring it into 'Self.precisionInDigits' range.
      let digitCount = Self._getDecimalDigitCount(significand)

      return FmaMul(
        sign: mulSign,
        signedExponent: mulExponent,
        signedExponentWithoutRoundingDigits: mulExponent + digitCount.roundingDigitCount,
        significand: significand,
        digitCount: digitCount.digitCount,
        roundingDigitCount: digitCount.roundingDigitCount
      )
    }()

    // (lhs * rhs) + ±0
    if add.significand == 0 {
      return Self._fmaAddIsZero(
        mul: mul,
        addExponent: add.signedExponent,
        rounding: rounding,
        status: &status
      )
    }

    // When the 'mul.significand' is small we can just use the standard addition
    // algorithm (as expected).
    //
    // This will handle the following edge case:
    // Since we do not have 'roundingDigits' it may happen that 'add' is just
    // after 'mul' in which case 'add' is used for rounding.
    // There is a very special case when we are power of 10 -> we change 'ulp'.
    //
    // (Also, for performance, as operating on DoubleBID is slower than on BID.)
    if mul.significand.high == 0 && mul.significand.low <= Self.maxDecimalDigits {
      assert(mul.roundingDigitCount == 0)

      return Self._addFiniteOrZero(
        lhs: (
          sign: mul.sign,
          signedExponent: mul.signedExponent,
          significand: mul.significand.low
        ),
        rhs: add,
        rounding: rounding,
        status: &status
      )
    }

    // The easiest thing to do would be to move 'mul' and 'add' into 'TripleBID',
    // align them and add. But then our result would be in 'TripleBID' which
    // would be the only place in this module that uses such wide type.
    // Too much code to write just for the FMA.

    // This path is quite common:
    // - all exponent equal:  1E-2 + 1E-2*1E-2 = 1E-2 + 1E-4
    // - mul by int:          1E-2 + 2E0 *1E-2 = 1E-2 + 2E-2
    if add.signedExponent >= mul.signedExponent {
      // Rescale 'add' to get to 'mul' exponent.
      // This will also take care of: The preferred exponent is min(Q(x) + Q(y), Q(z)).
      let addDigitCount: Int
      (add, addDigitCount) = Self._quantize(add, toLowerExponent: mul.signedExponent)
      assert(add.signedExponent >= mul.signedExponent)

      // Is 'add' dominating the 'mul'?
      // (lhs * rhs) + add = very_small + add = add
      //
      // Example for precision=7 (s=significand digit, r=rounding digit):
      // add | sss sss s00 000 000 000 | E11 |         |
      // mul |         sss sss srr r00 | E2  | 2+10=12 | False
      // mul |          ss sss ssr rr0 | E1  | 1+10=11 | False
      // mul |           s sss sss rrr | E0  | 0+10=10 | True
      if mul.signedExponent + mul.digitCount < add.signedExponent {
        return Self._fmaAddDominatesMul(
          mul: mul,
          add: add,
          rounding: rounding,
          status: &status
        )
      }

      // If 'add' is inside 'mul' (or just a tiny bit outside), then we do not
      // need the 3rd BID. In this case we can scale 'add' and simply add them.
      //
      // (This is only for performance, because equal exponents are very common.)
      //
      // Example for precision=7 (s=significand digit, r=rounding digit):
      // mul |      s sss sss rrr rrr r00 | E2  |
      // add |                sss sss s00 | E2  | 'add' is inside 'mul'
      // add |            sss sss s00 000 | E5  | 'add' is inside 'mul'
      // add |      s sss sss 000 000 000 | E9  | 'add' is inside 'mul'
      // add |     ss sss ss0 000 000 000 | E10 | Allowed via SPECIAL CASE.
      // add | ss sss ss0 000 000 000 000 | E13 | Invalid. 'add' is partially outside 'mul'
      //
      // SPECIAL CASE - We know that 'DoubleBID' can always hold at least
      // '2 * Self.precisionInDigits + 1' decimal digits, so we will use this
      // value instead of '2 * Self.precisionInDigits'.
      let maxAddDigitCountForInside = mul.signedExponent + 2 * Self.precisionInDigits + 1

      if add.signedExponent + addDigitCount <= maxAddDigitCountForInside {
        return Self._fmaAddIsInsideMul(
          mul: mul,
          add: add,
          addDigitCount: addDigitCount,
          rounding: rounding,
          status: &status
        )
      }

      // Aligned 'add' is partially outside of 'mul'.
      // We possibly need the 3rd BID.
      //
      // Example for precision=7 (s=significand digit, r=rounding digit):
      // BID index | 111 111 122 222 223 333 333|
      // mul       |      ss sss ssr rrr rrr 000| E3  |
      // add       | sss sss s00 000 000 000 000| E14 |
      return Self._fmaAddIsPartiallyOutsideMul(
        mul: mul,
        add: add,
        addDigitCount: addDigitCount,
        rounding: rounding,
        status: &status
      )
    }

    assert(mul.signedExponent > add.signedExponent)
    // We have filled all 'Self.precisionInDigits' digits.
    // This means that 'mul' is already 'quantized'.
    assert(mul.roundingDigitCount > 0, "We already handled: high=0, low<=Self.maxDecimalDigits")

    // Is 'mul' dominating the 'add'?
    // (lhs * rhs) + add = mul + very_small = mul
    //
    // We also have to avoid overlap with 'mul.roundingDigits', because:
    // mul | sssssss rrrrrrr
    // add |         9999999
    // So adding '9999999' to 'roundingDigits' could increase significand.
    //
    // Example for precision=7 (s=significand digit; r=rounding digit):
    // mul | sss sss srr rrr rr0 000 000 000 0 | E11 |        |
    // add |                  ss sss ss0 000 0 | E5  | 5+7=12 | False
    // add |                   s sss sss 000 0 | E4  | 4+7=11 | False
    // add |                     sss sss s00 0 | E3  | 3+7=10 | True
    let addDigitCount = Self._getDecimalDigitCount(add.significand)

    if add.signedExponent + addDigitCount < mul.signedExponent {
      return Self._fmaMulDominatesAdd(
        quantizedMul: mul,
        add: add,
        rounding: rounding,
        status: &status
      )
    }

    // At this point we know:
    // add.exponent < mul.exponent <= add.exponent + addDigitCount
    //
    // For example (precision=7; s=significand; r=rounding):
    // 1) partial overlap including 'mul.significand'
    //    mul | sss sss srr rrr 000 000 | E6 |
    //    add |         sss sss sss 000 | E3 |
    // 2) partial overlap on 'mul.roundingDigits'
    //    mul | sss sss srr rrr rr0 000 000 | E7 |
    //    add |             sss sss sss 000 | E3 |
    // 3) 'add' is just after 'mul'
    //    mul | sss sss srr rrr rr0 000 000 000 | sE10 |
    //    add |                   s sss sss 000 | sE3  |
    return Self._fmaMulIsPartiallyOutsideAdd(
      mul: mul,
      add: add,
      addDigitCount: addDigitCount,
      rounding: rounding,
      status: &status
    )
  }

  // MARK: - Quantize

  private static func _quantize(
    _ add: AddFiniteOrZero,
    toLowerExponent newExponent: Int
  ) -> (add: AddFiniteOrZero, digitCount: Int) {
    let (significand, signedExponent, digitCount) = Self._quantizeToLowerExponent(
      significand: add.significand,
      oldSignedExponent: add.signedExponent,
      newSignedExponent: newExponent
    )

    return (
      add: AddFiniteOrZero(
        sign: add.sign,
        signedExponent: signedExponent,
        significand: significand
      ),
      digitCount: digitCount
    )
  }

  // MARK: - NaN, infinity

  private static func _fmaNaN(
    _ mulLhs: Self,
    _ mulRhs: Self,
    _ add: Self,
    status: inout DecimalStatus
  ) -> Self {
    if mulLhs._isSignalingNaN || mulRhs._isSignalingNaN || add._isSignalingNaN {
      status.set(.isInvalidOperation)
    }

    // The NaN checking order is a bit weird, but this is how Intel does it.

    if mulRhs._isNaN {
      return Self._nanResult_viaIEEE754_section62(mulRhs, status: &status)
    }

    if add._isNaN {
      return Self._nanResult_viaIEEE754_section62(add, status: &status)
    }

    // https://www.youtube.com/watch?v=EtoMN_xi-AM
    assert(mulLhs._isNaN, "'mulLhs' is just a Bruce Wayne, not NaNaNaNa Batman?")
    return Self._nanResult_viaIEEE754_section62(mulLhs, status: &status)
  }

  private static func _fmaInfinity(
    _ mulLhs: Self,
    _ mulRhs: Self,
    _ add: Self,
    status: inout DecimalStatus
  ) -> Self {
    assert(!mulLhs._isNaN && !mulRhs._isNaN && !add._isNaN)

    let mulSign = mulLhs._sign ^ mulRhs._sign

    // (inf * rhs) + add
    if mulLhs._isInfinite {
      // (inf * 0) + add
      if mulRhs._isZero {
        status.set(.isInvalidOperation)
        return ._nan
      }

      // (inf * rhs) + -inf = inf + -inf
      if add._isInfinite && add._sign != mulSign {
        status.set(.isInvalidOperation)
        return ._nan
      }

      // (inf * rhs) + add = inf
      return Self(canonical: mulSign | Self.infinityMask)
    }

    // (lhs * inf) + add
    if mulRhs._isInfinite {
      // (0 * inf) + add
      if mulLhs._isZero {
        status.set(.isInvalidOperation)
        return ._nan
      }

      // (lhs * inf) + -inf = inf + -inf
      if add._isInfinite && add._sign != mulSign {
        status.set(.isInvalidOperation)
        return ._nan
      }

      // (rhs * inf) + add = inf
      return Self(canonical: mulSign | Self.infinityMask)
    }

    // (lhs * rhs) + inf
    assert(add._isInfinite, "Buzz Lightyear can't go to 'add' and Beyond!?")
    // We checked every other option, so:
    assert(mulLhs._isZero || mulLhs._isFinite)
    assert(mulRhs._isZero || mulRhs._isFinite)

    return Self(canonical: add._sign | Self.infinityMask)
  }

  // MARK: - Zero

  private static func _fmaMulIsZero(
    mulExponent: Int,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // (0 * rhs) + add, where add != 0
    // The preferred exponent is min(Q(x) + Q(y), Q(z)).
    assert(add.significand != 0)
    let sign = add.sign

    if add.signedExponent <= mulExponent {
      // 'add' has preferred exponent -> canonical add
      return Self._packWithoutChecks(
        sign: sign,
        significand: add.significand,
        signedExponent: add.signedExponent
      )
    }

    // We have to bring 'add' into the 'mulExponent'.
    let (significand, signedExponent, _) = Self._quantizeToLowerExponent(
      significand: add.significand,
      oldSignedExponent: add.signedExponent,
      newSignedExponent: mulExponent
    )

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: signedExponent,
      roundingDigitCount: 0,
      rounding: rounding,
      status: &status
    )
  }

  private static func _fmaAddIsZero(
    mul: FmaMul,
    addExponent: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // The preferred exponent is min(Q(x) + Q(y), Q(z)).
    // Btw. remember that at this point 'mul.exponent' is unchecked:
    // - can be ultra big: 999999…
    // - can be ultra small: -999999…
    // 'Self._pack' can deal with it, but be careful in the next few lines.
    var exponent = mul.signedExponentWithoutRoundingDigits
    var significand = mul.significand
    var roundingDigitCount = mul.roundingDigitCount

    let addHasLowerExponent = addExponent < exponent
    let mulExponentCanGoDown = exponent != Self.minSignedExponent
    let mulHasAvailableDigits = mul.digitCount < Self.precisionInDigits

    if addHasLowerExponent && mulExponentCanGoDown && mulHasAvailableDigits {
      // We are in a single precision.
      assert(mul.roundingDigitCount == 0)

      // We have to bring 'mul' into the 'add' exponent.
      // Or at least try to get as close as possible…
      let addedDigitCount = Swift.min(
        exponent - addExponent, // Get to 'add' exponent.
        Self.precisionInDigits - mul.digitCount, // Available digit count.
        exponent + Self.exponentBias // How low can exponent go?
      )

      assert(addedDigitCount > 0, "But we checked exponentCanGoDown/availableDigits?")

      let pow10: BID = Tables.getPowerOf10(exponent: addedDigitCount)
      significand = significand * pow10
      exponent = exponent - addedDigitCount
      roundingDigitCount = 0

      // We are in a single precision with all digits filled
      // (if the exponent allowed us).
      assert(significand.high == 0 && significand.low <= Self.maxDecimalDigits)
    }

    return Self._pack(
      sign: mul.sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }

  // MARK: - Add.exponent >= mul.exponent

  private static func _fmaAddDominatesMul(
    mul: FmaMul,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // There is a 1 digit 'gap' between '1*10^add.exponent' and highest 'mul' digit.
    // add: 1E7     = 10 000 000, signedExponent = 7
    // mul: 11111E1 =    111 110, signedExponent + digitCount = 1+5 = 6
    //                 ^ gap
    assert(mul.signedExponent + mul.digitCount < add.signedExponent)
    assert(mul.significand != 0, "mul=0, should be handled before calling this method")

    // 'mul' is small when compared to 'add'.
    // Most of the time its value will not matter, just a tiny thing used for
    // rounding. Though when it matters ('toNearest…' roundings) we need to
    // be precise for the whole 'Self.precisionInDigits' after the 'add'.
    //
    // Also, we want to unify our code with 'add' operation because of the tricky
    // edge cases. This is an additional (but necessary) difficulty.
    let mulSignificand: BID
    let mulMaxDigit = mul.signedExponent + mul.digitCount
    let minDigitToMatter = add.signedExponent - Self.precisionInDigits

    if mulMaxDigit <= minDigitToMatter {
      // The exact 'mul' value does not matter as long as it does not trigger
      // halfway rounding. Can't be '0' because 'mul.significand != 0'.
      mulSignificand = 1
    } else {
      // 'mul' is just after the 'add' (with possible 1 digit 'gap') -> full
      // calculation with 'Self.precisionInDigits' precision.
      let pow10: DoubleBID = Tables.getPowerOf10(exponent: mul.roundingDigitCount)
      let (q, r) = mul.significand.quotientAndRemainder(dividingBy: pow10)
      assert(q.high == 0 && q.low <= Self.maxDecimalDigits)
      mulSignificand = BID(truncatingIfNeeded: q) + (r == 0 ? 0 : 1)
    }

    return Self._additionWithBigExponentDiscrepancy(
      quantizedBigExponent: add,
      smallExponent: (
        sign: mul.sign,
        // Example for precision=7:
        // - mul:                     1234567890E10 (more digits than precision!)
        // - without rounding digits:    1234567E13
        signedExponent: mul.signedExponentWithoutRoundingDigits,
        significand: mulSignificand
      ),
      rounding: rounding,
      status: &status
    )
  }

  /// All 'add' bits overlap (maybe except for the highest bit, but it is still
  /// within 'DoubleBID'). We do not need the 3rd BID.
  private static func _fmaAddIsInsideMul(
    mul: FmaMul,
    add: AddFiniteOrZero,
    addDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    assert(mul.signedExponent <= add.signedExponent)
    assert(
      add.signedExponent + addDigitCount <= mul.signedExponent + 2 * Self.precisionInDigits + 1
    )

    var exponent = mul.signedExponent

    let addScale = add.signedExponent - exponent
    let pow10: DoubleBID = Tables.getPowerOf10(exponent: addScale)
    let addSignificandScaled = pow10 * add.significand

    let (sign, significand) = Self._addSignificands(
      lhsSign: mul.sign,
      lhs: mul.significand,
      rhsSign: add.sign,
      rhs: addSignificandScaled
    )

    // Do we have an exact 0?
    // There are some special rules about the sign of this thingie.
    if significand == 0 {
      return Self._additionExactZero(
        lhsSign: mul.sign,
        rhsSign: add.sign,
        signedExponent: exponent,
        rounding: rounding
      )
    }

    let roundingDigitCount = Self._getRoundingDigitCount(significand)
    exponent += roundingDigitCount

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }

  /// `add.exponent > mul.exponent`; some digits overlap.
  private static func _fmaAddIsPartiallyOutsideMul(
    mul: FmaMul,
    add: AddFiniteOrZero,
    addDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    assert(add.signedExponent > mul.signedExponent + mul.roundingDigitCount)
    assert(add.signedExponent <= mul.signedExponent + mul.digitCount)
    assert(
      mul.significand.high != 0 || mul.significand.low > Self.maxDecimalDigits,
      "'mul.significand' should have all 'Self.precisionInDigits' digits filled."
    )

    // Number of non-overlapping digits in 'mul' (the ones that 'stick out').
    let exponentDiff = add.signedExponent - mul.signedExponent
    assert(exponentDiff > 0)

    // Resize 'add' to '2 * Self.precisionInDigits' digits.
    // The idea is that by calculating to double precision we can safely round.
    let addScale = Swift.min(
      2 * Self.precisionInDigits - addDigitCount,
      exponentDiff
    )

    let addScalePow10: DoubleBID = Tables.getPowerOf10(exponent: addScale)
    let addScaledSignificand = addScalePow10 * add.significand

    // Align 'mul'
    let mulRemainderDigitCount = exponentDiff - addScale
    let pow10: DoubleBID = Tables.getPowerOf10(exponent: mulRemainderDigitCount)
    let (
      mulScaledSignificand,
      mulRemainder
    ) = mul.significand.quotientAndRemainder(dividingBy: pow10)

    // Exponent for 'mulScaledSignificand' (which is DoubleBID):
    // add = addScaledSignificand * 10^scaledExponent
    let scaledExponent = add.signedExponent - addScale

    return Self._fmaAddTripleBidWithRemainder(
      mulSign: mul.sign,
      mulScaledSignificand: mulScaledSignificand,
      addSign: add.sign,
      addScaledSignificand: addScaledSignificand,
      signedExponent: scaledExponent,
      remainderSign: mul.sign,
      remainder: mulRemainder,
      rounding: rounding,
      status: &status
    )
  }

  /// Add `mul` + `add` then adjust with `remainder`.
  /// `signedExponent` is for the whole `mulScaledSignificand/addScaledSignificand`
  ///  (they have the same exponent).
  private static func _fmaAddTripleBidWithRemainder(
    mulSign: Sign,
    mulScaledSignificand: DoubleBID,
    addSign: Sign,
    addScaledSignificand: DoubleBID,
    signedExponent: Int,
    remainderSign: Sign,
    remainder: DoubleBID,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    var (sign, significand) = Self._addSignificands(
      lhsSign: mulSign,
      lhs: mulScaledSignificand,
      rhsSign: addSign,
      rhs: addScaledSignificand
    )

    // If we come from one of the 'PartiallyOutside' methods then 'significand != 0'.
    // This is important, because exact '0' has special rules about the sign.
    //
    // Proof (for add.exponent >= mul.exponent, similar for the other side):
    // 1. We started with 'add.exponent >= mul.exponent'
    // 2. We quantized 'add' to 'mul.exponent'
    //
    // 'mul' can look like this (precision=7; s=significand; r=rounding):
    // mul = s sss sss rrr rrrE5
    //
    // Cases for 'significand' to be 0:
    //
    // a) 'Add' matches exactly with 's sss sss' from 'mul':
    //    mul = s sss sss rrr rrr E5
    //    add = s sss sss E11
    //    This case should be handled before calling this method (fast path that
    //    does not need the 3rd BID).
    //    It triggers this assertion (it is equal, not greater):
    //    assert(add.signedExponent > mul.signedExponent + mul.roundingDigitCount)
    //
    // b) 'Mul' ends with a bunch of '0'
    //    mul = s sss 000 rrr rrr E5
    //    add = s sss E14
    //    After quantization 'add' becomes:
    //    add = s sss 000 E11
    //    Which is the same case as a).
    assert(significand != 0)

    var roundingDigitCount = Self._getRoundingDigitCount(significand)
    var exponent = signedExponent + roundingDigitCount

    // Whatever remaining digits the 'remainder' holds, they will just modify
    // the least significand digit by '1'. We are in double precision, so most
    // of the time it will not change the final result.
    if remainder != 0 {
      // We have some 'remainder' digits -> we are inexact by definition.
      status.set(.isInexact)

      var isRemainderAwayFromZero = false
      var isRemainderTowardZero = false

      switch rounding {
      case .up:
        if sign.isPlus && remainderSign.isPlus { isRemainderAwayFromZero = true }
        if sign.isMinus && remainderSign.isPlus { isRemainderTowardZero = true }

      case .down:
        if sign.isMinus && remainderSign.isMinus { isRemainderAwayFromZero = true }
        if sign.isPlus && remainderSign.isMinus { isRemainderTowardZero = true }

      case .towardZero:
        if sign != remainderSign { isRemainderTowardZero = true }

      case .toNearestOrEven,
           .toNearestOrAwayFromZero:
        // Example for different signs:
        //    -8390735022900000|00000000000000000 <- mul
        // +                   +50000000000000000 <- add
        // =  -8390735022899999|50000000000000000 <- addition result
        //                                      +80288723120953 <- rounding
        // They have different signs, so it is not a perfect '50000000000000000'
        // (which could would round) it is a tiny bit below it -> no round.
        isRemainderAwayFromZero = sign == remainderSign
        isRemainderTowardZero = sign != remainderSign
      }

      if isRemainderAwayFromZero || isRemainderTowardZero {
        // Add trailing rounding digit that represents 'remainder'.
        // 'DoubleBID' always has space for at least '2*Self.precisionInDigits + 2'
        // digits. We will use them like this:
        // - 1 is potential overflow from 'add' + 'mul' addition
        // - 1 we will introduce right now for rounding
        let (s, overflow) = significand.multipliedReportingOverflow(by: 10 as BID)
        assert(!overflow)
        significand = s

        if isRemainderAwayFromZero {
          significand += 1
        } else {
          significand -= 1
        }

        let newRoundingDigitCount = Self._getRoundingDigitCount(significand)

        if newRoundingDigitCount == roundingDigitCount {
          // Rare case when significand was '10000…' we multiplied it by '10',
          // but by subtracting '-1' we brought it back to the same digit count.
          assert(isRemainderTowardZero)
          exponent -= 1
        } else {
          // We just added a new rounding digit.
          // Note that the exponent stays the same!
          roundingDigitCount = newRoundingDigitCount
        }
      }
    }

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }

  // MARK: - Mul.exponent > add.exponent

  /// `mul.exponent ≫ add.exponent`.
  private static func _fmaMulDominatesAdd(
    quantizedMul mul: FmaMul,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // '0' should have been handled before calling this method!
    // This is a CRUCIAL assertion for the way this whole thing is written.
    // From now on we will assume that 'add' has 'something'.
    // The only thing that we will be concerned about is whether this 'something'
    // has the same sign as 'mul' or not.
    assert(add.significand != 0)

    // Are we double width?
    // Single width case should be handled before calling this method.
    assert(mul.significand.high != 0 || mul.significand > Self.maxDecimalDigits)

    // We have some 'add' digits -> we are inexact by definition.
    status.set(.isInexact)

    let pow10: DoubleBID = Tables.getPowerOf10(exponent: mul.roundingDigitCount)
    let (q, r) = mul.significand.quotientAndRemainder(dividingBy: pow10)

    assert(q.high == 0)
    let significand = q.low
    let roundingDigits = r
    var direction = AdditionWithBigExponentDiscrepancy_RoundingDirection.none

    switch rounding {
    case .up:
      // -123 (rounding digits: 000) + 0.1 = -122
      if mul.sign.isMinus && roundingDigits == 0 && add.sign.isPlus { direction = .towardZero }
      // 123 (rounding digits: 100) + xxx = 124
      // 123 (rounding digits: 000) + 0.1 = 124
      if mul.sign.isPlus && (roundingDigits != 0 || add.sign.isPlus) { direction = .awayFromZero }

    case .down:
      // -123 (rounding digits: 100) + xxx = -124
      // -123 (rounding digits: 000) - 0.1 = -124
      if mul.sign.isMinus && (roundingDigits != 0 || add.sign.isMinus) { direction = .awayFromZero }
      // 123 (rounding digits: 000) - 0.1 = 122
      if mul.sign.isPlus && roundingDigits == 0 && add.sign.isMinus { direction = .towardZero }

    case .towardZero:
      // -123 (rounding digits: 000) + 0.1 = -122
      //  123 (rounding digits: 000) - 0.1 =  122
      if roundingDigits == 0 && add.sign != mul.sign { direction = .towardZero }

    case .toNearestOrEven,
         .toNearestOrAwayFromZero:
      // There is a very special case in the standard 'add' code here about
      // rounding to toward '0' because we are power of 10 and we crossed the
      // lower 'ulp'. This will not happen here, because we have some 'rounding
      // digits'. Even if those digits are a single '0' it is enough to push
      // 'add' away, so that it will never cross the lower 'ulp'.

      let halfway = pow10 / 2
      let isAboveHalfway = roundingDigits > halfway
        || (roundingDigits == halfway && add.sign == mul.sign)

#if DEBUG
      // We can't be exactly 'halfway' because we have 'add'.
      let __isHalfway = roundingDigits == halfway && add.significand == 0
      assert(!__isHalfway, "We have 'add != 0'. We can't be halfway?")
#endif

      if isAboveHalfway { direction = .awayFromZero }
    }

    let exponent = mul.signedExponentWithoutRoundingDigits
    assert(exponent >= Self.minSignedExponent, "But we dominate 'add', so how?")

    return Self._additionWithBigExponentDiscrepancy_roundAndPack(
      sign: mul.sign,
      signedExponent: exponent,
      quantizedSignificand: significand,
      additionRounding: direction,
      rounding: rounding,
      status: &status
    )
  }

  /// `mul.exponent > add.exponent`; some digits overlap.
  private static func _fmaMulIsPartiallyOutsideAdd(
    mul: FmaMul,
    add: AddFiniteOrZero,
    addDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    assert(add.signedExponent < mul.signedExponent)
    assert(mul.signedExponent <= add.signedExponent + addDigitCount)
    assert(mul.roundingDigitCount > 0)

    // Number of non-overlapping digits in 'add' (the ones that 'stick out').
    let exponentDiff = mul.signedExponent - add.signedExponent
    assert(exponentDiff > 0)

    // Resize 'mul' to '2 * Self.precisionInDigits' digits.
    // The idea is that by calculating to double precision we can safely round.
    let mulScale = Swift.min(
      2 * Self.precisionInDigits - mul.digitCount,
      exponentDiff
    )

    assert(mulScale <= Self.precisionInDigits, "Because: mul.roundingDigitCount > 0")
    let mulScalePow10: BID = Tables.getPowerOf10(exponent: mulScale)
    let mulScaledSignificand = mul.significand * mulScalePow10

    // Align 'add'.
    let addRemainderDigitCount = exponentDiff - mulScale
    let pow10: BID = Tables.getPowerOf10(exponent: addRemainderDigitCount)
    let qr = add.significand.quotientAndRemainder(dividingBy: pow10)
    let addScaledSignificand = DoubleBID(high: 0, low: qr.quotient)
    let addRemainder = DoubleBID(high: 0, low: qr.remainder)

    // Exponent for 'mulScaledSignificand' (which is DoubleBID):
    // mul = mulScaledSignificand * 10^scaledExponent
    let scaledExponent = mul.signedExponent - mulScale

    return Self._fmaAddTripleBidWithRemainder(
      mulSign: mul.sign,
      mulScaledSignificand: mulScaledSignificand,
      addSign: add.sign,
      addScaledSignificand: addScaledSignificand,
      signedExponent: scaledExponent,
      remainderSign: add.sign,
      remainder: addRemainder,
      rounding: rounding,
      status: &status
    )
  }
}
