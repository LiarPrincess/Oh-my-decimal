extension DecimalMixin {

  internal var _floatingPointClass: FloatingPointClassification {
    // if isSignalingNaN { return .signalingNaN }
    // if isNaN { return .quietNaN }
    // if isInfinite { return sign == .minus ? .negativeInfinity : .positiveInfinity }
    // if isNormal { return sign == .minus ? .negativeNormal : .positiveNormal }
    // if isSubnormal { return sign == .minus ? .negativeSubnormal : .positiveSubnormal }
    // return sign == .minus ? .negativeZero : .positiveZero
    let result = Self.fnFloatingPointClass(self.bid)
    return FloatingPointClassification(result)
  }

  internal var _isZero:      Bool { self._test(Self.fnIsZero) }
  internal var _isFinite:    Bool { self._test(Self.fnIsFinite) }
  internal var _isInfinite:  Bool { self._test(Self.fnIsInfinite) }

  // A NaN is in its preferred (canonical) representation if the bits G6 through
  // Gw + 4 are zero and the encoding of the payload is canonical.
  internal var _isCanonical: Bool { self._test(Self.fnIsCanonical) }

  internal var _isNormal:    Bool { self._test(Self.fnIsNormal) }
  internal var _isSubnormal: Bool { self._test(Self.fnIsSubnormal) }

  internal var _isNaN:          Bool { self._test(Self.fnIsNaN) }
  internal var _isSignalingNaN: Bool { self._test(Self.fnIsSignalingNaN) }

  internal var _isNegative: Bool { self._test(Self.fnIsNegative) }
  internal var _sign: FloatingPointSign { self._isNegative ? .minus : .plus }

  internal var _ulp: Self {
    guard self._isFinite else {
      return Self(canonical: Self.nanQuietMask)
    }

    let lhs: Self
    let rhs: Self
    let gfm = Self._greatestFiniteMagnitude
    var status = ExceptionStatus()

    if self._isNegative || self.bid == gfm.bid {
      lhs = self
      rhs = self._nextDown(status: &status)
    } else {
      lhs = self._nextUp(status: &status)
      rhs = self
    }

    // Next can only signal on signaling NaN, and we have already handled it.
    assert(status.isEmpty, "ulp: next signalled an exception.")

    // Rounding does not matter, it should never round according to Sterbenz lemma:
    // y/2 < x < 2y. Any other status should also not happen.
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    let result = lhs._subtracting(other: rhs, rounding: rounding, status: &status)
    assert(status.isEmpty, "ulp: subtraction signalled an exception.")

    return result
  }

  internal static var _ulpOfOne: Self {
    let one = Self._one
    return one._ulp
  }
}
