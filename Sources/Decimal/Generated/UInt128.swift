// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

// swiftlint:disable all

// 'Decimal128.BitPattern = UInt128' is 'public'.
// But we do not want to export `UInt128` as a global name.
// Instead we will define 'UInt128' inside 'Decimal128' as 'Decimal128._UInt128'.

extension Decimal128 {
  /// Internal storage.
  /// DO NOT use as a general purpose `UInt128`!
  /// This is only for `Decimal128`.
  public struct _UInt128: Sendable {
    // Words from high bits (w0) to low bits (w1).
    // It is slower than `LLVM.UInt128`, but that would require `Builtins`.
    internal var w0: Word
    internal var w1: Word
  }
}

// Inside the module we want to use the normal name.
internal typealias UInt128 = Decimal128._UInt128

extension Decimal128._UInt128: Codable, FixedWidthInteger, UnsignedInteger, CustomStringConvertible {

  internal typealias Word = UInt64

  // MARK: - Static properties

  public static let bitWidth = 128

  // MARK: - Properties

  public var words: Words { Words(self) }

  internal var isZero: Bool {
    return self.w0 == 0 && self.w1 == 0
  }

  public var leadingZeroBitCount: Int {
    if self.w0 != 0 { return 0 * Word.bitWidth + self.w0.leadingZeroBitCount }
    return 1 * Word.bitWidth + self.w1.leadingZeroBitCount
  }

  public var trailingZeroBitCount: Int {
    if self.w1 != 0 { return 0 * Word.bitWidth + self.w1.trailingZeroBitCount }
    return 1 * Word.bitWidth + self.w0.trailingZeroBitCount
  }

  public var nonzeroBitCount: Int {
    return self.w0.nonzeroBitCount + self.w1.nonzeroBitCount
  }

  public var byteSwapped: Self {
    let w0 = self.w0.byteSwapped
    let w1 = self.w1.byteSwapped
    return Self(w0, w1)
  }

  public var description: String {
    let _0: UInt8 = 48
    var n = self
    var result = ""

    while !n.isZero {
      let (q, r) = n.quotientAndRemainder(dividingBy: 10 as Word)
      n = q

      let ascii = _0 + UInt8(r)
      let scalar = UnicodeScalar(ascii)
      let char = Character(scalar)
      result.append(char)
    }

    return result.isEmpty ? "0" : String(result.reversed())
  }

  // MARK: - Init

  public init() {
    self.w0 = 0
    self.w1 = 0
  }

  internal init(_ w0: Word, _ w1: Word) {
    self.w0 = w0
    self.w1 = w1
  }

  // MARK: - Init - Int

  public init<T: BinaryInteger>(_ source: T) {
    guard let result = Self(exactly: source) else {
      preconditionFailure("Value is outside the representable range")
    }

    self = result
  }

  public init?<T: BinaryInteger>(exactly source: T) {
    if source < (0 as T) {
      return nil
    }

    if let low = Word(exactly: source.magnitude) {
      self.w0 = 0
      self.w1 = low
    } else {
      var s = source
      let mask = T(Word.max)

      self.w1 = Word(s & mask)
      s >>= Word.bitWidth

      self.w0 = Word(s & mask)
      s >>= Word.bitWidth

      if s != (0 as T) {
        return nil
      }
    }
  }

  public init(integerLiteral value: IntegerLiteralType) {
    self = Self(value)
  }

  public init(_truncatingBits bits: UInt) {
    self.w0 = Word(_truncatingBits: bits >> (1 * Word.bitWidth))
    self.w1 = Word(_truncatingBits: bits >> (0 * Word.bitWidth))
  }

  // MARK: - Init - Float

  public init<T: BinaryFloatingPoint>(_ source: T) {
    preconditionFailure("UInt128(BinaryFloatingPoint) not implemented.")
  }

  public init?<T: BinaryFloatingPoint>(exactly source: T) {
    preconditionFailure("UInt128(exactly: BinaryFloatingPoint) not implemented.")
  }

  // MARK: - Add

