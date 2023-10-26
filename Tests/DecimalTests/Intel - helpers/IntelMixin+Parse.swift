import XCTest
@testable import Decimal

// MARK: - Decimal

extension IntelMixin {

  func parseDecimal32(_ s: String, _ file: StaticString, _ line: UInt) -> Decimal32? {
    return self.parseDecimal(s, file, line)
  }

  func parseDecimal64(_ s: String, _ file: StaticString, _ line: UInt) -> Decimal64? {
    return self.parseDecimal(s, file, line)
  }

  func parseDecimal128(_ s: String, _ file: StaticString, _ line: UInt) -> Decimal128? {
    return self.parseDecimal(s, file, line)
  }

  func parseDecimal<T: DecimalFloatingPoint & DecimalMixin>(
    _ s: String,
    _ file: StaticString,
    _ line: UInt,
    _ comment: String = ""
  ) -> T? {
    if s.hasPrefix("[") {
      if let bid = self.parseHexInsideBrackets(T.BID.self, s) {
        return T(unchecked: bid)
      }

      XCTFail("Unable to parse \(T.self) from: \(s). \(comment)", file: file, line: line)
      return nil
    }

    var status = DecimalStatus()
    if let d = T._parse(s, rounding: .toNearestOrEven, status: &status) {
      return d
    }

    let lower = s.lowercased()
    if lower == "qnan" || lower == "null" {
      return T.nan
    }

    XCTFail("Unable to parse \(T.self) from: \(s). \(comment)", file: file, line: line)
    return nil
  }

  func parseDenselyPackedDecimal32(_ s: String, _ file: StaticString, _ line: UInt) -> UInt32? {
    return self.parseDenselyPackedDecimal(s, file, line)
  }

  func parseDenselyPackedDecimal64(_ s: String, _ file: StaticString, _ line: UInt) -> UInt64? {
    return self.parseDenselyPackedDecimal(s, file, line)
  }

  func parseDenselyPackedDecimal128(_ s: String, _ file: StaticString, _ line: UInt) -> UInt128? {
    return self.parseDenselyPackedDecimal(s, file, line)
  }

  func parseDenselyPackedDecimal<T: FixedWidthInteger>(
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    if let hex = self.parseHexInsideBrackets(T.self, s) {
      return hex
    }

    // Predefined outputs for some weird inputs.
    let lower = s.lowercased()

    if lower == "1e-102" {
      return T.zero
    }

    XCTFail("Unable to parse DenselyPackedDecimal\(T.bitWidth) from: \(s).", file: file, line: line)
    return nil
  }
}

// MARK: - Int

// Unsigned integer that is one of the Intel operands.
private protocol IntelUnsignedInteger: FixedWidthInteger {
  associatedtype Signed: FixedWidthInteger
  init(bitPattern: Signed)
}

extension UInt8: IntelUnsignedInteger {}
extension UInt16: IntelUnsignedInteger {}
extension UInt32: IntelUnsignedInteger {}
extension UInt64: IntelUnsignedInteger {}

extension IntelMixin {

  func parseInt(_ s: String, _ file: StaticString, _ line: UInt) -> Int? {
    return self.parseFixedWidthInt(s, file, line)
  }

  func parseInt8(_ s: String, _ file: StaticString, _ line: UInt) -> Int8? {
    return self.parseFixedWidthInt(s, file, line)
  }

  func parseInt16(_ s: String, _ file: StaticString, _ line: UInt) -> Int16? {
    return self.parseFixedWidthInt(s, file, line)
  }

  func parseInt32(_ s: String, _ file: StaticString, _ line: UInt) -> Int32? {
    return self.parseFixedWidthInt(s, file, line)
  }

  func parseInt64(_ s: String, _ file: StaticString, _ line: UInt) -> Int64? {
    return self.parseFixedWidthInt(s, file, line)
  }

  func parseUInt8(_ s: String, _ file: StaticString, _ line: UInt) -> UInt8? {
    return self.parseUnsignedFixedWidthInt(s, file, line)
  }

  func parseUInt16(_ s: String, _ file: StaticString, _ line: UInt) -> UInt16? {
    return self.parseUnsignedFixedWidthInt(s, file, line)
  }

  func parseUInt32(_ s: String, _ file: StaticString, _ line: UInt) -> UInt32? {
    return self.parseUnsignedFixedWidthInt(s, file, line)
  }

  func parseUInt64(_ s: String, _ file: StaticString, _ line: UInt) -> UInt64? {
    return self.parseUnsignedFixedWidthInt(s, file, line)
  }

