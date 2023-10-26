// MARK: - DoubleWidth

/// Two times wider than a normal BID. Much wow!
internal protocol DoubleWidthBinaryIntegerDecimal: BinaryIntegerDecimal {

  /// We are double width of this BID.
  ///
  /// It should be marked with `BinaryIntegerDecimal` requirement, but then the
  /// compiler would complain about the duplicate annotation in `DecimalMixin.BID`.
  associatedtype Half

  var high: Half { get }
  var low: Half { get }

  init(high: Half, low: Half)

  static func * (lhs: Self, rhs: Half) -> Self
  func multipliedReportingOverflow(by rhs: Half) -> (partialValue: Self, overflow: Bool)
  func quotientAndRemainder(dividingBy rhs: Half) -> (quotient: Self, remainder: Half)
}

// MARK: - Decimal32

extension UInt64: DoubleWidthBinaryIntegerDecimal {

  internal typealias Half = UInt32

  internal var high: Half { Half(truncatingIfNeeded: self >> Half.bitWidth) }
  internal var low: Half { Half(truncatingIfNeeded: self) }

  internal init(high: Half, low: Half) {
    let h = Self(truncatingIfNeeded: high) << Half.bitWidth
    let l = Self(truncatingIfNeeded: low)
    self = h | l
  }

  internal static func * (lhs: Self, rhs: Half) -> Self {
    let r = Self(truncatingIfNeeded: rhs)
    return lhs * r
  }

  internal func multipliedReportingOverflow(
    by rhs: Half
  ) -> (partialValue: Self, overflow: Bool) {
    let r = Self(truncatingIfNeeded: rhs)
    return self.multipliedReportingOverflow(by: r)
  }

  internal func quotientAndRemainder(
    dividingBy rhs: Half
  ) -> (quotient: Self, remainder: Half) {
    // We divide by 'rhs', so 'remainder < rhs', which is always representable.
    let r = Self(truncatingIfNeeded: rhs)
    let qr = self.quotientAndRemainder(dividingBy: r)
    let remainder = Half(truncatingIfNeeded: qr.remainder)
    return (qr.quotient, remainder)
  }
}

// MARK: - Decimal64

extension UInt128: DoubleWidthBinaryIntegerDecimal {

  internal typealias Half = UInt64

  internal var high: Word { self.w0 }
  internal var low:  Word { self.w1 }

  internal init(high: Word, low: Word) {
    self = Self(high, low)
  }
}

// MARK: - Decimal128

extension UInt256: DoubleWidthBinaryIntegerDecimal {

  internal typealias Half = UInt128

  internal var high: Half { Half(high: self.w0, low: self.w1) }
  internal var low:  Half { Half(high: self.w2, low: self.w3) }

  internal init(high: Half, low: Half) {
    self = Self(high.w0, high.w1, low.w0, low.w1)
  }
}
