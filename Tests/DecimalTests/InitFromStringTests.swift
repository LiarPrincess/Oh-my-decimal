import XCTest
@testable import Decimal

// swiftlint:disable comma

private func assertDouble(_ s: String, _ expected: Double?) {
  switch (Double(s), expected) {
  case let (.some(d), .some(e)):
    let dString = String(d)
    let eString = String(e)

    if dString == eString {
      Swift.print("'\(s)' -> \(dString) 🟢")
    } else {
      Swift.print("'\(s)' -> \(dString), expected: \(eString) 🔴")
    }
  case let (.some(d), nil):
    Swift.print("'\(s)' -> \(d), expected: nil 🔴")
  case let (nil, .some(e)):
    Swift.print("'\(s)' -> nil, expected: \(e) 🔴")
  case (nil, nil):
    Swift.print("'\(s)' -> nil 🟢")
  }
}

class InitFromStringTests: XCTestCase, DecimalTests {

  // MARK: - Empty

  func test_empty_double() {
    assertDouble("", nil)
  }

  func test_empty() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      for rounding in Self.roundingRules {
        self.assertParseFailed(T.self, "", rounding: rounding, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - NaN

  // Check how 'Double' works, so we can reproduce it.
  func test_nan_double() {
    // NaN
    assertDouble("nan", Double.nan)
    assertDouble("-nan", Double.nan)

    // Ignore case
    assertDouble("nAN", Double.nan)
    assertDouble("-nAN", Double.nan)

    // With additional characters
    assertDouble("nanan", nil)
    assertDouble("-nanan", nil)

    // Payload
    assertDouble("nan(0x7b)", Double(nan: 123, signaling: false))
    assertDouble("-nan(0x7b)", Double(nan: 123, signaling: false))

    // Payload - too big
    assertDouble("nan(0xffffffffffffffff)", Double(nan: 0x3ffffffffffff, signaling: false))
    assertDouble("-nan(0xffffffffffffffff)", Double(nan: 0x3ffffffffffff, signaling: false))

    // Payload - invalid characters
    assertDouble("nan(zzz)", Double.nan)
    assertDouble("-nan(zzz)", Double.nan)

    // Payload - no close paren
    assertDouble("nan(0x7b", nil)
    assertDouble("-nan(0x7b", nil)

    // Payload - invalid characters + no close paren
    assertDouble("nan(zzz", nil)
    assertDouble("-nan(zzz", nil)

    // Payload - with additional characters
    assertDouble("nan(0x7b)zzz", nil)
    assertDouble("-nan(0x7b)zzz", nil)
  }

  func test_nan() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      // NaN
      self.assertParseNaN("nan", T.nan, file, line)
      self.assertParseNaN("-nan", -T.nan, file, line)

      // Ignore case
      self.assertParseNaN("nAN", T.nan, file, line)
      self.assertParseNaN("-nAN", -T.nan, file, line)

      // Too long
      self.assertParseFailed(T.self, "nanan", file, line)
      self.assertParseFailed(T.self, "-nanan", file, line)

      // Payload
      let nan123 = T(nan: 123, signaling: false)
      self.assertParseNaN("nan(123)", nan123, file, line)
      self.assertParseNaN("-nan(123)", -nan123, file, line)
      self.assertParseNaN("nan(0x7b)", nan123, file, line)
      self.assertParseNaN("-nan(0x7b)", -nan123, file, line)

      // Payload - too big
      let n999 = String(repeating: "9", count: 100)
      let bigPayload = T(unchecked: T.nanQuietMask | T.nanPayloadMask)
      self.assertParseNaN("nan(\(n999))", bigPayload, file, line)
      self.assertParseNaN("-nan(\(n999))", -bigPayload, file, line)
      self.assertParseNaN("nan(0x\(n999))", bigPayload, file, line)
      self.assertParseNaN("-nan(0x\(n999))", -bigPayload, file, line)

      // Payload - invalid characters
      self.assertParseNaN("nan(zzz)", T.nan, file, line)
      self.assertParseNaN("-nan(zzz)", -T.nan, file, line)
      self.assertParseNaN("nan(0xzzz)", T.nan, file, line)
      self.assertParseNaN("-nan(0xzzz)", -T.nan, file, line)

      // Payload - no close paren
      self.assertParseFailed(T.self, "nan(0x7b", file, line)
      self.assertParseFailed(T.self, "-nan(0x7b", file, line)

      // Payload - invalid characters + no close paren
      self.assertParseFailed(T.self, "nan(zzz", file, line)
      self.assertParseFailed(T.self, "-nan(zzz", file, line)

      // Payload - with additional characters
      self.assertParseFailed(T.self, "nan(0x7b)zzz", file, line)
      self.assertParseFailed(T.self, "-nan(0x7b)zzz", file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_nan_toString_toDecimal() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      for nan: T in self.generateNaNs(count: 20) {
        let string = String(nan)
        self.assertParseNaN(string, nan, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Zero

  /// A lot of '0' in the beginning of the significand!
  func test_zero_inSignificandPrefix() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let zeros = String(repeating: "0", count: 50)

      // Tested strings, '_' means negative
      let zero = zeros //  0000000000
      let _zero = "-" + zeros // -0000000000
      let zeroE7 = zeros + "E7" //  0000000000E7
      let _zeroE7 = "-" + zeros + "E7" // -0000000000E7

      let three = zeros + "3" //  00000000003
      let _three = "-" + zeros + "3" // -00000000003
      let threeE7 = zeros + "3E7" //  00000000003E7
      let _threeE7 = "-" + zeros + "3E7" // -00000000003E7

      let expectedZero = T.zero
      let expectedThree = T(3)
      guard let expectedZeroE7: T = self.parseExact("0E7", file, line) else { return }
      guard let expectedThreeE7: T = self.parseExact("3E7", file, line) else { return }
      let noFlags = DecimalStatus()

      for r in Self.roundingRules {
        self.assertParse(zero,    r, expected:  expectedZero,   noFlags, file, line)
        self.assertParse(_zero,   r, expected: -expectedZero,   noFlags, file, line)
        self.assertParse(zeroE7,  r, expected:  expectedZeroE7, noFlags, file, line)
        self.assertParse(_zeroE7, r, expected: -expectedZeroE7, noFlags, file, line)

        self.assertParse(three,    r, expected:  expectedThree,   noFlags, file, line)
        self.assertParse(_three,   r, expected: -expectedThree,   noFlags, file, line)
        self.assertParse(threeE7,  r, expected:  expectedThreeE7, noFlags, file, line)
        self.assertParse(_threeE7, r, expected: -expectedThreeE7, noFlags, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  /// A lot of '0' in the beginning of the exponent!
  func test_zero_inExponentPrefix() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let significand = "123"
      let zeroCount = 2 * Self.exponentParseMaxDigitCount
      let exponent1 = String(repeating: "0", count: zeroCount)

      // A lot of '0'
      let plusPlus1 = significand + "E" + exponent1
      let plusMinus1 = significand + "E-" + exponent1
      let minusPlus1 = "-" + significand + "E" + exponent1
      let minusMinus1 = "-" + significand + "E-" + exponent1

      // A lot of '0' and digit after
      let plusPlus2 = plusPlus1 + "7"
      let plusMinus2 = plusMinus1 + "7"
      let minusPlus2 = minusPlus1 + "7"
      let minusMinus2 = minusMinus1 + "7"

      let expected1 = T(123)
      guard let expected2Plus: T = self.parseExact("123E7", file, line) else { return }
      guard let expected2Minus: T = self.parseExact("123E-7", file, line) else { return }
      let noFlags = DecimalStatus()

      for r in Self.roundingRules {
        self.assertParse(plusPlus1,   r, expected:  expected1, noFlags, file, line)
        self.assertParse(plusMinus1,  r, expected:  expected1, noFlags, file, line)
        self.assertParse(minusPlus1,  r, expected: -expected1, noFlags, file, line)
        self.assertParse(minusMinus1, r, expected: -expected1, noFlags, file, line)

        self.assertParse(plusPlus2,   r, expected:  expected2Plus,  noFlags, file, line)
        self.assertParse(plusMinus2,  r, expected:  expected2Minus, noFlags, file, line)
        self.assertParse(minusPlus2,  r, expected: -expected2Plus,  noFlags, file, line)
        self.assertParse(minusMinus2, r, expected: -expected2Minus, noFlags, file, line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Overflow

  /// A lot of digits in significand.
  func test_significandOverflow() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      // All precision digits. Start with 5, tons of 0…, end with 3 (odd).
      // 5000000000000003E+0
      let zeros = String(repeating: "0", count: T.precisionInDigits - 2)
      let s = "5" + zeros + "3"
      let sNext = "5" + zeros + "4"

      // Tested strings, '_' means negative
      let belowHalf = s + "420"
      let half = s + "500"
      let aboveHalf = s + "501"
      let _belowHalf = "-" + belowHalf
      let _half = "-" + half
      let _aboveHalf = "-" + aboveHalf

      // Expected
      guard let noRounding: T = self.parseExact(s + "E3", file, line) else { return }
      guard let awayFromZero: T = self.parseExact(sNext + "E3", file, line) else { return }
      let inexact = DecimalStatus.isInexact

      var r = DecimalFloatingPointRoundingRule.up
      self.assertParse(belowHalf,  r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(half,       r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(aboveHalf,  r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(_belowHalf, r, expected: -noRounding,   inexact, file, line)
      self.assertParse(_half,      r, expected: -noRounding,   inexact, file, line)
      self.assertParse(_aboveHalf, r, expected: -noRounding,   inexact, file, line)

      r = .down
      self.assertParse(belowHalf,  r, expected:  noRounding,   inexact, file, line)
      self.assertParse(half,       r, expected:  noRounding,   inexact, file, line)
      self.assertParse(aboveHalf,  r, expected:  noRounding,   inexact, file, line)
      self.assertParse(_belowHalf, r, expected: -awayFromZero, inexact, file, line)
      self.assertParse(_half,      r, expected: -awayFromZero, inexact, file, line)
      self.assertParse(_aboveHalf, r, expected: -awayFromZero, inexact, file, line)

      r = .towardZero
      self.assertParse(belowHalf,  r, expected:  noRounding, inexact, file, line)
      self.assertParse(half,       r, expected:  noRounding, inexact, file, line)
      self.assertParse(aboveHalf,  r, expected:  noRounding, inexact, file, line)
      self.assertParse(_belowHalf, r, expected: -noRounding, inexact, file, line)
      self.assertParse(_half,      r, expected: -noRounding, inexact, file, line)
      self.assertParse(_aboveHalf, r, expected: -noRounding, inexact, file, line)

      r = .toNearestOrEven
      self.assertParse(belowHalf,  r, expected:  noRounding,   inexact, file, line)
      self.assertParse(half,       r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(aboveHalf,  r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(_belowHalf, r, expected: -noRounding,   inexact, file, line)
      self.assertParse(_half,      r, expected: -awayFromZero, inexact, file, line)
      self.assertParse(_aboveHalf, r, expected: -awayFromZero, inexact, file, line)
      // 'sNext' is even, so we will use it for testing halfway.
      // It should not go to the higher number.
      let halfEven = sNext + "500"
      self.assertParse(      halfEven,   r, expected:  awayFromZero, inexact, file, line)
      self.assertParse("-" + halfEven,   r, expected: -awayFromZero, inexact, file, line)

      r = .toNearestOrAwayFromZero
      self.assertParse(belowHalf,  r, expected:  noRounding,   inexact, file, line)
      self.assertParse(half,       r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(aboveHalf,  r, expected:  awayFromZero, inexact, file, line)
      self.assertParse(_belowHalf, r, expected: -noRounding,   inexact, file, line)
      self.assertParse(_half,      r, expected: -awayFromZero, inexact, file, line)
      self.assertParse(_aboveHalf, r, expected: -awayFromZero, inexact, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  /// Type used when parsing exponent.
  private typealias ExponentParseInt = Int

  private static let exponentParseMaxDigitCount = String(ExponentParseInt.max).count

  /// Exponent not representable by `Int`.
  func test_exponentOverflow() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let inf = T.infinity
      let gfm = T.greatestFiniteMagnitude
      let lnm = T.leastNonzeroMagnitude
      let zero = T(sign: .plus, exponent: 0, significand: .zero)
      let overflow = DecimalStatus.isOverflowInexact
      let underflow = DecimalStatus.isUnderflowInexact

      let significand = "123"
      let exponent = String(repeating: "9", count: Self.exponentParseMaxDigitCount)

      let plusPlus = significand + "E" + exponent
      let plusMinus = significand + "E-" + exponent
      let minusPlus = "-" + significand + "E" + exponent
      let minusMinus = "-" + significand + "E-" + exponent

      var r = DecimalFloatingPointRoundingRule.up
      self.assertParse(plusPlus,   r, expected:  inf,   overflow, file, line)
      self.assertParse(plusMinus,  r, expected:  lnm,  underflow, file, line)
      self.assertParse(minusPlus,  r, expected: -gfm,   overflow, file, line)
      self.assertParse(minusMinus, r, expected: -zero, underflow, file, line)

      r = .down
      self.assertParse(plusPlus,   r, expected:  gfm,  overflow, file, line)
      self.assertParse(plusMinus,  r, expected: zero, underflow, file, line)
      self.assertParse(minusPlus,  r, expected: -inf,  overflow, file, line)
      self.assertParse(minusMinus, r, expected: -lnm, underflow, file, line)

      r = .towardZero
      self.assertParse(plusPlus,   r, expected:   gfm,  overflow, file, line)
      self.assertParse(plusMinus,  r, expected:  zero, underflow, file, line)
      self.assertParse(minusPlus,  r, expected:  -gfm,  overflow, file, line)
      self.assertParse(minusMinus, r, expected: -zero, underflow, file, line)

      r = .toNearestOrEven
      self.assertParse(plusPlus,   r, expected:   inf,  overflow, file, line)
      self.assertParse(plusMinus,  r, expected:  zero, underflow, file, line)
      self.assertParse(minusPlus,  r, expected:  -inf,  overflow, file, line)
      self.assertParse(minusMinus, r, expected: -zero, underflow, file, line)

      r = .toNearestOrAwayFromZero
      self.assertParse(plusPlus,   r, expected:   inf,  overflow, file, line)
      self.assertParse(plusMinus,  r, expected:  zero, underflow, file, line)
      self.assertParse(minusPlus,  r, expected:  -inf,  overflow, file, line)
      self.assertParse(minusMinus, r, expected: -zero, underflow, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  /// Long significand spills into exponent which overflows when added to `Exxx`.
  func test_exponentOverflow_whenAddedToSignificand() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let inf = T.infinity
      let gfm = T.greatestFiniteMagnitude
      let overflow = DecimalStatus.isOverflowInexact

      // Additional digits from significand overflow exponent.
      // Note that this can only happen if the exponent is positive.
      let fillPrecision = String(repeating: "0", count: T.precisionInDigits - 1)
      let significand = "5" + fillPrecision + "1234"
      let exponent = String(describing: ExponentParseInt.max - 3)

      let plus = significand + "E" + exponent
      let minus = "-" + significand + "E" + exponent

      var r = DecimalFloatingPointRoundingRule.up
      self.assertParse(plus,  r, expected:  inf, overflow, file, line)
      self.assertParse(minus, r, expected: -gfm, overflow, file, line)

      r = .down
      self.assertParse(plus,  r, expected:  gfm, overflow, file, line)
      self.assertParse(minus, r, expected: -inf, overflow, file, line)

      r = .towardZero
      self.assertParse(plus,  r, expected:  gfm, overflow, file, line)
      self.assertParse(minus, r, expected: -gfm, overflow, file, line)

      r = .toNearestOrEven
      self.assertParse(plus,  r, expected:  inf, overflow, file, line)
      self.assertParse(minus, r, expected: -inf, overflow, file, line)

      r = .toNearestOrAwayFromZero
      self.assertParse(plus,  r, expected:  inf, overflow, file, line)
      self.assertParse(minus, r, expected: -inf, overflow, file, line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Helpers

  private func assertParse<T: DecimalFloatingPoint & DecimalMixin>(
    _ s: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    expected: T,
    _ expectedStatus: DecimalStatus,
    _ file: StaticString,
    _ line: UInt
  ) {
    var status = DecimalStatus()
    let message = "\(s), rounding: \(rounding)"

    if let d = T(s, rounding: rounding, status: &status) {
      self.assertEqual(d, expected, message, file, line)
      self.assertStatus(status, expectedStatus, message, file, line)
    } else {
      XCTFail("Parse failed: " + message, file: file, line: line)
    }
  }

  private func assertParseFailed<T: DecimalFloatingPoint & DecimalMixin>(
    _ t: T.Type,
    _ s: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    self.assertParseFailed(T.self, s, rounding: .towardZero, file, line)
  }

  private func assertParseFailed<T: DecimalFloatingPoint & DecimalMixin>(
    _ t: T.Type,
    _ s: String,
    rounding: DecimalFloatingPointRoundingRule,
    _ file: StaticString,
    _ line: UInt
  ) {
    var status = DecimalStatus()

    if let d = T._parse(s, rounding: rounding, status: &status) {
      XCTFail("Expected to fail '\(s)', got '\(d)'.", file: file, line: line)
    }

    self.assertStatusIsEmpty(status, s, file, line)
  }

  private func assertParseNaN<T: DecimalFloatingPoint & DecimalMixin>(
    _ s: String,
    _ expected: T,
    _ file: StaticString,
    _ line: UInt
  ) {
    var status = DecimalStatus()

    if let d = T._parse(s, rounding: .towardZero, status: &status) {
      self.assertEqual(d, expected, s, file, line)
      self.assertStatusIsEmpty(status, s, file, line)
    } else {
      XCTFail("Failed to parse '\(s)'.", file: file, line: line)
    }
  }
}
