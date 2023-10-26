import XCTest
@testable import Decimal

private func assertDouble(_ d: Double, _ expected: Double) {
  let s = String(d)
  let e = String(expected)
  Swift.print(s, s == e ? "🟢" : "🔴")
}

class UnaryTests: XCTestCase, DecimalTests {

  // MARK: - sNaN

/*
  // [Swift bug] This test is VERY unstable
  func test_snan_double() {
    let plus = Double.signalingNaN
    let minus = -Double.signalingNaN

    //                                          code below commented | code below uncommented
    print(+plus, (+plus).bitPattern)   //  snan  9219994337134247936 | snan 9219994337134247936
    print(+minus, (+minus).bitPattern) // -snan 18443366373989023744 |  nan 9222246136947933184
    print(-plus, (-plus).bitPattern)   // -snan 18443366373989023744 |  nan 9222246136947933184
    print(-minus, (-minus).bitPattern) //  snan  9219994337134247936 |  nan 9222246136947933184

    // This is the 'code below':
    // XCTAssertEqual((+plus).bitPattern, Double(signOf: +1, magnitudeOf: plus).bitPattern)
    // XCTAssertEqual((+minus).bitPattern, Double(signOf: -1, magnitudeOf: plus).bitPattern)
    // XCTAssertEqual((-plus).bitPattern, Double(signOf: -1, magnitudeOf: plus).bitPattern)
    // XCTAssertEqual((-minus).bitPattern, Double(signOf: +1, magnitudeOf: plus).bitPattern)
  }
*/

  /// IEEE: NaN (section 6.2)
  /// Swift: sNaN
  func test_snan() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let plus = T.signalingNaN
      let minus = -T.signalingNaN

      self.assertEqual(+plus, T(signOf: +1, magnitudeOf: plus), file, line)
      self.assertEqual(+minus, T(signOf: -1, magnitudeOf: plus), file, line)

      self.assertEqual(-plus, T(signOf: -1, magnitudeOf: plus), file, line)
      self.assertEqual(-minus, T(signOf: +1, magnitudeOf: plus), file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Zero

  func test_zero_double() {
    let plus = 0.0
    let minus = -0.0

    assertDouble(+plus, Double(signOf: +1, magnitudeOf: plus))
    assertDouble(+minus, Double(signOf: -1, magnitudeOf: plus))

    assertDouble(-plus, Double(signOf: -1, magnitudeOf: plus))
    assertDouble(-minus, Double(signOf: +1, magnitudeOf: plus))
  }

  /// IEEE: ???
  /// Swift:
  func test_zero() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let plus = T.zero
      let minus = -T.zero

      self.assertEqual(+plus, T(signOf: +1, magnitudeOf: plus), file, line)
      self.assertEqual(+minus, T(signOf: -1, magnitudeOf: plus), file, line)

      self.assertEqual(-plus, T(signOf: -1, magnitudeOf: plus), file, line)
      self.assertEqual(-minus, T(signOf: +1, magnitudeOf: plus), file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }
}
