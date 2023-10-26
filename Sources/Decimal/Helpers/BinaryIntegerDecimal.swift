// Swift compiler complains about the 'Magnitude' requirement,
// but it will fail to compile if we remove it…
internal protocol BinaryIntegerDecimal: FixedWidthInteger, UnsignedInteger where Magnitude == Self {
  /// `⌊√self⌋`
  func squareRoot() -> Self
}

extension BinaryIntegerDecimal {
  internal var isOdd: Bool {
    return (self & 1) == 1
  }
}

extension UInt32: BinaryIntegerDecimal {
  internal func squareRoot() -> Self {
    // All 'UInt32' all representable in 'Double'.
    // Though we may pollute the flags with out 'inexactness'. Oh well…
    var d = Double(self)
    d.formSquareRoot()
    let result = Self(d)
    validateSquareRoot(self, root: result)
    return result
  }
}

extension UInt64: BinaryIntegerDecimal {
  internal func squareRoot() -> Self {
    // We may pollute the flags with out 'inexactness'. Oh well…
    var d = Double(self)
    d.formSquareRoot()
    var result = Self(d)

    // Apply correction as we can be off by 1 in either direction.
    let (square, overflow) = result.multipliedReportingOverflow(by: result)

    if overflow || square > self {
      result -= 1
    } else {
      let plus1 = result + 1
      let (square, overflow) = plus1.multipliedReportingOverflow(by: plus1)

      if !overflow && square <= self {
        result = plus1
      }
    }

    validateSquareRoot(self, root: result)
    return result
  }
}

extension UInt128: BinaryIntegerDecimal {
  internal func squareRoot() -> Self {
    return newtonSquareRoot(self)
  }
}

extension UInt256: BinaryIntegerDecimal {
  internal func squareRoot() -> Self {
    return newtonSquareRoot(self)
  }
}

/// https://en.wikipedia.org/wiki/Integer_square_root#Algorithm_using_Newton's_method
/// https://stackoverflow.com/a/63457507
/// https://codereview.stackexchange.com/a/199805
/// https://www.codeproject.com/Articles/5321399/NewtonPlus-A-Fast-Big-Number-Square-Root-Function
private func newtonSquareRoot<T: BinaryIntegerDecimal>(_ n: T) -> T {
  if n <= (1 as T) {
    return n
  }

  // Closer estimate from the Wikipedia 'Numerical example' section.
  let l2 = log2(nonZero: n)
  let exponent = (l2 / 2) + 1
  var x0: T = 1 << exponent
  var x1: T = (x0 + n / x0) >> 1 // Divide by 2

  while x1 < x0 {
    x0 = x1
    x1 = (x0 + n / x0) >> 1 // Divide by 2
  }

  validateSquareRoot(n, root: x0)
  return x0
}

/// Check if `root` is really the square root of `n`.
private func validateSquareRoot<T: BinaryIntegerDecimal>(_ n: T, root: T) {
#if DEBUG
  let square = root * root
  assert(square <= n, "√\(n) = \(root), square: \(square)")

  let root1 = root + 1
  let (square1, overflow1) = root1.multipliedReportingOverflow(by: root1)
  assert(overflow1 || square1 > n, "√\(n) =? \(root1), square1: \(square1)")
#endif
}
