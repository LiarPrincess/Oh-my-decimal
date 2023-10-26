internal func sum<T: FixedWidthInteger>(
  _ x: T,
  _ y: T
) -> (high: T, low: T) {
  let (sum, overflow) = x.addingReportingOverflow(y)
  return (overflow ? 1 : 0, sum)
}

internal func sum<T: FixedWidthInteger>(
  _ x: T,
  _ y: T,
  _ z: T
) -> (high: T, low: T) {
  let s1 = sum(x, y)
  let s2 = sum(s1.low, z)
  return (s1.high &+ s2.high, s2.low)
}

internal func sum<T: FixedWidthInteger>(
  _ x0: T,
  _ x1: T,
  _ x2: T,
  _ x3: T
) -> (high: T, low: T) {
  let s1 = sum(x0, x1)
  let s2 = sum(x2, x3)
  let s = sum(s1.low, s2.low)
  return (s1.high &+ s2.high &+ s.high, s.low)
}