  private func parseFixedWidthInt<T: FixedWidthInteger>(
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    if let hex = self.parseHexInsideBrackets(T.self, s) {
      return hex
    }

    if let int = T(s) {
      return int
    }

    if let predefined: T = self.getPredefinedInt(s) {
      return predefined
    }

    XCTFail("Unable to parse \(T.self) from \(s).", file: file, line: line)
    return nil
  }

  private func parseUnsignedFixedWidthInt<T: IntelUnsignedInteger>(
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    if let hex = self.parseHexInsideBrackets(T.self, s) {
      return hex
    }

    if let uint = T(s) {
      return uint
    }

    // Intel sometimes uses signed inputs for unsigned numbers.
    // For example "-9223372036854775808".
    //   #define BID_FMT_LLU   "%I64u"
    //   sscanf(op, BID_FMT_LLU, &bid)
    if let int = T.Signed(s) {
      return T(bitPattern: int)
    }

    // "-9223372036854775809" overflows even Int64.
    // AFAIK, this is UB for "sscanf".
    if s == "-9223372036854775809", let int = T.Signed("-9223372036854775800") {
      return T(bitPattern: int)
    }

    if let predefined: T = self.getPredefinedInt(s) {
      return predefined
    }

    XCTFail("Unable to parse \(T.self) from \(s).", file: file, line: line)
    return nil
  }

  private func parseHexInsideBrackets<T: FixedWidthInteger>(_ t: T.Type, _ s: String) -> T? {
    guard s.hasPrefix("[") else {
      return nil
    }

    assert(s.hasSuffix("]"))
    let inside = s.dropFirst().dropLast()
    let split = inside.split(separator: ",", omittingEmptySubsequences: true)

    switch split.count {
    case 1:
      return self.parseHex(T.self, inside)

    case 2:
      // 2 part split is sometimes used for for Decimal128.
      assert(T.self == UInt128.self, "Unexpected \(T.self) split into 2 parts: \(s).")
      let high = self.parseHex(UInt64.self, split[0])
      let low = self.parseHex(UInt64.self, split[1])
      return T(high) << 64 | T(low)

    default:
      return nil
    }
  }

  private func parseHex<T: FixedWidthInteger, S: StringProtocol>(
    _ t: T.Type,
    _ s: S
  ) -> T {
    // 's' is a raw bit pattern that can't be parsed via 'T(s, radix: 16)'.
    // Swift would think that it overflows.

    let _0: UInt32 = 48
    let _A: UInt32 = 65
    let _a: UInt32 = 97

    var result: T = 0

    for scalar in s.unicodeScalars {
      let ascii = scalar.value

      let hexDigit: UInt32 =
        ascii >= _a ? ascii - _a + 10 :
        ascii >= _A ? ascii - _A + 10 :
        ascii - _0

      assert(0 <= hexDigit && hexDigit <= 15)
      result = (result << 4) | T(hexDigit)
    }

    return result
  }

  /// Predefined outputs for some weird inputs.
  /// Intel uses 'sscanf(op, "%d", &bid)' which stops at 1st unrecognized character.
  private func getPredefinedInt<T: FixedWidthInteger>(_ s: String) -> T? {
    let lower = s.lowercased()

    switch lower {
    case "1.0", "1.0e-96": return T(1)
    case "-1.0", "-1.0e-96": return T(-1)
    case "9.999999e96", "9.999999e-95": return T(9)
    case "-9.999999e96", "-9.999999e-95": return T(-9)
    default: break
    }

    return nil
  }
}

// MARK: - Binary floating point

// Binary floating point that is one of the Intel operands.
private protocol IntelBinaryFloatingPoint: BinaryFloatingPoint {
  associatedtype BitPattern: FixedWidthInteger

  init(bitPattern: BitPattern)
  init?(_ s: String)
}

extension Float: IntelBinaryFloatingPoint {}
extension Double: IntelBinaryFloatingPoint {}

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

private let float80_signMask: UInt128 = 1 << 79
private let float80_exponentMask: UInt128 = (1 << 15) - 1
private let float80_significandMask: UInt128 = (1 << 64) - 1

extension Float80: IntelBinaryFloatingPoint {
  fileprivate init(bitPattern: UInt128) {
    let isNegative = (bitPattern & float80_signMask) == float80_signMask
    let exponent = UInt((bitPattern >> 64) & float80_exponentMask)
    let significand = UInt64(bitPattern & float80_significandMask)

    self = Float80(
      sign: isNegative ? .minus : .plus,
      exponentBitPattern: exponent,
      significandBitPattern: significand
    )
  }
}

#endif

extension IntelMixin {

