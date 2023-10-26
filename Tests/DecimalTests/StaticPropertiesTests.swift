import XCTest
@testable import Decimal

class StaticPropertiesTests: XCTestCase, DecimalTests {

  // MARK: - 0, 1

  func test_zero() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let plus = T.zero
      XCTAssert(plus.isZero, file: file, line: line)
      XCTAssert(plus.isCanonical, file: file, line: line)

      guard let fromInt: T = self.createExact(0) else { return }
      self.assertEqual(plus, fromInt, file, line)

      self.assertUnpackFinite(
        plus,
        sign: .plus,
        biasedExponent: T.exponentBias,
        significand: 0,
        file,
        line
      )

      let minus = -T.zero
      XCTAssert(minus.isZero, file: file, line: line)
      XCTAssert(minus.isCanonical, file: file, line: line)

      self.assertEqual(minus, -fromInt, file, line)

      self.assertUnpackFinite(
        minus,
        sign: .minus,
        biasedExponent: T.exponentBias,
        significand: 0,
        file,
        line
      )
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_one() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let d = T._one

      guard let expected: T = self.createExact(1) else { return }
      self.assertEqual(d, expected, file, line)

      self.assertUnpackFinite(
        d,
        sign: .plus,
        biasedExponent: T.exponentBias,
        significand: 1,
        file,
        line
      )
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - NaN, infinity

  func test_nan() {
    func testNaN<T: DecimalFloatingPoint & DecimalMixin>(
      _ d: T,
      message: String,
      file: StaticString,
      line: UInt
    ) {
      XCTAssert(d.isNaN, message + ".isNaN", file: file, line: line)
      XCTAssert(!d.isSignalingNaN, message + ".isSignalingNaN", file: file, line: line)
      XCTAssert(d.isCanonical, message + ".isCanonical", file: file, line: line)
    }

    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let nan = T.nan
      testNaN(nan, message: "nan", file: file, line: line)
      testNaN(-nan, message: "-nan", file: file, line: line)

      let payload = T(nan: 123, signaling: false)
      testNaN(payload, message: "nan(…)", file: file, line: line)
      testNaN(-payload, message: "-nan(…)", file: file, line: line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_snan() {
    func testNaN<T: DecimalFloatingPoint & DecimalMixin>(
      _ d: T,
      message: String,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      XCTAssert(d.isNaN, message + ".isNaN", file: file, line: line)
      XCTAssert(d.isSignalingNaN, message + ".isSignalingNaN", file: file, line: line)
      XCTAssert(d.isCanonical, message + ".isCanonical", file: file, line: line)
    }

    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let nan = T._signalingNaN
      testNaN(nan, message: "snan", file: file, line: line)
      testNaN(-nan, message: "-snan", file: file, line: line)

      let payload = T(nan: 123, signaling: true)
      testNaN(payload, message: "snan(…)", file: file, line: line)
      testNaN(-payload, message: "-snan(…)", file: file, line: line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_infinity() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let plus = T.infinity
      XCTAssert(plus.isInfinite, file: file, line: line)
      XCTAssert(plus.isCanonical, file: file, line: line)

      let minus = -T.infinity
      XCTAssert(minus.isInfinite, file: file, line: line)
      XCTAssert(minus.isCanonical, file: file, line: line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Limits

  func test_limits() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let greatestFinite = T.greatestFiniteMagnitude
      self.assertEqual(
        greatestFinite,
        T.infinity.nextDown,
        "greatestFiniteMagnitude",
        file,
        line
      )

      let leastNormal = T.leastNormalMagnitude
      XCTAssert(
        leastNormal.isNormal,
        "leastNormal.isNormal",
        file: file,
        line: line
      )
      XCTAssertFalse(
        leastNormal.nextDown.isNormal,
        "leastNormal.nextDown.isNormal",
        file: file,
        line: line
      )

      let leastNonzero = T.leastNonzeroMagnitude
      self.assertEqual(
        leastNonzero,
        T.zero.nextUp,
        "leastNonzero",
        file,
        line
      )
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - π

  /// From docs:
  /// This value is rounded toward zero to keep user computations with angles
  /// from inadvertently ending up in the wrong quadrant. A type that conforms
  /// to the `FloatingPoint` protocol provides the value for `pi` at its best
  /// possible precision.
  func test_pi() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      var status = DecimalStatus()
      // swiftlint:disable:next line_length
      let string = "3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647"

      guard let expected = T._parse(string, rounding: .towardZero, status: &status) else {
        XCTFail("Failed to parse π.", file: file, line: line)
        return
      }

      self.assertEqual(T.pi, expected, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }
}
