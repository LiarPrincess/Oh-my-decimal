// swiftlint:disable all

/*
================================================================================
Fast path in main method?
================================================================================

  private static func _fusedMultiplyAdd(
    mulLhs: Self,
    mulRhs: Self,
    add: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self? {
    // (lhs * rhs) + add = very_big + add = very_big
    // By 'very_big' we mean: 'mul * 10^99999999…'
    let isMulTooBig = mul.signedExponent >= Self.maxSignedExponent + Self.precisionInDigits
    let isAddingTooBig = mul.isNegative == addUnpack.isNegative
      && mul.signedExponent > Self.maxSignedExponent

    if isMulTooBig || isAddingTooBig {
      return Self._pack(
        sign: mul.sign,
        signedExponent: mul.signedExponent,
        significand: (Self.maxDecimalDigits + 1) / 10,
        roundingDigitCount: 0,
        rounding: rounding,
        status: &status
      )
    }
*/















/*
================================================================================
This is mostly translation of Intel for this branch:
'if add.signedExponent >= mul.signedExponent {'
================================================================================

  private static func _fmaOhNo(
    mul: Mul,
    add: FiniteUnpack,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus,
    EXPECTED: Self
  ) -> Self? {
/*
  if add.exponent.signed > mul.signedExponent {
    let exponentDiff = add.exponent.signed - mul.signedExponent
    let pow10: BID = Tables.getPowerOf10(exponent: exponentDiff)
    let addSignificandScaled = Self._mulSignificands(add.significand.canonical, pow10)

    // let CT = Self._addSignificands(
    //   isLhsNegative: add,
    //   lhs: mul,
    //   isRhsNegative: add.isNegative,
    //   rhs: addSignificandScaled
    // )

    // let exponent = exponent_y + mul.roundingDigitCount + 1 // Exponent is wrong!
    // let digitCount = Self._getDecimalDigitCount(CT.significand)

    // var zz = Self._pack(
    //   sign: CT.isNegative ? .minus : .plus,
    //   signedExponent: exponent,
    //   significand: CT.significand,
    //   roundingDigitCount: digitCount.roundingDigitCount,
    //   rounding: rounding,
    //   status: &status
    // )

    // if CT.significand == 0 {
    //   zz = Self._additionExactZero(
    //     isLhsNegative: mul.isNegative,
    //     isRhsNegative: add.isNegative,
    //     signedExponent: exponent,
    //     rounding: rounding
    //   )
    // }

    // print(
    //   zz.bid == EXPECTED.bid ? "🟢" : "🔴",
    //   zz,
    //   EXPECTED
    // )
    return nil
  }
*/

/*
    // In Intel:
    // P = mul
    // digits_p = mulDigitCount.digitCount
    // extra_digits = mulDigitCount.roundingDigitCount
    // final_exponent = mulExponent
    // ez = addExponentWithFullPrecision << only in 'handleMulExponentTooSmall'

    // res = bid_get_add128 (
		// 	sign_z,
		// 	exponent_z,
		// 	coefficient_z,
		// 	sign_x ^ sign_y,
		//   final_exponent,
		// 	P,
		// 	extra_digits,
		// 	rnd_mode,
		// 	pfpsf
		// );
    // BID_RETURN (res);
*/
//x = add!
    let sign_x = add.isNegative // BID_UINT64 sign_x,
    var exponent_x = add.exponent.signed // Intel: BIASED; int exponent_x,
    var coefficient_x = add.significand.canonical // BID_UINT64 coefficient_x,

    let sign_y = mul.isNegative // BID_UINT64 sign_y,
    /// Exponent in 'small' form
    let final_exponent_y = mul.signedExponent // Intel: BIASED; int final_exponent_y,
    let CY = mul.significand // BID_UINT128 CY,
    var extra_digits = mul.roundingDigitCount // int extra_digits,
