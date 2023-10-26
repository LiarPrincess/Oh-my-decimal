extension DecimalMixin {

  internal func _isEqual(to other: Self, status: inout ExceptionStatus) -> Bool {
    return self._compareOp(Self.fnIsEqual, other: other, status: &status)
  }

  internal func _isLess(than other: Self, status: inout ExceptionStatus) -> Bool {
    return self._compareOp(Self.fnIsLess, other: other, status: &status)
  }

  internal func _isLessThanOrEqualTo(_ other: Self, status: inout ExceptionStatus) -> Bool {
    return self._compareOp(Self.fnIsLessEqual, other: other, status: &status)
  }

  internal func _isTotallyOrdered(belowOrEqualTo other: Self) -> Bool {
    // Swift stdlib:
    // // Quick return when possible.
    // if self < other { return true }
    // if other > self { return false }
    // // Self and other are either equal or unordered.
    // // Every negative-signed value (even NaN) is less than every positive-
    // // signed value, so if the signs do not match, we simply return the
    // // sign bit of self.
    // if sign != other.sign { return sign == .minus }
    // // Sign bits match; look at exponents.
    // if exponentBitPattern > other.exponentBitPattern { return sign == .minus }
    // if exponentBitPattern < other.exponentBitPattern { return sign == .plus }
    // // Signs and exponents match, look at significands.
    // if significandBitPattern > other.significandBitPattern {
    //   return sign == .minus
    // }
    // if significandBitPattern < other.significandBitPattern {
    //   return sign == .plus
    // }
    // //  Sign, exponent, and significand all match.
    // return true
    return self._test(Self.fnTotalOrder, other: other)
  }

  internal static func _minimum(
    _ x: Self,
    _ y: Self,
    status: inout ExceptionStatus
  ) -> Self {
    // Swift stdlib:
    // if x <= y || y.isNaN { return x }
    // return y
    return x._binaryOp(Self.fnMinimum, other: y, status: &status)
  }

  internal static func _maximum(
    _ x: Self,
    _ y: Self,
    status: inout ExceptionStatus
  ) -> Self {
    // Swift stdlib:
    // if x > y || y.isNaN { return x }
    // return y
    return x._binaryOp(Self.fnMaximum, other: y, status: &status)
  }

  internal static func _minimumMagnitude(
    _ x: Self,
    _ y: Self,
    status: inout ExceptionStatus
  ) -> Self {
    // Swift stdlib:
    // if x.magnitude <= y.magnitude || y.isNaN { return x }
    // return y
    return x._binaryOp(Self.fnMinimumMagnitude, other: y, status: &status)
  }

  internal static func _maximumMagnitude(
    _ x: Self,
    _ y: Self,
    status: inout ExceptionStatus
  ) -> Self {
    // Swift stdlib:
    // if x.magnitude > y.magnitude || y.isNaN { return x }
    // return y
    return x._binaryOp(Self.fnMaximumMagnitude, other: y, status: &status)
  }
}
