// ASCII constants
private let _0: UInt8 = 48
private let _9: UInt8 = 57

private let _A: UInt8 = 65
private let _E: UInt8 = 69
private let _F: UInt8 = 70
private let _Z: UInt8 = 90

private let _a: UInt8 = 97
private let _e: UInt8 = 101
private let _f: UInt8 = 102
private let _i: UInt8 = 105
private let _n: UInt8 = 110
private let _s: UInt8 = 115
private let _t: UInt8 = 116
private let _x: UInt8 = 120
private let _y: UInt8 = 121

private let _NULL:  UInt8 = 0
private let _tab:   UInt8 = 9
private let _space: UInt8 = 32
private let _parenOpen:  UInt8 = 40
private let _parenClose: UInt8 = 41
private let _plus:  UInt8 = 43
private let _minus: UInt8 = 45
private let _point: UInt8 = 46

private func casefold(_ c: UInt8) -> UInt8 {
  let isUpper = _A <= c && c <= _Z
  return isUpper ? c - _A + _a : c
}

private func isDecimalDigit(_ char: UInt8) -> Bool {
  return _0 <= char && char <= _9
}

// MARK: - String

extension String {
  public init<T: DecimalFloatingPoint>(_ decimal: T) {
    self = decimal.description
  }
}

// MARK: - Parse

private struct Parser<C: BidirectionalCollection> where C.Element == UInt8 {
  private let chars: C
  private var index: C.Index

  fileprivate var peek: UInt8? {
    return self.index == self.chars.endIndex ? nil : self.chars[self.index]
  }

  fileprivate var isEnd: Bool { self.index == self.chars.endIndex }

  fileprivate init(_ chars: C) {
    self.chars = chars
    self.index = chars.startIndex
  }

  fileprivate mutating func advance() {
    self.chars.formIndex(after: &self.index)
  }

  /// Check if `self.peek == char` and advance if true.
  fileprivate mutating func advanceIf(_ char: UInt8) -> Bool {
    if let p = self.peek, casefold(p) == char {
      self.advance()
      return true
    }

    return false
  }

  /// Advance while `self.peek == 0`.
  fileprivate mutating func consumeZeros() {
    while let p = self.peek, p == _0 {
      self.chars.formIndex(after: &self.index)
    }
  }
}

extension DecimalMixin {