//----------------------------------------------------------

    // CY has more than 16 decimal digits
    /// Full exponent in 'DoubleBID' form
    let exponent_y = mul.signedExponent - extra_digits

    // 'add' has greater exponent
    // exponent_x   > final_exponent_y - extra_digits
    //       add.exponent > mul.signedExponent - mul.roundingDigitCount
    //       mul.signedExponent - mul.roundingDigitCount < add.exponent
    if exponent_y < exponent_x {
      // Quantization 'x' to max decimal digits?
      let digits_x = Self._getDecimalDigitCount(coefficient_x)
      var extra_dx = 16 - digits_x

      let pow10: BID = Tables.getPowerOf10(exponent: extra_dx)
      coefficient_x *= pow10

      if sign_x != sign_y && coefficient_x == 1000000000000000 {
        extra_dx += 1
        coefficient_x = 10000000000000000
      }

      exponent_x -= extra_dx

      // If full mul.exponent < add.exponent
      if exponent_y < exponent_x {
        let diff_dec_expon = exponent_x - exponent_y

        if exponent_x <= final_exponent_y + 1 {
          let pow10B: BID = Tables.getPowerOf10(exponent: diff_dec_expon)
          let CX = Self._mulSignificands(coefficient_x, pow10B)

          let CT = Self._addSignificands(
            isLhsNegative: sign_x,
            lhs: CX,
            isRhsNegative: sign_y,
            rhs: CY
          )

          let exponent = exponent_y + mul.roundingDigitCount + 1 // Exponent is wrong!
          let digitCount = Self._getDecimalDigitCount(CT.significand)

          var zz = Self._pack(
            sign: CT.isNegative ? .minus : .plus,
            signedExponent: exponent,
            significand: CT.significand,
            roundingDigitCount: digitCount.roundingDigitCount,
            rounding: rounding,
            status: &status
          )

          if CT.significand == 0 {
            zz = Self._additionExactZero(
              isLhsNegative: mul.isNegative,
              isRhsNegative: add.isNegative,
              signedExponent: exponent,
              rounding: rounding
            )
          }

          // print(
          //   zz.bid == EXPECTED.bid ? "🟢" : "🔴",
          //   zz,
          //   EXPECTED
          // )
          return nil
        }

        // diff_dec2+extra_digits is the number of digits to eliminate from
        //                           argument CY
        let diff_dec2 = exponent_x - final_exponent_y

        // This was already handled by my code
        // if diff_dec2 >= 17 {
        //   print("x")
        // }

        // here exponent_x <= 16+final_exponent_y

      }
    }

// print("y")

//----------------------------------------------------------
return nil
  }
*/













/*
================================================================================
Triple BID operations.
This is mostly for the subset where exponents are close.
================================================================================

  private static func _fmaBadThings(
    mul: FmaMul,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus,
    EXPECTED: Self
  ) -> Self? {
//------------------------------------------------------------------------------
// guard Self.bitWidth == 64 else { return nil }

    // Normally 'mul.signedExponent' does not include 'roundingDigits'
    // Only the first 'Self.precisionInDigits' are included.
    let mulExponentWithRoundingDigits = mul.signedExponent - mul.roundingDigitCount
    let exponent = Swift.min(mulExponentWithRoundingDigits, add.signedExponent)

    let mulScale = mulExponentWithRoundingDigits - exponent
    let mulPow10: DoubleBID = Tables.getPowerOf10(exponent: mulScale)
    let mulSignificand = mul.significand.multipliedFullWidth(by: mulPow10)

    let addScale = add.signedExponent - exponent
    let addPow10: DoubleBID = Tables.getPowerOf10(exponent: addScale)
    let addSignificand = DoubleBID(high: 0, low: add.significand).multipliedFullWidth(by: addPow10)

    guard let (isNegative, significand) = Self._fmaAddSignificands(
      isLhsNegative: mul.isNegative,
      lhs: mulSignificand,
      isRhsNegative: add.isNegative,
      rhs: addSignificand
    ) else {
      return nil
    }

    let sign: FloatingPointSign = isNegative ? .minus : .plus

    if significand.high == 0 {
      let s = significand.low
      let digitCount = Self._getDecimalDigitCount(s)
      let e = exponent + digitCount.roundingDigitCount
      return Self._pack(
        sign: sign,
        signedExponent: e,
        significand: s,
        roundingDigitCount: digitCount.roundingDigitCount,
        rounding: rounding,
        status: &status
      )
    }

print("y")

    // print("\(significand)E\(exponent) ==? \(EXPECTED)")

return nil
  }

  private typealias FmaAddSignificands = (
    isNegative: Bool,
    significand: (high: DoubleBID, low: DoubleBID)
  )

  private static func _fmaAddSignificands(
    isLhsNegative: Bool,
    lhs: (high: DoubleBID, low: DoubleBID),
    isRhsNegative: Bool,
    rhs: (high: DoubleBID, low: DoubleBID)
  ) -> FmaAddSignificands? {
    if isLhsNegative == isRhsNegative {
      let (low, ov1) = lhs.low.addingReportingOverflow(rhs.low)
      let (ov2, high) = sum(lhs.high, rhs.high, ov1 ? 1 : 0)
      assert(ov2 == 0, "Overflow on QuadBID?")

      return (isLhsNegative, (high, low))
    }

return nil
  }
*/












