extension DecimalMixin {

  internal static func _initByScaling(
    sign: FloatingPointSign,
    exponent: Int,
    significand: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    // sign | exponent | significand | Decimal   | Double | Human
    //    + |        2 |      1.2345 | +12345E-2 |  4.938 | +123.45
    //    + |        2 |     -1.2345 | -12345E-2 | -4.938 | -123.45
    //    - |        2 |      1.2345 | -12345E-2 | -4.938 | -123.45
    //    - |        2 |     -1.2345 | +12345E-2 |  4.938 | +123.45
    //
    // Obviously Double has b=2 in scaleB(x, N)= x*(b^N).

    let bid = Self.fnScaleB(significand.bid, exponent, rounding.value, &status.value)
    var result = Self(unchecked: bid)

    switch sign {
    case .plus: break
    case .minus: result._negate()
    }

    return result
  }

  /// Cbid: bid64_ilogb (modified for Swift semantics)
  internal func _getExponent(status: inout ExceptionStatus) -> Int {
    let unpack: Unpack

    switch self.unpack() {
    case .zero:
      status.set(.isInvalidOperation)
      return Int.min

    case .infinity,
         .quietNaN,
         .signalingNaN:
      status.set(.isInvalidOperation)
      return Int.max

    case .finite(let u):
      unpack = u
    }

    let digitCount = Self._getDecimalDigitCount(significand: unpack.significand)
    let exponent = Self._removeBias(biasedExponent: unpack.biasedExponent)
    return exponent + digitCount - 1
  }

  /// Cbid: bid64_frexp (modified for Swift semantics)
  internal func _getSignificand() -> Self {
    let unpack: Unpack

    switch self.unpack() {
    case .zero,
         .infinity,
         .quietNaN,
         .signalingNaN:
      // Preserve sign and NaN payload.
      return self
    case .finite(let u):
      unpack = u
    }

    // For finite values we have to return positive value.

    if !self._isCanonical {
      // 0 with 00_01_10 encoding
      return Self(canonical: unpack.biasedExponent << Self.exponentShift_00_01_10)
    }

    let digitCount = Self._getDecimalDigitCount2(significand: unpack.significand)
    let maxSignificand_00_01_10 = BID(1) << Self.exponentShift_00_01_10

    assert(Self.exponentBias > digitCount)
    let newExponent = BID(Self.exponentBias - digitCount) + 1

    if unpack.significand < maxSignificand_00_01_10 {
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
