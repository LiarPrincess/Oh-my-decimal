// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class GeneratedInitFromIntTests: XCTestCase, DecimalTests {

  func test_double() {
    var i = Int64.zero
    var expected = Float.zero
    XCTAssertEqual(Float(i), expected)
    XCTAssertEqual(Float(exactly: i), expected)

    i = 5
    expected = Float("5")!
    XCTAssertEqual(Float( i),  expected)
    XCTAssertEqual(Float(-i), -expected)
    XCTAssertEqual(Float(exactly:  i),  expected)
    XCTAssertEqual(Float(exactly: -i), -expected)

    i = 42
    expected = Float("42")!
    XCTAssertEqual(Float( i),  expected)
    XCTAssertEqual(Float(-i), -expected)
    XCTAssertEqual(Float(exactly:  i),  expected)
    XCTAssertEqual(Float(exactly: -i), -expected)

    i = .max
    // Float( i) - no easy algorithm to find the exact result
    XCTAssertNil(Float(exactly:  i))
    XCTAssertNil(Float(exactly: -i))

    // i = .min
    // We can't test '-i', as it overflows.
    // Float( i) - no easy algorithm to find the exact result
    XCTAssertNil(Float(exactly: i))
  }

  // MARK: - Decimal32 from Int32

  func test_Decimal32_from_Int32() {
    var i = Int32.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal32 = self.parseExact("2147483E3", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, .isInexact)
      self.run(-i, rounding: .towardZero, expected: -e, .isInexact)
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal32 = self.parseExact("2147483E3", #file, #line) {
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, .isInexact)
    }
  }

  func test_Decimal32_from_Int32_rounding() {
    var i = Int32.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      // More digits than precision, but all = 0
      i = 1234567_00
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1234567, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // More digits than precision, with rounding
    let  noRounding = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234567, signedExponent: 2)
    let  rounded    = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234568, signedExponent: 2)
    let _noRounding = Decimal32._packWithoutChecks(sign: .minus, significand: 1234567, signedExponent: 2)
    let _rounded    = Decimal32._packWithoutChecks(sign: .minus, significand: 1234568, signedExponent: 2)

    // Below half
    i = 1234567_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _noRounding, .isInexact)

    // Half - odd
    i = 1234567_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = 1234568_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)

    // Above half
    i = 1234567_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
  }

  func test_Decimal32_from_Int32_exactly() {
    var i = Int32.zero
    var expected = Decimal32.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    // If we have a lot of trailing '0' then we are always representable.
    i = 1111111000
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1111111, signedExponent: 3)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = .max
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 2147483, signedExponent: 3)
    self.runExactNil( i, Decimal32.self)
    self.runExactNil(-i, Decimal32.self)

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    i = .min
    self.runExactNil( i, Decimal32.self)
  }

  // MARK: - Decimal32 from Int64

  func test_Decimal32_from_Int64() {
    var i = Int64.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal32 = self.parseExact("9223372E12", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, .isInexact)
      self.run(-i, rounding: .towardZero, expected: -e, .isInexact)
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal32 = self.parseExact("9223372E12", #file, #line) {
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, .isInexact)
    }
  }

  func test_Decimal32_from_Int64_rounding() {
    var i = Int64.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      // More digits than precision, but all = 0
      i = 1234567_00
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1234567, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // More digits than precision, with rounding
    let  noRounding = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234567, signedExponent: 2)
    let  rounded    = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234568, signedExponent: 2)
    let _noRounding = Decimal32._packWithoutChecks(sign: .minus, significand: 1234567, signedExponent: 2)
    let _rounded    = Decimal32._packWithoutChecks(sign: .minus, significand: 1234568, signedExponent: 2)

    // Below half
    i = 1234567_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _noRounding, .isInexact)

    // Half - odd
    i = 1234567_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = 1234568_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)

    // Above half
    i = 1234567_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
  }

  func test_Decimal32_from_Int64_exactly() {
    var i = Int64.zero
    var expected = Decimal32.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    // If we have a lot of trailing '0' then we are always representable.
    i = 1111111000000000000
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1111111, signedExponent: 12)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = .max
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 9223372, signedExponent: 12)
    self.runExactNil( i, Decimal32.self)
    self.runExactNil(-i, Decimal32.self)

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    i = .min
    self.runExactNil( i, Decimal32.self)
  }

  // MARK: - Decimal32 from UInt32

  func test_Decimal32_from_UInt32() {
    var i = UInt32.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal32 = self.parseExact("4294967E3", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, .isInexact)
    }
  }

  func test_Decimal32_from_UInt32_rounding() {
    var i = UInt32.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      // More digits than precision, but all = 0
      i = 1234567_00
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1234567, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // More digits than precision, with rounding
    let  noRounding = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234567, signedExponent: 2)
    let  rounded    = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234568, signedExponent: 2)

    // Below half
    i = 1234567_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)

    // Half - odd
    i = 1234567_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = 1234568_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)

    // Above half
    i = 1234567_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
  }

  func test_Decimal32_from_UInt32_exactly() {
    var i = UInt32.zero
    var expected = Decimal32.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)

    i = 42
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)

    // If we have a lot of trailing '0' then we are always representable.
    i = 1111111000
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1111111, signedExponent: 3)
    self.runExact( i, expected:  expected)

    i = .max
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 4294967, signedExponent: 3)
    self.runExactNil( i, Decimal32.self)
  }

  // MARK: - Decimal32 from UInt64

  func test_Decimal32_from_UInt64() {
    var i = UInt64.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal32 = self.parseExact("1844674E13", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, .isInexact)
    }
  }

  func test_Decimal32_from_UInt64_rounding() {
    var i = UInt64.zero
    var expected = Decimal32.zero

    for r in Self.roundingRules {
      // More digits than precision, but all = 0
      i = 1234567_00
      expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1234567, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // More digits than precision, with rounding
    let  noRounding = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234567, signedExponent: 2)
    let  rounded    = Decimal32._packWithoutChecks(sign: .plus,  significand: 1234568, signedExponent: 2)

    // Below half
    i = 1234567_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)

    // Half - odd
    i = 1234567_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = 1234568_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)

    // Above half
    i = 1234567_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
  }

  func test_Decimal32_from_UInt64_exactly() {
    var i = UInt64.zero
    var expected = Decimal32.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)

    i = 42
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)

    // If we have a lot of trailing '0' then we are always representable.
    i = 11111110000000000000
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1111111, signedExponent: 13)
    self.runExact( i, expected:  expected)

    i = .max
    expected = Decimal32._packWithoutChecks(sign: .plus, significand: 1844674, signedExponent: 13)
    self.runExactNil( i, Decimal32.self)
  }

  // MARK: - Decimal64 from Int32

  func test_Decimal64_from_Int32() {
    var i = Int32.zero
    var expected = Decimal64.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("2147483647E0", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, DecimalStatus())
      self.run(-i, rounding: .towardZero, expected: -e, DecimalStatus())
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("2147483648E0", #file, #line) {
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, DecimalStatus())
    }
  }

  func test_Decimal64_from_Int32_exactly() {
    var i = Int32.zero
    var expected = Decimal64.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("2147483647E0", #file, #line) {
      i = .max
      self.runExact( i, expected:  e)
      self.runExact(-i, expected: -e)
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("2147483648E0", #file, #line) {
      i = .min
      self.runExact(i, expected: -e)
    }
  }

  // MARK: - Decimal64 from Int64

  func test_Decimal64_from_Int64() {
    var i = Int64.zero
    var expected = Decimal64.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("9223372036854775E3", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, .isInexact)
      self.run(-i, rounding: .towardZero, expected: -e, .isInexact)
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("9223372036854775E3", #file, #line) {
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, .isInexact)
    }
  }

  func test_Decimal64_from_Int64_rounding() {
    var i = Int64.zero
    var expected = Decimal64.zero

    for r in Self.roundingRules {
      // More digits than precision, but all = 0
      i = 1234567890123455_00
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 1234567890123455, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // More digits than precision, with rounding
    let  noRounding = Decimal64._packWithoutChecks(sign: .plus,  significand: 1234567890123455, signedExponent: 2)
    let  rounded    = Decimal64._packWithoutChecks(sign: .plus,  significand: 1234567890123456, signedExponent: 2)
    let _noRounding = Decimal64._packWithoutChecks(sign: .minus, significand: 1234567890123455, signedExponent: 2)
    let _rounded    = Decimal64._packWithoutChecks(sign: .minus, significand: 1234567890123456, signedExponent: 2)

    // Below half
    i = 1234567890123455_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _noRounding, .isInexact)

    // Half - odd
    i = 1234567890123455_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = 1234567890123456_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)

    // Above half
    i = 1234567890123455_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
  }

  func test_Decimal64_from_Int64_exactly() {
    var i = Int64.zero
    var expected = Decimal64.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    // If we have a lot of trailing '0' then we are always representable.
    i = 1111111111111111000
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 1111111111111111, signedExponent: 3)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = .max
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 9223372036854775, signedExponent: 3)
    self.runExactNil( i, Decimal64.self)
    self.runExactNil(-i, Decimal64.self)

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    i = .min
    self.runExactNil( i, Decimal64.self)
  }

  // MARK: - Decimal64 from UInt32

  func test_Decimal64_from_UInt32() {
    var i = UInt32.zero
    var expected = Decimal64.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("4294967295E0", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, DecimalStatus())
    }
  }

  func test_Decimal64_from_UInt32_exactly() {
    var i = UInt32.zero
    var expected = Decimal64.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)

    i = 42
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("4294967295E0", #file, #line) {
      i = .max
      self.runExact( i, expected:  e)
    }
  }

  // MARK: - Decimal64 from UInt64

  func test_Decimal64_from_UInt64() {
    var i = UInt64.zero
    var expected = Decimal64.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal64 = self.parseExact("1844674407370955E4", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, .isInexact)
    }
  }

  func test_Decimal64_from_UInt64_rounding() {
    var i = UInt64.zero
    var expected = Decimal64.zero

    for r in Self.roundingRules {
      // More digits than precision, but all = 0
      i = 1234567890123455_00
      expected = Decimal64._packWithoutChecks(sign: .plus, significand: 1234567890123455, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // More digits than precision, with rounding
    let  noRounding = Decimal64._packWithoutChecks(sign: .plus,  significand: 1234567890123455, signedExponent: 2)
    let  rounded    = Decimal64._packWithoutChecks(sign: .plus,  significand: 1234567890123456, signedExponent: 2)

    // Below half
    i = 1234567890123455_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)

    // Half - odd
    i = 1234567890123455_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = 1234567890123456_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)

    // Above half
    i = 1234567890123455_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
  }

  func test_Decimal64_from_UInt64_exactly() {
    var i = UInt64.zero
    var expected = Decimal64.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)

    i = 42
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)

    // If we have a lot of trailing '0' then we are always representable.
    i = 11111111111111110000
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 1111111111111111, signedExponent: 4)
    self.runExact( i, expected:  expected)

    i = .max
    expected = Decimal64._packWithoutChecks(sign: .plus, significand: 1844674407370955, signedExponent: 4)
    self.runExactNil( i, Decimal64.self)
  }

  // MARK: - Decimal128 from Int32

  func test_Decimal128_from_Int32() {
    var i = Int32.zero
    var expected = Decimal128.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("2147483647E0", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, DecimalStatus())
      self.run(-i, rounding: .towardZero, expected: -e, DecimalStatus())
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("2147483648E0", #file, #line) {
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, DecimalStatus())
    }
  }

  func test_Decimal128_from_Int32_exactly() {
    var i = Int32.zero
    var expected = Decimal128.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("2147483647E0", #file, #line) {
      i = .max
      self.runExact( i, expected:  e)
      self.runExact(-i, expected: -e)
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("2147483648E0", #file, #line) {
      i = .min
      self.runExact(i, expected: -e)
    }
  }

  // MARK: - Decimal128 from Int64

  func test_Decimal128_from_Int64() {
    var i = Int64.zero
    var expected = Decimal128.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("9223372036854775807E0", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, DecimalStatus())
      self.run(-i, rounding: .towardZero, expected: -e, DecimalStatus())
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("9223372036854775808E0", #file, #line) {
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, DecimalStatus())
    }
  }

  func test_Decimal128_from_Int64_exactly() {
    var i = Int64.zero
    var expected = Decimal128.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("9223372036854775807E0", #file, #line) {
      i = .max
      self.runExact( i, expected:  e)
      self.runExact(-i, expected: -e)
    }

    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("9223372036854775808E0", #file, #line) {
      i = .min
      self.runExact(i, expected: -e)
    }
  }

  // MARK: - Decimal128 from UInt32

  func test_Decimal128_from_UInt32() {
    var i = UInt32.zero
    var expected = Decimal128.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("4294967295E0", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, DecimalStatus())
    }
  }

  func test_Decimal128_from_UInt32_exactly() {
    var i = UInt32.zero
    var expected = Decimal128.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)

    i = 42
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("4294967295E0", #file, #line) {
      i = .max
      self.runExact( i, expected:  e)
    }
  }

  // MARK: - Decimal128 from UInt64

  func test_Decimal128_from_UInt64() {
    var i = UInt64.zero
    var expected = Decimal128.zero

    for r in Self.roundingRules {
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)

      i = 42
      expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
    }

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("18446744073709551615E0", #file, #line) {
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, DecimalStatus())
    }
  }

  func test_Decimal128_from_UInt64_exactly() {
    var i = UInt64.zero
    var expected = Decimal128.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)

    i = 42
    expected = Decimal128._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)

    // We have to parse because the value may not be representable by int literal.
    if let e: Decimal128 = self.parseExact("18446744073709551615E0", #file, #line) {
      i = .max
      self.runExact( i, expected:  e)
    }
  }

  // MARK: - Helpers

  private func run<D: DecimalFloatingPoint & DecimalMixin, I: FixedWidthInteger>(
    _ i: I,
    rounding: DecimalFloatingPointRoundingRule,
    expected: D,
    _ expectedStatus: DecimalStatus,
    _ message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    var status = DecimalStatus()
    let result = D(i, rounding: rounding, status: &status)

    self.assertEqual(result, expected, message, file, line)
    self.assertStatus(status, expectedStatus, message, file, line)
  }

  private func runExact<D: DecimalFloatingPoint & DecimalMixin, I: FixedWidthInteger>(
    _ i: I,
    expected: D?,
    _ message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    let result = D(exactly: i)

    switch (result, expected) {
    case let (.some(l), .some(r)):
      self.assertEqual(l, r, message, file, line)

    case let (.some(l), .none):
      XCTFail("Got: \(l) " + message, file: file, line: line)

    case (.none, .some):
      XCTFail("Got nil. " + message, file: file, line: line)

    case (.none, .none):
      // Both 'nil' -> equal
      break
    }
  }

  private func runExactNil<D: DecimalFloatingPoint & DecimalMixin, I: FixedWidthInteger>(
    _ i: I,
    _ d: D.Type,
    _ message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    let result = D(exactly: i)
    XCTAssertNil(result, message, file: file, line: line)
  }
}
