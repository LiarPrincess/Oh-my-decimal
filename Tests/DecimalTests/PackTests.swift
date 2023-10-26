import XCTest
@testable import Decimal

// swiftlint:disable comma

private typealias T = Decimal32
private typealias BID = T.BID

class PackTests: XCTestCase, DecimalTests {

  // MARK: - Limits

  func test_normal_greatestFiniteMagnitude() {
    func run(
      _ sign: T.Sign,
      rounding: DecimalFloatingPointRoundingRule,
      expected: T,
      message: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: T.maxDecimalDigits,
        exponent: T.maxSignedExponent,
        roundingDigitCount: 0,
        rounding: rounding,
        expected: expected,
        expectedStatus: DecimalStatus(),
        message: message,
        file,
        line
      )
    }

    for r in Self.roundingRules {
      let m = String(describing: r)
      run(.plus,  rounding: r, expected:  T.greatestFiniteMagnitude, message: m)
      run(.minus, rounding: r, expected: -T.greatestFiniteMagnitude, message: m)
    }
  }

  func test_normal_leastNonzeroMagnitude() {
    func run(
      _ sign: T.Sign,
      rounding: DecimalFloatingPointRoundingRule,
      expected: T,
      message: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: 1,
        exponent: T.minSignedExponent,
        roundingDigitCount: 0,
        rounding: rounding,
        expected: expected,
        expectedStatus: DecimalStatus(),
        message: message,
        file,
        line
      )
    }

    for r in Self.roundingRules {
      let m = String(describing: r)
      run(.plus,  rounding: r, expected:  T.leastNonzeroMagnitude, message: m)
      run(.minus, rounding: r, expected: -T.leastNonzeroMagnitude, message: m)
    }
  }

  // MARK: - Rounding

  func test_normal_rounding_zero_isExact() {
    func run(
      _ sign: T.Sign,
      rounding: DecimalFloatingPointRoundingRule,
      expected: T,
      message: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: 12300,
        exponent: 7,
        roundingDigitCount: 2,
        rounding: rounding,
        expected: expected,
        expectedStatus: DecimalStatus(),
        message: message,
        file,
        line
      )
    }

    let expected = T._packWithoutChecks(
      sign: .plus,
      significand: 123,
      signedExponent: 7
    )

    for r in Self.roundingRules {
      let m = String(describing: r)
      run(.plus,  rounding: r, expected:  expected, message: m)
      run(.minus, rounding: r, expected: -expected, message: m)
    }
  }

  func test_normal_rounding_up() {
    func run(
      _ sign: T.Sign,
      _ significand: BID,
      expected: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: 11,
        roundingDigitCount: 2,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isInexact,
        file,
        line
      )
    }

    let rounding = DecimalFloatingPointRoundingRule.up

    // 123.42
    run(.plus,  12342, expected:  "124E11")
    run(.minus, 12342, expected: "-123E11")

    // 123.50
    run(.plus,  12350, expected:  "124E11")
    run(.minus, 12350, expected: "-123E11")

    // 123.51
    run(.plus,  12351, expected:  "124E11")
    run(.minus, 12351, expected: "-123E11")

    // 999.99
    run(.plus,  99999, expected: "1000E11")
    run(.minus, 99999, expected: "-999E11")

    // maxDecimalDigits - exponent increase
    let max = T.maxDecimalDigits * 100 + 94
    run(.plus,  max, expected:  "1000000E12")
    run(.minus, max, expected: "-9999999E11")

    // maxDecimalDigits - overflow
    self.run(
      sign: .plus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: T.infinity,
      expectedStatus: .isOverflowInexact
    )

    self.run(
      sign: .minus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: -T.greatestFiniteMagnitude,
      expectedStatus: .isInexact
    )
  }

  func test_normal_rounding_down() {
    func run(
      _ sign: T.Sign,
      _ significand: BID,
      expected: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: 11,
        roundingDigitCount: 2,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isInexact,
        file,
        line
      )
    }

    let rounding = DecimalFloatingPointRoundingRule.down

    // 123.42
    run(.plus,  12342, expected:  "123E11")
    run(.minus, 12342, expected: "-124E11")

    // 123.50
    run(.plus,  12350, expected:  "123E11")
    run(.minus, 12350, expected: "-124E11")

    // 123.51
    run(.plus,  12351, expected:  "123E11")
    run(.minus, 12351, expected: "-124E11")

    // 999.99
    run(.plus,  99999, expected: "999E11")
    run(.minus, 99999, expected: "-1000E11")

    // maxDecimalDigits - exponent increase
    let max = T.maxDecimalDigits * 100 + 94
    run(.plus,  max, expected:  "9999999E11")
    run(.minus, max, expected: "-1000000E12")

    // maxDecimalDigits - overflow
    self.run(
      sign: .plus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: T.greatestFiniteMagnitude,
      expectedStatus: .isInexact
    )

    self.run(
      sign: .minus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: -T.infinity,
      expectedStatus: .isOverflowInexact
    )
  }

  func test_normal_rounding_towardZero() {
    func run(
      _ sign: T.Sign,
      _ significand: BID,
      expected: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: 11,
        roundingDigitCount: 2,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isInexact,
        file,
        line
      )
    }

    let rounding = DecimalFloatingPointRoundingRule.towardZero

    // 123.42
    run(.plus,  12342, expected:  "123E11")
    run(.minus, 12342, expected: "-123E11")

    // 123.50
    run(.plus,  12350, expected:  "123E11")
    run(.minus, 12350, expected: "-123E11")

    // 123.51
    run(.plus,  12351, expected:  "123E11")
    run(.minus, 12351, expected: "-123E11")

    // 999.99
    run(.plus,  99999, expected:  "999E11")
    run(.minus, 99999, expected: "-999E11")

    // maxDecimalDigits - exponent increase
    let max = T.maxDecimalDigits * 100 + 94
    run(.plus,  max, expected:  "9999999E11")
    run(.minus, max, expected: "-9999999E11")

    // maxDecimalDigits - overflow
    self.run(
      sign: .plus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: T.greatestFiniteMagnitude,
      expectedStatus: .isInexact
    )

    self.run(
      sign: .minus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: -T.greatestFiniteMagnitude,
      expectedStatus: .isInexact
    )
  }

  func test_normal_rounding_toNearestOrEven() {
    func run(
      _ sign: T.Sign,
      _ significand: BID,
      expected: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: 11,
        roundingDigitCount: 2,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isInexact,
        file,
        line
      )
    }

    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven

    // 123.42
    run(.plus,  12342, expected:  "123E11")
    run(.minus, 12342, expected: "-123E11")

    // 123.50, odd -> even
    run(.plus,  12350, expected:  "124E11")
    run(.minus, 12350, expected: "-124E11")

    // 124.50, even
    run(.plus,  12450, expected:  "124E11")
    run(.minus, 12450, expected: "-124E11")

    // 123.51
    run(.plus,  12351, expected:  "124E11")
    run(.minus, 12351, expected: "-124E11")

    // 999.99
    run(.plus,  99999, expected:  "1000E11")
    run(.minus, 99999, expected: "-1000E11")

    // maxDecimalDigits - exponent increase
    let max = T.maxDecimalDigits * 100 + 94
    run(.plus,  max, expected:  "1000000E12")
    run(.minus, max, expected: "-1000000E12")

    // maxDecimalDigits - overflow
    self.run(
      sign: .plus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: T.infinity,
      expectedStatus: .isOverflowInexact
    )

    self.run(
      sign: .minus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: -T.infinity,
      expectedStatus: .isOverflowInexact
    )
  }

  func test_normal_rounding_toNearestOrAwayFromZero() {
    func run(
      _ sign: T.Sign,
      _ significand: BID,
      expected: String,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: 11,
        roundingDigitCount: 2,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isInexact,
        file,
        line
      )
    }

    let rounding = DecimalFloatingPointRoundingRule.toNearestOrAwayFromZero

    // 123.42
    run(.plus,  12342, expected:  "123E11")
    run(.minus, 12342, expected: "-123E11")

    // 123.50, odd <- should not matter
    run(.plus,  12350, expected:  "124E11")
    run(.minus, 12350, expected: "-124E11")

    // 124.50, even <- should not matter
    run(.plus,  12450, expected:  "125E11")
    run(.minus, 12450, expected: "-125E11")

    // 123.51
    run(.plus,  12351, expected:  "124E11")
    run(.minus, 12351, expected: "-124E11")

    // 999.99
    run(.plus,  99999, expected:  "1000E11")
    run(.minus, 99999, expected: "-1000E11")

    // maxDecimalDigits - exponent increase
    let max = T.maxDecimalDigits * 100 + 94
    run(.plus,  max, expected:  "1000000E12")
    run(.minus, max, expected: "-1000000E12")

    // maxDecimalDigits - overflow
    self.run(
      sign: .plus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: T.infinity,
      expectedStatus: .isOverflowInexact
    )

    self.run(
      sign: .minus,
      significand: max,
      exponent: T.maxSignedExponent,
      roundingDigitCount: 2,
      rounding: rounding,
      expected: -T.infinity,
      expectedStatus: .isOverflowInexact
    )
  }

  // MARK: - Overflow

  func test_overflow_zero() {
    func run(
      _ sign: T.Sign,
      exponent: Int,
      roundingDigitCount: Int,
      expected: T,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      for r in Self.roundingRules {
        self.run(
          sign: sign,
          significand: 0,
          exponent: exponent,
          roundingDigitCount: roundingDigitCount,
          rounding: r,
          expected: expected,
          expectedStatus: DecimalStatus(),
          file,
          line
        )
      }
    }

    let expected = T._packWithoutChecks(
      sign: .plus,
      significand: 0,
      signedExponent: T.maxSignedExponent
    )

    // exponent = Int.max
    run(.plus,  exponent: Int.max, roundingDigitCount: 0, expected:  expected)
    run(.minus, exponent: Int.max, roundingDigitCount: 0, expected: -expected)

    let maxPlus1 = T.maxSignedExponent + 1
    run(.plus,  exponent: maxPlus1, roundingDigitCount: 0, expected:  expected)
    run(.minus, exponent: maxPlus1, roundingDigitCount: 0, expected: -expected)

    // rounding digits
    run(.plus,  exponent: maxPlus1, roundingDigitCount: 5, expected:  expected)
    run(.minus, exponent: maxPlus1, roundingDigitCount: 5, expected: -expected)
  }

  func test_overflow_exponentTotallyOutOfRange() {
    // exponent = Int.max
    self.runExpectingInfinitelyBigValue(
      significand: 123,
      exponent: Int.max,
      roundingDigitCount: 0
    )

    // exponent = max + precision
    let withPrecision = T.maxSignedExponent + T.precisionInDigits
    self.runExpectingInfinitelyBigValue(
      significand: 123,
      exponent: withPrecision,
      roundingDigitCount: 0
    )

    // rounding digits
    self.runExpectingInfinitelyBigValue(
      significand: 123,
      exponent: withPrecision,
      roundingDigitCount: T.precisionInDigits
    )
  }

  /// rounding digit count == exponent diff
  func test_overflow_useAllRoundingDigits() {
    // With rounding digits -> valid decimal
    var roundingDigitCount = 3
    let expected = T._packWithoutChecks(
      sign: .plus,
      significand: 1234567,
      signedExponent: T.maxSignedExponent
    )

    for r in Self.roundingRules {
      self.run(
        sign: .plus,
        significand: 1234567,
        exponent: T.maxSignedExponent + roundingDigitCount,
        roundingDigitCount: roundingDigitCount,
        rounding: r,
        expected: expected,
        expectedStatus: DecimalStatus()
      )

      self.run(
        sign: .minus,
        significand: 1234567,
        exponent: T.maxSignedExponent + roundingDigitCount,
        roundingDigitCount: roundingDigitCount,
        rounding: r,
        expected: -expected,
        expectedStatus: DecimalStatus()
      )
    }

    // With rounding digits -> significand overflow
    // - exponent will be correct
    // - significand will be too big
    roundingDigitCount = 2

    self.runExpectingInfinitelyBigValue(
      significand: 123456789,
      exponent: T.maxSignedExponent + roundingDigitCount,
      roundingDigitCount: roundingDigitCount
    )
  }

  /// rounding digit count < exponent diff
  /// We need to multiply by power of 10 to get it to normal.
  func test_overflow_useAllRoundingDigits_andMore() {
    func run(
      _ sign: T.Sign,
      _ significand: BID,
      exponent: Int,
      roundingDigitCount: Int,
      expected: T,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      for r in Self.roundingRules {
        self.run(
          sign: sign,
          significand: significand,
          exponent: exponent,
          roundingDigitCount: roundingDigitCount,
          rounding: r,
          expected: expected,
          expectedStatus: DecimalStatus(),
          file,
          line
        )
      }
    }

    let max = T.maxSignedExponent

    //        | Needed exponent decrease | From rounding digits | From mul
    // Test 1 |                        4 |                    2 |        2
    // Test 2 |                        4 |                    3 |        1
    let expected1 = T._packWithoutChecks(sign: .plus, significand: 1234500, signedExponent: max)
    run(.plus,  12345, exponent: max + 4, roundingDigitCount: 2, expected:  expected1)
    run(.minus, 12345, exponent: max + 4, roundingDigitCount: 2, expected: -expected1)

    let expected2 = T._packWithoutChecks(sign: .plus, significand: 1234560, signedExponent: max)
    run(.plus,  123456, exponent: max + 4, roundingDigitCount: 3, expected:  expected2)
    run(.minus, 123456, exponent: max + 4, roundingDigitCount: 3, expected: -expected2)

    // Not enough digits to mul
    self.runExpectingInfinitelyBigValue(
      significand: 123457,
      exponent: max + 4,
      roundingDigitCount: 2
    )

    // Not enough digits to mul - full significand
    self.runExpectingInfinitelyBigValue(
      significand: 1234578,
      exponent: max + 2,
      roundingDigitCount: 1
    )
  }

  /// rounding digit count > exponent diff
  /// Remaining rounding digits are used for rounding.
  func test_overflow_useSomeRoundingDigits_andRound() {
    // We need to decrease the exponent by 2.
    // Take those 2 numbers from rounding digits.
    // Ooops… significand is too big
    self.runExpectingInfinitelyBigValue(
      significand: 123456789,
      exponent: T.maxSignedExponent + 2,
      roundingDigitCount: 3
    )
  }

  func test_overflow_useSomeRoundingDigits_andRound_up() {
    let r = DecimalFloatingPointRoundingRule.up

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 1234567,
      signedExponent: T.maxSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 1234568,
      signedExponent: T.maxSignedExponent
    )

    // Exact
    self.runRoundedOverflow(.plus,  1234567_00, r, expected:  noRounding)
    self.runRoundedOverflow(.minus, 1234567_00, r, expected: -noRounding)

    // Below half
    self.runRoundedOverflow(.plus,  1234567_42, r, expected:  rounded,    .isInexact)
    self.runRoundedOverflow(.minus, 1234567_42, r, expected: -noRounding, .isInexact)

    // Half
    self.runRoundedOverflow(.plus,  1234567_50, r, expected:  rounded,    .isInexact)
    self.runRoundedOverflow(.minus, 1234567_50, r, expected: -noRounding, .isInexact)

    // Above half
    self.runRoundedOverflow(.plus,  1234567_51, r, expected:  rounded,    .isInexact)
    self.runRoundedOverflow(.minus, 1234567_51, r, expected: -noRounding, .isInexact)

    // Overflow after rounding
    self.runRoundedOverflow(.plus,  9999999_51, r, expected:  T.infinity, .isOverflowInexact)
    self.runRoundedOverflow(.minus, 9999999_51, r, expected: -T.greatestFiniteMagnitude, .isInexact)
  }

  func test_overflow_useSomeRoundingDigits_andRound_down() {
    let r = DecimalFloatingPointRoundingRule.down

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 1234567,
      signedExponent: T.maxSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 1234568,
      signedExponent: T.maxSignedExponent
    )

    // Exact
    self.runRoundedOverflow(.plus,  1234567_00, r, expected:  noRounding)
    self.runRoundedOverflow(.minus, 1234567_00, r, expected: -noRounding)

    // Below half
    self.runRoundedOverflow(.plus,  1234567_42, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_42, r, expected: -rounded,    .isInexact)

    // Half
    self.runRoundedOverflow(.plus,  1234567_50, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_50, r, expected: -rounded,    .isInexact)

    // Above half
    self.runRoundedOverflow(.plus,  1234567_51, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_51, r, expected: -rounded,    .isInexact)

    // Overflow after rounding
    self.runRoundedOverflow(.plus,  9999999_51, r, expected:  T.greatestFiniteMagnitude, .isInexact)
    self.runRoundedOverflow(.minus, 9999999_51, r, expected: -T.infinity, .isOverflowInexact)
  }

  func test_overflow_useSomeRoundingDigits_andRound_towardZero() {
    let r = DecimalFloatingPointRoundingRule.towardZero

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 1234567,
      signedExponent: T.maxSignedExponent
    )

    // Exact
    self.runRoundedOverflow(.plus,  1234567_00, r, expected:  noRounding)
    self.runRoundedOverflow(.minus, 1234567_00, r, expected: -noRounding)

    // Below half
    self.runRoundedOverflow(.plus,  1234567_42, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_42, r, expected: -noRounding, .isInexact)

    // Half
    self.runRoundedOverflow(.plus,  1234567_50, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_50, r, expected: -noRounding, .isInexact)

    // Above half
    self.runRoundedOverflow(.plus,  1234567_51, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_51, r, expected: -noRounding, .isInexact)

    // Overflow after rounding
    self.runRoundedOverflow(.plus,  9999999_51, r, expected:  T.greatestFiniteMagnitude, .isInexact)
    self.runRoundedOverflow(.minus, 9999999_51, r, expected: -T.greatestFiniteMagnitude, .isInexact)
  }

  func test_overflow_useSomeRoundingDigits_andRound_toNearestOrEven() {
    let r = DecimalFloatingPointRoundingRule.toNearestOrEven

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 1234567,
      signedExponent: T.maxSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 1234568,
      signedExponent: T.maxSignedExponent
    )

    // Exact
    self.runRoundedOverflow(.plus,  1234567_00, r, expected:  noRounding)
    self.runRoundedOverflow(.minus, 1234567_00, r, expected: -noRounding)

    // Below half
    self.runRoundedOverflow(.plus,  1234567_42, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_42, r, expected: -noRounding, .isInexact)

    // Half - odd
    self.runRoundedOverflow(.plus,  1234567_50, r, expected:  rounded, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_50, r, expected: -rounded, .isInexact)

    // Half - even
    // We will reuse 'rounded', because it is even
    self.runRoundedOverflow(.plus,  1234568_50, r, expected:  rounded, .isInexact)
    self.runRoundedOverflow(.minus, 1234568_50, r, expected: -rounded, .isInexact)

    // Above half
    self.runRoundedOverflow(.plus,  1234567_51, r, expected:  rounded, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_51, r, expected: -rounded, .isInexact)

    // Overflow after rounding
    self.runRoundedOverflow(.plus,  9999999_51, r, expected:  T.infinity, .isOverflowInexact)
    self.runRoundedOverflow(.minus, 9999999_51, r, expected: -T.infinity, .isOverflowInexact)
  }

  func test_overflow_useSomeRoundingDigits_andRound_toNearestOrAwayFromZero() {
    let r = DecimalFloatingPointRoundingRule.toNearestOrAwayFromZero

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 1234567,
      signedExponent: T.maxSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 1234568,
      signedExponent: T.maxSignedExponent
    )

    // Exact
    self.runRoundedOverflow(.plus,  1234567_00, r, expected:  noRounding)
    self.runRoundedOverflow(.minus, 1234567_00, r, expected: -noRounding)

    // Below half
    self.runRoundedOverflow(.plus,  1234567_42, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_42, r, expected: -noRounding, .isInexact)

    // Half - odd <- should not matter
    self.runRoundedOverflow(.plus,  1234567_50, r, expected:  rounded, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_50, r, expected: -rounded, .isInexact)

    // Half - even <- should not matter
    // We will use number before 'noRounding' that should round to 'noRounding'.
    self.runRoundedOverflow(.plus,  1234566_50, r, expected:  noRounding, .isInexact)
    self.runRoundedOverflow(.minus, 1234566_50, r, expected: -noRounding, .isInexact)

    // Above half
    self.runRoundedOverflow(.plus,  1234567_51, r, expected:  rounded, .isInexact)
    self.runRoundedOverflow(.minus, 1234567_51, r, expected: -rounded, .isInexact)

    // Overflow after rounding
    self.runRoundedOverflow(.plus,  9999999_51, r, expected:  T.infinity, .isOverflowInexact)
    self.runRoundedOverflow(.minus, 9999999_51, r, expected: -T.infinity, .isOverflowInexact)
  }

  /// Rounding digits:
  /// - 1 goes to the significand
  /// - remaining 2 are used for rounding
  private func runRoundedOverflow(
    _ sign: T.Sign,
    _ significand: BID,
    _ rounding: DecimalFloatingPointRoundingRule,
    expected: T,
    _ expectedStatus: DecimalStatus = DecimalStatus(),
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    self.run(
      sign: sign,
      significand: significand,
      exponent: T.maxSignedExponent + 1,
      roundingDigitCount: 3,
      rounding: rounding,
      expected: expected,
      expectedStatus: expectedStatus,
      file,
      line
    )
  }

  // MARK: - Underflow

  func test_underflow_zero() {
    func run(
      _ sign: T.Sign,
      exponent: Int,
      roundingDigitCount: Int,
      expected: T,
      _ file: StaticString = #file,
      _ line: UInt = #line
    ) {
      for r in Self.roundingRules {
        self.run(
          sign: sign,
          significand: 0,
          exponent: exponent,
          roundingDigitCount: roundingDigitCount,
          rounding: r,
          expected: expected,
          expectedStatus: DecimalStatus(),
          file,
          line
        )
      }
    }

    let expected = T._packWithoutChecks(
      sign: .plus,
      significand: 0,
      signedExponent: T.minSignedExponent
    )

    // exponent = Int.max
    run(.plus,  exponent: Int.min, roundingDigitCount: 0, expected:  expected)
    run(.minus, exponent: Int.min, roundingDigitCount: 0, expected: -expected)

    let minMinus1 = T.minSignedExponent - 1
    run(.plus,  exponent: minMinus1, roundingDigitCount: 0, expected:  expected)
    run(.minus, exponent: minMinus1, roundingDigitCount: 0, expected: -expected)

    // rounding digits
    run(.plus,  exponent: minMinus1, roundingDigitCount: 5, expected:  expected)
    run(.minus, exponent: minMinus1, roundingDigitCount: 5, expected: -expected)
  }

  func test_underflow_exponentTotallyOutOfRange() {
    // exponent = Int.max
    self.runExpectingInfinitelySmallValue(
      significand: 123,
      exponent: Int.min,
      roundingDigitCount: 0
    )

    // exponent = min - precision
    let withPrecision = T.minSignedExponent - T.precisionInDigits
    self.runExpectingInfinitelySmallValue(
      significand: 123,
      exponent: withPrecision,
      roundingDigitCount: 0
    )

    // rounding digits
    self.runExpectingInfinitelySmallValue(
      significand: 123,
      exponent: withPrecision,
      roundingDigitCount: 2
    )
  }

  /// Increase exponent by cutting significand digits.
  func test_underflow_eatSignificandDigits_andRound_up() {
    let r = DecimalFloatingPointRoundingRule.up

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 12345,
      signedExponent: T.minSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 12346,
      signedExponent: T.minSignedExponent
    )

    // Exact
    self.runRoundedUnderflow(.plus,  12345_000, r, expected:  noRounding)
    self.runRoundedUnderflow(.minus, 12345_000, r, expected: -noRounding)

    // Below half
    self.runRoundedUnderflow(.plus,  12345_402, r, expected:     rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_402, r, expected: -noRounding, .isUnderflowInexact)

    // Half
    self.runRoundedUnderflow(.plus,  12345_500, r, expected:     rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_500, r, expected: -noRounding, .isUnderflowInexact)

    // Above half
    self.runRoundedUnderflow(.plus,  12345_501, r, expected:     rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_501, r, expected: -noRounding, .isUnderflowInexact)
  }

  /// Increase exponent by cutting significand digits.
  func test_underflow_eatSignificandDigits_andRound_down() {
    let r = DecimalFloatingPointRoundingRule.down

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 12345,
      signedExponent: T.minSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 12346,
      signedExponent: T.minSignedExponent
    )

    // Exact
    self.runRoundedUnderflow(.plus,  12345_000, r, expected:  noRounding)
    self.runRoundedUnderflow(.minus, 12345_000, r, expected: -noRounding)

    // Below half
    self.runRoundedUnderflow(.plus,  12345_402, r, expected: noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_402, r, expected:   -rounded, .isUnderflowInexact)

    // Half
    self.runRoundedUnderflow(.plus,  12345_500, r, expected: noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_500, r, expected:   -rounded, .isUnderflowInexact)

    // Above half
    self.runRoundedUnderflow(.plus,  12345_501, r, expected: noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_501, r, expected:   -rounded, .isUnderflowInexact)
  }

  /// Increase exponent by cutting significand digits.
  func test_underflow_eatSignificandDigits_andRound_towardZero() {
    let r = DecimalFloatingPointRoundingRule.towardZero

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 12345,
      signedExponent: T.minSignedExponent
    )

    // Exact
    self.runRoundedUnderflow(.plus,  12345_000, r, expected:  noRounding)
    self.runRoundedUnderflow(.minus, 12345_000, r, expected: -noRounding)

    // Below half
    self.runRoundedUnderflow(.plus,  12345_402, r, expected:  noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_402, r, expected: -noRounding, .isUnderflowInexact)

    // Half
    self.runRoundedUnderflow(.plus,  12345_500, r, expected:  noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_500, r, expected: -noRounding, .isUnderflowInexact)

    // Above half
    self.runRoundedUnderflow(.plus,  12345_501, r, expected:  noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_501, r, expected: -noRounding, .isUnderflowInexact)
  }

  /// Increase exponent by cutting significand digits.
  func test_underflow_eatSignificandDigits_andRound_toNearestOrEven() {
    let r = DecimalFloatingPointRoundingRule.toNearestOrEven

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 12345,
      signedExponent: T.minSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 12346,
      signedExponent: T.minSignedExponent
    )

    // Exact
    self.runRoundedUnderflow(.plus,  12345_000, r, expected:  noRounding)
    self.runRoundedUnderflow(.minus, 12345_000, r, expected: -noRounding)

    // Below half
    self.runRoundedUnderflow(.plus,  12345_402, r, expected:  noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_402, r, expected: -noRounding, .isUnderflowInexact)

    // Half - odd
    self.runRoundedUnderflow(.plus,  12345_500, r, expected:  rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_500, r, expected: -rounded, .isUnderflowInexact)

    // Half - even
    // We will reuse 'rounded', because it is even
    self.runRoundedUnderflow(.plus,  12346_500, r, expected:  rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12346_500, r, expected: -rounded, .isUnderflowInexact)

    // Above half
    self.runRoundedUnderflow(.plus,  12345_501, r, expected:  rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_501, r, expected: -rounded, .isUnderflowInexact)
  }

  /// Increase exponent by cutting significand digits.
  func test_underflow_eatSignificandDigits_andRound_toNearestOrAwayFromZero() {
    let r = DecimalFloatingPointRoundingRule.toNearestOrAwayFromZero

    let noRounding = T._packWithoutChecks(
      sign: .plus,
      significand: 12345,
      signedExponent: T.minSignedExponent
    )

    let rounded = T._packWithoutChecks(
      sign: .plus,
      significand: 12346,
      signedExponent: T.minSignedExponent
    )

    // Exact
    self.runRoundedUnderflow(.plus,  12345_000, r, expected:  noRounding)
    self.runRoundedUnderflow(.minus, 12345_000, r, expected: -noRounding)

    // Below half
    self.runRoundedUnderflow(.plus,  12345_402, r, expected:  noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_402, r, expected: -noRounding, .isUnderflowInexact)

    // Half - odd <- should not matter
    self.runRoundedUnderflow(.plus,  12345_500, r, expected:  rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_500, r, expected: -rounded, .isUnderflowInexact)

    // Half - even <- should not matter
    // We will use number before 'noRounding' that should round to 'noRounding'.
    self.runRoundedUnderflow(.plus,  12344_500, r, expected:  noRounding, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12344_500, r, expected: -noRounding, .isUnderflowInexact)

    // Above half
    self.runRoundedUnderflow(.plus,  12345_501, r, expected:  rounded, .isUnderflowInexact)
    self.runRoundedUnderflow(.minus, 12345_501, r, expected: -rounded, .isUnderflowInexact)
  }

  /// Significand:
  /// - 1 rounding digits
  /// - 2 used to increase exponent
  private func runRoundedUnderflow(
    _ sign: T.Sign,
    _ significand: BID,
    _ rounding: DecimalFloatingPointRoundingRule,
    expected: T,
    _ expectedStatus: DecimalStatus = DecimalStatus(),
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    self.run(
      sign: sign,
      significand: significand,
      exponent: T.minSignedExponent - 2,
      roundingDigitCount: 1,
      rounding: rounding,
      expected: expected,
      expectedStatus: expectedStatus,
      file,
      line
    )
  }

  // MARK: - Helpers

  private func run(
    sign: T.Sign,
    significand: BID,
    exponent: Int,
    roundingDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    expected: String,
    expectedStatus: DecimalStatus,
    message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    if let e: T = self.parseExact(expected, file, line) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: exponent,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        expected: e,
        expectedStatus: expectedStatus,
        message: message,
        file,
        line
      )
    }
  }

  private func run(
    sign: T.Sign,
    significand: BID,
    exponent: Int,
    roundingDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    expected: T,
    expectedStatus: DecimalStatus,
    message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    var status = DecimalStatus()

    let result = T._pack(
      sign: sign,
      significand: significand,
      signedExponent: exponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )

    self.assertEqual(result, expected, message, file, line)
    self.assertStatus(status, expectedStatus, message, file, line)
  }

  private func runExpectingInfinitelyBigValue(
    significand: BID,
    exponent: Int,
    roundingDigitCount: Int,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    func run(
      _ sign: T.Sign,
      _ rounding: DecimalFloatingPointRoundingRule,
      expected: T
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: exponent,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isOverflowInexact,
        message: rounding.description,
        file,
        line
      )
    }

    run(.plus, .up, expected: T.infinity)
    run(.plus, .down, expected: T.greatestFiniteMagnitude)
    run(.plus, .towardZero, expected: T.greatestFiniteMagnitude)
    run(.plus, .toNearestOrEven, expected: T.infinity)
    run(.plus, .toNearestOrAwayFromZero, expected: T.infinity)

    run(.minus, .up, expected: -T.greatestFiniteMagnitude)
    run(.minus, .down, expected: -T.infinity)
    run(.minus, .towardZero, expected: -T.greatestFiniteMagnitude)
    run(.minus, .toNearestOrEven, expected: -T.infinity)
    run(.minus, .toNearestOrAwayFromZero, expected: -T.infinity)
  }

  private func runExpectingInfinitelySmallValue(
    significand: BID,
    exponent: Int,
    roundingDigitCount: Int,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    func run(
      _ sign: T.Sign,
      _ rounding: DecimalFloatingPointRoundingRule,
      expected: T
    ) {
      self.run(
        sign: sign,
        significand: significand,
        exponent: exponent,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        expected: expected,
        expectedStatus: .isUnderflowInexact,
        message: rounding.description,
        file,
        line
      )
    }

    let zero = T._packWithoutChecks(
      sign: .plus,
      significand: 0,
      signedExponent: T.minSignedExponent
    )

    run(.plus, .up, expected: T.leastNonzeroMagnitude)
    run(.plus, .down, expected: zero)
    run(.plus, .towardZero, expected: zero)
    run(.plus, .toNearestOrEven, expected: zero)
    run(.plus, .toNearestOrAwayFromZero, expected: zero)

    run(.minus, .up, expected: -zero)
    run(.minus, .down, expected: -T.leastNonzeroMagnitude)
    run(.minus, .towardZero, expected: -zero)
    run(.minus, .toNearestOrEven, expected: -zero)
    run(.minus, .toNearestOrAwayFromZero, expected: -zero)
  }
}