/*
================================================================================
Slower (but still interesting) version of '_fmaAlignedAddIsPartiallyOutsideMul'.
================================================================================

  /// Aligned 'add' is partially outside of 'mul'.
  /// We possibly need the 3rd BID.
  private static func _fmaAlignedAddIsPartiallyOutsideMul(
    mul: FmaMul,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    assert(add.signedExponent > mul.signedExponent + mul.roundingDigitCount)
    assert(add.signedExponent <= mul.signedExponent + mul.digitCount)
    assert(
      mul.significand.high != 0 || mul.significand.low > Self.maxDecimalDigits,
      "'mul.significand' should have all 'Self.precisionInDigits' digits filled."
    )

    // Take top 'Self.precisionInDigits' from mul.
    // Later we will align 'add' to this.
    let mulRoundingDigitsPow10: BID = Tables.getPowerOf10(exponent: mul.roundingDigitCount)
    let (mulSignificand, mulRemainder) = mul.significand.quotientAndRemainder(dividingBy: mulRoundingDigitsPow10)

    // Align 'add'.
    let doubleBidExponent = mul.signedExponentWithoutRoundingDigits
    let addScale = add.signedExponent - doubleBidExponent
    assert(addScale <= Self.precisionInDigits)
    let addPow10: BID = Tables.getPowerOf10(exponent: addScale)
    let addSignificand = Self._mulSignificands(add.significand, addPow10)

    // The final result is approximately equal to:
    // doubleBidSignificand * 10^doubleBidExponent
    // Obviously now we have to take 'mulRemainder' into account.
    let (isNegative, doubleBidSignificand) = Self._addSignificands(
      isLhsNegative: mul.isNegative,
      lhs: mulSignificand,
      isRhsNegative: add.isNegative,
      rhs: addSignificand
    )

    // Proof for this assertion is difficult (but necessary).
    // 1. We started with 'add.exponent >= mul.exponent'
    // 2. We quantized 'add' to 'mul.exponent'
    //
    // 'mul' can look like this (precision=7; s=significand; r=rounding):
    // mul = s sss sss rrr rrrE5
    //
    // Cases for 'doubleBidSignificand' to be 0:
    //
    // a) 'Add' matches exactly with 's sss sss' from 'mul':
    //    mul = s sss sss rrr rrr E5
    //    add = s sss sss E11
    //    This case should be handled before calling this method.
    //    It triggers this assertion (it is equal, not greater):
    //    assert(add.signedExponent > mul.signedExponent + mul.roundingDigitCount)
    //
    // b) 'Mul' ends with a bunch of '0'
    //    mul = s sss 000 rrr rrr E5
    //    add = s sss E14
    //    After quantization 'add' becomes:
    //    add = s sss 000 E11
    //    Which is the same case as a).
    assert(doubleBidSignificand != 0)

    let sign: FloatingPointSign = isNegative ? .minus : .plus
    let (_, doubleBidRoundingDigitCount) = Self._getDecimalDigitCount(doubleBidSignificand)
    let singleBidExponent = doubleBidExponent + doubleBidRoundingDigitCount

    // Are we just a standard DoubleBID?
    if mulRemainder == 0 {
      return Self._pack(
        sign: sign,
        signedExponent: singleBidExponent,
        significand: doubleBidSignificand,
        roundingDigitCount: doubleBidRoundingDigitCount,
        rounding: rounding,
        status: &status
      )
    }

    // We have some 'mulRemainder' digits -> we are inexact by definition.
    status.set(.isInexact)

    // If 'mul' and 'add' have the same sign:
    //   'mulRemainder' further increases the magnitude
    // Else if 'mull' has bigger magnitude:
    //   doubleBidSignificand = mulSignificand - addSignificand
    //   So 'doubleBidSignificand' has the same sign as 'mul' which means that
    //   the 'mulRemainder' pushes us away from '0'.
    // Else (if 'add' has bigger magnitude):
    //   doubleBidSignificand = addSignificand - mulSignificand
    //   So far we have subtracted 'mulSignificand', now we have to subtract
    //   'mulRemainder' -> this pushes us toward '0'.
    let mulRemainderIsAwayFromZero = isNegative == mul.isNegative

    // Fill all remaining 'rounding digits' in 'doubleBidSignificand' with '0'.
    // Then fill those '0' with numbers depending on 'mulRemainderIsAwayFromZero'.
    // The idea is that by calculating to double precision we can safely round.
    // In almost all of the cases 'exponent' stays at 'singleBidExponent',
    // because this is the preferred exponent.
    let addedZeroCount = Self.precisionInDigits - doubleBidRoundingDigitCount
    let significand: DoubleBID
    var exponent = singleBidExponent
    let roundingDigitCount: Int

    if mulRemainderIsAwayFromZero {
      // Move top digits from 'mulRemainder' to 'significand' as rounding digits.
      // Always move at least 1 digit, so that we correctly handle 'toNearest…'.
      // 'DoubleBID' with '2 * Self.precisionInDigits' digits is not 'full'.
      // We always have space for at least 1 more decimal digit.
      let movedDigitCount = Swift.min(addedZeroCount + 1, mul.roundingDigitCount)

      let movedDivExponent = mul.roundingDigitCount - movedDigitCount
      let movedDiv: BID = Tables.getPowerOf10(exponent: movedDivExponent)
      // We know that 'mulRemainder != 0' -> we always have to move something.
      let movedDigits =  Swift.max(mulRemainder / movedDiv, 1)

      let pow10: BID = Tables.getPowerOf10(exponent: movedDigitCount)
      let s10 = doubleBidSignificand * pow10
      significand = s10 + movedDigits
      roundingDigitCount = doubleBidRoundingDigitCount + movedDigitCount
    } else {
      // Fill rounding digits with '0' and subtract '1'.
      let pow10: BID = Tables.getPowerOf10(exponent: addedZeroCount)
      let s10 = doubleBidSignificand * pow10
      significand = s10 - (1 as BID)

      // 10000000000 - 1 = 9999999999
      let dc = Self._getDecimalDigitCount(significand)
      let hasRemovedDigit = dc.roundingDigitCount != doubleBidRoundingDigitCount + addedZeroCount
      exponent -= hasRemovedDigit ? 1 : 0
      roundingDigitCount = dc.roundingDigitCount
    }

    return Self._pack(
      sign: sign,
      // 'carry' digit means that our exponent goes up.
      signedExponent: exponent,
      significand: significand,
      // We added a new digit at the back -> this is a rounding digit.
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }
*/


















