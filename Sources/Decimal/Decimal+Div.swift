extension DecimalMixin {

  internal func _divided(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // formatOf-division(source1, source2)
    //
    // The operation division(x, y) computes x/y.
    // The preferred exponent is Q(x) − Q(y).
    //
    // 6.1 Infinity arithmetic
    // Operations on infinite operands are usually exact and therefore signal no
    // exceptions, including, among others:
    // ― division(∞, x) or division(x, ∞) for finite x
    //
    // The exceptions that do pertain to infinities are signaled only when:
    // ― ∞ is created from finite operands by overflow (see 7.4) or division
    //   by zero (see 7.3)
    //
    // 7.2 Invalid operation
    // For operations producing results in floating-point format, the default
    // result of an operation that signals the invalid operation exception shall
    // be a quiet NaN that should provide some diagnostic information (see 6.2).
    //
    // These operations are:
    // ― division: division(0, 0) or division(∞, ∞)
    //
    // 7.3 Division by zero
    // The divideByZero exception shall be signaled if and only if an exact
    // infinite result is defined for an operation on finite operands.
    // The default result of divideByZero shall be an ∞ correctly signed
    // according to the operation:
    // ― For division, when the divisor is zero and the dividend is a finite
    //   non-zero number, the sign of the infinity is the exclusive OR of the
    //   operands’ signs (see 6.3).

    if self._isNaN || other._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, other, status: &status)
    }

    // inf / inf = ?
    if self._isInfinite && other._isInfinite {
      status.set(.isInvalidOperation)
      return Self._nan
    }

    let sign = self._sign ^ other._sign

    // inf / ? = inf
    if self._isInfinite {
      return Self(canonical: sign | Self.infinityMask)
    }

    // 0 / inf = 0
    // finite / inf = 0
    if other._isInfinite {
      return Self(canonical: sign.bid)
    }

    let lhs = self._unpackFiniteOrZero()
    let rhs = other._unpackFiniteOrZero()

    // 0 / finite = 0
    if lhs.significand.isZero {
      // 0 / 0 = invalid operation
      if rhs.significand.isZero {
        status.set(.isInvalidOperation)
        return Self._nan
      }

      // The preferred exponent is Q(x) − Q(y).
      let signedExponent = clamp(
        lhs.exponent.signed - rhs.exponent.signed,
        min: Self.minSignedExponent,
        max: Self.maxSignedExponent
      )

      let biasedExponent = Self._addBias(exponent: signedExponent)
      return Self(canonical: sign | biasedExponent << Self.exponentShift_00_01_10)
    }

    // finite / 0 = inf
    if rhs.significand.isZero {
      assert(!lhs.significand.isZero, "0/0 has special rules")
      status.set(.isDivisionByZero)
      return Self(canonical: sign | Self.infinityMask)
    }

    let lhsSignificand = lhs.significand.canonical
    let rhsSignificand = rhs.significand.canonical

    // Result 'significand' depends only on the lhs/rhs significands, not on the
    // exponents. We will borrow digits from 'lhs.exponent' just to calculate
    // the correct 'significand', and then we will worry about underflow.
    var quotient: BID
    var remainder: BID
    let exponentBorrowedDigitCount: Int
    var signedExponent = lhs.exponent.signed - rhs.exponent.signed

    if lhsSignificand >= rhsSignificand {
      // Example for precision = 7:
      // 1234567E20 / 456E7 = 2707E13 rem 175
      let (q1, r1) = lhsSignificand.quotientAndRemainder(dividingBy: rhsSignificand)

      // 10E20 / 5E7 = exactly 2E13, no remainder
      if r1 == 0 {
        return Self._pack(
          sign: sign,
          significand: q1,
          signedExponent: signedExponent,
          roundingDigitCount: 0,
          rounding: rounding,
          status: &status
        )
      }

      // Scale 'q' to 'Self.precisionInDigits' digits.
      // In our example:
      // scale = 7-4 = 3
      // q1Scaled = 2707*1000 = 2 707 000
      // r1Scaled =  175*1000 =   175 000
      let digitCount = Self._getDecimalDigitCount(q1)
      let scale = Self.precisionInDigits - digitCount
      let scalePow10: BID = Tables.getPowerOf10(exponent: scale)

      let q1Scaled = q1 * scalePow10
      let r1Scaled = Self._mulSignificands(r1, scalePow10)
      exponentBorrowedDigitCount = scale
      signedExponent -= exponentBorrowedDigitCount

      // r1Scaled / rhsSignificand = 175000 / 456 = 383 rem 352
      // quotient = 383 + 2 707 000 = 2 707 383
      let (q, r) = r1Scaled.quotientAndRemainder(dividingBy: rhsSignificand)
      quotient = q1Scaled + q.low
      remainder = r

#if DEBUG
      // We will reference 'IMPORTANT-1' later.
      let __quotientDigitCount = Self._getDecimalDigitCount(quotient)
      assert(__quotientDigitCount == Self.precisionInDigits, "IMPORTANT-1")

      // Proof:
      // a) We scaled 'q1' up to the full precision:
      //    q1Scaled = q1 * 10^scale <= Self.maxDecimalDigits
      assert(q1Scaled <= Self.maxDecimalDigits, "We scaled 'q1' to 'precision'")
      // b) r1Scaled < rhs*10^scale
      let __rhsScaled = Self._mulSignificands(rhsSignificand, scalePow10)
      assert(r1 < rhsSignificand, "remainder < divisor, obviously")
      assert(r1Scaled < __rhsScaled, "remainder * 10^scale < rhs * 10^scale")
      // c) From b) we can deduct that:
      // q = r1Scaled / rhs = r1 * 10^scale / rhs < 10^scale
      assert(q.high == 0)
      assert(q.low < scalePow10)
      // We know that:
      // a) q1Scaled = q1 * scalePow10 <= Self.maxDecimalDigits
      // c) q.low <= scalePow10
      //
      // So basically 'q.low' fills the trailing '0s' inside the 'q1Scaled'.
      // And since 'q1Scaled' is 'q' scaled to 'precision' digits then:
      // digitCount(quotient) = digitCount(q1Scaled + q.low) = digitCount(q1Scaled) = precision
      // QED
#endif
    } else {
      // 123E20 / 123456789E7 = ?
      // Scale 'lhs' the the same number of decimal digits as 'rhs'.
      let lhsDigitCount = Self._getDecimalDigitCount(lhsSignificand)
      let rhsDigitCount = Self._getDecimalDigitCount(rhsSignificand)

      let scaleToRhs = rhsDigitCount - lhsDigitCount
      let scaleToRhsPow10: BID = Tables.getPowerOf10(exponent: scaleToRhs)
      let lhsScaledToRhs = lhsSignificand * scaleToRhsPow10

      // Scale 'lhs' by 'Self.precisionInDigits - 1' (we need 'DoubleBID' to fit it).
      // If 'lhsScaledToRhs' is smaller than 'rhs' (they have the same number of
      // digits, but we can have 1234 vs 5678) then scale it a little bit more.
      // This is why we have this '-1' -> to fit in 'DoubleBID'.
      let makeLhsGreaterThanRhs = lhsScaledToRhs < rhsSignificand ? 1 : 0
      let scaleByPrecision = Self.precisionInDigits - 1 + makeLhsGreaterThanRhs
      let scaleByPrecisionPow10: BID = Tables.getPowerOf10(exponent: scaleByPrecision)
      assert(scaleByPrecision <= Self.precisionInDigits)

      let remainder1 = Self._mulSignificands(lhsScaledToRhs, scaleByPrecisionPow10)
      exponentBorrowedDigitCount = scaleToRhs + scaleByPrecision
      signedExponent -= exponentBorrowedDigitCount

      let (q, r) = remainder1.quotientAndRemainder(dividingBy: rhsSignificand)
      quotient = q.low
      remainder = r

#if DEBUG
      // We will reference 'IMPORTANT-2' later.
      let __quotientDigitCount = Self._getDecimalDigitCount(quotient)
      assert(__quotientDigitCount == Self.precisionInDigits, "IMPORTANT-2")

      // Proof:
      // We scaled 'lhs', so that 'digitCount(lhsScaledToRhs) == digitCount(rhs)':
      // lhsScaledToRhs = lhs * 10^(digitCount(rhs) - digitCount(lhs))
      // Then we scaled 'lhsScaledToRhs' by 'scaleByPrecision', so the division was:
      // q = remainder1 / rhs
      //   = (lhsScaledToRhs * 10^scaleByPrecision) / rhs
      //
      // a) lhs < rhs
      assert(lhsSignificand < rhsSignificand, "The 'else' branch that we are in")
      // b) scaleByPrecision = precision - 1 + makeLhsGreaterThanRhs <= precision
      assert(scaleByPrecision <= Self.precisionInDigits, "scaleByPrecision <= precision")
      // c) From a) and b) we have:
      //    remainder1 = lhsScaledToRhs * 10^scaleByPrecision <= rhs * 10^precision
      let __pow10: BID = Tables.getPowerOf10(exponent: Self.precisionInDigits)
      let __rhsScaled = Self._mulSignificands(rhsSignificand, __pow10)
      assert(remainder1 < __rhsScaled, "lhsScaledToRhs * 10^scaleByPrecision <= rhs * 10^precision")
      // d) From c) we have:
      //    remainder1 < rhs*10^precision
      assert(q.high == 0)
      assert(q.low <= __pow10)
      // e) rhs * 10^(precision-1) <= remainder1
      //    rhs * 10^(precision-1) <= lhsScaledToRhs * 10^scaleByPrecision
      //
      //    if lhsScaledToRhs >= rhs:
      //      makeLhsGreaterThanRhs = 0
      //      scaleByPrecision = precision - 1 + 0 = precision -1
      //
      //      Putting that into our equation:
      //      rhs * 10^(precision-1) <= lhsScaledToRhs * 10^(precision-1)
      //      rhs <= lhsScaledToRhs
      //
      //    else lhsScaledToRhs < rhs:
      //      makeLhsGreaterThanRhs = 1
      //      scaleByPrecision = precision - 1 + 1 = precision
      //
      //      Putting that into our equation:
      //      rhs * 10^(precision-1) <= lhsScaledToRhs * 10^precision
      //      rhs * 10^(precision-1) <= lhsScaledToRhs * 10^(precision-1) * 10
      //      rhs <= lhsScaledToRhs * 10
      //
      //      Which is true because:
      //      - lhsScaledToRhs < rhs
      //      - digitCount(lhsScaledToRhs) == digitCount(rhs)
      let __rhsScaledExponentMinus1 = __rhsScaled / 10
      assert(__rhsScaledExponentMinus1 <= remainder1)
      // From d) and e) we have:
      // rhs*10^(precision-1) <= remainder1 < rhs*10^precision
      // QED
#endif
    }

    if remainder == 0 {
      // Remainder is '0' -> exact result -> eliminate trailing zeros.
      let trailingZeroCount = Self._divCountQuotientTrailingZeros(
        lhs: lhs,
        rhs: rhs,
        quotient: quotient,
        exponentBorrowedDigitCount: exponentBorrowedDigitCount
      )

      if trailingZeroCount != 0 {
        let pow10: BID = Tables.getPowerOf10(exponent: trailingZeroCount)
        quotient /= pow10
        signedExponent += trailingZeroCount
      }
    } else {
      status.set(.isInexact)
    }

    if signedExponent < Self.minSignedExponent {
      // Increasing exponent will 'eat' least significand digits from 'quotient'.
      // So the least significand digit does not matter (it will always be 'eaten'),
      // as long as we round correctly. There will ALWAYS be rounding!
      var roundingDigitCount = 0

      if remainder != 0 {
        quotient *= 10
        quotient |= 1
        roundingDigitCount = 1
      }

      return Self._pack(
        sign: sign,
        significand: quotient,
        signedExponent: signedExponent,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        status: &status
      )
    }

    if remainder != 0 {
#if DEBUG
      // Why can we round here?
      // We handled 'underflow', as for the 'overflow':
      // - overflow will try to decrease exponent by multiplying the significand.
      // - based on the 'IMPORTANT-1' and 'IMPORTANT-2' proofs from the 'if' above
      //   we know that the 'quotient' has all significand digits filled.
      //
      // This means that the significand multiplication will fail, as there are
      // no available significand digits.
      //
      // Also, FML for doing mathematical proofs for such 💩.
      let __quotientDigitCount = Self._getDecimalDigitCount(quotient)
      assert(__quotientDigitCount == Self.precisionInDigits, "IMPORTANT-1&2")
      assert(quotient <= Self.maxDecimalDigits, "No rounding digits.")
#endif

      let isRoundingAwayFromZero: Bool

      switch rounding {
      case .up:
        isRoundingAwayFromZero = sign.isPlus
      case .down:
        isRoundingAwayFromZero = sign.isMinus
      case .towardZero:
        isRoundingAwayFromZero = false // Ignore the remainder.

      case .toNearestOrEven,
           .toNearestOrAwayFromZero:
        // For 'toNearestOrAwayFromZero':
        //  rem >= rhs/2
        //  2*rem >= rhs
        //  2*rem - rhs >= 0
        let remainder2 = remainder + remainder
        let (sub, borrow) = remainder2.subtractingReportingOverflow(rhsSignificand)
        let isHalfway = sub == 0

        isRoundingAwayFromZero = isHalfway ?
          (rounding == .toNearestOrAwayFromZero || quotient.isOdd) :
          !borrow
      }

      if isRoundingAwayFromZero {
        quotient += 1

        // Make it canonical if needed.
        // I can't think of any pair of numbers that would go inside this 'if'.
        // Things like '99999/0.1' are handled via fast path.
        // And yet… we still have to handle it.
        if quotient == Self.maxDecimalDigits + 1 {
          quotient /= 10
          signedExponent += 1
        }
      }
    }

    return Self._pack(
      sign: sign,
      significand: quotient,
      signedExponent: signedExponent,
      roundingDigitCount: 0,
      rounding: rounding,
      status: &status
    )
  }

  private static func _divCountQuotientTrailingZeros(
    lhs: FiniteUnpack,
    rhs: FiniteUnpack,
    quotient: BID,
    exponentBorrowedDigitCount: Int
  ) -> Int {
    if quotient == 0 {
      return 0
    }

    let lhsSignificand = lhs.significand.canonical
    let rhsSignificand = rhs.significand.canonical

    if lhsSignificand <= 1024 && rhsSignificand <= 1024 {
      // Prime factorization -> count the number of 2 and 5 (because 2*5=10).
      // The lower number dictates the power of 10 (trailing zero count).
      let lhsFactors = Tables.getFactorCount(lessEqual1024: lhsSignificand)
      let rhsFactors = Tables.getFactorCount(lessEqual1024: rhsSignificand)

      let d2 = exponentBorrowedDigitCount - rhsFactors.count2 + lhsFactors.count2
      let d5 = exponentBorrowedDigitCount - rhsFactors.count5 + lhsFactors.count5
      return Swift.min(d2, d5)
    }

    if let q64 = UInt64(exactly: quotient) {
      return countTrailingZeros(q64)
    }

    // 10^17
    let pow10_17: BID = 100_000_000_000_000_000
    let (q, r) = quotient.quotientAndRemainder(dividingBy: pow10_17)

    // If we have 'remainder' then its trailing zero count is the result.
    if r != 0 {
      let r64 = UInt64(r)
      return countTrailingZeros(r64)
    }

    // 'Decimal128' is the biggest with 'Self.precisionInDigits = 34'.
    assert(q <= pow10_17)
    let q64 = UInt64(q)
    let count = countTrailingZeros(q64)
    // Since 'r == 0' then we have at least 17 trailing '0'.
    return count + 17
  }
}
