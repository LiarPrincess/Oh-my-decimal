import XCTest
@testable import Decimal

private func assertDouble(_ d: Double, _ expected: String...) {
  let s = String(d)
  let isExpected = expected.contains { $0 == s }
  Swift.print(s, isExpected ? "🟢" : "🔴")
}

private func assertDouble(_ d: Double, _ expected: Double) {
  let e = String(expected)
  assertDouble(d, e)
}

class PropertiesTests: XCTestCase, DecimalTests {

  // MARK: - Abs

  func test_magnitude_nan_double() {
    // IEEE 754: sign does not matter
    // Swift: always positive
    let nan = Double.nan
    assertDouble(nan.magnitude, "nan")
    assertDouble((+nan).magnitude, "nan")
    assertDouble((-nan).magnitude, "nan")

    // IEEE 754: returns nan with whatever sign + invalid operation
    // Swift: positive nan/snan
    let snan = Double.signalingNaN
    assertDouble(snan.magnitude, "nan", "snan")
    assertDouble((+snan).magnitude, "nan", "snan")
    assertDouble((-snan).magnitude, "nan", "snan")
  }

  func test_magnitude_nan() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let nan = T.nan
      self.assertEqual(nan.magnitude, nan, file, line)
      self.assertEqual((-nan).magnitude, nan, file, line)