  public static func + (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  public static func += (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  public func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let w1 = self.w1.addingReportingOverflow(rhs.w1)
    let carry1: Word = w1.overflow ? 1 : 0

    let partial0 = self.w0.addingReportingOverflow(rhs.w0)
    let w0 = partial0.partialValue.addingReportingOverflow(carry1)
    let carry0: Word = (partial0.overflow ? 1 : 0) + (w0.overflow ? 1 : 0)

    let result = Self(w0.partialValue, w1.partialValue)
    let overflow = carry0 != 0
    return (result, overflow)
  }

  // MARK: - Sub

  public static func - (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  public static func -= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  public func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let w1 = self.w1.subtractingReportingOverflow(rhs.w1)
    let borrow1: Word = w1.overflow ? 1 : 0

    let partial0 = self.w0.subtractingReportingOverflow(rhs.w0)
    let w0 = partial0.partialValue.subtractingReportingOverflow(borrow1)
    let borrow0: Word = (partial0.overflow ? 1 : 0) + (w0.overflow ? 1 : 0)

    let result = Self(w0.partialValue, w1.partialValue)
    let overflow = borrow0 != 0
    return (result, overflow)
  }

  // MARK: - Mul

  internal static func * (lhs: Self, rhs: UInt64) -> Self {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  internal static func *= (_ lhs: inout Self, _ rhs: UInt64) {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  internal func multipliedReportingOverflow(by rhs: UInt64) -> (partialValue: Self, overflow: Bool) {
    let mul01 = self.w0.multipliedFullWidth(by: rhs)
    let mul11 = self.w1.multipliedFullWidth(by: rhs)

    // Column 3
    let w3 = mul11.low
    let carry3: Word = 0

    // Column 2
    let (carry2, w2) = sum(
      carry3,
      mul11.high, // previous column (sum=2)
      mul01.low // this column (sum=1)
    )

    let overflow: Bool = carry2 != 0
      // Check 'high' in column 1
      || (mul01.high != 0)
      // Check not preformed multiplications

    let result = Self(w2, w3)
    return (result, overflow)
  }

  internal func multipliedFullWidth(by rhs: UInt64) -> (high: UInt64, low: Self) {
    let mul01 = self.w0.multipliedFullWidth(by: rhs)
    let mul11 = self.w1.multipliedFullWidth(by: rhs)

    // Column 3
    let w3 = mul11.low
    let carry3: Word = 0

    // Column 2
    let (carry2, w2) = sum(
      carry3,
      mul11.high, // previous column (sum=2)
      mul01.low // this column (sum=1)
    )

    // Column 1
    let (carry1, w1) = sum(
      carry2,
      mul01.high // previous column (sum=1)
    )

    assert(carry1 == 0)
    let high = UInt64(w1)
    let low = Self(w2, w3)
    return (high, low)
  }

  public static func * (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  public static func *= (_ lhs: inout Self, _ rhs: Self) {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  public func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let mul01 = self.w0.multipliedFullWidth(by: rhs.w1)
    let mul10 = self.w1.multipliedFullWidth(by: rhs.w0)
    let mul11 = self.w1.multipliedFullWidth(by: rhs.w1)

    // Column 3
    let w3 = mul11.low
    let carry3: Word = 0

    // Column 2
    let (carry2, w2) = sum(
      carry3,
      mul11.high, // previous column (sum=2)
      mul01.low, mul10.low // this column (sum=1)
    )

    let overflow: Bool = carry2 != 0
      // Check 'high' in column 1
      || (mul01.high != 0)
      || (mul10.high != 0)
      // Check not preformed multiplications
      || (self.w0 != 0 && rhs.w0 != 0)

    let result = Self(w2, w3)
    return (result, overflow)
  }

  public func multipliedFullWidth(by rhs: Self) -> (high: Self, low: Self) {
    let mul00 = self.w0.multipliedFullWidth(by: rhs.w0)
    let mul01 = self.w0.multipliedFullWidth(by: rhs.w1)
    let mul10 = self.w1.multipliedFullWidth(by: rhs.w0)
    let mul11 = self.w1.multipliedFullWidth(by: rhs.w1)

    // Column 3
    let w3 = mul11.low
    let carry3: Word = 0

    // Column 2
    let (carry2, w2) = sum(
      carry3,
      mul11.high, // previous column (sum=2)
      mul01.low, mul10.low // this column (sum=1)
    )

    // Column 1
    let (carry1, w1) = sum(
      carry2,
      mul01.high, mul10.high, // previous column (sum=1)
      mul00.low // this column (sum=0)
    )

    // Column 0
    let (carry0, w0) = sum(
      carry1,
      mul00.high // previous column (sum=0)
    )

    assert(carry0 == 0)
    let high = Self(w0, w1)
    let low = Self(w2, w3)
    return (high, low)
  }

  // MARK: - Div

  public static func / (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "Division by zero")
    return result
  }

  public static func /= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "Division by zero")
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
    precondition(!overflow, "Division by zero in remainder operation")
    return result
  }

  public static func %= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "Division by zero in remainder operation")
    lhs = result
  }

  public func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
    if rhs == Self.zero {
      return (self, true)
    }

    let qr = self.quotientAndRemainder(dividingBy: rhs)
    return (qr.remainder, false)
  }

  internal func quotientAndRemainder(dividingBy rhs: Word) -> (quotient: Self, remainder: Word) {
    let div0 = self.w0.quotientAndRemainder(dividingBy: rhs)

    let div1 = div0.remainder == 0 ?
      self.w1.quotientAndRemainder(dividingBy: rhs) :
      rhs.dividingFullWidth((div0.remainder, self.w1))

    let quotient = Self(div0.quotient, div1.quotient)
    return (quotient, div1.remainder)
  }

  public func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
    precondition(rhs != 0, "Division by zero")

    if self == rhs {
      return (1, 0)
    }

    if self < rhs {
      return (0, self)
    }

    // Rhs 1 word?
    if rhs.w0 == 0 {
      let rhsShort = UInt64(rhs.w1)
      let (q, r) = self.quotientAndRemainder(dividingBy: rhsShort)
      let remainder = Self(0, r)
      return (q, remainder)
    }

    // Edge case for the bit shifting below.
    if self.leadingZeroBitCount == rhs.leadingZeroBitCount {
      // Quotient is 1 and remainder is the difference:
      // - lhs > rhs
      // - both operands have non-0 high bits
      // - both have the same high power of 2, so quotient has to be 1
      let quotient = Self(0, 1)
      let remainder = self - rhs
      return (quotient, remainder)
    }

    // At this point we know that:
    // - lhs > rhs
    // - lhs it has 'more' bits
    // - both lhs and rhs have upper half filled -> full width division
    //
    // What follows is:
    // - "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler
    // - "The Art of Computer Programming vol 2" by Knuth -> 4.3.1 - Algorithm D
    let shift = rhs.leadingZeroBitCount
    let rhsShifted = rhs &<< shift

    let lhsHigh = (self &>> (Self.bitWidth &- shift))
    let lhsLow = self &<< shift

    let (q, r) = Self.divide3by2(
      lhsHigh.low, lhsLow.high, lhsLow.low,
      by: rhsShifted
    )

    let quotient = Self(high: 0, low: q)
    let remainder = r &>> shift
    return (quotient, remainder)
  }

  /// "Algorithm 2. (D3n/2n)" by Christoph Burnikel and Joachim Ziegler
  private static func divide3by2(
    _ a1: UInt64, _ a2: UInt64, _ a3: UInt64,
    by b: Self
  ) -> (quotient: UInt64, remainder: Self) {
    // Let A and B be nonnegative integers, and let A<βn*B and β2n/2 <= B < β2n.
    // Algorithm D3n/2n computes the quotient Q = [A/B] with remainder R = A-Q*B.
    // 1. Split A into three parts A = [A1;A2;A3] with Ai < βn.
    // 2. Split B into two   parts B = [B1;B2] with Bi < βn.
    // 3. Distinguish the cases A1 < B1 or A1 >= B1 .
    //   (a) If A1<B1, compute Q̂ = floor([A1;A2]/B1) with remainder R1 using
    //                 algorithm D2n/1n.
    //   (b) If A1>=B1, set Q̂ = βn-1
    //                  set R1 = [A1;A2] - [B1;0] + [0;B1] (=[A1,A2] - Q̂B1).
    // 4. Compute D = Q̂*B2 using Karatsuba multiplication.
    // 5. Compute R̂ = R1*βn + A4 - D.
    // 6. As long as R̂ < 0, repeat // Same as R1*βn + A4 < D.
    //   (a) R̂ = R̂ + B
    //   (b) Q̂ = Q̂ - 1
    // 7. Return Q̂, R̂
    //
    // (…)
    //
    // We conclude that the body of the loop in step 6 of algorithm D3n/2n is
    // processed at most twice.

    assert(b.leadingZeroBitCount == 0)
    let b1 = b.high

    // We do not need R1.
    // We will calculate 'R̂' differently, see details below.
    var qHat = a1 < b1 ?
      b1.dividingFullWidth((a1, a2)).quotient :
      UInt64.max

    // The method in the paper gives incorrect reminder?
    // They want 'D = Q̂*B2'.
    // We will use 'D = Q̂*B' and compare with original value 'A'.
    let d = b.multipliedFullWidth(by: qHat)
    let D = UInt192(d.high, d.low)
    // This is basically the original value of 'A'
    // We will do the '-D' part later.
    var rHat = UInt192(a1, a2, a3)
    let bWide = UInt192(0, b)

    // Statement about the double iteration holds true even if 'D = Q̂*B'
    // (and not 'D = Q̂*B1'), because the iteration count depends on the quotient
    // approximation and not on the exact value of 'D'.
    while rHat < D {
      rHat += bWide
      qHat &-= 1
    }

    rHat -= D
    assert(rHat.w0 == 0)
    let r = Self(high: rHat.w1, low: rHat.w2)
    return (qHat, r)
  }

  public func dividingFullWidth(
    _ lhs: (high: Self, low: Self)
  ) -> (quotient: Self, remainder: Self) {
    let rhs = self
    precondition(rhs != 0, "Division by zero")
    precondition(rhs >= lhs.high, "Division results in an overflow")

    // lhs = UInt128?
    if lhs.high == 0 {
      return lhs.low.quotientAndRemainder(dividingBy: rhs)
    }

    let lhs = UInt256(high: lhs.high, low: lhs.low)

    // rhs = Word?
    if rhs.high == 0 {
      // School method: abcd / r
      let r = rhs.low
      let a = lhs.w0 % r

      let b = a == 0 ?
        lhs.w1 % r :
        r.dividingFullWidth((a, lhs.w1)).remainder

      let (x, c) = b == 0 ?
        lhs.w2.quotientAndRemainder(dividingBy: r) :
        r.dividingFullWidth((b, lhs.w2))

      let (y, d) = c == 0 ?
        lhs.w3.quotientAndRemainder(dividingBy: r) :
        r.dividingFullWidth((c, lhs.w3))

      let quotient = Self(high: x, low: y)
      let remainder = Self(high: 0, low: d)
      return (quotient, remainder)
    }

    // Left shift both rhs and lhs, then divide and right shift the remainder.
    // Similar to Knuth Algorithm D.
    let shift = rhs.leadingZeroBitCount
    let lhsShifted = lhs &<< shift
    let rhsShifted = rhs &<< shift

    if lhsShifted.w0 == 0 && Self(high: lhsShifted.w1, low: lhsShifted.w2) < rhsShifted {
      let (q, r) = Self.divide3by2(
        lhsShifted.w1, lhsShifted.w2, lhsShifted.w3,
        by: rhsShifted
      )

      let quotient = Self(high: 0, low: q)
      let remainder = r &>> shift
      return (quotient, remainder)
    }

    let (q1, r1) = Self.divide3by2(
      lhsShifted.w0, lhsShifted.w1, lhsShifted.w2,
      by: rhsShifted
    )

    let (q2, r2) = Self.divide3by2(
      r1.high, r1.low, lhsShifted.w3,
      by: rhsShifted
    )

    let quotient = Self(q1, q2)
    let remainder = r2 &>> shift
    return (quotient, remainder)
  }

  // MARK: - Bit operations

  public static prefix func ~ (n: Self) -> Self {
    let w0 = ~n.w0
    let w1 = ~n.w1
    return Self(w0, w1)
  }

  public static func &= (lhs: inout Self, rhs: Self) {
    lhs.w0 &= rhs.w0
    lhs.w1 &= rhs.w1
  }

  public static func |= (lhs: inout Self, rhs: Self) {
    lhs.w0 |= rhs.w0
    lhs.w1 |= rhs.w1
  }

  public static func ^= (lhs: inout Self, rhs: Self) {
    lhs.w0 ^= rhs.w0
    lhs.w1 ^= rhs.w1
  }

  // MARK: - Shifts

  public static func &<<= (lhs: inout Self, rhs: Self) {
    let rhs = Self.applyShiftMask(rhs)
    let word = Word(Word.bitWidth)

    if rhs == 0 {
      // Nothing to do here.
    } else if rhs < 1 &* word {
      let left = rhs &- (0 &* word)
      let right = word &- left
      lhs.w0 = lhs.w0 &<< left
      lhs.w0 |= lhs.w1 &>> right
      lhs.w1 = lhs.w1 &<< left
    } else if rhs == 1 &* word {
      lhs.w0 = lhs.w1
      lhs.w1 = 0
    } else if rhs < 2 &* word {
      let left = rhs &- (1 &* word)
      lhs.w0 = lhs.w1 &<< left
      lhs.w1 = 0
    } else if rhs == 2 &* word {
      lhs.w0 = 0
      lhs.w1 = 0
    }
  }

  public static func &>>= (lhs: inout Self, rhs: Self) {
    let rhs = Self.applyShiftMask(rhs)
    let word = Word(Word.bitWidth)

    if rhs == 0 {
      // Nothing to do here.
    } else if rhs < 1 &* word {
      let right = rhs &- (0 &* word)
      let left = word &- right
      lhs.w1 = lhs.w1 &>> right
      lhs.w1 |= lhs.w0 &<< left
      lhs.w0 = lhs.w0 &>> right
    } else if rhs == 1 &* word {
      lhs.w1 = lhs.w0
      lhs.w0 = 0
    } else if rhs < 2 &* word {
      let right = rhs &- (1 &* word)
      lhs.w1 = lhs.w0 &>> right
      lhs.w0 = 0
    } else if rhs == 2 &* word {
      lhs.w1 = 0
      lhs.w0 = 0
    }
  }

  /// Calculates the result of shifting a value’s binary representation the
  /// specified number of digits in direction, MASKING THE SHIFT AMOUNT TO
  /// THE TYPE’S BIT WIDTH, and stores the result in the left-hand-side variable.
  private static func applyShiftMask(_ n: Self) -> Word {
    let mask = Word(truncatingIfNeeded: Self.bitWidth &- 1)
    return n.w1 & mask
  }

  // MARK: - Equal, compare

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.w0 == rhs.w0 && lhs.w1 == rhs.w1
  }

  public static func < (lhs: Self, rhs: Self) -> Bool {
    if lhs.w0 < rhs.w0 { return true }

    if lhs.w0 != rhs.w0 { return false }
    return lhs.w1 < rhs.w1
  }

  // MARK: - Words

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
      let shifted = self.value &>> shift
      return UInt(truncatingIfNeeded: shifted.w1)
    }

    public func index(after i: Index) -> Index { i + 1 }
    public func index(before i: Index) -> Index { i - 1 }
  }
}