/*
================================================================================
Fast path in ;_fmaAlignedAddIsPartiallyOutsideMul':
if doubleWidthSignificand.high == 0 && doubleWidthSignificand.low <= Self.maxDecimalDigits {
================================================================================

  private static func _fmaAlignedAddIsPartiallyOutsideMul(
    mul: FmaMul,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus,
    EXPECTED: Self
  ) -> Self? {


    // Are we a single BID?
    if doubleWidthSignificand.high == 0 && doubleWidthSignificand.low <= Self.maxDecimalDigits {
      var significand = doubleWidthSignificand
      var exponent = doubleWidthExponent

      if mulRemainder != 0 {
        // Scale 'significand' to make space for 'mulRemainder'.
        significand = significand * mulRoundingDigitsPow10
        exponent -= mul.roundingDigitCount

        // Add them together.
        if mulRemainderIsAwayFromZero {
          significand = significand + mulRemainder
        } else {
          // Because we scaled 'significand' we are sure that it is greater than
          // 'mulRemainder', so we will never go below '0'.
          significand = significand - mulRemainder
        }
      }

      let roundingDigitCount = Self._getRoundingDigitCount(significand)
      exponent += roundingDigitCount

      return Self._pack(
        sign: sign,
        signedExponent: exponent,
        significand: significand,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        status: &status
      )
    }
*/















