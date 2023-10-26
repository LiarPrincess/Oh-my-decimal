// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

// swiftlint:disable all

/// You know what this is, don't make me say it…
internal struct UInt256: Codable, FixedWidthInteger, UnsignedInteger, CustomStringConvertible {

  internal typealias Word = UInt64

  // MARK: - Static properties

  internal static let bitWidth = 256

  // MARK: - Properties

  // Words from high bits (w0) to low bits (w3).
  internal var w0: Word
  internal var w1: Word
  internal var w2: Word
  internal var w3: Word

  internal var words: Words { Words(self) }

  internal var isZero: Bool {
    return self.w0 == 0 && self.w1 == 0 && self.w2 == 0 && self.w3 == 0
  }

  internal var leadingZeroBitCount: Int {
    if self.w0 != 0 { return 0 * Word.bitWidth + self.w0.leadingZeroBitCount }
    if self.w1 != 0 { return 1 * Word.bitWidth + self.w1.leadingZeroBitCount }
    if self.w2 != 0 { return 2 * Word.bitWidth + self.w2.leadingZeroBitCount }
    return 3 * Word.bitWidth + self.w3.leadingZeroBitCount
  }

  internal var trailingZeroBitCount: Int {
    if self.w3 != 0 { return 0 * Word.bitWidth + self.w3.trailingZeroBitCount }
    if self.w2 != 0 { return 1 * Word.bitWidth + self.w2.trailingZeroBitCount }
    if self.w1 != 0 { return 2 * Word.bitWidth + self.w1.trailingZeroBitCount }
    return 3 * Word.bitWidth + self.w0.trailingZeroBitCount
  }

  internal var nonzeroBitCount: Int {
    return self.w0.nonzeroBitCount + self.w1.nonzeroBitCount + self.w2.nonzeroBitCount + self.w3.nonzeroBitCount
  }

  internal var byteSwapped: Self {
    let w0 = self.w0.byteSwapped
    let w1 = self.w1.byteSwapped
    let w2 = self.w2.byteSwapped
    let w3 = self.w3.byteSwapped
    return Self(w0, w1, w2, w3)
  }