  internal static func _parse<S: StringProtocol>(
    _ s: S,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self? {
    if s.isEmpty {
      return nil
    }

    let utf8 = Substring(s).utf8

    // Most of the time we will go 'fast' (in Swift dominant apps).
    let fast = utf8.withContiguousStorageIfAvailable { ptr in
      return Self.parse(ptr, rounding: rounding, status: &status)
    }

    // There is also 'string.withUTF8', but it may copy the whole input and that
    // could result in ENOMEM. We value stability over performance.
    if let r = fast ?? Self.parse(utf8, rounding: rounding, status: &status) {
      return r
    }

    return nil
  }

  private static func parse<C: BidirectionalCollection>(
    _ chars: C,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self? where C.Element == UInt8 {
    var parser = Parser(chars)
    assert(!parser.isEnd, "Decimal.parse<C> with empty?")

    let sign = Self.parseSign(&parser)

    guard let char = parser.peek, char == _point || isDecimalDigit(char) else {
      if let d = Self.parseInfinity(sign, parser) { return d }
      if let d = Self.parseNaN(sign, parser) { return d }
      return nil
    }

    var significand: BID = 0
    var significandDigitCount = 0
    // 2 most important digits after 'significand', because 0.5 may round
    // differently than 0.51. We will skip middle '0', so '50001' -> '51'.
    var roundingDigitsCount = 0
    // There will be a 2nd exponent from parsing 'e+XX' later.
    var significandExponent = 0
    var hasSeenPoint = false

    parser.consumeZeros()

    while let char = parser.peek, char == _point || isDecimalDigit(char) {
      if char == _point {
        if hasSeenPoint {
          return nil
        }

        hasSeenPoint = true
      } else if char == _0 && significand == 0 {
        // '0' is not a valid leading 'significand' digit, so skip it.
        // Though, for numbers like 0.0000000000000000000000000000001001
        // we want to decrease the exponent for the future 'significand'.
        if hasSeenPoint {
          significandExponent -= 1
        }
      } else if significandDigitCount < Self.precisionInDigits {
        significand *= 10
        significand += BID(truncatingIfNeeded: char - _0)
        significandDigitCount += 1

        // We added a 'fraction' digit: 123.45 = 12345 * 10^-2
        if hasSeenPoint {
          significandExponent -= 1
        }
      } else {
        // We are dealing with 'tail' digits that, will not be included in
        // 'significand'. 2 digits will be used for rounding. Rest is discarded.
        if roundingDigitsCount == 0 {
          significand *= 10
          significand += BID(truncatingIfNeeded: char - _0)
          roundingDigitsCount = 1
        } else if roundingDigitsCount == 1 && char != _0 {
          significand *= 10
          significand += BID(truncatingIfNeeded: char - _0)
          roundingDigitsCount = 2
        }

        // This is a 'whole' digit: 12354 = 123 * 10^2
        if !hasSeenPoint {
          significandExponent += 1
        }
      }

      parser.advance()
    }

    if parser.isEnd {
      return Self._pack(
        sign: sign,
        significand: significand,
        signedExponent: significandExponent,
        roundingDigitCount: roundingDigitsCount,
        rounding: rounding,
        status: &status
      )
    }

    guard parser.advanceIf(_e) else {
      return nil
    }

    let exponentSign = Self.parseSign(&parser)
    var explicitExponent = 0

    parser.consumeZeros()

    while let char = parser.peek, isDecimalDigit(char) {
      let n = Int(truncatingIfNeeded: char - _0)
      let (mul, ov1) = explicitExponent.multipliedReportingOverflow(by: 10)
      let (add, ov2) = mul.addingReportingOverflow(n)

      if ov1 || ov2 {
        return Self.exponentOverflow(
          sign: sign,
          exponentSign: exponentSign,
          rounding: rounding,
          status: &status
        )
      }

      explicitExponent = add
      parser.advance()
    }

    guard parser.isEnd else {
      return nil
    }

    explicitExponent = exponentSign.isPlus ? explicitExponent : -explicitExponent
    let (exponent, ov) = explicitExponent.addingReportingOverflow(significandExponent)

    if ov {
      return Self.exponentOverflow(
        sign: sign,
        exponentSign: exponentSign,
        rounding: rounding,
        status: &status
      )
    }

    return Self._pack(
      sign: sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitsCount,
      rounding: rounding,
      status: &status
    )
  }

  private static func parseSign<C>(_ parser: inout Parser<C>) -> Sign {
    if parser.peek == _plus {
      parser.advance()
      return .plus
    }

    if parser.peek == _minus {
      parser.advance()
      return .minus
    }

    return .plus
  }

  private static func exponentOverflow(
    sign: Sign,
    exponentSign: Sign,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    if exponentSign.isPlus {
      status.set(.isOverflowInexact)
      return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
    }

    status.set(.isUnderflowInexact)
    return Self._roundInfinitelySmallValue(
      sign: sign,
      preferredSignedExponentForZero: 0,
      rounding: rounding
    )
  }

  private static func parseInfinity<C>(_ sign: Sign, _ parser: Parser<C>) -> Self? {
    var p = parser

    guard p.advanceIf(_i) else { return nil }
    guard p.advanceIf(_n) else { return nil }
    guard p.advanceIf(_f) else { return nil }

    if p.isEnd { return Self(canonical: sign | Self.infinityMask) }

    guard p.advanceIf(_i) else { return nil }
    guard p.advanceIf(_n) else { return nil }
    guard p.advanceIf(_i) else { return nil }
    guard p.advanceIf(_t) else { return nil }
    guard p.advanceIf(_y) else { return nil }

    return p.isEnd ? Self(canonical: sign | Self.infinityMask) : nil
  }

  private static func parseNaN<C>(_ sign: Sign, _ parser: Parser<C>) -> Self? {
    var p = parser

    var nan = Self.nanQuietMask

    if p.advanceIf(_s) {
      nan = Self.nanSignalingMask
    }

    guard p.advanceIf(_n) else { return nil }
    guard p.advanceIf(_a) else { return nil }
    guard p.advanceIf(_n) else { return nil }

    let withoutPayload = Self(canonical: sign | nan)

    if p.isEnd {
      return withoutPayload
    }

    // From Swift docs:
    // A NaN string may also include a payload in parentheses following the "nan"
    // keyword. The payload consists of a sequence of decimal digits, or the
    // characters 0X or 0x followed by a sequence of hexadecimal digits.
    // If the payload contains any other characters, it is ignored.
    // If the value of the payload is larger than can be stored as the payload
    // of a Double.nan, the least significant bits are used.

    guard p.advanceIf(_parenOpen) else { return nil }

    var payload: BID = 0
    var hasInvalidCharacter = false
    var base: BID = 10

    if p.advanceIf(_0) && p.advanceIf(_x) {
      base = 16
    }

    let isHexaDecimal = base == 16
    var hasOverflow = false

    while let char = p.peek {
      if char == _parenClose {
        break
      }

      // Continue parsing even if we have an overflow.
      // If the ')' is missing then we should return 'nil'.
      let mul = payload.multipliedReportingOverflow(by: base)
      payload = mul.partialValue
      hasOverflow = hasOverflow || mul.overflow

      if isDecimalDigit(char) {
        payload += BID(truncatingIfNeeded: char - _0)
      } else if isHexaDecimal && _a <= char && char <= _f {
        payload += BID(truncatingIfNeeded: char - _a + 10)
      } else if isHexaDecimal && _A <= char && char <= _F {
        payload += BID(truncatingIfNeeded: char - _A + 10)
      } else {
        hasInvalidCharacter = true
      }

      p.advance()
    }

    guard p.advanceIf(_parenClose) else { return nil }
    guard p.isEnd else { return nil }

    // If the payload contains any other characters, it is ignored.
    if hasInvalidCharacter {
      return withoutPayload
    }

    // - payload is canonical -> ok
    // - payload is not canonical, but fits within mask -> accept non-canonical
    // - payload does not fit within mask -> non-canonical with all bits 1
    if hasOverflow || payload > Self.nanPayloadMask {
      payload = Self.nanPayloadMask
    }

    return Self(unchecked: withoutPayload.bid | payload)
  }
}

// MARK: - To string

/// Writer that writes from the back.
///
/// We are dealing with trivial data, so we can do things 'by hand' without
/// dealing with Swift overhead.
private struct ReverseWriter {

  private let ptr: UnsafeMutablePointer<UInt8>
  private var index: Int

  fileprivate init(capacity: Int) {
    let nullCapacity = capacity + 1
    self.ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: nullCapacity)
    self.ptr[nullCapacity - 1] = _NULL
    self.index = nullCapacity - 2
  }

  fileprivate mutating func write<T: FixedWidthInteger & UnsignedInteger>(_ n: T) {
    if n == 0 {
      self.write(_0)
    } else {
      var n = n

      while n != 0 {
        let (quotient, remainder) = n.quotientAndRemainder(dividingBy: 10)
        self.write(_0 + UInt8(remainder))
        n = quotient
      }
    }
  }

  fileprivate mutating func write<T: FixedWidthInteger & UnsignedInteger>(hex n: T) {
    if n == 0 {
      self.write(_0)
    } else {
      var n = n

      while n != 0 {
        let (quotient, remainder) = n.quotientAndRemainder(dividingBy: 16)
        let r = UInt8(remainder)
        self.write(r < 10 ? r + _0 : r - 10 + _a)
        n = quotient
      }
    }
  }

  fileprivate mutating func write(_ n: UInt8) {
    assert(self.index >= 0, "Incorrect capacity estimation.")
    self.ptr[self.index] = n
    self.index -= 1
  }

  /// Will deallocate buffer! Do not call 2 times!
  fileprivate func finalize() -> String {
    let ptr = self.ptr.advanced(by: self.index + 1)
    let result = String(cString: ptr) // Borrows 'ptr' to create owned copy.
    self.ptr.deallocate()
    return result
  }
}

extension DecimalMixin {

