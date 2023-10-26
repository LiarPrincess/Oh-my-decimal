import XCTest
@testable import Decimal

extension SpeleotroveMixin {

  /// Bid equality.
  /// This is what you should use most of the time.
  func assertEqual<T: DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    let m = self.createMessage("\(lhs) == \(rhs)", message)
    XCTAssertEqual(lhs.bid, rhs.bid, m, file: file, line: line)
  }

  /// Equal via `==`.
  func assertEqualByEqualEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    if lhs.isNaN || rhs.isNaN {
      let m = self.createMessage("\(lhs) == \(rhs)", message)
      XCTAssertEqual(lhs.bid, rhs.bid, m, file: file, line: line)
    } else {
      let m = self.createMessage(message)
      XCTAssertEqual(lhs, rhs, m, file: file, line: line)
    }
  }

  func assertCompare<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    status: inout DecimalStatus,
    expected: String,
    expectedStatus: DecimalStatus,
    _ file: StaticString,
    _ line: UInt
  ) {
    var expected = expected

    if expected != "-1" && expected != "0" && expected != "1" {
      var s = DecimalStatus()

      guard let e: T = self.parseDecimal(expected, status: &s, file, line) else {
        return
      }

      if e == T.zero {
        expected = "0"
      } else if e == T._one {
        expected = "1"
      } else if e == T._minusOne {
        expected = "-1"
      } else {
        assert(e.isNaN, "Compare result can be -1, 0, 1 or NaN. Got: \(e).")
      }
    }

    let expectedEqual = expected == "0"
    let expectedLess = expected == "-1"
    let expectedGreater = expected == "1"

    let isEqual = lhs.isEqual(to: rhs, status: &status)
    self.assertBool(isEqual, expectedEqual, file, line, "isEqual")
    self.assertStatus(status, expectedStatus, file, line, "isEqual")
    status.clearAll()

    let isLess = lhs.isLess(than: rhs, status: &status)
    self.assertBool(isLess, expectedLess, file, line, "isLess")
    self.assertStatus(status, expectedStatus, file, line, "isLess")
    status.clearAll()

    let isLessEqual = lhs.isLessThanOrEqualTo(rhs, status: &status)
    let expectedLessEqual = expectedEqual || expectedLess
    self.assertBool(isLessEqual, expectedLessEqual, file, line, "isLessEqual")
    self.assertStatus(status, expectedStatus, file, line, "isLessEqual")
    status.clearAll()

    let isGreater = rhs.isLess(than: lhs, status: &status)
    self.assertBool(isGreater, expectedGreater, file, line, "isGreater")
    self.assertStatus(status, expectedStatus, file, line, "isGreater")
    status.clearAll()

    let isGreaterEqual = rhs.isLessThanOrEqualTo(lhs, status: &status)
    let expectedGreaterEqual = expectedEqual || expectedGreater
    self.assertBool(isGreaterEqual, expectedGreaterEqual, file, line, "isGreaterEqual")
    self.assertStatus(status, expectedStatus, file, line, "isGreaterEqual")
    status.clearAll()
  }

  // https://speleotrove.com/decimal/daops.html#refnumcosi
  // We do not have this operation, but we want those tests.
  // Use only the public api!
  func assertCompareSignaling<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    status: inout DecimalStatus,
    expected: String,
    expectedStatus: DecimalStatus,
    _ file: StaticString,
    _ line: UInt
  ) {
    // compare-signal takes two operands and compares their values numerically.
    // This operation is identical to compare, except that if neither operand is
    // a signaling NaN then any quiet NaN operand is treated as though it were
    // a signaling NaN.
    // (That is, all NaNs signal, with signaling NaNs taking precedence over quiet NaNs.)
    func addSignalingBit(_ d: T) -> T {
      if d.isQuietNaN {
        return T(unchecked: d.bid | T.nanSignalingMask)
      }
      return d
    }

    let lhs = addSignalingBit(lhs)
    let rhs = addSignalingBit(rhs)

    self.assertCompare(
      lhs,
      rhs,
      status: &status,
      expected: expected,
      expectedStatus: expectedStatus,
      file,
      line
    )
  }

  func assertStatus(
    _ lhs: DecimalStatus,
    _ rhs: DecimalStatus,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    let m = self.createMessage(message)
    XCTAssertEqual(lhs, rhs, m, file: file, line: line)
  }

  func assertInt(
    _ lhs: Int,
    _ rhs: Int,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    let m = self.createMessage(message)
    XCTAssertEqual(lhs, rhs, m, file: file, line: line)
  }

  func assertTrue(
    _ value: Bool,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    let m = self.createMessage(message)
    XCTAssert(value, m, file: file, line: line)
  }

  func assertFalse(
    _ value: Bool,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    let m = self.createMessage(message)
    XCTAssertFalse(value, m, file: file, line: line)
  }

  func assertBool(
    _ lhs: Bool,
    _ rhs: Bool,
    _ file: StaticString,
    _ line: UInt,
    _ message: String? = nil
  ) {
    let m = self.createMessage(message)
    XCTAssertEqual(lhs, rhs, m, file: file, line: line)
  }

  // MARK: - Helpers

  private func createMessage(_ optional: String?) -> String {
    return optional ?? ""
  }

  private func createMessage(_ s: String, _ optional: String?) -> String {
    if let o = optional {
      return s + ": " + o
    }

    return s
  }
}
