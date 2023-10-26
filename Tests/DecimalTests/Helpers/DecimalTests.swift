import XCTest
@testable import Decimal

protocol DecimalTests {}

extension DecimalTests {

  // MARK: - Properties

  static var roundingRules: [DecimalFloatingPointRoundingRule] {
    return [
      .up,
      .down,
      .towardZero,
      .toNearestOrEven,
      .toNearestOrAwayFromZero,
    ]
  }

  // MARK: - Create

  func createExact<T: DecimalFloatingPoint & DecimalMixin>(
    _ n: Int,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> T? {
    var status = DecimalStatus()
    let result = T._init(n, rounding: .towardZero, status: &status)
    return self.returnExact(result, status: status)
  }

  func createExact<T: DecimalFloatingPoint & DecimalMixin>(
    _ s: String,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> T? {
    var status = DecimalStatus()

    guard let result = T._parse(s, rounding: .towardZero, status: &status) else {
      XCTFail("[createExact(\(T.self))] Unable to parse '\(s)'.", file: file, line: line)
      return nil
    }

    return self.returnExact(result, status: status)
  }

  private func returnExact<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    status: DecimalStatus,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> T? {
    if !status.isEmpty {
      XCTFail("[createExact(\(T.self))] Status: \(status)", file: file, line: line)
      return nil
    }

    return d
  }

  // MARK: - Generate

  /// The real count is a multiple of `T.precisionInDigits`.
  func generateDecimals<T: DecimalMixin>(
    approximateCount: Int,
    seed: RandomDecimalGenerator<T>.Seed? = nil
  ) -> [T] {
    // We will generate at least 1 number per each digit in 'precision'.
    // For example: if the precision is 7 we will generate significands with
    // 1,2,3,4,5,6,7 digits.
    var result = [T]()
    var generator = RandomDecimalGenerator<T>(seed: seed)
    let countPerExponent = Swift.max(1, approximateCount / T.precisionInDigits)

    for i in 0..<T.precisionInDigits {
      for _ in 0..<countPerExponent {
        let d = generator.next(significandDigitCount: i + 1)
        result.append(d)
      }
    }

    return result
  }

  func generateNaNs<T: DecimalMixin>(
    count: Int,
    seed: RandomDecimalGenerator<T>.Seed? = nil
  ) -> [T] {
    var result = [T]()
    var generator = RandomDecimalGenerator<T>(seed: seed)

    for _ in 0..<count {
      let nan = generator.nextNaN()
      result.append(nan)
    }

    return result
  }

  // MARK: - Assert status

  func assertStatus(
    _ lhs: DecimalStatus,
    _ rhs: DecimalStatus,
    _ message: String, // Message is required
    _ file: StaticString,
    _ line: UInt
  ) {
    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
  }

  func assertStatusIsEmpty(
    _ status: DecimalStatus,
    _ message: String, // Message is required
    _ file: StaticString,
    _ line: UInt
  ) {
    let expected = DecimalStatus()
    XCTAssertEqual(status, expected, message, file: file, line: line)
  }

  // MARK: - Assert decimal

  func assertQuietNaN<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    self.assertQuietNaN(d, "", file, line)
  }

  func assertQuietNaN<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ message: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    if !d.isQuietNaN {
      XCTFail(message, file: file, line: line)
    }
  }

  /// Equal via `==`.
  func assertEqualByEqualEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    self.assertEqualByEqualEqual(lhs, rhs, "", file, line)
  }

  /// Equal via `==`.
  func assertEqualByEqualEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ message: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
  }

  /// Bid equality.
  /// This is what you should use most of the time.
  func assertEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    self.assertEqual(lhs, rhs, "", file, line)
  }

  /// Bid equality.
  /// This is what you should use most of the time.
  func assertEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ message: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    let m = self.createMessage("\(lhs) == \(rhs) (BID)", message)
    XCTAssertEqual(lhs.bid, rhs.bid, m, file: file, line: line)
  }

  // MARK: - Assert unpack

  func assertUnpackFinite<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    sign: T.Sign,
    biasedExponent: Int,
    significand: T.BID,
    _ file: StaticString,
    _ line: UInt
  ) {
    if !d.isFinite {
      XCTFail("Not finite: \(d)", file: file, line: line)
      return
    }

    let unpack = d._unpackFiniteOrZero()

    let e = unpack.exponent.biased
    XCTAssertEqual(
      Int(e),
      biasedExponent,
      "\(d) - Biased exponent",
      file: file,
      line: line
    )

    let s = unpack.significand.valueCanonicalOrNot
    XCTAssertEqual(
      s,
      significand,
      "\(d) - Significand",
      file: file,
      line: line
    )
  }

  // MARK: - Parse

  /// You can also use `T._packWithoutChecks`.
  func parseExact<T: DecimalFloatingPoint & DecimalMixin>(
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) -> T? {
    var status = DecimalStatus()

    guard let d = T(s, rounding: .towardZero, status: &status) else {
      XCTFail("Parse failed: " + s, file: file, line: line)
      return nil
    }

    if status.isInexact {
      XCTFail("Inexact parse: " + s, file: file, line: line)
      return nil
    }

    return d
  }

  // MARK: - Helpers

  private func createMessage(_ optional: String?) -> String {
    return optional ?? ""
  }

  private func createMessage(_ s: String, _ optional: String?) -> String {
    guard let o = optional else {
      return s
    }

    if s.isEmpty {
      return o
    }

    return s + ": " + o
  }
}
