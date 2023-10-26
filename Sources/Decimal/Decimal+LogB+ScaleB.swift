extension DecimalMixin {

  // MARK: - ScaleB

  internal static func _init(
    sign: FloatingPointSign,
    exponent: Int,
    significand: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // sourceFormat scaleB(source, logBFormat)
    //
    // scaleB(x, N) is x × b N for integral values N. The result is computed as
    // if the exact product were formed and then rounded to the destination format,
    // subject to the applicable rounding-direction attribute. When logBFormat
    // is a floating-point format, the behavior of scaleB is language-defined
    // when the second operand is non-integral.
    //
    // For non-zero values of N, scaleB(±0, N) returns ±0 and scaleB(±∞, N)
    // returns ±∞. For zero values of N, scaleB(x, N) returns x.
    //
    // The preferred exponent is Q(x) + N.

    // What is the sign of the result?
    //
    // sign | exponent | significand | Double |
    //    + |        2 |      1.2345 |  4.938 |
    //    + |        2 |     -1.2345 | -4.938 |
    //    - |        2 |      1.2345 | -4.938 |
    //    - |        2 |     -1.2345 |  4.938 |
    //
    // Basically: sign equal -> plus; sign different -> minus.
    let isSignEqual = (sign == .minus) == significand._isNegative
    let sign: Sign = isSignEqual ? .plus : .minus

    if significand._isNaN {
      // For sNaN the result of this function will not obey IEEE-754.
      //
      // Swift returns sNaN (with no flags?):
      //   let nan = Double(nan: 123, signaling: true)
      //   print(Double(sign: .plus, exponent: 1, significand: nan)) // snan(0x7b)
      //
      // IEEE-754 -> 6.2 Operations with NaNs -> returns NaN:
      //   Under default exception handling, any operation signaling an invalid
      //   operation exception and for which a floating-point result is to be
      //   delivered shall deliver a quiet NaN.
      //
      //   The only exception is character sequence conversion.
      //
      // If the payload is not canonical, then oh well…
      let keep = significand.bid & ~Self.signMask
      return Self(unchecked: sign | keep)
    }

    if significand._isInfinite {
      return Self(canonical: sign | Self.infinityMask)
    }

    let unpack = significand._unpackFiniteOrZero()
    let oldExponent = unpack.exponent.signed
    let (newExponent, overflow) = oldExponent.addingReportingOverflow(exponent)

    // '0' becomes '0' with clamped 'newExponent'.
    // No status flags are raised (even on overflow).
    // Intel works differently, but I think this is a sensible default.
    if unpack.significand.isZero {
      let signedExponent: Int

      if overflow {
        signedExponent = exponent > 0 ? Self.maxSignedExponent : Self.minSignedExponent
      } else {
        signedExponent = clamp(
          newExponent,
          min: Self.minSignedExponent,
          max: Self.maxSignedExponent
        )
      }

      return Self._packWithoutChecks(
        sign: sign,
        significand: 0,
        signedExponent: signedExponent
      )
    }

    if overflow {
      if exponent > 0 {
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      }

      status.set(.isUnderflowInexact)
      return Self._roundInfinitelySmallValue(
        sign: sign,
        preferredSignedExponentForZero: Self.minSignedExponent,
        rounding: rounding
      )
    }

    return Self._pack(
      sign: sign,
      significand: unpack.significand.canonical,
      signedExponent: newExponent,
      roundingDigitCount: 0,
      rounding: rounding,
      status: &status
    )
  }

  // MARK: - Exponent - LogB

  internal func _getExponent(status: inout DecimalStatus) -> Int {
    // logBFormat logB(source)
    //
    // logB(x) is the exponent e of x, a signed integral value, determined as
    // though x were represented with infinite range and minimum exponent.
    // Thus 1 ≤ scaleB(x, −logB(x)) < b when x is positive and finite.
    // logB(1) is +0.
    //
    // When logBFormat is a floating-point format, logB(NaN) is a NaN,
    // logB(∞) is +∞, and logB(0) is −∞ and signals the divideByZero exception.
    //
    // When logBFormat is an integer format, then logB(NaN), logB(∞), and logB(0)
    // return language-defined values outside the range ±2 × (emax + p − 1) and
    // signal the invalid operation exception.
    //
    // The preferred exponent is 0.
    //
    // NOTE — For positive finite x, the value of logB(x) is floor(log2 (x)) in
    // a binary format, and is floor(log10 (x)) in a decimal format.
    //
    // 7.2 Invalid operation
    // For operations producing no result in floating-point format, the operations
    // that signal the invalid operation exception are:
    // k) logB(NaN), logB(∞), or logB(0) when logBFormat is an integer format (see 5.3.3).
    //
    // 7.3 Division by zero
    // The divideByZero exception shall be signaled if and only if an exact
    // infinite result is defined for an operation on finite operands. The
    // default result of divideByZero shall be an ∞ correctly signed according to
    // the operation:
    // ― For logB(0) when logBFormat is a floating-point format, the sign of the
    //   infinity is minus (−∞).

    if self._isInfiniteOrNaN {
      status.set(.isInvalidOperation)
      return Int.max
    }

    let unpack = self._unpackFiniteOrZero()

    if unpack.significand.isZero {
      status.set(.isInvalidOperation)
      return Int.min
    }

    let digitCount = Self._getDecimalDigitCount(unpack.significand)
    let exponent = unpack.exponent.signed
    return exponent + digitCount - 1
  }

  // MARK: - Significand

  /// Cbid: bid64_frexp (modified for Swift semantics)
  internal func _getSignificand() -> Self {
    if self._isNaN {
      // We will return positive value, even though 'Swift.Double' returns negative.
      // This is needed to preserve following idiom:
      //  let x0 = F(sign: x.sign, exponent: x.exponent, significand: x.significand)
      //  assert(x.bid == x0.bid)
      //
      // On '-Double.nan' the result of this idiom would be 'nan' instead of '-nan'.
      //
      // If the payload is not canonical, then oh well…
      let bid = self.bid & (~Self.signMask)
      return Self(unchecked: bid)
    }

    if self._isInfinite {
      return Self._infinity
    }

    // For finite values we have to return positive value.
    let unpack = self._unpackFiniteOrZero()

    // This will also handle non-canonical values.
    if unpack.significand.isZero {
      // 0 with 00_01_10 encoding
      return Self(canonical: unpack.exponent.biased << Self.exponentShift_00_01_10)
    }

    let digitCount = Self._getDecimalDigitCount(unpack.significand)
    let maxSignificand_00_01_10 = BID(1) << Self.exponentShift_00_01_10

    assert(Self.exponentBias > digitCount)
    let newExponent = BID(Self.exponentBias - digitCount) + 1

    if unpack.significand.canonical < maxSignificand_00_01_10 {
      let mask = maxSignificand_00_01_10 - 1
      let significand = self.bid & mask
      let exponent = newExponent << Self.exponentShift_00_01_10
      return Self(canonical: significand | exponent)
    }

    let mask = (BID(1) << Self.exponentShift_11) - 1
    let significand = self.bid & mask
    let exponent = newExponent << Self.exponentShift_11
    return Self(canonical: Self.combinationHighBits11Mask | significand | exponent)
  }
}
