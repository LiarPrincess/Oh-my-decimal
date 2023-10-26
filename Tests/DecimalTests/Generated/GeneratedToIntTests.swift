// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class GeneratedToIntTests: XCTestCase, DecimalTests {

  func test_double() {
    var d = Double.nan
    // _ = Int32(d) // crash
    // _ = Int32(-d) // crash
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Double.signalingNaN
    // _ = Int32(d) // crash
    // _ = Int32(-d) // crash
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Double.infinity
    // _ = Int32(d) // crash
    // _ = Int32(-d) // crash
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Double.zero
    XCTAssertEqual(Int32( d), 0)
    XCTAssertEqual(Int32(-d), 0)
    XCTAssertEqual(Int32(exactly:  d), 0)
    XCTAssertEqual(Int32(exactly: -d), 0)

    d = 5.0
    XCTAssertEqual(Int32( d),  5)
    XCTAssertEqual(Int32(-d), -5)
    XCTAssertEqual(Int32(exactly:  d),  5)
    XCTAssertEqual(Int32(exactly: -d), -5)

    d = 11.00
    XCTAssertEqual(Int32( d),  11)
    XCTAssertEqual(Int32(-d), -11)
    XCTAssertEqual(Int32(exactly:  d),  11)
    XCTAssertEqual(Int32(exactly: -d), -11)

    d = 11.13
    XCTAssertEqual(Int32( d),  11)
    XCTAssertEqual(Int32(-d), -11)
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))
  }

  // MARK: - Decimal32 -> Int32

  func test_Decimal32_to_Int32() {
    // Decimal32.nan will crash
    // Decimal32.signalingNaN will crash
    // Decimal32.infinity will crash
    var d = Decimal32.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal32.zero
      XCTAssertEqual(Int32( d, rounding: r), 0, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(Int32( d, rounding: r),  5, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(Int32( d, rounding: r),  171900, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(Int32( d, rounding: r),  11, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -12)

    // Int32.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal32 = self.parseExact("2147483E3", #file, #line) {
      XCTAssertEqual(Int32( d),  2147483000)
      XCTAssertEqual(Int32(-d), -2147483000)
    }

    // Int32.min
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal32 = self.parseExact("2147483E3", #file, #line) {
      XCTAssertEqual(Int32(-d), -2147483000)
    }
  }

  func test_Decimal32_to_Int32_exactly() {
    var d = Decimal32.nan
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal32.signalingNaN
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal32.infinity
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal32.zero
    XCTAssertEqual(Int32(exactly:  d), 0)
    XCTAssertEqual(Int32(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(Int32(exactly:  d),  5)
    XCTAssertEqual(Int32(exactly: -d), -5)

    // Positive exponent
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(Int32(exactly:  d),  171900)
    XCTAssertEqual(Int32(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(Int32(exactly:  d),  11)
    XCTAssertEqual(Int32(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    // Int32.max
    if let d: Decimal32 = self.parseExact("2147483E3", #file, #line) {
      XCTAssertEqual(Int32(exactly:  d),  2147483000)
      XCTAssertEqual(Int32(exactly: -d), -2147483000)
    }

    // Int32.min
    // We have to parse because '-Int32.min' may not be representable.
    if let d: Decimal32 = self.parseExact("2147483E3", #file, #line) {
      XCTAssertEqual(Int32(exactly: -d), -2147483000)
    }
  }

  // MARK: - Decimal32 -> Int64

  func test_Decimal32_to_Int64() {
    // Decimal32.nan will crash
    // Decimal32.signalingNaN will crash
    // Decimal32.infinity will crash
    var d = Decimal32.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal32.zero
      XCTAssertEqual(Int64( d, rounding: r), 0, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(Int64( d, rounding: r),  5, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(Int64( d, rounding: r),  171900, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(Int64( d, rounding: r),  11, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -12)

    // Int64.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal32 = self.parseExact("9223372E12", #file, #line) {
      XCTAssertEqual(Int64( d),  9223372000000000000)
      XCTAssertEqual(Int64(-d), -9223372000000000000)
    }

    // Int64.min
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal32 = self.parseExact("9223372E12", #file, #line) {
      XCTAssertEqual(Int64(-d), -9223372000000000000)
    }
  }

  func test_Decimal32_to_Int64_exactly() {
    var d = Decimal32.nan
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal32.signalingNaN
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal32.infinity
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal32.zero
    XCTAssertEqual(Int64(exactly:  d), 0)
    XCTAssertEqual(Int64(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(Int64(exactly:  d),  5)
    XCTAssertEqual(Int64(exactly: -d), -5)

    // Positive exponent
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(Int64(exactly:  d),  171900)
    XCTAssertEqual(Int64(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(Int64(exactly:  d),  11)
    XCTAssertEqual(Int64(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    // Int64.max
    if let d: Decimal32 = self.parseExact("9223372E12", #file, #line) {
      XCTAssertEqual(Int64(exactly:  d),  9223372000000000000)
      XCTAssertEqual(Int64(exactly: -d), -9223372000000000000)
    }

    // Int64.min
    // We have to parse because '-Int64.min' may not be representable.
    if let d: Decimal32 = self.parseExact("9223372E12", #file, #line) {
      XCTAssertEqual(Int64(exactly: -d), -9223372000000000000)
    }
  }

  // MARK: - Decimal32 -> UInt32

  func test_Decimal32_to_UInt32() {
    // Decimal32.nan will crash
    // Decimal32.signalingNaN will crash
    // Decimal32.infinity will crash
    var d = Decimal32.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal32.zero
      XCTAssertEqual(UInt32( d, rounding: r), 0, r.description)
      XCTAssertEqual(UInt32(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(UInt32( d, rounding: r),  5, r.description)

      // Positive exponent
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(UInt32( d, rounding: r),  171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(UInt32( d, rounding: r),  11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 11)

    // Negative exponent, decimal digits half odd
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 12)
    // Negative exponent, decimal digits half even
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 10)

    // Negative exponent, decimal digits above half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 12)

    // UInt32.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal32 = self.parseExact("4294967E3", #file, #line) {
      XCTAssertEqual(UInt32( d),  4294967000)
    }
  }

  func test_Decimal32_to_UInt32_exactly() {
    var d = Decimal32.nan
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal32.signalingNaN
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal32.infinity
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal32.zero
    XCTAssertEqual(UInt32(exactly:  d), 0)
    XCTAssertEqual(UInt32(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(UInt32(exactly:  d),  5)
    XCTAssertNil(UInt32(exactly: -d))

    // Positive exponent
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(UInt32(exactly:  d),  171900)
    XCTAssertNil(UInt32(exactly: -d))

    // Negative exponent, decimal digits = 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(UInt32(exactly:  d),  11)
    XCTAssertNil(UInt32(exactly: -d))

    // Negative exponent, decimal digits != 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    // UInt32.max
    if let d: Decimal32 = self.parseExact("4294967E3", #file, #line) {
      XCTAssertEqual(UInt32(exactly:  d),  4294967000)
    XCTAssertNil(UInt32(exactly: -d))
    }
  }

  // MARK: - Decimal32 -> UInt64

  func test_Decimal32_to_UInt64() {
    // Decimal32.nan will crash
    // Decimal32.signalingNaN will crash
    // Decimal32.infinity will crash
    var d = Decimal32.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal32.zero
      XCTAssertEqual(UInt64( d, rounding: r), 0, r.description)
      XCTAssertEqual(UInt64(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(UInt64( d, rounding: r),  5, r.description)

      // Positive exponent
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(UInt64( d, rounding: r),  171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(UInt64( d, rounding: r),  11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 11)

    // Negative exponent, decimal digits half odd
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 12)
    // Negative exponent, decimal digits half even
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 10)

    // Negative exponent, decimal digits above half
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 12)

    // UInt64.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal32 = self.parseExact("1844674E13", #file, #line) {
      XCTAssertEqual(UInt64( d),  18446740000000000000)
    }
  }

  func test_Decimal32_to_UInt64_exactly() {
    var d = Decimal32.nan
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal32.signalingNaN
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal32.infinity
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal32.zero
    XCTAssertEqual(UInt64(exactly:  d), 0)
    XCTAssertEqual(UInt64(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(UInt64(exactly:  d),  5)
    XCTAssertNil(UInt64(exactly: -d))

    // Positive exponent
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(UInt64(exactly:  d),  171900)
    XCTAssertNil(UInt64(exactly: -d))

    // Negative exponent, decimal digits = 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(UInt64(exactly:  d),  11)
    XCTAssertNil(UInt64(exactly: -d))

    // Negative exponent, decimal digits != 0
    d = Decimal32._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    // UInt64.max
    if let d: Decimal32 = self.parseExact("1844674E13", #file, #line) {
      XCTAssertEqual(UInt64(exactly:  d),  18446740000000000000)
    XCTAssertNil(UInt64(exactly: -d))
    }
  }

  // MARK: - Decimal64 -> Int32

  func test_Decimal64_to_Int32() {
    // Decimal64.nan will crash
    // Decimal64.signalingNaN will crash
    // Decimal64.infinity will crash
    var d = Decimal64.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal64.zero
      XCTAssertEqual(Int32( d, rounding: r), 0, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(Int32( d, rounding: r),  5, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(Int32( d, rounding: r),  171900, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(Int32( d, rounding: r),  11, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -12)

    // Int32.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal64 = self.parseExact("2147483647E0", #file, #line) {
      XCTAssertEqual(Int32( d),  2147483647)
      XCTAssertEqual(Int32(-d), -2147483647)
    }

    // Int32.min
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal64 = self.parseExact("2147483648E0", #file, #line) {
      XCTAssertEqual(Int32(-d), -2147483648)
    }
  }

  func test_Decimal64_to_Int32_exactly() {
    var d = Decimal64.nan
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal64.signalingNaN
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal64.infinity
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal64.zero
    XCTAssertEqual(Int32(exactly:  d), 0)
    XCTAssertEqual(Int32(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(Int32(exactly:  d),  5)
    XCTAssertEqual(Int32(exactly: -d), -5)

    // Positive exponent
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(Int32(exactly:  d),  171900)
    XCTAssertEqual(Int32(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(Int32(exactly:  d),  11)
    XCTAssertEqual(Int32(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    // Int32.max
    if let d: Decimal64 = self.parseExact("2147483647E0", #file, #line) {
      XCTAssertEqual(Int32(exactly:  d),  2147483647)
      XCTAssertEqual(Int32(exactly: -d), -2147483647)
    }

    // Int32.min
    // We have to parse because '-Int32.min' may not be representable.
    if let d: Decimal64 = self.parseExact("2147483648E0", #file, #line) {
      XCTAssertEqual(Int32(exactly: -d), -2147483648)
    }
  }

  // MARK: - Decimal64 -> Int64

  func test_Decimal64_to_Int64() {
    // Decimal64.nan will crash
    // Decimal64.signalingNaN will crash
    // Decimal64.infinity will crash
    var d = Decimal64.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal64.zero
      XCTAssertEqual(Int64( d, rounding: r), 0, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(Int64( d, rounding: r),  5, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(Int64( d, rounding: r),  171900, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(Int64( d, rounding: r),  11, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -12)

    // Int64.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal64 = self.parseExact("9223372036854775E3", #file, #line) {
      XCTAssertEqual(Int64( d),  9223372036854775000)
      XCTAssertEqual(Int64(-d), -9223372036854775000)
    }

    // Int64.min
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal64 = self.parseExact("9223372036854775E3", #file, #line) {
      XCTAssertEqual(Int64(-d), -9223372036854775000)
    }
  }

  func test_Decimal64_to_Int64_exactly() {
    var d = Decimal64.nan
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal64.signalingNaN
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal64.infinity
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal64.zero
    XCTAssertEqual(Int64(exactly:  d), 0)
    XCTAssertEqual(Int64(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(Int64(exactly:  d),  5)
    XCTAssertEqual(Int64(exactly: -d), -5)

    // Positive exponent
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(Int64(exactly:  d),  171900)
    XCTAssertEqual(Int64(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(Int64(exactly:  d),  11)
    XCTAssertEqual(Int64(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    // Int64.max
    if let d: Decimal64 = self.parseExact("9223372036854775E3", #file, #line) {
      XCTAssertEqual(Int64(exactly:  d),  9223372036854775000)
      XCTAssertEqual(Int64(exactly: -d), -9223372036854775000)
    }

    // Int64.min
    // We have to parse because '-Int64.min' may not be representable.
    if let d: Decimal64 = self.parseExact("9223372036854775E3", #file, #line) {
      XCTAssertEqual(Int64(exactly: -d), -9223372036854775000)
    }
  }

  // MARK: - Decimal64 -> UInt32

  func test_Decimal64_to_UInt32() {
    // Decimal64.nan will crash
    // Decimal64.signalingNaN will crash
    // Decimal64.infinity will crash
    var d = Decimal64.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal64.zero
      XCTAssertEqual(UInt32( d, rounding: r), 0, r.description)
      XCTAssertEqual(UInt32(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(UInt32( d, rounding: r),  5, r.description)

      // Positive exponent
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(UInt32( d, rounding: r),  171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(UInt32( d, rounding: r),  11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 11)

    // Negative exponent, decimal digits half odd
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 12)
    // Negative exponent, decimal digits half even
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 10)

    // Negative exponent, decimal digits above half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 12)

    // UInt32.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal64 = self.parseExact("4294967295E0", #file, #line) {
      XCTAssertEqual(UInt32( d),  4294967295)
    }
  }

  func test_Decimal64_to_UInt32_exactly() {
    var d = Decimal64.nan
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal64.signalingNaN
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal64.infinity
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal64.zero
    XCTAssertEqual(UInt32(exactly:  d), 0)
    XCTAssertEqual(UInt32(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(UInt32(exactly:  d),  5)
    XCTAssertNil(UInt32(exactly: -d))

    // Positive exponent
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(UInt32(exactly:  d),  171900)
    XCTAssertNil(UInt32(exactly: -d))

    // Negative exponent, decimal digits = 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(UInt32(exactly:  d),  11)
    XCTAssertNil(UInt32(exactly: -d))

    // Negative exponent, decimal digits != 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    // UInt32.max
    if let d: Decimal64 = self.parseExact("4294967295E0", #file, #line) {
      XCTAssertEqual(UInt32(exactly:  d),  4294967295)
    XCTAssertNil(UInt32(exactly: -d))
    }
  }

  // MARK: - Decimal64 -> UInt64

  func test_Decimal64_to_UInt64() {
    // Decimal64.nan will crash
    // Decimal64.signalingNaN will crash
    // Decimal64.infinity will crash
    var d = Decimal64.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal64.zero
      XCTAssertEqual(UInt64( d, rounding: r), 0, r.description)
      XCTAssertEqual(UInt64(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(UInt64( d, rounding: r),  5, r.description)

      // Positive exponent
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(UInt64( d, rounding: r),  171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(UInt64( d, rounding: r),  11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 11)

    // Negative exponent, decimal digits half odd
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 12)
    // Negative exponent, decimal digits half even
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 10)

    // Negative exponent, decimal digits above half
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 12)

    // UInt64.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal64 = self.parseExact("1844674407370955E4", #file, #line) {
      XCTAssertEqual(UInt64( d),  18446744073709550000)
    }
  }

  func test_Decimal64_to_UInt64_exactly() {
    var d = Decimal64.nan
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal64.signalingNaN
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal64.infinity
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal64.zero
    XCTAssertEqual(UInt64(exactly:  d), 0)
    XCTAssertEqual(UInt64(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(UInt64(exactly:  d),  5)
    XCTAssertNil(UInt64(exactly: -d))

    // Positive exponent
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(UInt64(exactly:  d),  171900)
    XCTAssertNil(UInt64(exactly: -d))

    // Negative exponent, decimal digits = 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(UInt64(exactly:  d),  11)
    XCTAssertNil(UInt64(exactly: -d))

    // Negative exponent, decimal digits != 0
    d = Decimal64._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    // UInt64.max
    if let d: Decimal64 = self.parseExact("1844674407370955E4", #file, #line) {
      XCTAssertEqual(UInt64(exactly:  d),  18446744073709550000)
    XCTAssertNil(UInt64(exactly: -d))
    }
  }

  // MARK: - Decimal128 -> Int32

  func test_Decimal128_to_Int32() {
    // Decimal128.nan will crash
    // Decimal128.signalingNaN will crash
    // Decimal128.infinity will crash
    var d = Decimal128.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal128.zero
      XCTAssertEqual(Int32( d, rounding: r), 0, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(Int32( d, rounding: r),  5, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(Int32( d, rounding: r),  171900, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(Int32( d, rounding: r),  11, r.description)
      XCTAssertEqual(Int32(-d, rounding: r), -11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(Int32( d, rounding: .up), 12)
    XCTAssertEqual(Int32( d, rounding: .down), 11)
    XCTAssertEqual(Int32( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int32( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int32(-d, rounding: .up), -11)
    XCTAssertEqual(Int32(-d, rounding: .down), -12)
    XCTAssertEqual(Int32(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int32(-d, rounding: .toNearestOrAwayFromZero), -12)

    // Int32.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal128 = self.parseExact("2147483647E0", #file, #line) {
      XCTAssertEqual(Int32( d),  2147483647)
      XCTAssertEqual(Int32(-d), -2147483647)
    }

    // Int32.min
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal128 = self.parseExact("2147483648E0", #file, #line) {
      XCTAssertEqual(Int32(-d), -2147483648)
    }
  }

  func test_Decimal128_to_Int32_exactly() {
    var d = Decimal128.nan
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal128.signalingNaN
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal128.infinity
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Decimal128.zero
    XCTAssertEqual(Int32(exactly:  d), 0)
    XCTAssertEqual(Int32(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(Int32(exactly:  d),  5)
    XCTAssertEqual(Int32(exactly: -d), -5)

    // Positive exponent
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(Int32(exactly:  d),  171900)
    XCTAssertEqual(Int32(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(Int32(exactly:  d),  11)
    XCTAssertEqual(Int32(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    // Int32.max
    if let d: Decimal128 = self.parseExact("2147483647E0", #file, #line) {
      XCTAssertEqual(Int32(exactly:  d),  2147483647)
      XCTAssertEqual(Int32(exactly: -d), -2147483647)
    }

    // Int32.min
    // We have to parse because '-Int32.min' may not be representable.
    if let d: Decimal128 = self.parseExact("2147483648E0", #file, #line) {
      XCTAssertEqual(Int32(exactly: -d), -2147483648)
    }
  }

  // MARK: - Decimal128 -> Int64

  func test_Decimal128_to_Int64() {
    // Decimal128.nan will crash
    // Decimal128.signalingNaN will crash
    // Decimal128.infinity will crash
    var d = Decimal128.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal128.zero
      XCTAssertEqual(Int64( d, rounding: r), 0, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(Int64( d, rounding: r),  5, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(Int64( d, rounding: r),  171900, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(Int64( d, rounding: r),  11, r.description)
      XCTAssertEqual(Int64(-d, rounding: r), -11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(Int64( d, rounding: .up), 12)
    XCTAssertEqual(Int64( d, rounding: .down), 11)
    XCTAssertEqual(Int64( d, rounding: .towardZero), 11)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(Int64( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual(Int64(-d, rounding: .up), -11)
    XCTAssertEqual(Int64(-d, rounding: .down), -12)
    XCTAssertEqual(Int64(-d, rounding: .towardZero), -11)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual(Int64(-d, rounding: .toNearestOrAwayFromZero), -12)

    // Int64.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal128 = self.parseExact("9223372036854775807E0", #file, #line) {
      XCTAssertEqual(Int64( d),  9223372036854775807)
      XCTAssertEqual(Int64(-d), -9223372036854775807)
    }

    // Int64.min
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal128 = self.parseExact("9223372036854775808E0", #file, #line) {
      XCTAssertEqual(Int64(-d), -9223372036854775808)
    }
  }

  func test_Decimal128_to_Int64_exactly() {
    var d = Decimal128.nan
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal128.signalingNaN
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal128.infinity
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    d = Decimal128.zero
    XCTAssertEqual(Int64(exactly:  d), 0)
    XCTAssertEqual(Int64(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(Int64(exactly:  d),  5)
    XCTAssertEqual(Int64(exactly: -d), -5)

    // Positive exponent
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(Int64(exactly:  d),  171900)
    XCTAssertEqual(Int64(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(Int64(exactly:  d),  11)
    XCTAssertEqual(Int64(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(Int64(exactly:  d))
    XCTAssertNil(Int64(exactly: -d))

    // Int64.max
    if let d: Decimal128 = self.parseExact("9223372036854775807E0", #file, #line) {
      XCTAssertEqual(Int64(exactly:  d),  9223372036854775807)
      XCTAssertEqual(Int64(exactly: -d), -9223372036854775807)
    }

    // Int64.min
    // We have to parse because '-Int64.min' may not be representable.
    if let d: Decimal128 = self.parseExact("9223372036854775808E0", #file, #line) {
      XCTAssertEqual(Int64(exactly: -d), -9223372036854775808)
    }
  }

  // MARK: - Decimal128 -> UInt32

  func test_Decimal128_to_UInt32() {
    // Decimal128.nan will crash
    // Decimal128.signalingNaN will crash
    // Decimal128.infinity will crash
    var d = Decimal128.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal128.zero
      XCTAssertEqual(UInt32( d, rounding: r), 0, r.description)
      XCTAssertEqual(UInt32(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(UInt32( d, rounding: r),  5, r.description)

      // Positive exponent
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(UInt32( d, rounding: r),  171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(UInt32( d, rounding: r),  11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 11)

    // Negative exponent, decimal digits half odd
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 12)
    // Negative exponent, decimal digits half even
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 10)

    // Negative exponent, decimal digits above half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(UInt32( d, rounding: .up), 12)
    XCTAssertEqual(UInt32( d, rounding: .down), 11)
    XCTAssertEqual(UInt32( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt32( d, rounding: .toNearestOrAwayFromZero), 12)

    // UInt32.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal128 = self.parseExact("4294967295E0", #file, #line) {
      XCTAssertEqual(UInt32( d),  4294967295)
    }
  }

  func test_Decimal128_to_UInt32_exactly() {
    var d = Decimal128.nan
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal128.signalingNaN
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal128.infinity
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    d = Decimal128.zero
    XCTAssertEqual(UInt32(exactly:  d), 0)
    XCTAssertEqual(UInt32(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(UInt32(exactly:  d),  5)
    XCTAssertNil(UInt32(exactly: -d))

    // Positive exponent
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(UInt32(exactly:  d),  171900)
    XCTAssertNil(UInt32(exactly: -d))

    // Negative exponent, decimal digits = 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(UInt32(exactly:  d),  11)
    XCTAssertNil(UInt32(exactly: -d))

    // Negative exponent, decimal digits != 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(UInt32(exactly:  d))
    XCTAssertNil(UInt32(exactly: -d))

    // UInt32.max
    if let d: Decimal128 = self.parseExact("4294967295E0", #file, #line) {
      XCTAssertEqual(UInt32(exactly:  d),  4294967295)
    XCTAssertNil(UInt32(exactly: -d))
    }
  }

  // MARK: - Decimal128 -> UInt64

  func test_Decimal128_to_UInt64() {
    // Decimal128.nan will crash
    // Decimal128.signalingNaN will crash
    // Decimal128.infinity will crash
    var d = Decimal128.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {
      d = Decimal128.zero
      XCTAssertEqual(UInt64( d, rounding: r), 0, r.description)
      XCTAssertEqual(UInt64(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual(UInt64( d, rounding: r),  5, r.description)

      // Positive exponent
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual(UInt64( d, rounding: r),  171900, r.description)

      // Negative exponent, decimal digits = 0
      d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual(UInt64( d, rounding: r),  11, r.description)
    }

    // Negative exponent, decimal digits below half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 11)

    // Negative exponent, decimal digits half odd
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 12)
    // Negative exponent, decimal digits half even
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 10)

    // Negative exponent, decimal digits above half
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual(UInt64( d, rounding: .up), 12)
    XCTAssertEqual(UInt64( d, rounding: .down), 11)
    XCTAssertEqual(UInt64( d, rounding: .towardZero), 11)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual(UInt64( d, rounding: .toNearestOrAwayFromZero), 12)

    // UInt64.max
    // We have to parse because the value may not be representable by int literal.
    if let d: Decimal128 = self.parseExact("18446744073709551615E0", #file, #line) {
      XCTAssertEqual(UInt64( d),  18446744073709551615)
    }
  }

  func test_Decimal128_to_UInt64_exactly() {
    var d = Decimal128.nan
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal128.signalingNaN
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal128.infinity
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    d = Decimal128.zero
    XCTAssertEqual(UInt64(exactly:  d), 0)
    XCTAssertEqual(UInt64(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual(UInt64(exactly:  d),  5)
    XCTAssertNil(UInt64(exactly: -d))

    // Positive exponent
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual(UInt64(exactly:  d),  171900)
    XCTAssertNil(UInt64(exactly: -d))

    // Negative exponent, decimal digits = 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual(UInt64(exactly:  d),  11)
    XCTAssertNil(UInt64(exactly: -d))

    // Negative exponent, decimal digits != 0
    d = Decimal128._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil(UInt64(exactly:  d))
    XCTAssertNil(UInt64(exactly: -d))

    // UInt64.max
    if let d: Decimal128 = self.parseExact("18446744073709551615E0", #file, #line) {
      XCTAssertEqual(UInt64(exactly:  d),  18446744073709551615)
    XCTAssertNil(UInt64(exactly: -d))
    }
  }
}
