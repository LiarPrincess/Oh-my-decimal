import XCTest
@testable import Decimal

class LogScaleTests: XCTestCase, DecimalTests {

  // MARK: - Scale - exponent overflow

  func test_scale_exponentOverflow() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      guard let e0 = T("3E0", rounding: .towardZero),
            let e5 = T("3E5", rounding: .towardZero),
            let e_5 = T("3E-5", rounding: .towardZero) else {
        XCTFail("Parsing failed", file: file, line: line)
        return
      }

      typealias Input = (d: T, exponent: T.Exponent)
      typealias Rounding = (rounding: DecimalFloatingPointRoundingRule, expected: T)

      let cases: [Input] = [
        (e0, .max), // max
        (e0, .max - 5), // below max
        (e5, .max), // T.Exponent overflow
        (e5, .max - 5), // max
        (e5, .max - 10), // below max
        (e_5, .max), // below max
      ]

      let roundings: [Rounding] = [
        (.toNearestOrEven, T.infinity),
        (.toNearestOrAwayFromZero, T.infinity),
        (.up, T.infinity),
        (.down, T.greatestFiniteMagnitude),
        (.towardZero, T.greatestFiniteMagnitude)
      ]

      for (d, exponent) in cases {
        for (rounding, expected) in roundings {
          var status = DecimalStatus()
          let result = T(
            sign: .plus,
            exponent: exponent,
            significand: d,
            rounding: rounding,
            status: &status
          )

          let m = "\(d) + \(exponent), \(rounding)"
          self.assertEqual(result, expected, m, file, line)
        }
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_scale_exponentUnderflow() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      guard let e0 = T("3E0", rounding: .towardZero),
            let e5 = T("3E5", rounding: .towardZero),
            let e_5 = T("3E-5", rounding: .towardZero) else {
        XCTFail("Parsing failed", file: file, line: line)
        return
      }

      typealias Input = (d: T, exponent: T.Exponent)
      typealias Rounding = (rounding: DecimalFloatingPointRoundingRule, expected: T)

      let cases: [Input] = [
        (e0, .min), // min
        (e0, .min + 5), // above min
        (e_5, .min), // T.Exponent overflow
        (e_5, .min + 5), // min
        (e_5, .min + 10), // above min
        (e5, .min), // above min
      ]

      let minSignedExponent = T.Exponent(T.minSignedExponent)
      let zero = T(sign: .plus, exponent: minSignedExponent, significand: T.zero)

      let roundings: [Rounding] = [
        (.toNearestOrEven, zero),
        (.toNearestOrAwayFromZero, zero),
        (.up, T.leastNonzeroMagnitude),
        (.down, zero),
        (.towardZero, zero)
      ]

      for (d, exponent) in cases {
        for (rounding, expected) in roundings {
          var status = DecimalStatus()
          let result = T(
            sign: .plus,
            exponent: exponent,
            significand: d,
            rounding: rounding,
            status: &status
          )

          let m = "\(d) + \(exponent), \(rounding)"
          self.assertEqual(result, expected, m, file, line)
        }
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Destruct + restore

  private static let destructRestoreStrings = [
    "inf",
    "nan",
    "nan(0x12)",
    "snan",
    "snan(0x12)",
    "0",
    "1",
    "4",
    "123",
    "0.123",
    "0.0123",
    "0.00123",
    "1.234",
    "12.34",
    "123.4",
    "123.0",
  ]

  func test_destructRestore() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      for s in Self.destructRestoreStrings {
        if let d = T(s) {
          self.assertDestructRestoreEqual(+d, file, line)
          self.assertDestructRestoreEqual(-d, file, line)
        } else {
          XCTFail(s, file: file, line: line)
        }
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_destructRestore_generated() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      for d: T in self.generateDecimals(approximateCount: 1000) {
        self.assertDestructRestoreEqual(+d, file, line)
        self.assertDestructRestoreEqual(-d, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  private func assertDestructRestoreEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    let sign = d.sign
    let exponent = d.exponent
    let significand = d.significand
    var status = DecimalStatus()

    let result = T(
      sign: sign,
      exponent: exponent,
      significand: significand,
      rounding: .towardZero,
      status: &status
    )

    // 0.exponent = Int.min
    if result.isZero && d.isZero {
      self.assertEqualByEqualEqual(result, d, file, line)
    } else {
      self.assertEqual(result, d, file, line)
    }

    self.assertStatusIsEmpty(status, String(describing: d), file, line)
  }
}
