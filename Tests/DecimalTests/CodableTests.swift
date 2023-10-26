import XCTest
@testable import Decimal

class CodableTests: XCTestCase, DecimalTests {

  // MARK: - Encode

  func test_encode() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) where T.BitPattern == T.BID, T.Exponent == Int {
      let decimals: [T] = [
        T(nan: 0x123, signaling: false),
        T(nan: 0x123, signaling: true),
        T.infinity,
        T(sign: .plus, exponent: T.minSignedExponent, significand: T.zero),
        T(sign: .plus, exponent: 0, significand: T.zero),
        T(sign: .plus, exponent: T.maxSignedExponent, significand: T.zero),
        T.leastNonzeroMagnitude,
        T.leastNormalMagnitude,
        T.greatestFiniteMagnitude,
      ]

      // Encode: bid as Int
      for d in decimals {
        self.assertEncode(+d, file, line)
        self.assertEncode(-d, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  private func assertEncode<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(d)

      guard let result = String(data: data, encoding: .utf8) else {
        XCTFail("\(d): Unable to parse encoded JSON.")
        return
      }

      let expected = "\"" + String(d.bid) + "\""
      print(d, result)

      XCTAssertEqual(result, expected, "\(d)", file: file, line: line)
    } catch {
      XCTFail("\(d): \(error)")
    }
  }

  // MARK: - Encode -> decode

  func test_encodeDecode_nan() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) where T.BitPattern == T.BID {
      let payloads: [T.BitPattern] = [
        0,
        0x123,
        T.nanPayloadMask
      ]

      for p in payloads {
        let nan = T(nan: p, signaling: false)
        self.assertEncodeDecode(+nan, file, line)
        self.assertEncodeDecode(-nan, file, line)

        let snan = T(nan: p, signaling: true)
        self.assertEncodeDecode(+snan, file, line)
        self.assertEncodeDecode(-snan, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_encodeDecode_infinity() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let significand: [T.BID] = [
        0,
        0x123,
        T.maxDecimalDigits,
        T.trailingSignificandMask
      ]

      for s in significand {
        let d = T(unchecked: T.infinityMask | s)
        self.assertEncodeDecode(+d, file, line)
        self.assertEncodeDecode(-d, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_encodeDecode_zero() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) where T.Exponent == Int {
      let exponents: [T.Exponent] = [
        T.minSignedExponent,
        -42,
        0,
        42,
        T.maxSignedExponent
      ]

      for e in exponents {
        let d = T(sign: .plus, exponent: e, significand: 0)
        self.assertEncodeDecode(+d, file, line)
        self.assertEncodeDecode(-d, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_encodeDecode_finite() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) where T.BitPattern == T.BID, T.Exponent == Int {
      let significands: [T.BitPattern] = [
        0,
        0x123,
        T.maxDecimalDigits,
        T.trailingSignificandMask
      ]

      let exponents: [T.Exponent] = [
        T.minSignedExponent,
        -42,
        0,
        42,
        T.maxSignedExponent
      ]

      for (s, e) in CartesianProduct(significands, exponents) {
        let d = T._packWithoutChecks(sign: .plus, significand: s, signedExponent: e)
        self.assertEncodeDecode(+d, file, line)
        self.assertEncodeDecode(-d, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_encodeDecode_finite_random() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) where T.Exponent == Int {
      for d: T in self.generateDecimals(approximateCount: 100) {
        self.assertEncodeDecode(+d, file, line)
        self.assertEncodeDecode(-d, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  private func assertEncodeDecode<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(d)

      let decoder = JSONDecoder()
      let result = try decoder.decode(T.self, from: data)

      self.assertEqual(result, d, file, line)
    } catch {
      XCTFail("\(d): \(error)")
    }
  }
}
