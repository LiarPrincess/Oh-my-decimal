import XCTest
@testable import Decimal

extension SpeleotroveMixin {

  func parseDecimal32(_ s: String, _ file: StaticString, _ line: UInt) -> Decimal32? {
    var status = DecimalStatus()
    return self.parseDecimal(s, status: &status, file, line)
  }

  func parseDecimal64(_ s: String, _ file: StaticString, _ line: UInt) -> Decimal64? {
    var status = DecimalStatus()
    return self.parseDecimal(s, status: &status, file, line)
  }

  func parseDecimal128(_ s: String, _ file: StaticString, _ line: UInt) -> Decimal128? {
    var status = DecimalStatus()
    return self.parseDecimal(s, status: &status, file, line)
  }

  func parseDecimal<T: DecimalFloatingPoint>(
    _ s: String,
    status: inout DecimalStatus,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    return self.parseDecimal(s, rounding: .towardZero, status: &status, file, line)
  }

  func parseDecimal<T: DecimalFloatingPoint>(
    _ s: String,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    if s.starts(with: "#") {
      let sub = s.dropFirst()
      if let bid = T.BitPattern(sub, radix: 16) {
        return T(decimalEncoding: bid)
      }
    }

    if let d = T(s, rounding: .towardZero, status: &status) {
      return d
    }

    XCTFail("Unable to parse \(T.self) from: \(s).", file: file, line: line)
    return nil
  }
}