  internal var description: String {
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

  internal init() {
    self.w0 = 0
    self.w1 = 0
    self.w2 = 0
    self.w3 = 0
  }

  internal init(_ w0: Word, _ w1: Word, _ w2: Word, _ w3: Word) {
    self.w0 = w0
    self.w1 = w1
    self.w2 = w2
    self.w3 = w3
  }

  // MARK: - Init - Int

  internal init<T: BinaryInteger>(_ source: T) {
    guard let result = Self(exactly: source) else {
      preconditionFailure("Value is outside the representable range")
    }

    self = result
  }

  internal init?<T: BinaryInteger>(exactly source: T) {
    if source < (0 as T) {
      return nil
    }

    if let low = Word(exactly: source.magnitude) {
      self.w0 = 0
      self.w1 = 0
      self.w2 = 0
      self.w3 = low
    } else {
      var s = source
      let mask = T(Word.max)

      self.w3 = Word(s & mask)
      s >>= Word.bitWidth

      self.w2 = Word(s & mask)
      s >>= Word.bitWidth

      self.w1 = Word(s & mask)
      s >>= Word.bitWidth

      self.w0 = Word(s & mask)
      s >>= Word.bitWidth

      if s != (0 as T) {
        return nil
      }
    }
  }

  internal init(integerLiteral value: IntegerLiteralType) {
    self = Self(value)
  }

  internal init(_truncatingBits bits: UInt) {
    self.w0 = Word(_truncatingBits: bits >> (3 * Word.bitWidth))
    self.w1 = Word(_truncatingBits: bits >> (2 * Word.bitWidth))
    self.w2 = Word(_truncatingBits: bits >> (1 * Word.bitWidth))
    self.w3 = Word(_truncatingBits: bits >> (0 * Word.bitWidth))
  }

  // MARK: - Init - Float

  internal init<T: BinaryFloatingPoint>(_ source: T) {
    preconditionFailure("UInt256(BinaryFloatingPoint) not implemented.")
  }

  internal init?<T: BinaryFloatingPoint>(exactly source: T) {
    preconditionFailure("UInt256(exactly: BinaryFloatingPoint) not implemented.")
  }

  // MARK: - Add

  internal static func + (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  internal static func += (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  internal func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let w3 = self.w3.addingReportingOverflow(rhs.w3)
    let carry3: Word = w3.overflow ? 1 : 0

    let partial2 = self.w2.addingReportingOverflow(rhs.w2)
    let w2 = partial2.partialValue.addingReportingOverflow(carry3)
    let carry2: Word = (partial2.overflow ? 1 : 0) + (w2.overflow ? 1 : 0)

    let partial1 = self.w1.addingReportingOverflow(rhs.w1)
    let w1 = partial1.partialValue.addingReportingOverflow(carry2)
    let carry1: Word = (partial1.overflow ? 1 : 0) + (w1.overflow ? 1 : 0)

    let partial0 = self.w0.addingReportingOverflow(rhs.w0)
    let w0 = partial0.partialValue.addingReportingOverflow(carry1)
    let carry0: Word = (partial0.overflow ? 1 : 0) + (w0.overflow ? 1 : 0)

    let result = Self(w0.partialValue, w1.partialValue, w2.partialValue, w3.partialValue)
    let overflow = carry0 != 0
    return (result, overflow)
  }

  // MARK: - Sub

  internal static func - (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  internal static func -= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  internal func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let w3 = self.w3.subtractingReportingOverflow(rhs.w3)
    let borrow3: Word = w3.overflow ? 1 : 0

    let partial2 = self.w2.subtractingReportingOverflow(rhs.w2)
    let w2 = partial2.partialValue.subtractingReportingOverflow(borrow3)
    let borrow2: Word = (partial2.overflow ? 1 : 0) + (w2.overflow ? 1 : 0)

    let partial1 = self.w1.subtractingReportingOverflow(rhs.w1)
    let w1 = partial1.partialValue.subtractingReportingOverflow(borrow2)
    let borrow1: Word = (partial1.overflow ? 1 : 0) + (w1.overflow ? 1 : 0)

    let partial0 = self.w0.subtractingReportingOverflow(rhs.w0)
    let w0 = partial0.partialValue.subtractingReportingOverflow(borrow1)
    let borrow0: Word = (partial0.overflow ? 1 : 0) + (w0.overflow ? 1 : 0)

    let result = Self(w0.partialValue, w1.partialValue, w2.partialValue, w3.partialValue)
    let overflow = borrow0 != 0
    return (result, overflow)
  }

  // MARK: - Mul

  internal static func * (lhs: Self, rhs: UInt128) -> Self {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  internal static func *= (_ lhs: inout Self, _ rhs: UInt128) {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  internal func multipliedReportingOverflow(by rhs: UInt128) -> (partialValue: Self, overflow: Bool) {
    let mul03 = self.w0.multipliedFullWidth(by: rhs.w1)
    let mul12 = self.w1.multipliedFullWidth(by: rhs.w0)
    let mul13 = self.w1.multipliedFullWidth(by: rhs.w1)
    let mul22 = self.w2.multipliedFullWidth(by: rhs.w0)
    let mul23 = self.w2.multipliedFullWidth(by: rhs.w1)
    let mul32 = self.w3.multipliedFullWidth(by: rhs.w0)
    let mul33 = self.w3.multipliedFullWidth(by: rhs.w1)

    // Column 7
    let w7 = mul33.low
    let carry7: Word = 0

    // Column 6
    let (carry6, w6) = sum(
      carry7,
      mul33.high, // previous column (sum=6)
      mul23.low, mul32.low // this column (sum=5)
    )

    // Column 5
    let (carry5, w5) = sum(
      carry6,
      mul23.high, mul32.high, // previous column (sum=5)
      mul13.low, mul22.low // this column (sum=4)
    )

    // Column 4
    let (carry4, w4) = sum(
      carry5,
      mul13.high, mul22.high, // previous column (sum=4)
      mul03.low, mul12.low // this column (sum=3)
    )

    let overflow: Bool = carry4 != 0
      // Check 'high' in column 3
      || (mul03.high != 0)
      || (mul12.high != 0)
      // Check not preformed multiplications
      || (self.w0 != 0 && rhs.w0 != 0)

    let result = Self(w4, w5, w6, w7)
    return (result, overflow)
  }

  internal func multipliedFullWidth(by rhs: UInt128) -> (high: UInt128, low: Self) {
    let mul02 = self.w0.multipliedFullWidth(by: rhs.w0)
    let mul03 = self.w0.multipliedFullWidth(by: rhs.w1)
    let mul12 = self.w1.multipliedFullWidth(by: rhs.w0)
    let mul13 = self.w1.multipliedFullWidth(by: rhs.w1)
    let mul22 = self.w2.multipliedFullWidth(by: rhs.w0)
    let mul23 = self.w2.multipliedFullWidth(by: rhs.w1)
    let mul32 = self.w3.multipliedFullWidth(by: rhs.w0)
    let mul33 = self.w3.multipliedFullWidth(by: rhs.w1)

    // Column 7
    let w7 = mul33.low
    let carry7: Word = 0

    // Column 6
    let (carry6, w6) = sum(
      carry7,
      mul33.high, // previous column (sum=6)
      mul23.low, mul32.low // this column (sum=5)
    )

    // Column 5
    let (carry5, w5) = sum(
      carry6,
      mul23.high, mul32.high, // previous column (sum=5)
      mul13.low, mul22.low // this column (sum=4)
    )

    // Column 4
    let (carry4, w4) = sum(
      carry5,
      mul13.high, mul22.high, // previous column (sum=4)
      mul03.low, mul12.low // this column (sum=3)
    )

    // Column 3
    let (carry3, w3) = sum(
      carry4,
      mul03.high, mul12.high, // previous column (sum=3)
      mul02.low // this column (sum=2)
    )

    // Column 2
    let (carry2, w2) = sum(
      carry3,
      mul02.high // previous column (sum=2)
    )

    assert(carry2 == 0)
    let high = UInt128(w2, w3)
    let low = Self(w4, w5, w6, w7)
    return (high, low)
  }

  internal static func * (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }

  internal static func *= (_ lhs: inout Self, _ rhs: Self) {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }

  internal func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
    let mul03 = self.w0.multipliedFullWidth(by: rhs.w3)
    let mul12 = self.w1.multipliedFullWidth(by: rhs.w2)
    let mul13 = self.w1.multipliedFullWidth(by: rhs.w3)
    let mul21 = self.w2.multipliedFullWidth(by: rhs.w1)
    let mul22 = self.w2.multipliedFullWidth(by: rhs.w2)
    let mul23 = self.w2.multipliedFullWidth(by: rhs.w3)
    let mul30 = self.w3.multipliedFullWidth(by: rhs.w0)
    let mul31 = self.w3.multipliedFullWidth(by: rhs.w1)
    let mul32 = self.w3.multipliedFullWidth(by: rhs.w2)
    let mul33 = self.w3.multipliedFullWidth(by: rhs.w3)

    // Column 7
    let w7 = mul33.low
    let carry7: Word = 0

    // Column 6
    let (carry6, w6) = sum(
      carry7,
      mul33.high, // previous column (sum=6)
      mul23.low, mul32.low // this column (sum=5)
    )

    // Column 5
    let (carry5, w5) = sum(
      carry6,
      mul23.high, mul32.high, // previous column (sum=5)
      mul13.low, mul22.low, mul31.low // this column (sum=4)
    )

    // Column 4
    let (carry4, w4) = sum(
      carry5,
      mul13.high, mul22.high, mul31.high, // previous column (sum=4)
      mul03.low, mul12.low, mul21.low, mul30.low // this column (sum=3)
    )

    let overflow: Bool = carry4 != 0
      // Check 'high' in column 3
      || (mul03.high != 0)
      || (mul12.high != 0)
      || (mul21.high != 0)
      || (mul30.high != 0)
      // Check not preformed multiplications
      || (self.w0 != 0 && rhs.w2 != 0)
      || (self.w1 != 0 && rhs.w1 != 0)
      || (self.w2 != 0 && rhs.w0 != 0)
      || (self.w0 != 0 && rhs.w1 != 0)
      || (self.w1 != 0 && rhs.w0 != 0)
      || (self.w0 != 0 && rhs.w0 != 0)

    let result = Self(w4, w5, w6, w7)
    return (result, overflow)
  }

  internal func multipliedFullWidth(by rhs: Self) -> (high: Self, low: Self) {
    let mul00 = self.w0.multipliedFullWidth(by: rhs.w0)
    let mul01 = self.w0.multipliedFullWidth(by: rhs.w1)
    let mul02 = self.w0.multipliedFullWidth(by: rhs.w2)
    let mul03 = self.w0.multipliedFullWidth(by: rhs.w3)
    let mul10 = self.w1.multipliedFullWidth(by: rhs.w0)
    let mul11 = self.w1.multipliedFullWidth(by: rhs.w1)
    let mul12 = self.w1.multipliedFullWidth(by: rhs.w2)
    let mul13 = self.w1.multipliedFullWidth(by: rhs.w3)
    let mul20 = self.w2.multipliedFullWidth(by: rhs.w0)
    let mul21 = self.w2.multipliedFullWidth(by: rhs.w1)
    let mul22 = self.w2.multipliedFullWidth(by: rhs.w2)
    let mul23 = self.w2.multipliedFullWidth(by: rhs.w3)
    let mul30 = self.w3.multipliedFullWidth(by: rhs.w0)
    let mul31 = self.w3.multipliedFullWidth(by: rhs.w1)
    let mul32 = self.w3.multipliedFullWidth(by: rhs.w2)
    let mul33 = self.w3.multipliedFullWidth(by: rhs.w3)

    // Column 7
    let w7 = mul33.low
    let carry7: Word = 0

    // Column 6
    let (carry6, w6) = sum(
      carry7,
      mul33.high, // previous column (sum=6)
      mul23.low, mul32.low // this column (sum=5)
    )

    // Column 5
    let (carry5, w5) = sum(
      carry6,
      mul23.high, mul32.high, // previous column (sum=5)
      mul13.low, mul22.low, mul31.low // this column (sum=4)
    )

    // Column 4
    let (carry4, w4) = sum(
      carry5,
      mul13.high, mul22.high, mul31.high, // previous column (sum=4)
      mul03.low, mul12.low, mul21.low, mul30.low // this column (sum=3)
    )

    // Column 3
    let (carry3, w3) = sum(
      carry4,
      mul03.high, mul12.high, mul21.high, mul30.high, // previous column (sum=3)
      mul02.low, mul11.low, mul20.low // this column (sum=2)
    )

    // Column 2
    let (carry2, w2) = sum(
      carry3,
      mul02.high, mul11.high, mul20.high, // previous column (sum=2)
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
    let high = Self(w0, w1, w2, w3)
    let low = Self(w4, w5, w6, w7)
    return (high, low)
  }

  // MARK: - Div

  internal static func / (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "Division by zero")
    return result
  }

  internal static func /= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "Division by zero")
    lhs = result
  }

  internal func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
    if rhs == Self.zero {
      return (self, true)
    }

    let qr = self.quotientAndRemainder(dividingBy: rhs)
    return (qr.quotient, false)
  }

