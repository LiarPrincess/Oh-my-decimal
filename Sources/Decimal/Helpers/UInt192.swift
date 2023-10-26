/// Not a full type. Just the parts that we need.
internal struct UInt192: Equatable, Comparable {

  internal typealias Word = UInt64

  internal let high: Word
  internal let mid: Word
  internal let low: Word

  internal init(high: Word, mid: Word, low: Word) {
    self.high = high
    self.mid = mid
    self.low = low
  }

  internal static func + (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "UInt192.+ overflow.")
    return result
  }

  internal static func += (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "UInt192.+= overflow.")
    lhs = result
  }

  internal static func += (lhs: inout Self, rhs: UInt128) {
    let rhs192 = UInt192(high: 0, mid: rhs.high, low: rhs.low)
    let (result, overflow) = lhs.addingReportingOverflow(rhs192)
    precondition(!overflow, "UInt192.+= overflow.")
    lhs = result
  }

  internal func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let lowAdd = self.low.addingReportingOverflow(rhs.low)
    let midAdd = self.mid.addingReportingOverflow(rhs.mid)
    let highAdd = self.high.addingReportingOverflow(rhs.high)

    let midCarry: Word = lowAdd.overflow ? 1 : 0
    let mid = midAdd.partialValue.addingReportingOverflow(midCarry)

    let highCarry: Word = (midAdd.overflow ? 1 : 0) + (mid.overflow ? 1 : 0)
    let high = highAdd.partialValue.addingReportingOverflow(highCarry)

    let result = Self(high: high.partialValue, mid: mid.partialValue, low: lowAdd.partialValue)
    let overflow = highAdd.overflow || high.overflow
    return (partialValue: result, overflow: overflow)
  }

  internal static func - (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "UInt192.- overflow.")
    return result
  }

  internal static func -= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "UInt192.-= overflow.")
    lhs = result
  }

  internal func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let lowSub = self.low.subtractingReportingOverflow(rhs.low)
    let midSub = self.mid.subtractingReportingOverflow(rhs.mid)
    let highSub = self.high.subtractingReportingOverflow(rhs.high)

    let midBorrow: Word = lowSub.overflow ? 1 : 0
    let mid = midSub.partialValue.subtractingReportingOverflow(midBorrow)

    let highBorrow: Word = (midSub.overflow ? 1 : 0) + (mid.overflow ? 1 : 0)
    let high = highSub.partialValue.subtractingReportingOverflow(highBorrow)

    let result = Self(high: high.partialValue, mid: mid.partialValue, low: lowSub.partialValue)
    let overflow = highSub.overflow || high.overflow
    return (partialValue: result, overflow: overflow)
  }

  internal static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.high == rhs.high && lhs.mid == rhs.mid && lhs.low == rhs.low
  }

  internal static func < (lhs: Self, rhs: Self) -> Bool {
    return lhs.high < rhs.high
      || (
        lhs.high == rhs.high
        && (lhs.mid < rhs.mid || (lhs.mid == rhs.mid && lhs.low < rhs.low))
      )
  }
}