/*
================================================================================
Manual rounding for '_fmaAlignedAddIsPartiallyOutsideMul'.
Scarry stuff, that never managed to work properly.
================================================================================

  private static func _fmaAlignedAddIsPartiallyOutsideMul(
    mul: FmaMul,
    add: AddFiniteOrZero,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus,
    EXPECTED: Self
  ) -> Self? {

// Check if 'doubleBidSignificand' and 'bid3' fit inside DoubleBID

    // Split 'doubleBidSignificand' into 'significand' and 'bid2'.
    // Our 3 BIDs are: [significand, bid2, bid3] (in this order).
    // Our result is:  [significand, bid2] * 10^doubleBidExponent, with 'bid3' for rounding.
    assert(doubleBidRoundingDigitCount > 0)
    let pow10: DoubleBID = Tables.getPowerOf10(exponent: doubleBidRoundingDigitCount)
    let (q, bid2) = doubleBidSignificand.quotientAndRemainder(dividingBy: pow10)
    var significand = q.low
    assert(q.high == 0)
    assert(significand != 0)

    // It is not possible to be exactly 'halfway'.
    // If 'bid2 == halfway' then the 'bid3' will make it '!= halfway'.
    let halfway = pow10 / 2
    let isAboveHalfway = bid2 > halfway || (bid2 == halfway && isBid3AwayFromZero)

#if DEBUG
    let __isHalfway = bid2 == halfway && bid3 == 0
    assert(!__isHalfway, "We have 'bid3 != 0'. We can't be halfway?")
#endif

    let isPositive = !isNegative
    var direction = AdditionWithBigExponentDiscrepancy_RoundingDirection.none

    switch rounding {
    case .up:
      // -123 (rounding digits: 000) + 0.1 = -122
      if isNegative && bid2 == 0 && isBid3TowardZero { direction = .towardZero }
      // 123 (rounding digits: 100) + xxx = 124
      // 123 (rounding digits: 000) + 0.1 = 124
      if isPositive && (bid2 != 0 || isBid3AwayFromZero) { direction = .awayFromZero }

    case .down:
      // -123 (rounding digits: 100) + xxx = -124
      // -123 (rounding digits: 000) - 0.1 = -124
      if isNegative && (bid2 != 0 || isBid3AwayFromZero) { direction = .awayFromZero }
      // 123 (rounding digits: 000) - 0.1 = 122
      if isPositive && bid2 == 0 && isBid3TowardZero { direction = .towardZero }

    case .towardZero:
      // -123 (rounding digits: 000) + 0.1 = -122
      //  123 (rounding digits: 000) - 0.1 =  122
      if bid2 == 0 && isBid3TowardZero { direction = .towardZero }

    case .toNearestOrEven,
         .toNearestOrAwayFromZero:
      // We can't be halfway because we have 'add'.
      if isAboveHalfway { direction = .awayFromZero }
    }

print("mul = \(mul.isNegative ? "-" : "+")\(mul.significand)E\(mul.signedExponent)")
print("add = \(add.isNegative ? "-" : "+")\(add.significand)E\(add.signedExponent)")
print("")
print("mulScaled = \(mul.isNegative ? "-" : "+")\(mulSignificand)E\(doubleBidExponent)")
print("addScaled = \(add.isNegative ? "-" : "+")\(addSignificand)E\(doubleBidExponent)")
print("doubleBID = \(isNegative ? "-" : "+")\(doubleBidSignificand)E\(doubleBidExponent)")
print("")

print("significand =", significand)
print("bid2        =", bid2)
print("bid3        = \(mul.isNegative ? "-" : "+")\(bid3) SIGN MAY BE INCORRECT")
print("Exponent =", singleBidExponent)
print("Rounding =", direction, "from", rounding)
print("")

print("EXPECTED =", EXPECTED)
defer { print("-----------") }

//------------------------------------------------------------------------------
// guard Self.bitWidth == 64 else { return nil }

/*
    // Rename method
    Self._additionWithBigExponentDiscrepancy_round(
      significand: &significand,
      signedExponent: &singleBidExponent,
      direction: direction
    )

    let result = Self._pack(
      sign: sign,
      signedExponent: singleBidExponent,
      significand: significand,
      roundingDigitCount: 0,
      rounding: rounding,
      status: &status
    )
*/

// Another version. Maybe this will work? Nope!
    var s = doubleBidSignificand

    switch direction {
    case .awayFromZero:
      s += 1

    case .towardZero:
      s -= 1

    case .none:
      break
    }

    let roundingDigitCount = Self._getRoundingDigitCount(s)
    var e = doubleBidExponent + roundingDigitCount

    let result = Self._pack(
      sign: sign,
      signedExponent: e,
      significand: s,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )


    print(
      result.bid == EXPECTED.bid ? "🟢" : "🔴",
      result,
      EXPECTED
      // , "                     ", doubleBidRoundingDigitCount
    )


// What it we have to increase exponent?
//       We need to decrease significand
//       Rounding nearest ties to even:
//       .51 always bring us to next
//       .5  only if we are odd
// Handle the edge case when exponent is just 1 below? No we may have trailing '00s'

    // This seems like a double rounding: when exponent is too high 'pack' will
    // try to decrease the exponent by increasing significand. But remember that
    // we 'quantized' the 'mul', so there is no more space available.
    // Thus no digits will be moved from 'bid2'.
    return Self._pack(
      sign: mul.isNegative ? .minus : .plus,
      signedExponent: exponent,
      significand: significand,
      roundingDigitCount: 0,
      rounding: rounding,
      status: &status
    )
*/
