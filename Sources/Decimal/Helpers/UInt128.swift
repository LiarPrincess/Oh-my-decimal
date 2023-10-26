import Cbid

// swiftlint:disable nesting
// swiftlint:disable unavailable_function
// swiftlint:disable file_length

// Following parts were taken from Swift numerics -> DoubleWidth:
// - multipliedFullWidth
// - quotientAndRemainder
// - dividingFullWidth

internal typealias UInt128 = BID_UINT128

extension Int {
  public init?(exactly value: BID_UINT128) {
    guard value.high == 0, let result = Int(exactly: value.low) else {
      return nil
    }

    self = result
  }
}

extension UInt {
  public init?(exactly value: BID_UINT128) {
    guard value.high == 0, let result = UInt(exactly: value.low) else {
      return nil
    }

    self = result
  }
}

// Little endian:
// #define BID_HIGH_128W 1
// #define BID_LOW_128W  0
private let isLittleEndian = true

extension BID_UINT128: Codable, FixedWidthInteger, UnsignedInteger {

  internal typealias Word = UInt64

  public static let bitWidth = 128

  internal var high: Word {
    get { assert(isLittleEndian); return self.w.1 }
    set { assert(isLittleEndian); self.w.1 = newValue }
  }

  internal var low: Word {
    get { assert(isLittleEndian); return self.w.0 }
    set { assert(isLittleEndian); self.w.0 = newValue }
  }

  public var words: Words { Words(self) }

  public var byteSwapped: Self {
    let high = Word(truncatingIfNeeded: self.high.byteSwapped)
    let low = Word(truncatingIfNeeded: self.low.byteSwapped)
    return Self(high: high, low: low)
  }

  public var nonzeroBitCount: Int {
    return self.high.nonzeroBitCount + self.low.nonzeroBitCount
  }

  public var leadingZeroBitCount: Int {
    return self.high == 0 ?
      Word.bitWidth + self.low.leadingZeroBitCount :
      self.high.leadingZeroBitCount
  }

  public var trailingZeroBitCount: Int {
    return self.low == 0 ?
      Word.bitWidth + self.high.trailingZeroBitCount :
      self.low.trailingZeroBitCount
  }

  internal init(high: Word, low: Word) {
    // If we used init(w: (UInt64, UInt64) then we would have to use the correct
    // endian! It is a bit easier to just use property setters.
    assert(isLittleEndian)
    self = Self()
    self.high = high
    self.low = low
  }

  public init<T: BinaryInteger>(_ source: T) {
    guard let result = Self(exactly: source) else {
      preconditionFailure("Value is outside the representable range")
    }

    self = result
  }

  public init?<T: BinaryInteger>(exactly source: T) {
    if source < 0 {
      return nil
    }

    if let low = Word(exactly: source.magnitude) {
      self = Self(high: 0, low: low)
      return
    }

    // At this point we know source.bitWidth > Word.bitWidth,
    // or else we would've taken the first branch.
    let lowT = source & T(Word.max)
    let highT = source >> Word.bitWidth

    let low = Word(lowT)
    guard let high = Word(exactly: highT) else {
      return nil
    }

    self = Self(high: high, low: low)
  }

  public init(integerLiteral value: IntegerLiteralType) {
    self = Self(value)
  }

  public init(_truncatingBits bits: UInt) {
    let low = Word(_truncatingBits: bits)
    let high = Word(_truncatingBits: bits >> Word.bitWidth)
    self = Self(high: high, low: low)
  }

  public init<T: BinaryFloatingPoint>(_ source: T) {
    preconditionFailure("UInt128(BinaryFloatingPoint) not implemented.")
  }

  public init?<T: BinaryFloatingPoint>(exactly source: T) {
    preconditionFailure("UInt128(exactly: BinaryFloatingPoint) not implemented.")
  }