// MARK: - Div helper - UInt192

/// Unsigned Int that is used during division.
private struct UInt192 {

  fileprivate typealias Word = UInt64

  fileprivate let w0: Word
  fileprivate let w1: Word
  fileprivate let w2: Word

  fileprivate init(_ w0: Word, _ wide: UInt128) {
    self.w0 = w0
    self.w1 = Word(wide.w0)
    self.w2 = Word(wide.w1)
  }

  fileprivate init(_ w0: Word, _ w1: Word, _ w2: Word) {
    self.w0 = w0
    self.w1 = w1
    self.w2 = w2
  }

  fileprivate static func + (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  fileprivate static func += (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  fileprivate func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let w2 = self.w2.addingReportingOverflow(rhs.w2)
    let carry2: Word = w2.overflow ? 1 : 0

    let partial1 = self.w1.addingReportingOverflow(rhs.w1)
    let w1 = partial1.partialValue.addingReportingOverflow(carry2)
    let carry1: Word = (partial1.overflow ? 1 : 0) + (w1.overflow ? 1 : 0)

    let partial0 = self.w0.addingReportingOverflow(rhs.w0)
    let w0 = partial0.partialValue.addingReportingOverflow(carry1)
    let carry0: Word = (partial0.overflow ? 1 : 0) + (w0.overflow ? 1 : 0)

    let result = Self(w0.partialValue, w1.partialValue, w2.partialValue)
    let overflow = carry0 != 0
    return (result, overflow)
  }

  fileprivate static func - (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  fileprivate static func -= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  fileprivate func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let w2 = self.w2.subtractingReportingOverflow(rhs.w2)
    let borrow2: Word = w2.overflow ? 1 : 0

    let partial1 = self.w1.subtractingReportingOverflow(rhs.w1)
    let w1 = partial1.partialValue.subtractingReportingOverflow(borrow2)
    let borrow1: Word = (partial1.overflow ? 1 : 0) + (w1.overflow ? 1 : 0)

    let partial0 = self.w0.subtractingReportingOverflow(rhs.w0)
    let w0 = partial0.partialValue.subtractingReportingOverflow(borrow1)
    let borrow0: Word = (partial0.overflow ? 1 : 0) + (w0.overflow ? 1 : 0)

    let result = Self(w0.partialValue, w1.partialValue, w2.partialValue)
    let overflow = borrow0 != 0
    return (result, overflow)
  }

  fileprivate static func < (lhs: Self, rhs: Self) -> Bool {
    if lhs.w0 < rhs.w0 { return true }

    if lhs.w0 != rhs.w0 { return false }
    if lhs.w1 < rhs.w1 { return true }

    if lhs.w1 != rhs.w1 { return false }
    return lhs.w2 < rhs.w2
  }
}