  internal static func % (lhs: Self, rhs: Self) -> Self {
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "Division by zero in remainder operation")
    return result
  }

  internal static func %= (lhs: inout Self, rhs: Self) {
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "Division by zero in remainder operation")
    lhs = result
  }

  internal func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
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

    let div2 = div1.remainder == 0 ?
      self.w2.quotientAndRemainder(dividingBy: rhs) :
      rhs.dividingFullWidth((div1.remainder, self.w2))

    let div3 = div2.remainder == 0 ?
      self.w3.quotientAndRemainder(dividingBy: rhs) :
      rhs.dividingFullWidth((div2.remainder, self.w3))

    let quotient = Self(div0.quotient, div1.quotient, div2.quotient, div3.quotient)
    return (quotient, div3.remainder)
  }

  internal func quotientAndRemainder(dividingBy rhs: UInt128) -> (quotient: Self, remainder: UInt128) {
    // rhs == Word?
    if rhs.w0 == 0 {
      let (q, r) = self.quotientAndRemainder(dividingBy: rhs.w1)
      let remainder = UInt128(0, r)
      return (q, remainder)
    }

    // self == UInt128?
    if self.w0 == 0 && self.w1 == 0 {
      let w2w3 = UInt128(self.w2, self.w3)
      let (q, r) = w2w3.quotientAndRemainder(dividingBy: rhs)
      let quotient = Self(0, 0, q.w0, q.w1)
      return (quotient, r)
    }

    let w0w1 = UInt128(self.w0, self.w1)
    let div0 = w0w1.quotientAndRemainder(dividingBy: rhs)

    let w2w3 = UInt128(self.w2, self.w3)
    let div1 = div0.remainder == 0 ?
      w2w3.quotientAndRemainder(dividingBy: rhs) :
      rhs.dividingFullWidth((div0.remainder, w2w3))

    let quotient = Self(div0.quotient.w0, div0.quotient.w1, div1.quotient.w0, div1.quotient.w1)
    let remainder = UInt128(div1.remainder.w0, div1.remainder.w1)
    return (quotient, remainder)
  }

  internal func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
    precondition(rhs != 0, "Division by zero")

    if self == rhs {
      return (1, 0)
    }

    if self < rhs {
      return (0, self)
    }

    // Rhs 2 words?
    if rhs.w0 == 0 && rhs.w1 == 0 {
      let rhsShort = UInt128(rhs.w2, rhs.w3)
      let (q, r) = self.quotientAndRemainder(dividingBy: rhsShort)
      let remainder = Self(0, 0, r.w0, r.w1)
      return (q, remainder)
    }

    // Edge case for the bit shifting below.
    if self.leadingZeroBitCount == rhs.leadingZeroBitCount {
      // Quotient is 1 and remainder is the difference:
      // - lhs > rhs
      // - both operands have non-0 high bits
      // - both have the same high power of 2, so quotient has to be 1
      let quotient = Self(0, 0, 0, 1)
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
    _ a1: UInt128, _ a2: UInt128, _ a3: UInt128,
    by b: Self
  ) -> (quotient: UInt128, remainder: Self) {
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
      UInt128.max

    // The method in the paper gives incorrect reminder?
    // They want 'D = Q̂*B2'.
    // We will use 'D = Q̂*B' and compare with original value 'A'.
    let d = b.multipliedFullWidth(by: qHat)
    let D = UInt384(d.high, d.low)
    // This is basically the original value of 'A'
    // We will do the '-D' part later.
    var rHat = UInt384(a1, a2, a3)
    let bWide = UInt384(0, b)

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

  internal func dividingFullWidth(_ dividend: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {
    fatalError("UInt256 dividingFullWidth is not implemented.")
  }

  // MARK: - Bit operations

  internal static prefix func ~ (n: Self) -> Self {
    let w0 = ~n.w0
    let w1 = ~n.w1
    let w2 = ~n.w2
    let w3 = ~n.w3
    return Self(w0, w1, w2, w3)
  }

  internal static func &= (lhs: inout Self, rhs: Self) {
    lhs.w0 &= rhs.w0
    lhs.w1 &= rhs.w1
    lhs.w2 &= rhs.w2
    lhs.w3 &= rhs.w3
  }

  internal static func |= (lhs: inout Self, rhs: Self) {
    lhs.w0 |= rhs.w0
    lhs.w1 |= rhs.w1
    lhs.w2 |= rhs.w2
    lhs.w3 |= rhs.w3
  }

  internal static func ^= (lhs: inout Self, rhs: Self) {
    lhs.w0 ^= rhs.w0
    lhs.w1 ^= rhs.w1
    lhs.w2 ^= rhs.w2
    lhs.w3 ^= rhs.w3
  }

  // MARK: - Shifts

  internal static func &<<= (lhs: inout Self, rhs: Self) {
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
      lhs.w1 |= lhs.w2 &>> right
      lhs.w2 = lhs.w2 &<< left
      lhs.w2 |= lhs.w3 &>> right
      lhs.w3 = lhs.w3 &<< left
    } else if rhs == 1 &* word {
      lhs.w0 = lhs.w1
      lhs.w1 = lhs.w2
      lhs.w2 = lhs.w3
      lhs.w3 = 0
    } else if rhs < 2 &* word {
      let left = rhs &- (1 &* word)
      let right = word &- left
      lhs.w0 = lhs.w1 &<< left
      lhs.w0 |= lhs.w2 &>> right
      lhs.w1 = lhs.w2 &<< left
      lhs.w1 |= lhs.w3 &>> right
      lhs.w2 = lhs.w3 &<< left
      lhs.w3 = 0
    } else if rhs == 2 &* word {
      lhs.w0 = lhs.w2
      lhs.w1 = lhs.w3
      lhs.w2 = 0
      lhs.w3 = 0
    } else if rhs < 3 &* word {
      let left = rhs &- (2 &* word)
      let right = word &- left
      lhs.w0 = lhs.w2 &<< left
      lhs.w0 |= lhs.w3 &>> right
      lhs.w1 = lhs.w3 &<< left
      lhs.w2 = 0
      lhs.w3 = 0
    } else if rhs == 3 &* word {
      lhs.w0 = lhs.w3
      lhs.w1 = 0
      lhs.w2 = 0
      lhs.w3 = 0
    } else if rhs < 4 &* word {
      let left = rhs &- (3 &* word)
      lhs.w0 = lhs.w3 &<< left
      lhs.w1 = 0
      lhs.w2 = 0
      lhs.w3 = 0
    } else if rhs == 4 &* word {
      lhs.w0 = 0
      lhs.w1 = 0
      lhs.w2 = 0
      lhs.w3 = 0
    }
  }

  internal static func &>>= (lhs: inout Self, rhs: Self) {
    let rhs = Self.applyShiftMask(rhs)
    let word = Word(Word.bitWidth)

    if rhs == 0 {
      // Nothing to do here.
    } else if rhs < 1 &* word {
      let right = rhs &- (0 &* word)
      let left = word &- right
      lhs.w3 = lhs.w3 &>> right
      lhs.w3 |= lhs.w2 &<< left
      lhs.w2 = lhs.w2 &>> right
      lhs.w2 |= lhs.w1 &<< left
      lhs.w1 = lhs.w1 &>> right
      lhs.w1 |= lhs.w0 &<< left
      lhs.w0 = lhs.w0 &>> right
    } else if rhs == 1 &* word {
      lhs.w3 = lhs.w2
      lhs.w2 = lhs.w1
      lhs.w1 = lhs.w0
      lhs.w0 = 0
    } else if rhs < 2 &* word {
      let right = rhs &- (1 &* word)
      let left = word &- right
      lhs.w3 = lhs.w2 &>> right
      lhs.w3 |= lhs.w1 &<< left
      lhs.w2 = lhs.w1 &>> right
      lhs.w2 |= lhs.w0 &<< left
      lhs.w1 = lhs.w0 &>> right
      lhs.w0 = 0
    } else if rhs == 2 &* word {
      lhs.w3 = lhs.w1
      lhs.w2 = lhs.w0
      lhs.w1 = 0
      lhs.w0 = 0
    } else if rhs < 3 &* word {
      let right = rhs &- (2 &* word)
      let left = word &- right
      lhs.w3 = lhs.w1 &>> right
      lhs.w3 |= lhs.w0 &<< left
      lhs.w2 = lhs.w0 &>> right
      lhs.w1 = 0
      lhs.w0 = 0
    } else if rhs == 3 &* word {
      lhs.w3 = lhs.w0
      lhs.w2 = 0
      lhs.w1 = 0
      lhs.w0 = 0
    } else if rhs < 4 &* word {
      let right = rhs &- (3 &* word)
      lhs.w3 = lhs.w0 &>> right
      lhs.w2 = 0
      lhs.w1 = 0
      lhs.w0 = 0
    } else if rhs == 4 &* word {
      lhs.w3 = 0
      lhs.w2 = 0
      lhs.w1 = 0
      lhs.w0 = 0
    }
  }

  /// Calculates the result of shifting a value’s binary representation the
  /// specified number of digits in direction, MASKING THE SHIFT AMOUNT TO
  /// THE TYPE’S BIT WIDTH, and stores the result in the left-hand-side variable.
  private static func applyShiftMask(_ n: Self) -> Word {
    let mask = Word(truncatingIfNeeded: Self.bitWidth &- 1)
    return n.w3 & mask
  }

  // MARK: - Equal, compare

  internal static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.w0 == rhs.w0 && lhs.w1 == rhs.w1 && lhs.w2 == rhs.w2 && lhs.w3 == rhs.w3
  }

  internal static func < (lhs: Self, rhs: Self) -> Bool {
    if lhs.w0 < rhs.w0 { return true }

    if lhs.w0 != rhs.w0 { return false }
    if lhs.w1 < rhs.w1 { return true }

    if lhs.w1 != rhs.w1 { return false }
    if lhs.w2 < rhs.w2 { return true }

    if lhs.w2 != rhs.w2 { return false }
    return lhs.w3 < rhs.w3
  }

  // MARK: - Words

  internal struct Words: RandomAccessCollection {
    internal typealias Element = UInt
    internal typealias Index = Int

    internal var count: Int { UInt256.bitWidth / UInt.bitWidth }
    internal var startIndex: Index { 0 }
    internal var endIndex: Index { count }

    internal var value: UInt256

    fileprivate init(_ value: UInt256) {
      self.value = value
    }

    internal subscript(position: Index) -> UInt {
      precondition(
        0 <= position && position < self.endIndex,
        "Word index out of range"
      )

      let shift = position * UInt.bitWidth
      let shifted = self.value &>> shift
      return UInt(truncatingIfNeeded: shifted.w3)
    }

    internal func index(after i: Index) -> Index { i + 1 }
    internal func index(before i: Index) -> Index { i - 1 }
  }
}

// MARK: - Div helper - UInt384

/// Unsigned Int that is used during division.
private struct UInt384 {

  fileprivate typealias Word = UInt128

  fileprivate let w0: Word
  fileprivate let w1: Word
  fileprivate let w2: Word

  fileprivate init(_ w0: Word, _ wide: UInt256) {
    self.w0 = w0
    self.w1 = Word(wide.w0, wide.w1)
    self.w2 = Word(wide.w2, wide.w3)
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