  public static func + (_ lhs: Self, _ rhs: Self) -> Self {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "UInt128.+ overflow.")
    return result
  }

  public func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let lowAdd = self.low.addingReportingOverflow(rhs.low)
    let highAdd = self.high.addingReportingOverflow(rhs.high)

    let highCarry: Word = lowAdd.overflow ? 1 : 0
    let high = highAdd.partialValue.addingReportingOverflow(highCarry)

    let result = Self(high: high.partialValue, low: lowAdd.partialValue)
    let overflow = highAdd.overflow || high.overflow
    return (partialValue: result, overflow: overflow)
  }

  public static func - (_ lhs: Self, _ rhs: Self) -> Self {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "UInt128.- overflow.")
    return result
  }

  public func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let lowSub = self.low.subtractingReportingOverflow(rhs.low)
    let highSub = self.high.subtractingReportingOverflow(rhs.high)

    let highBorrow: Word = lowSub.overflow ? 1 : 0
    let high = highSub.partialValue.subtractingReportingOverflow(highBorrow)

    let result = Self(high: high.partialValue, low: lowSub.partialValue)
    let overflow = highSub.overflow || high.overflow
    return (partialValue: result, overflow: overflow)
  }

  public static func * (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "UInt128.* overflow.")
    return result
  }

  public static func *= (_ lhs: inout Self, _ rhs: Self) {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "UInt128.*= overflow.")
    lhs = result
  }

  public func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
    //     h  l
    //  *  h  l <- self
    // --------
    //    lh ll
    // hh hl    <- 'hh' is overflow and does not matter

    let ll = self.low.multipliedFullWidth(by: rhs.low)
    let lh = self.low.multipliedReportingOverflow(by: rhs.high)
    let hl = self.high.multipliedReportingOverflow(by: rhs.low)

    let high1 = ll.high.addingReportingOverflow(lh.partialValue)
    let high2 = high1.partialValue.addingReportingOverflow(hl.partialValue)

    let result = Self(high: high2.partialValue, low: ll.low)
    let hasAdditionalWord = self.high != 0 && rhs.high != 0
    let overflow = lh.overflow || hl.overflow || high1.overflow || high2.overflow

    return (result, hasAdditionalWord || overflow)
  }

  internal func multipliedFullWidth(by other: Word) -> UInt192 {
    let lowMul = self.low.multipliedFullWidth(by: other)
    let highMul = self.high.multipliedFullWidth(by: other)

    let low = lowMul.low
    let (mid, midOverflow) = lowMul.high.addingReportingOverflow(highMul.low)
    let high = highMul.high &+ (midOverflow ? 1 : 0)

    return UInt192(high: high, mid: mid, low: low)
  }

  public func multipliedFullWidth(by other: Self) -> (high: Self, low: Self) {
    //     h  l
    //  *  h  l <- self
    // --------
    //    lh ll
    // hh hl
    // --------
    //         | lh.high        | lh.low+ll.high | ll.low
    // hh.high | hh.low+hl.high | hl.low
    let ll = self.low.multipliedFullWidth(by: other.low)
    let lh = self.low.multipliedFullWidth(by: other.high)
    let hl = self.high.multipliedFullWidth(by: other.low)
    let hh = self.high.multipliedFullWidth(by: other.high)

    let mid1 = sum(lh.low, ll.high, hl.low)
    let mid2 = sum(lh.high, hh.low, hl.high, mid1.high)

    // Note: this addition will never wrap
    let high = UInt128(high: Word(hh.high &+ mid2.high), low: mid2.low )
    let low = UInt128(high: mid1.low, low: ll.low)
    return (high, low)
  }

  public static func / (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "UInt128./ overflow.")
    return result
  }

  public static func /= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "UInt128./= overflow.")
    lhs = result
  }

  public func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
    if rhs == Self.zero {
      return (self, true)
    }

    let qr = self.quotientAndRemainder(dividingBy: rhs)
    return (qr.quotient, false)
  }

  public static func % (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "UInt128.% overflow.")
    return result
  }

  public static func %= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "UInt128.%= overflow.")
    lhs = result
  }

  public func remainderReportingOverflow(
    dividingBy rhs: Self
  ) -> (partialValue: Self, overflow: Bool) {
    if rhs == Self.zero {
      return (self, true)
    }

    let qr = self.quotientAndRemainder(dividingBy: rhs)
    return (qr.remainder, false)
  }

  public func quotientAndRemainder(
    dividingBy rhs: Self
  ) -> (quotient: Self, remainder: Self) {
    precondition(rhs != 0, "Division by zero")

    if self == rhs {
      return (1, 0)
    }

    if self < rhs {
      return (0, self)
    }

    if self.high == 0 {
      let (quotient, remainder) = self.low.quotientAndRemainder(dividingBy: rhs.low)
      return (Self(quotient), Self(remainder))
    }

    if rhs.high == 0 {
      let highDiv = self.high.quotientAndRemainder(dividingBy: rhs.low)
      let lowDiv = rhs.low.dividingFullWidth((highDiv.remainder, self.low))

      let quotient = Self(high: highDiv.quotient, low: lowDiv.quotient)
      let remainder = Self(high: 0, low: lowDiv.remainder)
      return (quotient, remainder)
    }

    // Left shift both rhs and lhs, then divide and right shift the remainder.
    let shift = rhs.leadingZeroBitCount
    let rhsShifted = rhs &<< shift

    let lhsHigh = (self &>> (Self.bitWidth &- shift)).low
    let lhsLow = self &<< shift
    let lhsShifted = UInt192(high: lhsHigh, mid: lhsLow.high, low: lhsLow.low)

    let qr = Self._divide(lhsShifted, by: rhsShifted)
    let quotient = Self(high: 0, low: qr.quotient)
    let remainder = qr.remainder &>> shift
    return (quotient, remainder)
  }

  public func dividingFullWidth(
    _ dividend: (high: Self, low: Self)
  ) -> (quotient: Self, remainder: Self) {
    // let lhs = dividend
    // let rhs = self

    // precondition(rhs != 0, "Division by zero")
    // precondition(rhs >= lhs.high, "Division results in an overflow")

    // if lhs.high == 0 {
    //   return lhs.low.quotientAndRemainder(dividingBy: rhs)
    // }

    // if rhs.high == 0 {
    //   // School method: abcd / low
    //   let low = rhs.low
    //   let a = lhs.high.high % low

    //   let b = a == 0 ?
    //     lhs.high.low % low :
    //     low.dividingFullWidth((a, lhs.high.low)).remainder

    //   let (x, c) = b == 0 ?
    //     lhs.low.high.quotientAndRemainder(dividingBy: low) :
    //     low.dividingFullWidth((b, lhs.low.high))

    //   let (y, d) = c == 0 ?
    //     lhs.low.low.quotientAndRemainder(dividingBy: low) :
    //     low.dividingFullWidth((c, lhs.low.low))

    //   let quotient = Self(high: x, low: y)
    //   let remainder = Self(high: 0, low: d)
    //   return (quotient, remainder)
    // }

    // // Left shift both rhs and lhs, then divide and right shift the remainder.
    // // Similar to Knuth Algorithm D.
    // let shift = rhs.leadingZeroBitCount
    // let rhsShifted = rhs &<< shift
    // let lhsShifted: DoubleWidth = lhs &<< shift

    // if lhsShifted.high.high == 0 && Self(lhsShifted.high.low, lhsShifted.low.high) < rhsShifted {
    //   let (quotient, remainder) = Self._divide(
    //     (lhsShifted.high.low, lhsShifted.low.high, lhsShifted.low.low),
    //     by: rhsShifted
    //   )
    //   return (Self(0, quotient), remainder &>> shift)
    // }

    // let (x, a) = Self._divide(
    //   (lhsShifted.high.high, lhsShifted.high.low, lhsShifted.low.high),
    //   by: rhsShifted
    // )
    // let (y, b) = Self._divide((a.high, a.low, lhsShifted.low.low), by: rhsShifted)
    // return (Self(x, y), b &>> shift)
    preconditionFailure("UInt128.dividingFullWidth not implemented!")
  }

  private static func _divide(
    _ lhs: UInt192,
    by rhs: UInt128
  ) -> (quotient: Word, remainder: UInt128) {
    // The following invariants are guaranteed to hold by UInt128.dividingFullWidth
    // or UInt128.quotientAndRemainder before this method is invoked:
    precondition(lhs.high != 0)
    precondition(rhs.leadingZeroBitCount == 0)
    precondition(Self(high: lhs.high, low: lhs.mid) < rhs)

    // Estimate the quotient.
    var quotient = lhs.high == rhs.high ?
      Word.max :
      rhs.high.dividingFullWidth((lhs.high, lhs.mid)).quotient

    let product = rhs.multipliedFullWidth(by: quotient)
    var remainder = UInt192(high: lhs.high, mid: lhs.mid, low: lhs.low)

    // Adjust quotient estimation based on product.
    while remainder < product {
      quotient = quotient &- 1
      remainder += rhs
    }

    remainder -= product
    assert(remainder.high == 0)
    return (quotient, Self(high: remainder.mid, low: remainder.low))
  }

  public static prefix func ~ (n: Self) -> Self {
    return Self(high: ~n.high, low: ~n.low)
  }

  public static func &= (lhs: inout Self, rhs: Self) {
    lhs.high &= rhs.high
    lhs.low &= rhs.low
  }

  public static func |= (lhs: inout Self, rhs: Self) {
    lhs.high |= rhs.high
    lhs.low |= rhs.low
  }

  public static func ^= (lhs: inout Self, rhs: Self) {
    lhs.high ^= rhs.high
    lhs.low ^= rhs.low
  }

  private static let shiftMask = Self(high: 0, low: Word(Self.bitWidth) - 1)

  public static func &<<= (lhs: inout Self, rhs: Self) {
    let rhs = (rhs & Self.shiftMask).low
    let wordWidth = Word(Word.bitWidth)

    if rhs >= wordWidth {
      lhs.high = lhs.low &<< (rhs &- wordWidth)
      lhs.low = 0
    } else if rhs != 0 {
      lhs.high &<<= rhs
      lhs.high |= lhs.low &>> (wordWidth &- rhs)
      lhs.low &<<= rhs
    }
  }

  public static func &>>= (lhs: inout Self, rhs: Self) {
    let rhs = (rhs & Self.shiftMask).low
    let wordWidth = Word(Word.bitWidth)

    if rhs >= wordWidth {
      lhs.low = lhs.high &>> (rhs &- wordWidth)
      lhs.high = 0
    } else if rhs != 0 {
      lhs.low &>>= rhs
      lhs.low |= lhs.high &<< (wordWidth &- rhs)
      lhs.high &>>= rhs
    }
  }

  public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
    return lhs.high == rhs.high && lhs.low == rhs.low
  }

  public static func < (_ lhs: Self, _ rhs: Self) -> Bool {
    return lhs.high < rhs.high || (lhs.high == rhs.high && lhs.low < rhs.low)
  }

  // TODO: [UInt128.Codable] Remove manual Codable once we go to full Swift

  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(self.high)
    try container.encode(self.low)
  }

  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    let high = try container.decode(UInt64.self)
    let low = try container.decode(UInt64.self)
    self = Self(high: high, low: low)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.high)
    hasher.combine(self.low)
  }

  public struct Words: RandomAccessCollection {
    public typealias Element = UInt
    public typealias Index = Int

    public var count: Int { UInt128.bitWidth / UInt.bitWidth }
    public var startIndex: Index { 0 }
    public var endIndex: Index { count }

    internal var value: UInt128

    fileprivate init(_ value: UInt128) {
      self.value = value
    }

    public subscript(position: Index) -> UInt {
      precondition(
        0 <= position && position < self.endIndex,
        "Word index out of range"
      )

      let shift = position * UInt.bitWidth
      let shifted = self.value >> shift
      return UInt(truncatingIfNeeded: shifted.low)
    }

    public func index(after i: Index) -> Index { i + 1 }
    public func index(before i: Index) -> Index { i - 1 }
  }
}
