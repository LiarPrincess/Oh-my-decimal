extension DecimalMixin {

  // MARK: - Minimum

  internal static func _minimum(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self {
    // minNum(x, y) is the canonicalized number x if x < y, y if y < x, the
    // canonicalized number if one operand is a number and the other a quiet NaN.
    // Otherwise it is either x or y, canonicalized (this means results might
    // differ among implementations).
    // When either x or y is a signalingNaN, then the result is according to 6.2.
    let x = Self.makeCanonical(x)
    let y = Self.makeCanonical(y)

    switch Self._compare(x, y) {
    case .nan:
      return Self.handleNaN(x, y, status: &status)

    case .less, .equal:
      return x

    case .greater:
      return y
    }
  }

  internal static func _minimumMagnitude(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self {
    // minNumMag(x, y) is the canonicalized number
    // x if |x| < |y|
    // y if |y| < |x|
    // otherwise minNum(x, y).
    let x = Self.makeCanonical(x)
    let y = Self.makeCanonical(y)

    switch Self._compare(x._magnitude, y._magnitude) {
    case .nan:
      return Self.handleNaN(x, y, status: &status)

    case .less:
      return x

    case .equal:
      var s = DecimalStatus()
      let isLessEqual = x._isLessThanOrEqualTo(y, status: &s)
      assert(s.isEmpty)
      return isLessEqual ? x : y

    case .greater:
      return y
    }
  }

  // MARK: - Maximum

  internal static func _maximum(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self {
    // maxNum(x, y) is the canonicalized number y if x < y, x if y < x, the
    // canonicalized number if one operand is a number and the other a quiet NaN.
    // Otherwise it is either x or y, canonicalized (this means results might
    // differ among implementations).
    // When either x or y is a signalingNaN, then the result is according to 6.2.
    let x = Self.makeCanonical(x)
    let y = Self.makeCanonical(y)

    switch Self._compare(x, y) {
    case .nan:
      return Self.handleNaN(x, y, status: &status)

    case .less:
      return y

    case .equal, .greater:
      return x
    }
  }

  internal static func _maximumMagnitude(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self {
    // maxNumMag(x, y) is the canonicalized number
    // x if |x| > |y|
    // y if |y| > |x|
    // otherwise maxNum(x, y).
    let x = Self.makeCanonical(x)
    let y = Self.makeCanonical(y)

    switch Self._compare(x._magnitude, y._magnitude) {
    case .nan:
      return Self.handleNaN(x, y, status: &status)

    case .less:
      return y

    case .equal:
      var s = DecimalStatus()
      let isLess = x._isLess(than: y, status: &s)
      assert(s.isEmpty)
      return isLess ? y : x

    case .greater:
      return x
    }
  }

  // MARK: - Helpers

  private static func makeCanonical(_ d: Self) -> Self {
    if d._isNaN {
      let nan = d.bid & (Self.signMask | Self.nanSignalingMask)
      let payload = d._unpackNaN()
      return Self(canonical: nan | payload.canonical)
    }

    if d._isInfinite {
      let sign = d.bid & Self.signMask
      return Self(canonical: sign | Self.infinityMask)
    }

    let unpack = d._unpackFiniteOrZero()
    return Self(canonical: unpack)
  }

  private static func handleNaN(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self {
    assert(x._isNaN || y._isNaN)

    // When either x or y is a signalingNaN, then the result is according to 6.2.
    if x._isSignalingNaN || y._isSignalingNaN {
      return Self._nanResult_viaIEEE754_section62(x, y, status: &status)
    }

    // minNum(x, y) is (…), the canonicalized number if one operand is a number
    // and the other a quiet NaN.
    // If both are 'nan' then return x.
    if y._isNaN {
      return x
    }

    assert(x._isNaN)
    return y
  }
}
