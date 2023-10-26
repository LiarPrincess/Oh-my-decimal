internal typealias CCharBuffer = UnsafeMutablePointer<CChar>

extension DecimalMixin {

  internal static func _parse(
    _ s: String,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self? {
    let bid = s.withCString { ptr -> Self.BID? in
      let mutablePtr = UnsafeMutablePointer(mutating: ptr)
      let result = Self.fnFromString(mutablePtr, rounding.value, &status.value)

      // In case of invalid string (like: Decimal64("xxx")) Cbid will return NaN,
      // with empty ExceptionStatus. Swift wants nil.
      let isQuietNaN = (result & Self.nanQuietMask) == Self.nanQuietMask
      let isSignalingNaN = (result & Self.nanSignalingMask) == Self.nanSignalingMask

      if isQuietNaN && !isSignalingNaN && !Self._isStrictlyNaN(ptr) {
        return nil
      }

      return result
    }

    return bid.map(Self.init(unchecked:))
  }

  /// Possible forms: `nan`, `+nan`, `-nan`.
  private static func _isStrictlyNaN(_ s: UnsafePointer<CChar>) -> Bool {
    let _plus:  CChar = 43,  _minus: CChar = 45
    let _space: CChar = 32,  _tab:   CChar = 9
    let _a:     CChar = 97,  _A:     CChar = 65
    let _n:     CChar = 110, _N:     CChar = 78

    var index = 0
    while s[index] == _space || s[index] == _tab { index += 1 }
    if s[index] == _plus || s[index] == _minus { index += 1 }

    return (s[index + 0] == _n || s[index + 0] == _N)
        && (s[index + 1] == _a || s[index + 1] == _A)
        && (s[index + 2] == _n || s[index + 2] == _N)
        &&  s[index + 3] == 0
  }

  internal func _toString(status: inout ExceptionStatus) -> String {
    // TODO: [toString] Use Self._getDecimalDigitCount()
    // +9642445997045387E+81
    let capacity = 1 // sign (always present)
      + Self.precisionInDigits
      + 2 // E + exponent sign
      + self._slowLog10(Self.maxUnbiasedExponent)
      + 3 // NULL + some safety margin

    let buffer = CCharBuffer.allocate(capacity: capacity)
    defer { buffer.deallocate() }

    Self.fnToString(buffer, self.bid, &status.value)
    return String(cString: buffer) // borrow and create owned copy
  }

  /// 0->0 | 9->1 | 10->2 | 99->2 | 100->3 etc.
  private func _slowLog10(_ n: Int) -> Int {
    assert(n >= 0)

    var n = n
    var result = 0

    while n != 0 {
      result += 1
      n /= 10
    }

    return result
  }
}
