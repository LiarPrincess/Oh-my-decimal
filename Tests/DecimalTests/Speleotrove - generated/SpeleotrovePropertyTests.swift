// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class SpeleotrovePropertyTests: XCTestCase, SpeleotroveMixin {

  // MARK: - Abs

  func test_abs64() {
    /* ddabs001 */ self.abs64("1", "1", .toNearestOrEven)
    /* ddabs002 */ self.abs64("-1", "1", .toNearestOrEven)
    /* ddabs003 */ self.abs64("1.00", "1.00", .toNearestOrEven)
    /* ddabs004 */ self.abs64("-1.00", "1.00", .toNearestOrEven)
    /* ddabs005 */ self.abs64("0", "0", .toNearestOrEven)
    /* ddabs006 */ self.abs64("0.00", "0.00", .toNearestOrEven)
    /* ddabs007 */ self.abs64("00.0", "0.0", .toNearestOrEven)
    /* ddabs008 */ self.abs64("00.00", "0.00", .toNearestOrEven)
    /* ddabs009 */ self.abs64("00", "0", .toNearestOrEven)
    /* ddabs010 */ self.abs64("-2", "2", .toNearestOrEven)
    /* ddabs011 */ self.abs64("2", "2", .toNearestOrEven)
    /* ddabs012 */ self.abs64("-2.00", "2.00", .toNearestOrEven)
    /* ddabs013 */ self.abs64("2.00", "2.00", .toNearestOrEven)
    /* ddabs014 */ self.abs64("-0", "0", .toNearestOrEven)
    /* ddabs015 */ self.abs64("-0.00", "0.00", .toNearestOrEven)
    /* ddabs016 */ self.abs64("-00.0", "0.0", .toNearestOrEven)
    /* ddabs017 */ self.abs64("-00.00", "0.00", .toNearestOrEven)
    /* ddabs018 */ self.abs64("-00", "0", .toNearestOrEven)
    /* ddabs020 */ self.abs64("-2000000", "2000000", .toNearestOrEven)
    /* ddabs021 */ self.abs64("2000000", "2000000", .toNearestOrEven)
    /* ddabs030 */ self.abs64("+0.1", "0.1", .toNearestOrEven)
    /* ddabs031 */ self.abs64("-0.1", "0.1", .toNearestOrEven)
    /* ddabs032 */ self.abs64("+0.01", "0.01", .toNearestOrEven)
    /* ddabs033 */ self.abs64("-0.01", "0.01", .toNearestOrEven)
    /* ddabs034 */ self.abs64("+0.001", "0.001", .toNearestOrEven)
    /* ddabs035 */ self.abs64("-0.001", "0.001", .toNearestOrEven)
    /* ddabs036 */ self.abs64("+0.000001", "0.000001", .toNearestOrEven)
    /* ddabs037 */ self.abs64("-0.000001", "0.000001", .toNearestOrEven)
    /* ddabs038 */ self.abs64("+0.000000000001", "1E-12", .toNearestOrEven)
    /* ddabs039 */ self.abs64("-0.000000000001", "1E-12", .toNearestOrEven)
    /* ddabs040 */ self.abs64("2.1", "2.1", .toNearestOrEven)
    /* ddabs041 */ self.abs64("-100", "100", .toNearestOrEven)
    /* ddabs042 */ self.abs64("101.5", "101.5", .toNearestOrEven)
    /* ddabs043 */ self.abs64("-101.5", "101.5", .toNearestOrEven)
    /* ddabs060 */ self.abs64("-56267E-10", "0.0000056267", .toNearestOrEven)
    /* ddabs061 */ self.abs64("-56267E-5", "0.56267", .toNearestOrEven)
    /* ddabs062 */ self.abs64("-56267E-2", "562.67", .toNearestOrEven)
    /* ddabs063 */ self.abs64("-56267E-1", "5626.7", .toNearestOrEven)
    /* ddabs065 */ self.abs64("-56267E-0", "56267", .toNearestOrEven)
    /* ddabs111 */ self.abs64("0", "0", .toNearestOrEven)
    /* ddabs112 */ self.abs64("-0", "0", .toNearestOrEven)
    /* ddabs113 */ self.abs64("0E+6", "0E+6", .toNearestOrEven)
    /* ddabs114 */ self.abs64("-0E+6", "0E+6", .toNearestOrEven)
    /* ddabs115 */ self.abs64("0.0000", "0.0000", .toNearestOrEven)
    /* ddabs116 */ self.abs64("-0.0000", "0.0000", .toNearestOrEven)
    /* ddabs117 */ self.abs64("0E-141", "0E-141", .toNearestOrEven)
    /* ddabs118 */ self.abs64("-0E-141", "0E-141", .toNearestOrEven)
    /* ddabs121 */ self.abs64("2682682682682682", "2682682682682682", .toNearestOrEven)
    /* ddabs122 */ self.abs64("-2682682682682682", "2682682682682682", .toNearestOrEven)
    /* ddabs123 */ self.abs64("1341341341341341", "1341341341341341", .toNearestOrEven)
    /* ddabs124 */ self.abs64("-1341341341341341", "1341341341341341", .toNearestOrEven)
    /* ddabs131 */ self.abs64("9.999999999999999E+384", "9.999999999999999E+384", .toNearestOrEven)
    /* ddabs132 */ self.abs64("1E-383", "1E-383", .toNearestOrEven)
    /* ddabs133 */ self.abs64("1.000000000000000E-383", "1.000000000000000E-383", .toNearestOrEven)
    /* ddabs134 */ self.abs64("1E-398", "1E-398", .toNearestOrEven)
    /* ddabs135 */ self.abs64("-1E-398", "1E-398", .toNearestOrEven)
    /* ddabs136 */ self.abs64("-1.000000000000000E-383", "1.000000000000000E-383", .toNearestOrEven)
    /* ddabs137 */ self.abs64("-1E-383", "1E-383", .toNearestOrEven)
    /* ddabs138 */ self.abs64("-9.999999999999999E+384", "9.999999999999999E+384", .toNearestOrEven)
    /* ddabs321 */ self.abs64("1234567890123456", "1234567890123456", .toNearestOrEven)
    /* ddabs322 */ self.abs64("12345678000", "12345678000", .toNearestOrEven)
    /* ddabs323 */ self.abs64("1234567800", "1234567800", .toNearestOrEven)
    /* ddabs324 */ self.abs64("1234567890", "1234567890", .toNearestOrEven)
    /* ddabs325 */ self.abs64("1234567891", "1234567891", .toNearestOrEven)
    /* ddabs326 */ self.abs64("12345678901", "12345678901", .toNearestOrEven)
    /* ddabs327 */ self.abs64("1234567896", "1234567896", .toNearestOrEven)
    /* ddabs520 */ self.abs64("Inf", "Infinity", .toNearestOrEven)
    /* ddabs521 */ self.abs64("-Inf", "Infinity", .toNearestOrEven)
    /* ddabs522 */ self.abs64("NaN", "NaN", .toNearestOrEven)
    /* ddabs523 */ self.abs64("sNaN", "NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddabs524 */ self.abs64("NaN(0x16)", "NaN(0x16)", .toNearestOrEven)
    /* ddabs525 */ self.abs64("sNaN(0x21)", "NaN(0x21)", .toNearestOrEven, .isInvalidOperation)
    /* ddabs526 */ self.abs64("-NaN(0x16)", "-NaN(0x16)", .toNearestOrEven)
    /* ddabs527 */ self.abs64("-sNaN(0x21)", "-NaN(0x21)", .toNearestOrEven, .isInvalidOperation)
  }

  private func abs64(
    _ _arg0: String,
    _ _expected: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = arg0.magnitude
    let speleotroveResult = self.toSpeleotrove_magnitude(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
  }

  func test_abs128() {
    /* dqabs001 */ self.abs128("1", "1", .toNearestOrEven)
    /* dqabs002 */ self.abs128("-1", "1", .toNearestOrEven)
    /* dqabs003 */ self.abs128("1.00", "1.00", .toNearestOrEven)
    /* dqabs004 */ self.abs128("-1.00", "1.00", .toNearestOrEven)
    /* dqabs005 */ self.abs128("0", "0", .toNearestOrEven)
    /* dqabs006 */ self.abs128("0.00", "0.00", .toNearestOrEven)
    /* dqabs007 */ self.abs128("00.0", "0.0", .toNearestOrEven)
    /* dqabs008 */ self.abs128("00.00", "0.00", .toNearestOrEven)
    /* dqabs009 */ self.abs128("00", "0", .toNearestOrEven)
    /* dqabs010 */ self.abs128("-2", "2", .toNearestOrEven)
    /* dqabs011 */ self.abs128("2", "2", .toNearestOrEven)
    /* dqabs012 */ self.abs128("-2.00", "2.00", .toNearestOrEven)
    /* dqabs013 */ self.abs128("2.00", "2.00", .toNearestOrEven)
    /* dqabs014 */ self.abs128("-0", "0", .toNearestOrEven)
    /* dqabs015 */ self.abs128("-0.00", "0.00", .toNearestOrEven)
    /* dqabs016 */ self.abs128("-00.0", "0.0", .toNearestOrEven)
    /* dqabs017 */ self.abs128("-00.00", "0.00", .toNearestOrEven)
    /* dqabs018 */ self.abs128("-00", "0", .toNearestOrEven)
    /* dqabs020 */ self.abs128("-2000000", "2000000", .toNearestOrEven)
    /* dqabs021 */ self.abs128("2000000", "2000000", .toNearestOrEven)
    /* dqabs030 */ self.abs128("+0.1", "0.1", .toNearestOrEven)
    /* dqabs031 */ self.abs128("-0.1", "0.1", .toNearestOrEven)
    /* dqabs032 */ self.abs128("+0.01", "0.01", .toNearestOrEven)
    /* dqabs033 */ self.abs128("-0.01", "0.01", .toNearestOrEven)
    /* dqabs034 */ self.abs128("+0.001", "0.001", .toNearestOrEven)
    /* dqabs035 */ self.abs128("-0.001", "0.001", .toNearestOrEven)
    /* dqabs036 */ self.abs128("+0.000001", "0.000001", .toNearestOrEven)
    /* dqabs037 */ self.abs128("-0.000001", "0.000001", .toNearestOrEven)
    /* dqabs038 */ self.abs128("+0.000000000001", "1E-12", .toNearestOrEven)
    /* dqabs039 */ self.abs128("-0.000000000001", "1E-12", .toNearestOrEven)
    /* dqabs040 */ self.abs128("2.1", "2.1", .toNearestOrEven)
    /* dqabs041 */ self.abs128("-100", "100", .toNearestOrEven)
    /* dqabs042 */ self.abs128("101.5", "101.5", .toNearestOrEven)
    /* dqabs043 */ self.abs128("-101.5", "101.5", .toNearestOrEven)
    /* dqabs060 */ self.abs128("-56267E-10", "0.0000056267", .toNearestOrEven)
    /* dqabs061 */ self.abs128("-56267E-5", "0.56267", .toNearestOrEven)
    /* dqabs062 */ self.abs128("-56267E-2", "562.67", .toNearestOrEven)
    /* dqabs063 */ self.abs128("-56267E-1", "5626.7", .toNearestOrEven)
    /* dqabs065 */ self.abs128("-56267E-0", "56267", .toNearestOrEven)
    /* dqabs111 */ self.abs128("0", "0", .toNearestOrEven)
    /* dqabs112 */ self.abs128("-0", "0", .toNearestOrEven)
    /* dqabs113 */ self.abs128("0E+6", "0E+6", .toNearestOrEven)
    /* dqabs114 */ self.abs128("-0E+6", "0E+6", .toNearestOrEven)
    /* dqabs115 */ self.abs128("0.0000", "0.0000", .toNearestOrEven)
    /* dqabs116 */ self.abs128("-0.0000", "0.0000", .toNearestOrEven)
    /* dqabs117 */ self.abs128("0E-141", "0E-141", .toNearestOrEven)
    /* dqabs118 */ self.abs128("-0E-141", "0E-141", .toNearestOrEven)
    /* dqabs121 */ self.abs128("2682682682682682682682682682682682", "2682682682682682682682682682682682", .toNearestOrEven)
    /* dqabs122 */ self.abs128("-2682682682682682682682682682682682", "2682682682682682682682682682682682", .toNearestOrEven)
    /* dqabs123 */ self.abs128("1341341341341341341341341341341341", "1341341341341341341341341341341341", .toNearestOrEven)
    /* dqabs124 */ self.abs128("-1341341341341341341341341341341341", "1341341341341341341341341341341341", .toNearestOrEven)
    /* dqabs131 */ self.abs128("9.999999999999999999999999999999999E+6144", "9.999999999999999999999999999999999E+6144", .toNearestOrEven)
    /* dqabs132 */ self.abs128("1E-6143", "1E-6143", .toNearestOrEven)
    /* dqabs133 */ self.abs128("1.000000000000000000000000000000000E-6143", "1.000000000000000000000000000000000E-6143", .toNearestOrEven)
    /* dqabs134 */ self.abs128("1E-6176", "1E-6176", .toNearestOrEven)
    /* dqabs135 */ self.abs128("-1E-6176", "1E-6176", .toNearestOrEven)
    /* dqabs136 */ self.abs128("-1.000000000000000000000000000000000E-6143", "1.000000000000000000000000000000000E-6143", .toNearestOrEven)
    /* dqabs137 */ self.abs128("-1E-6143", "1E-6143", .toNearestOrEven)
    /* dqabs138 */ self.abs128("-9.999999999999999999999999999999999E+6144", "9.999999999999999999999999999999999E+6144", .toNearestOrEven)
    /* dqabs321 */ self.abs128("1234567890123456", "1234567890123456", .toNearestOrEven)
    /* dqabs322 */ self.abs128("12345678000", "12345678000", .toNearestOrEven)
    /* dqabs323 */ self.abs128("1234567800", "1234567800", .toNearestOrEven)
    /* dqabs324 */ self.abs128("1234567890", "1234567890", .toNearestOrEven)
    /* dqabs325 */ self.abs128("1234567891", "1234567891", .toNearestOrEven)
    /* dqabs326 */ self.abs128("12345678901", "12345678901", .toNearestOrEven)
    /* dqabs327 */ self.abs128("1234567896", "1234567896", .toNearestOrEven)
    /* dqabs520 */ self.abs128("Inf", "Infinity", .toNearestOrEven)
    /* dqabs521 */ self.abs128("-Inf", "Infinity", .toNearestOrEven)
    /* dqabs522 */ self.abs128("NaN", "NaN", .toNearestOrEven)
    /* dqabs523 */ self.abs128("sNaN", "NaN", .toNearestOrEven, .isInvalidOperation)
    /* dqabs524 */ self.abs128("NaN(0x16)", "NaN(0x16)", .toNearestOrEven)
    /* dqabs525 */ self.abs128("sNaN(0x21)", "NaN(0x21)", .toNearestOrEven, .isInvalidOperation)
    /* dqabs526 */ self.abs128("-NaN(0x16)", "-NaN(0x16)", .toNearestOrEven)
    /* dqabs527 */ self.abs128("-sNaN(0x21)", "-NaN(0x21)", .toNearestOrEven, .isInvalidOperation)
  }

  private func abs128(
    _ _arg0: String,
    _ _expected: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = arg0.magnitude
    let speleotroveResult = self.toSpeleotrove_magnitude(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
  }

  // MARK: - Class

  func test_class64() {
    /* ddcla001 */ self.class64("0", .positiveZero, .toNearestOrEven)
    /* ddcla002 */ self.class64("0.00", .positiveZero, .toNearestOrEven)
    /* ddcla003 */ self.class64("0E+5", .positiveZero, .toNearestOrEven)
    /* ddcla004 */ self.class64("1E-396", .positiveSubnormal, .toNearestOrEven)
    /* ddcla005 */ self.class64("0.1E-383", .positiveSubnormal, .toNearestOrEven)
    /* ddcla006 */ self.class64("0.999999999999999E-383", .positiveSubnormal, .toNearestOrEven)
    /* ddcla007 */ self.class64("1.000000000000000E-383", .positiveNormal, .toNearestOrEven)
    /* ddcla008 */ self.class64("1E-383", .positiveNormal, .toNearestOrEven)
    /* ddcla009 */ self.class64("1E-100", .positiveNormal, .toNearestOrEven)
    /* ddcla010 */ self.class64("1E-10", .positiveNormal, .toNearestOrEven)
    /* ddcla012 */ self.class64("1E-1", .positiveNormal, .toNearestOrEven)
    /* ddcla013 */ self.class64("1", .positiveNormal, .toNearestOrEven)
    /* ddcla014 */ self.class64("2.50", .positiveNormal, .toNearestOrEven)
    /* ddcla015 */ self.class64("100.100", .positiveNormal, .toNearestOrEven)
    /* ddcla016 */ self.class64("1E+30", .positiveNormal, .toNearestOrEven)
    /* ddcla017 */ self.class64("1E+384", .positiveNormal, .toNearestOrEven)
    /* ddcla018 */ self.class64("9.999999999999999E+384", .positiveNormal, .toNearestOrEven)
    /* ddcla019 */ self.class64("Inf", .positiveInfinity, .toNearestOrEven)
    /* ddcla021 */ self.class64("-0", .negativeZero, .toNearestOrEven)
    /* ddcla022 */ self.class64("-0.00", .negativeZero, .toNearestOrEven)
    /* ddcla023 */ self.class64("-0E+5", .negativeZero, .toNearestOrEven)
    /* ddcla024 */ self.class64("-1E-396", .negativeSubnormal, .toNearestOrEven)
    /* ddcla025 */ self.class64("-0.1E-383", .negativeSubnormal, .toNearestOrEven)
    /* ddcla026 */ self.class64("-0.999999999999999E-383", .negativeSubnormal, .toNearestOrEven)
    /* ddcla027 */ self.class64("-1.000000000000000E-383", .negativeNormal, .toNearestOrEven)
    /* ddcla028 */ self.class64("-1E-383", .negativeNormal, .toNearestOrEven)
    /* ddcla029 */ self.class64("-1E-100", .negativeNormal, .toNearestOrEven)
    /* ddcla030 */ self.class64("-1E-10", .negativeNormal, .toNearestOrEven)
    /* ddcla032 */ self.class64("-1E-1", .negativeNormal, .toNearestOrEven)
    /* ddcla033 */ self.class64("-1", .negativeNormal, .toNearestOrEven)
    /* ddcla034 */ self.class64("-2.50", .negativeNormal, .toNearestOrEven)
    /* ddcla035 */ self.class64("-100.100", .negativeNormal, .toNearestOrEven)
    /* ddcla036 */ self.class64("-1E+30", .negativeNormal, .toNearestOrEven)
    /* ddcla037 */ self.class64("-1E+384", .negativeNormal, .toNearestOrEven)
    /* ddcla038 */ self.class64("-9.999999999999999E+384", .negativeNormal, .toNearestOrEven)
    /* ddcla039 */ self.class64("-Inf", .negativeInfinity, .toNearestOrEven)
    /* ddcla041 */ self.class64("NaN", .quietNaN, .toNearestOrEven)
    /* ddcla042 */ self.class64("-NaN", .quietNaN, .toNearestOrEven)
    /* ddcla043 */ self.class64("+NaN(0x3039)", .quietNaN, .toNearestOrEven)
    /* ddcla044 */ self.class64("sNaN", .signalingNaN, .toNearestOrEven)
    /* ddcla045 */ self.class64("-sNaN", .signalingNaN, .toNearestOrEven)
    /* ddcla046 */ self.class64("+sNaN(0x3039)", .signalingNaN, .toNearestOrEven)
  }

  private func class64(
    _ _arg0: String,
    _ expected: FloatingPointClassification,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }

    let result = arg0.floatingPointClass
    XCTAssertEqual(result, expected, file: file, line: line)
  }

  func test_class128() {
    /* dqcla001 */ self.class128("0", .positiveZero, .toNearestOrEven)
    /* dqcla002 */ self.class128("0.00", .positiveZero, .toNearestOrEven)
    /* dqcla003 */ self.class128("0E+5", .positiveZero, .toNearestOrEven)
    /* dqcla004 */ self.class128("1E-6176", .positiveSubnormal, .toNearestOrEven)
    /* dqcla005 */ self.class128("0.1E-6143", .positiveSubnormal, .toNearestOrEven)
    /* dqcla006 */ self.class128("0.99999999999999999999999999999999E-6143", .positiveSubnormal, .toNearestOrEven)
    /* dqcla007 */ self.class128("1.00000000000000000000000000000000E-6143", .positiveNormal, .toNearestOrEven)
    /* dqcla008 */ self.class128("1E-6143", .positiveNormal, .toNearestOrEven)
    /* dqcla009 */ self.class128("1E-100", .positiveNormal, .toNearestOrEven)
    /* dqcla010 */ self.class128("1E-10", .positiveNormal, .toNearestOrEven)
    /* dqcla012 */ self.class128("1E-1", .positiveNormal, .toNearestOrEven)
    /* dqcla013 */ self.class128("1", .positiveNormal, .toNearestOrEven)
    /* dqcla014 */ self.class128("2.50", .positiveNormal, .toNearestOrEven)
    /* dqcla015 */ self.class128("100.100", .positiveNormal, .toNearestOrEven)
    /* dqcla016 */ self.class128("1E+30", .positiveNormal, .toNearestOrEven)
    /* dqcla017 */ self.class128("1E+6144", .positiveNormal, .toNearestOrEven)
    /* dqcla018 */ self.class128("9.99999999999999999999999999999999E+6144", .positiveNormal, .toNearestOrEven)
    /* dqcla019 */ self.class128("Inf", .positiveInfinity, .toNearestOrEven)
    /* dqcla021 */ self.class128("-0", .negativeZero, .toNearestOrEven)
    /* dqcla022 */ self.class128("-0.00", .negativeZero, .toNearestOrEven)
    /* dqcla023 */ self.class128("-0E+5", .negativeZero, .toNearestOrEven)
    /* dqcla024 */ self.class128("-1E-6176", .negativeSubnormal, .toNearestOrEven)
    /* dqcla025 */ self.class128("-0.1E-6143", .negativeSubnormal, .toNearestOrEven)
    /* dqcla026 */ self.class128("-0.99999999999999999999999999999999E-6143", .negativeSubnormal, .toNearestOrEven)
    /* dqcla027 */ self.class128("-1.00000000000000000000000000000000E-6143", .negativeNormal, .toNearestOrEven)
    /* dqcla028 */ self.class128("-1E-6143", .negativeNormal, .toNearestOrEven)
    /* dqcla029 */ self.class128("-1E-100", .negativeNormal, .toNearestOrEven)
    /* dqcla030 */ self.class128("-1E-10", .negativeNormal, .toNearestOrEven)
    /* dqcla032 */ self.class128("-1E-1", .negativeNormal, .toNearestOrEven)
    /* dqcla033 */ self.class128("-1", .negativeNormal, .toNearestOrEven)
    /* dqcla034 */ self.class128("-2.50", .negativeNormal, .toNearestOrEven)
    /* dqcla035 */ self.class128("-100.100", .negativeNormal, .toNearestOrEven)
    /* dqcla036 */ self.class128("-1E+30", .negativeNormal, .toNearestOrEven)
    /* dqcla037 */ self.class128("-1E+6144", .negativeNormal, .toNearestOrEven)
    /* dqcla039 */ self.class128("-Inf", .negativeInfinity, .toNearestOrEven)
    /* dqcla041 */ self.class128("NaN", .quietNaN, .toNearestOrEven)
    /* dqcla042 */ self.class128("-NaN", .quietNaN, .toNearestOrEven)
    /* dqcla043 */ self.class128("+NaN(0x3039)", .quietNaN, .toNearestOrEven)
    /* dqcla044 */ self.class128("sNaN", .signalingNaN, .toNearestOrEven)
    /* dqcla045 */ self.class128("-sNaN", .signalingNaN, .toNearestOrEven)
    /* dqcla046 */ self.class128("+sNaN(0x3039)", .signalingNaN, .toNearestOrEven)
    /* dqcla0614 */ self.class128("-9.99999999999999999999999999999999E+6144", .negativeNormal, .toNearestOrEven)
  }

  private func class128(
    _ _arg0: String,
    _ expected: FloatingPointClassification,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }

    let result = arg0.floatingPointClass
    XCTAssertEqual(result, expected, file: file, line: line)
  }
}
