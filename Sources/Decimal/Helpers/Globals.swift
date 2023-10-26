// swiftlint:disable function_parameter_count

internal func sum<T: FixedWidthInteger>(
  _ n0: T,
  _ n1: T
) -> (high: T, low: T) {
  let (sum, overflow) = n0.addingReportingOverflow(n1)
  return (overflow ? 1 : 0, sum)
}

internal func sum<T: FixedWidthInteger>(
  _ n0: T,
  _ n1: T,
  _ n2: T
) -> (high: T, low: T) {
  let s1 = sum(n0, n1)
  let s2 = sum(s1.low, n2)
  return (s1.high &+ s2.high, s2.low)
}

internal func sum<T: FixedWidthInteger>(
  _ n0: T,
  _ n1: T,
  _ n2: T,
  _ n3: T
) -> (high: T, low: T) {
  let s1 = sum(n0, n1)
  let s2 = sum(n2, n3)
  let s = sum(s1.low, s2.low)
  return (s1.high &+ s2.high &+ s.high, s.low)
}

internal func sum<T: FixedWidthInteger>(
  _ n0: T,
  _ n1: T,
  _ n2: T,
  _ n3: T,
  _ n4: T
) -> (high: T, low: T) {
  let s1 = sum(n0, n1)
  let s2 = sum(n2, n3, n4)
  let s = sum(s1.low, s2.low)
  return (s1.high &+ s2.high &+ s.high, s.low)
}

internal func sum<T: FixedWidthInteger>(
  _ n0: T,
  _ n1: T,
  _ n2: T,
  _ n3: T,
  _ n4: T,
  _ n5: T
) -> (high: T, low: T) {
  let s1 = sum(n0, n1, n2)
  let s2 = sum(n3, n4, n5)
  let s = sum(s1.low, s2.low)
  return (s1.high &+ s2.high &+ s.high, s.low)
}

internal func sum<T: FixedWidthInteger>(
  _ n0: T,
  _ n1: T,
  _ n2: T,
  _ n3: T,
  _ n4: T,
  _ n5: T,
  _ n6: T,
  _ n7: T
) -> (high: T, low: T) {
  let s1 = sum(n0, n1, n2, n3)
  let s2 = sum(n4, n5, n6, n7)
  let s = sum(s1.low, s2.low)
  return (s1.high &+ s2.high &+ s.high, s.low)
}

/// 1 -> 0; 7 -> 2; 8 -> 3 etc.
internal func log2<T: FixedWidthInteger & UnsignedInteger>(nonZero n: T) -> Int {
  precondition(n != 0, "Log2(0)")
  return T.bitWidth - n.leadingZeroBitCount - 1
}

/// return Swift.max(Swift.min(n, max), min)
internal func clamp(_ n: Int, min: Int, max: Int) -> Int {
  if n < min { return min }
  if n > max { return max }
  return n
}

internal func countTrailingZeros(_ n: UInt64) -> Int {
  // Intel does quite complicated things.
  // We could do the same (and it will work, I tested it), but…
  //
  // 'UInt64' can have at max 20 trailing zeros.
  // We will do unrolled binary search with divisions.
  // Yes, divisions are VERY expensive, but we always divide by a constant and
  // according to 'godbolt' ('-O -gnone') no division will actually be performed.
  // All of them will be changed to the standard 'shr & mul'.

  if n == 0 {
    return 0
  }

  var n = n
  var result = 0

  let pow10: UInt64 = 10_000_000_000
  var (q, r) = n.quotientAndRemainder(dividingBy: pow10)

  if r == 0 {
    result += 10
    n = q
  } else {
    n = r
  }

  assert(n <= pow10)
  let pow5: UInt64 = 100_000
  (q, r) = n.quotientAndRemainder(dividingBy: pow5)

  if r == 0 {
    result += 5
    n = q
  } else {
    n = r
  }

  assert(n <= pow5)
  let pow2: UInt64 = 100
  (q, r) = n.quotientAndRemainder(dividingBy: pow2)

  if r == 0 {
    //   100 / 100 =   1 rem 0
    //  1000 / 100 =  10 rem 0
    // 12300 / 100 = 123 rem 0
    result += 2
    n = q

    // If we have 3 digits then bring it down to 2 digits.
    if n >= 100 {
      assert(n < 1000)
      (q, r) = n.quotientAndRemainder(dividingBy: 10)

      if r != 0 {
        return result
      }

      result += 1
      n = q
    }
  } else {
    n = r
  }

  assert(n < pow2)
  result += (n != 0 && n.isMultiple(of: 10)) ? 1 : 0

  return result
}
