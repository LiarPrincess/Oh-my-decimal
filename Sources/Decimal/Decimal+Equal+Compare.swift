extension DecimalMixin {

  // MARK: - Equal, less

  internal func _isEqual(to other: Self, status: inout DecimalStatus) -> Bool {
    switch Self._compare(self, other) {
    case .nan:
      if self._isSignalingNaN || other._isSignalingNaN {
        status.set(.isInvalidOperation)
      }

      return false

    case .equal:
      return true

    case .less, .greater:
      return false
    }
  }

  internal func _isLess(than other: Self, status: inout DecimalStatus) -> Bool {
    switch Self._compare(self, other) {
    case .nan:
      if self._isSignalingNaN || other._isSignalingNaN {
        status.set(.isInvalidOperation)
      }

      return false

    case .less:
      return true

    case .equal, .greater:
      return false
    }
  }

  internal func _isLessThanOrEqualTo(_ other: Self, status: inout DecimalStatus) -> Bool {
    switch Self._compare(self, other) {
    case .nan:
      if self._isSignalingNaN || other._isSignalingNaN {
        status.set(.isInvalidOperation)
      }

      return false

    case .less, .equal:
      return true

    case .greater:
      return false
    }
  }

  // MARK: - Total order

  internal func _isTotallyOrdered(belowOrEqualTo other: Self) -> Bool {
    switch Self._compare(self, other) {
    // a) If x < y, totalOrder(x, y) is true.
    case .less:
      return true

    // b) If x > y, totalOrder(x, y) is false
    case .greater:
      return false

    // c) If x = y:
    case .equal:
      // Infinity with the same sign.
      // Other bits do not matter, because they are not canonical.
      if self._isInfinite {
        return true
      }

      // 1) totalOrder(−0, +0) is true.
      // 2) totalOrder(+0, −0) is false.
      // Note that this check will be 'false' if we have '0' with the same sign!
      if self._isNegative != other._isNegative {
        assert(self._isZero, "Only 0 can be equal with different signs?")
        return self._isNegative
      }

      // 3) If x and y represent the same floating-point datum:
      //   i) If x and y have negative sign,
      //      totalOrder(x, y) is true if and only if the exponent of x ≥ the exponent of y
      //  ii) otherwise
      //      totalOrder(x, y) is true if and only if the exponent of x ≤ the exponent of y.
      let selfUnpack = self._unpackFiniteOrZero()
      let otherUnpack = other._unpackFiniteOrZero()

      if self._isNegative {
        return selfUnpack.exponent >= otherUnpack.exponent
      }

      return selfUnpack.exponent <= otherUnpack.exponent

    // d) If x and y are unordered numerically because x or y is NaN:
    case .nan:
      // 3) If x and y are both NaNs, then totalOrder reflects a total ordering
      //    based on:
      if self._isNaN && other._isNaN {
        // i) negative sign orders below positive sign
        if self._isNegative != other._isNegative {
          return self._isNegative
        }

        // ii) signaling orders below quiet for +NaN, reverse for −NaN
        if self._isSignalingNaN && other._isQuietNaN {
          return self._isPositive
        }

        if other._isSignalingNaN && self._isQuietNaN {
          return self._isNegative
        }

        // iii) lesser payload, when regarded as an integer, orders below greater
        //      payload for +NaN, reverse for −NaN.
        let payloadSelf = self._unpackNaN()
        let payloadOther = other._unpackNaN()

        if self._isPositive {
          return payloadSelf.canonical <= payloadOther.canonical
        }

        return payloadSelf.canonical >= payloadOther.canonical
      }

      // 1) totalOrder(−NaN, y) is true where −NaN represents a NaN with negative
      //    sign bit and y is a floating-point number.
      // 2) totalOrder(x, +NaN) is true where +NaN represents a NaN with positive
      //    sign bit and x is a floating-point number.
      if self._isNaN {
        return self._isNegative
      }

      assert(other._isNaN)
      return other._isPositive
    }
  }
}

// MARK: - Compare

internal enum CompareResult {
  /// One of the arguments is NaN.
  case nan
  /// x < y
  case less
  /// x == y
  case equal
  /// x > y
  case greater
}

extension DecimalMixin {

  internal static func _compare(_ x: Self, _ y: Self) -> CompareResult {
    // =========================================================================
    // Brace yourself.
    // This function is truly mind-bending.
    // Unfortunately, a general purpose 'compare' function is quite useful.
    // =========================================================================

    if x._isNaN || y._isNaN {
      return .nan
    }

    if x.bid == y.bid {
      return .equal
    }

    if x._isInfinite {
      if x._isPositive {
        // +inf vs y
        return y._isPositive && y._isInfinite ? .equal : .greater
      }

      // -inf vs y
      return y._isNegative && y._isInfinite ? .equal : .less
    }

    // x vs +inf
    // x vs -inf
    if y._isInfinite {
      return y._isPositive ? .less : .greater
    }

    let xUnpack = x._unpackFiniteOrZero()
    let yUnpack = y._unpackFiniteOrZero()
    let xSignificand = xUnpack.significand.canonical
    let ySignificand = yUnpack.significand.canonical

    // ±0 vs ±0? This will also handle non-canonical.
    if xSignificand == 0 && ySignificand == 0 {
      return .equal
    }

    // 0 vs y
    if xSignificand == 0 {
      return y._isPositive ? .less : .greater
    }

    // x vs 0
    if ySignificand == 0 {
      return x._isPositive ? .greater : .less
    }

    // Different signs
    if x._isPositive != y._isPositive {
      return x._isPositive ? .greater : .less
    }

    let xExponent = xUnpack.exponent.signed
    let yExponent = yUnpack.exponent.signed

    // |x| > |y|
    if xSignificand > ySignificand && xExponent > yExponent {
      return x._isPositive ? .greater : .less
    }

    // |x| < |y|
    if xSignificand < ySignificand && xExponent < yExponent {
      return x._isPositive ? .less : .greater
    }

    // Even after quantization the result would still be the same.
    // xExponent ≫ yExponent
    if xExponent - yExponent >= Self.precisionInDigits {
      return x._isPositive ? .greater : .less
    }

    // xExponent ≪ yExponent
    if yExponent - xExponent >= Self.precisionInDigits {
      return x._isPositive ? .less : .greater
    }

    if xExponent > yExponent {
      let (significand, overflow) = Self._quantize(
        significand: xSignificand,
        exponentBig: xExponent,
        exponentSmall: yExponent
      )

      // When rescaling x it overflowed
      if overflow {
        return x._isPositive ? .greater : .less
      }

      if significand == ySignificand {
        return .equal
      }

      if x._isPositive {
        return significand < ySignificand ? .less : .greater
      }

      return significand < ySignificand ? .greater : .less
    }

    let (significand, overflow) = Self._quantize(
      significand: ySignificand,
      exponentBig: yExponent,
      exponentSmall: xExponent
    )

    // When rescaling y it overflowed
    if overflow {
      return x._isPositive ? .less : .greater
    }

    if significand == xSignificand {
      return .equal
    }

    if x._isPositive {
      return xSignificand < significand ? .less : .greater
    }

    return xSignificand < significand ? .greater : .less
  }

  private static func _quantize(
    significand: BID,
    exponentBig: Int,
    exponentSmall: Int
  ) -> (significand: BID, overflow: Bool) {
    assert(exponentBig >= exponentSmall)
    let diff = exponentBig - exponentSmall
    let pow10: BID = Tables.getPowerOf10(exponent: diff)
    let r = significand.multipliedReportingOverflow(by: pow10)
    return (r.partialValue, r.overflow)
  }
}