      let snan = T.signalingNaN
      self.assertEqual(snan.magnitude, snan, file, line)
      self.assertEqual((-snan).magnitude, snan, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - ULP

  // Check how 'Double' works, so we can reproduce it.
  func test_ulp_double() {
    // NaN
    let nan = Double.nan
    assertDouble((+nan).ulp, "nan")
    assertDouble((-nan).ulp, "nan")

    let payload = Double(nan: 123, signaling: false)
    assertDouble((+payload).ulp, "nan")
    assertDouble((-payload).ulp, "nan")

    // Signaling NaN
    let snan = Double.signalingNaN
    assertDouble((+snan).ulp, "nan")
    assertDouble((-snan).ulp, "nan")

    let sPayload = Double(nan: 123, signaling: true)
    assertDouble((+sPayload).ulp, "nan")
    assertDouble((-sPayload).ulp, "nan")

    // Infinity
    let inf = Double.infinity
    assertDouble((+inf).ulp, "nan")
    assertDouble((-inf).ulp, "nan")

    // Zero
    let zero = Double.zero
    assertDouble((+zero).ulp, Double.leastNonzeroMagnitude)
    assertDouble((-zero).ulp, Double.leastNonzeroMagnitude)

    // greatestFinite
    let greatestFinite = Double.greatestFiniteMagnitude
    let greatestFiniteExpected = greatestFinite.nextDown.ulp
    assertDouble((+greatestFinite).ulp, greatestFiniteExpected)
    assertDouble((-greatestFinite).ulp, greatestFiniteExpected)

    // Finite
    func assertDoubleBySubtraction(
      _ d: Double,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let unsigned = d.magnitude

      let expected = unsigned == Double.greatestFiniteMagnitude ?
        unsigned - unsigned.nextDown :
        unsigned.nextUp - unsigned

      assertDouble(d.ulp, expected)
    }

    var d = 1.0

    for _ in 0..<10 {
      assertDoubleBySubtraction(d)
      assertDoubleBySubtraction(d.nextDown)
      assertDoubleBySubtraction(d.nextUp)

      assertDoubleBySubtraction((-d))
      assertDoubleBySubtraction((-d).nextDown)
      assertDoubleBySubtraction((-d).nextUp)

      // Go to the next number (most important!)
      d *= 2
    }
  }

  func test_ulp_nan() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      // NaN
      let nan = T.nan
      self.assertQuietNaN((+nan).ulp, "+nan", file, line)
      self.assertQuietNaN((-nan).ulp, "-nan", file, line)

      let payload = T(nan: 123, signaling: false)
      self.assertQuietNaN((+payload).ulp, file, line)
      self.assertQuietNaN((-payload).ulp, file, line)

      // Signaling NaN
      let snan = T.signalingNaN
      self.assertQuietNaN((+snan).ulp, file, line)
      self.assertQuietNaN((-snan).ulp, file, line)

      let sPayload = T(nan: 123, signaling: true)
      self.assertQuietNaN((+sPayload).ulp, file, line)
      self.assertQuietNaN((-sPayload).ulp, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_ulp_infinity() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      self.assertQuietNaN((+T.infinity).ulp, file, line)
      self.assertQuietNaN((-T.infinity).ulp, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_ulp_zero() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let leastNonzero = T.leastNonzeroMagnitude
      self.assertEqual((+T.zero).ulp, leastNonzero, "+0", file, line)
      self.assertEqual((-T.zero).ulp, leastNonzero, "-0", file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_ulp_greatestFiniteMagnitude() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let greatestFinite = T.greatestFiniteMagnitude
      let expected = greatestFinite.nextDown.ulp

      self.assertEqual((+greatestFinite).ulp, expected, "Plus", file, line)
      self.assertEqual((-greatestFinite).ulp, expected, "Minus", file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_ulp_finite() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let min = -15
      let max = 15

      for e in min..<max {
        let d = T._packWithoutChecks(sign: .plus, significand: 1, signedExponent: e)

        self.assertEqualUlpBySubtraction(d, file, line)
        self.assertEqualUlpBySubtraction(d.nextDown, file, line)
        self.assertEqualUlpBySubtraction(d.nextUp, file, line)

        self.assertEqualUlpBySubtraction((-d), file, line)
        self.assertEqualUlpBySubtraction((-d).nextDown, file, line)
        self.assertEqualUlpBySubtraction((-d).nextUp, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_ulp_finite_lowExponent() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let min = T.minSignedExponent
      let max = min + T.precisionInDigits + 1

      for e in min..<max {
        let d = T._packWithoutChecks(sign: .plus, significand: 1, signedExponent: e)

        self.assertEqualUlpBySubtraction(d, file, line)
        self.assertEqualUlpBySubtraction(d.nextDown, file, line)
        self.assertEqualUlpBySubtraction(d.nextUp, file, line)

        self.assertEqualUlpBySubtraction((-d), file, line)
        self.assertEqualUlpBySubtraction((-d).nextDown, file, line)
        self.assertEqualUlpBySubtraction((-d).nextUp, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_ulp_finite_differentCohorts() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      for d: T in self.generateDecimals(approximateCount: 50) {
        let expected = self.getUlpBySubtraction(d, file, line)
        self.assertEqual(d.ulp, expected, "\(d)", file, line)

        let cohorts = CohortGenerator(finiteOrZero: d)

        if let inc = cohorts.incrementExponent(allowInexact: false) {
          self.assertEqual(inc.ulp, expected, "\(d) -> \(inc)", file, line)
        }

        if let dec = cohorts.decrementExponent() {
          self.assertEqual(dec.ulp, expected, "\(d) -> \(dec)", file, line)
        }
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  private func assertEqualUlpBySubtraction<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    let expected = self.getUlpBySubtraction(d, file, line)
    XCTAssertEqual(d.ulp, expected, "\(d)", file: file, line: line)
  }

  private func getUlpBySubtraction<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ file: StaticString,
    _ line: UInt
  ) -> T {
    assert(d.isFinite)

    let lhs: T
    let rhs: T
    let magnitude = d.magnitude
    var status = DecimalStatus()

    if magnitude.bid == T.greatestFiniteMagnitude.bid {
      lhs = magnitude
      rhs = magnitude._nextDown(status: &status)
    } else {
      lhs = magnitude._nextUp(status: &status)
      rhs = magnitude
    }

    // Next can only signal on signaling NaN, and we have already handled it.
    XCTAssert(
      status.isEmpty,
      "\(d).ulp: next signalled an exception.",
      file: file,
      line: line
    )

    // Rounding does not matter, because it should never round.
    // Any other status should also not happen.
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    let result = lhs._subtracting(other: rhs, rounding: rounding, status: &status)

    XCTAssert(
      status.isEmpty,
      "\(d).ulp: subtraction signalled an exception.",
      file: file,
      line: line
    )

    return result
  }
}