  func parseFloat(_ s: String, _ file: StaticString, _ line: UInt) -> Float? {
    return self.parseBinaryFloatingPoint(s, file, line)
  }

  func parseDouble(_ s: String, _ file: StaticString, _ line: UInt) -> Double? {
    return self.parseBinaryFloatingPoint(s, file, line)
  }

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

  func parseFloat80(_ s: String, _ file: StaticString, _ line: UInt) -> Float80? {
    return self.parseBinaryFloatingPoint(s, file, line)
  }

#endif

  private func parseBinaryFloatingPoint<T: IntelBinaryFloatingPoint>(
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    // This input is 128 bits, which is longer than Float80.
    // Trimming trailing '0' to bring it back to 80 bits does the trick.
    // 4073 96FF 33D4 AAC3 D365 0000 0000 0000 = 8 groups * 16 bits each = 128 bits
    let s = T.self == Float80.self && s == "[407396FF33D4AAC3D365000000000000]" ?
     "[407396FF33D4AAC3D365]" :
     s

    if s.hasPrefix("[") {
      if let bitPattern = self.parseHexInsideBrackets(T.BitPattern.self, s) {
        return T(bitPattern: bitPattern)
      }

      XCTFail("Unable to parse \(T.self) from: \(s)", file: file, line: line)
      return nil
    }

    // Remove the 'e0' suffix (e0 == 0 -> 2**0 = 1).
    let lower = s.lowercased()

    if lower == "+0.00000100000e0", let d = T("+0.00000100000") {
      return d
    }

    if lower == "+85886696878585969769557975866955695.e0",
      let d = T("+85886696878585969769557975866955695") {
      return d
    }

    if lower == "+9862472843996373385459829996945747934.44e0",
      let d = T("+9862472843996373385459829996945747934.44") {
      return d
    }

    XCTFail("Unable to parse \(T.self) from: \(s).", file: file, line: line)
    return T(s)
  }
}

// MARK: - Status

extension IntelMixin {

  func parseStatus(_ s: String, _ file: StaticString, _ line: UInt) -> DecimalStatus? {
    var s = s[...]

    if s.starts(with: "0x") {
      s = s.dropFirst(2)
    }

    guard let int = Int32(s, radix: 16) else {
      XCTFail("Unable to parse status from \(s).", file: file, line: line)
      return nil
    }

    func isSet(_ n: Int32, _ flag: Int32) -> Bool {
      return (int & flag) == flag
    }

    var result = DecimalStatus()

    if isSet(int, BID_INVALID_EXCEPTION) { result.set(.isInvalidOperation) }
    if isSet(int, BID_DENORMAL_EXCEPTION) { result.set(.isBinaryFloatingPointSubnormal) }
    if isSet(int, BID_ZERO_DIVIDE_EXCEPTION) { result.set(.isDivisionByZero) }
    if isSet(int, BID_OVERFLOW_EXCEPTION) { result.set(.isOverflow) }
    if isSet(int, BID_UNDERFLOW_EXCEPTION) { result.set(.isUnderflow) }
    if isSet(int, BID_INEXACT_EXCEPTION) { result.set(.isInexact) }

    return result
  }
}

// MARK: - Other

extension IntelMixin {

  func parseRounding(
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) -> DecimalFloatingPointRoundingRule? {
    // Intel:
    // char *roundstr_bid[] = { "half_even", "down", "up", "zero", "half_away" };
    //
    // In main:
    //  sscanf(line, "%s %d %s %s %s %s %x", funcstr, &rnd_mode, …)
    //  strcpy (rounding, roundstr_bid[rnd_mode]);

    switch s {
    case "0": return .toNearestOrEven
    case "1": return .down
    case "2": return .up
    case "3": return .towardZero
    case "4": return .toNearestOrAwayFromZero
    default:
      XCTFail("Unable to parse rounding from \(s).", file: file, line: line)
      return nil
    }
  }

  /// Double ??:
  /// - Outer -> parsing succeeded or not
  /// - Inner -> value
  func parseUlp(_ s: String?, _ file: StaticString, _ line: UInt) -> Double?? {
    guard let s = s else {
      return .some(nil)
    }

    if let d = Double(s) {
      return .some(d)
    }

    XCTFail("Unable to parse Ulp from \(s) (as Double).", file: file, line: line)
    return nil
  }

  func parseLongIntSize(_ s: String?, _ file: StaticString, _ line: UInt) -> Int? {
    if let s = s {
      assert(
        ["00", "01", "28", "30"].contains(s),
        "Unexpected LongIntSize: \(s)."
      )
    }

    // Never used -> value does not matter.
    return 0
  }
}