  internal func _toString() -> String {
    let isNegative = self._isNegative

    if self._isNaN {
      let payload = self._unpackNaN()
      let isSignaling = self._isSignalingNaN

      if payload.canonical == 0 {
        return isSignaling ?
          isNegative ? "-snan" : "snan" :
          isNegative ? "-nan" : "nan"
      }

      // Double(nan: 123, signaling: false) -> nan(0x7b)
      // sign (1) + [optional s (1)] + nan (3) + '(' (1) + payload + ')' (1)
      let capacity = 6 + Self.precisionInDigits + (isSignaling ? 1 : 0)
      var writer = ReverseWriter(capacity: capacity)

      writer.write(_parenClose)
      writer.write(hex: payload.canonical)
      writer.write(_x)
      writer.write(_0)
      writer.write(_parenOpen)
      writer.write(_n)
      writer.write(_a)
      writer.write(_n)
      if isSignaling { writer.write(_s) }
      if isNegative { writer.write(_minus) }

      return writer.finalize()
    }

    if self._isInfinite {
      return isNegative ? "-inf" : "inf"
    }

    let u = self._unpackFiniteOrZero()

    // sign (1) + significand + e (1) + exponentSign (1) + exponent
    let exponent = u.exponent.signed
    let exponentCount = self.estimateCount(exponent: exponent)
    let significandCount = u.significand.isZero ? 1 : Self.precisionInDigits
    let capacity = 3 + significandCount + exponentCount

    var writer = ReverseWriter(capacity: capacity)
    writer.write(exponent.magnitude)
    writer.write(exponent >= 0 ? _plus : _minus)
    writer.write(_E)
    writer.write(u.significand.canonical)
    if isNegative { writer.write(_minus) }

    return writer.finalize()
  }

  private func estimateCount(exponent: Int) -> Int {
    // Exponents are small (6144 for Decimal128), we can get away with this.
    let n = exponent.magnitude
    assert(n < 10_000, "exponent >= 10_000?")
    if n >= 1000 { return 4 }
    if n >= 100 { return 3 }
    if n >= 10 { return 2 }
    return 1
  }
}
