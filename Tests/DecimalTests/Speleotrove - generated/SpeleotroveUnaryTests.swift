// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class SpeleotroveUnaryTests: XCTestCase, SpeleotroveMixin {

  // MARK: - Minus

  func test_minus64() {
    /* ddmns001 */ self.minus64("+7.50", "-7.50", .toNearestOrEven)
    /* ddmns011 */ self.minus64("Infinity", "-Infinity", .toNearestOrEven)
    /* ddmns012 */ self.minus64("-Infinity", "Infinity", .toNearestOrEven)
    /* ddmns021 */ self.minus64("NaN", "NaN", .toNearestOrEven)
    /* ddmns022 */ self.minus64("-NaN", "-NaN", .toNearestOrEven)
    /* ddmns023 */ self.minus64("sNaN", "NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddmns024 */ self.minus64("-sNaN", "-NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddmns031 */ self.minus64("NaN(0xd)", "NaN(0xd)", .toNearestOrEven)
    /* ddmns032 */ self.minus64("-NaN(0xd)", "-NaN(0xd)", .toNearestOrEven)
    /* ddmns033 */ self.minus64("sNaN(0xd)", "NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* ddmns034 */ self.minus64("-sNaN(0xd)", "-NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* ddmns035 */ self.minus64("NaN(0x46)", "NaN(0x46)", .toNearestOrEven)
    /* ddmns036 */ self.minus64("-NaN(0x46)", "-NaN(0x46)", .toNearestOrEven)
    /* ddmns037 */ self.minus64("sNaN(0x65)", "NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* ddmns038 */ self.minus64("-sNaN(0x65)", "-NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* ddmns101 */ self.minus64("7", "-7", .toNearestOrEven)
    /* ddmns102 */ self.minus64("-7", "7", .toNearestOrEven)
    /* ddmns103 */ self.minus64("75", "-75", .toNearestOrEven)
    /* ddmns104 */ self.minus64("-75", "75", .toNearestOrEven)
    /* ddmns105 */ self.minus64("7.50", "-7.50", .toNearestOrEven)
    /* ddmns106 */ self.minus64("-7.50", "7.50", .toNearestOrEven)
    /* ddmns107 */ self.minus64("7.500", "-7.500", .toNearestOrEven)
    /* ddmns108 */ self.minus64("-7.500", "7.500", .toNearestOrEven)
    /* ddmns111 */ self.minus64("0", "0", .toNearestOrEven)
    /* ddmns112 */ self.minus64("-0", "0", .toNearestOrEven)
    /* ddmns113 */ self.minus64("0E+4", "0E+4", .toNearestOrEven)
    /* ddmns114 */ self.minus64("-0E+4", "0E+4", .toNearestOrEven)
    /* ddmns115 */ self.minus64("0.0000", "0.0000", .toNearestOrEven)
    /* ddmns116 */ self.minus64("-0.0000", "0.0000", .toNearestOrEven)
    /* ddmns117 */ self.minus64("0E-141", "0E-141", .toNearestOrEven)
    /* ddmns118 */ self.minus64("-0E-141", "0E-141", .toNearestOrEven)
    /* ddmns121 */ self.minus64("2682682682682682", "-2682682682682682", .toNearestOrEven)
    /* ddmns122 */ self.minus64("-2682682682682682", "2682682682682682", .toNearestOrEven)
    /* ddmns123 */ self.minus64("1341341341341341", "-1341341341341341", .toNearestOrEven)
    /* ddmns124 */ self.minus64("-1341341341341341", "1341341341341341", .toNearestOrEven)
    /* ddmns131 */ self.minus64("9.999999999999999E+384", "-9.999999999999999E+384", .toNearestOrEven)
    /* ddmns132 */ self.minus64("1E-383", "-1E-383", .toNearestOrEven)
    /* ddmns133 */ self.minus64("1.000000000000000E-383", "-1.000000000000000E-383", .toNearestOrEven)
    /* ddmns134 */ self.minus64("1E-398", "-1E-398", .toNearestOrEven)
    /* ddmns135 */ self.minus64("-1E-398", "1E-398", .toNearestOrEven)
    /* ddmns136 */ self.minus64("-1.000000000000000E-383", "1.000000000000000E-383", .toNearestOrEven)
    /* ddmns137 */ self.minus64("-1E-383", "1E-383", .toNearestOrEven)
    /* ddmns138 */ self.minus64("-9.999999999999999E+384", "9.999999999999999E+384", .toNearestOrEven)
  }

  private func minus64(
    _ _arg0: String,
    _ _expected: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = -arg0
    let speleotroveResult = self.toSpeleotrove_unaryMinus(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
  }

  func test_minus128() {
    /* dqmns001 */ self.minus128("+7.50", "-7.50", .toNearestOrEven)
    /* dqmns011 */ self.minus128("Infinity", "-Infinity", .toNearestOrEven)
    /* dqmns012 */ self.minus128("-Infinity", "Infinity", .toNearestOrEven)
    /* dqmns021 */ self.minus128("NaN", "NaN", .toNearestOrEven)
    /* dqmns022 */ self.minus128("-NaN", "-NaN", .toNearestOrEven)
    /* dqmns023 */ self.minus128("sNaN", "NaN", .toNearestOrEven, .isInvalidOperation)
    /* dqmns024 */ self.minus128("-sNaN", "-NaN", .toNearestOrEven, .isInvalidOperation)
    /* dqmns031 */ self.minus128("NaN(0xd)", "NaN(0xd)", .toNearestOrEven)
    /* dqmns032 */ self.minus128("-NaN(0xd)", "-NaN(0xd)", .toNearestOrEven)
    /* dqmns033 */ self.minus128("sNaN(0xd)", "NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* dqmns034 */ self.minus128("-sNaN(0xd)", "-NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* dqmns035 */ self.minus128("NaN(0x46)", "NaN(0x46)", .toNearestOrEven)
    /* dqmns036 */ self.minus128("-NaN(0x46)", "-NaN(0x46)", .toNearestOrEven)
    /* dqmns037 */ self.minus128("sNaN(0x65)", "NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* dqmns038 */ self.minus128("-sNaN(0x65)", "-NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* dqmns101 */ self.minus128("7", "-7", .toNearestOrEven)
    /* dqmns102 */ self.minus128("-7", "7", .toNearestOrEven)
    /* dqmns103 */ self.minus128("75", "-75", .toNearestOrEven)
    /* dqmns104 */ self.minus128("-75", "75", .toNearestOrEven)
    /* dqmns105 */ self.minus128("7.50", "-7.50", .toNearestOrEven)
    /* dqmns106 */ self.minus128("-7.50", "7.50", .toNearestOrEven)
    /* dqmns107 */ self.minus128("7.500", "-7.500", .toNearestOrEven)
    /* dqmns108 */ self.minus128("-7.500", "7.500", .toNearestOrEven)
    /* dqmns111 */ self.minus128("0", "0", .toNearestOrEven)
    /* dqmns112 */ self.minus128("-0", "0", .toNearestOrEven)
    /* dqmns113 */ self.minus128("0E+4", "0E+4", .toNearestOrEven)
    /* dqmns114 */ self.minus128("-0E+4", "0E+4", .toNearestOrEven)
    /* dqmns115 */ self.minus128("0.0000", "0.0000", .toNearestOrEven)
    /* dqmns116 */ self.minus128("-0.0000", "0.0000", .toNearestOrEven)
    /* dqmns117 */ self.minus128("0E-141", "0E-141", .toNearestOrEven)
    /* dqmns118 */ self.minus128("-0E-141", "0E-141", .toNearestOrEven)
    /* dqmns121 */ self.minus128("2682682682682682682682682682682682", "-2682682682682682682682682682682682", .toNearestOrEven)
    /* dqmns122 */ self.minus128("-2682682682682682682682682682682682", "2682682682682682682682682682682682", .toNearestOrEven)
    /* dqmns123 */ self.minus128("1341341341341341341341341341341341", "-1341341341341341341341341341341341", .toNearestOrEven)
    /* dqmns124 */ self.minus128("-1341341341341341341341341341341341", "1341341341341341341341341341341341", .toNearestOrEven)
    /* dqmns131 */ self.minus128("9.999999999999999999999999999999999E+6144", "-9.999999999999999999999999999999999E+6144", .toNearestOrEven)
    /* dqmns132 */ self.minus128("1E-6143", "-1E-6143", .toNearestOrEven)
    /* dqmns133 */ self.minus128("1.000000000000000000000000000000000E-6143", "-1.000000000000000000000000000000000E-6143", .toNearestOrEven)
    /* dqmns134 */ self.minus128("1E-6176", "-1E-6176", .toNearestOrEven)
    /* dqmns135 */ self.minus128("-1E-6176", "1E-6176", .toNearestOrEven)
    /* dqmns136 */ self.minus128("-1.000000000000000000000000000000000E-6143", "1.000000000000000000000000000000000E-6143", .toNearestOrEven)
    /* dqmns137 */ self.minus128("-1E-6143", "1E-6143", .toNearestOrEven)
    /* dqmns138 */ self.minus128("-9.999999999999999999999999999999999E+6144", "9.999999999999999999999999999999999E+6144", .toNearestOrEven)
  }

  private func minus128(
    _ _arg0: String,
    _ _expected: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = -arg0
    let speleotroveResult = self.toSpeleotrove_unaryMinus(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
  }

  // MARK: - Plus

  func test_plus64() {
    /* ddpls001 */ self.plus64("+7.50", "7.50", .toNearestOrEven)
    /* ddpls011 */ self.plus64("Infinity", "Infinity", .toNearestOrEven)
    /* ddpls012 */ self.plus64("-Infinity", "-Infinity", .toNearestOrEven)
    /* ddpls021 */ self.plus64("NaN", "NaN", .toNearestOrEven)
    /* ddpls022 */ self.plus64("-NaN", "-NaN", .toNearestOrEven)
    /* ddpls023 */ self.plus64("sNaN", "NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddpls024 */ self.plus64("-sNaN", "-NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddpls031 */ self.plus64("NaN(0xd)", "NaN(0xd)", .toNearestOrEven)
    /* ddpls032 */ self.plus64("-NaN(0xd)", "-NaN(0xd)", .toNearestOrEven)
    /* ddpls033 */ self.plus64("sNaN(0xd)", "NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* ddpls034 */ self.plus64("-sNaN(0xd)", "-NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* ddpls035 */ self.plus64("NaN(0x46)", "NaN(0x46)", .toNearestOrEven)
    /* ddpls036 */ self.plus64("-NaN(0x46)", "-NaN(0x46)", .toNearestOrEven)
    /* ddpls037 */ self.plus64("sNaN(0x65)", "NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* ddpls038 */ self.plus64("-sNaN(0x65)", "-NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* ddpls101 */ self.plus64("7", "7", .toNearestOrEven)
    /* ddpls102 */ self.plus64("-7", "-7", .toNearestOrEven)
    /* ddpls103 */ self.plus64("75", "75", .toNearestOrEven)
    /* ddpls104 */ self.plus64("-75", "-75", .toNearestOrEven)
    /* ddpls105 */ self.plus64("7.50", "7.50", .toNearestOrEven)
    /* ddpls106 */ self.plus64("-7.50", "-7.50", .toNearestOrEven)
    /* ddpls107 */ self.plus64("7.500", "7.500", .toNearestOrEven)
    /* ddpls108 */ self.plus64("-7.500", "-7.500", .toNearestOrEven)
    /* ddpls111 */ self.plus64("0", "0", .toNearestOrEven)
    /* ddpls112 */ self.plus64("-0", "0", .toNearestOrEven)
    /* ddpls113 */ self.plus64("0E+4", "0E+4", .toNearestOrEven)
    /* ddpls114 */ self.plus64("-0E+4", "0E+4", .toNearestOrEven)
    /* ddpls115 */ self.plus64("0.0000", "0.0000", .toNearestOrEven)
    /* ddpls116 */ self.plus64("-0.0000", "0.0000", .toNearestOrEven)
    /* ddpls117 */ self.plus64("0E-141", "0E-141", .toNearestOrEven)
    /* ddpls118 */ self.plus64("-0E-141", "0E-141", .toNearestOrEven)
    /* ddpls121 */ self.plus64("2682682682682682", "2682682682682682", .toNearestOrEven)
    /* ddpls122 */ self.plus64("-2682682682682682", "-2682682682682682", .toNearestOrEven)
    /* ddpls123 */ self.plus64("1341341341341341", "1341341341341341", .toNearestOrEven)
    /* ddpls124 */ self.plus64("-1341341341341341", "-1341341341341341", .toNearestOrEven)
    /* ddpls131 */ self.plus64("9.999999999999999E+384", "9.999999999999999E+384", .toNearestOrEven)
    /* ddpls132 */ self.plus64("1E-383", "1E-383", .toNearestOrEven)
    /* ddpls133 */ self.plus64("1.000000000000000E-383", "1.000000000000000E-383", .toNearestOrEven)
    /* ddpls134 */ self.plus64("1E-398", "1E-398", .toNearestOrEven)
    /* ddpls135 */ self.plus64("-1E-398", "-1E-398", .toNearestOrEven)
    /* ddpls136 */ self.plus64("-1.000000000000000E-383", "-1.000000000000000E-383", .toNearestOrEven)
    /* ddpls137 */ self.plus64("-1E-383", "-1E-383", .toNearestOrEven)
    /* ddpls138 */ self.plus64("-9.999999999999999E+384", "-9.999999999999999E+384", .toNearestOrEven)
  }

  private func plus64(
    _ _arg0: String,
    _ _expected: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = +arg0
    let speleotroveResult = self.toSpeleotrove_unaryPlus(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
  }

  func test_plus128() {
    /* ddqls021 */ self.plus128("NaN", "NaN", .toNearestOrEven)
    /* ddqls022 */ self.plus128("-NaN", "-NaN", .toNearestOrEven)
    /* ddqls023 */ self.plus128("sNaN", "NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddqls024 */ self.plus128("-sNaN", "-NaN", .toNearestOrEven, .isInvalidOperation)
    /* ddqls031 */ self.plus128("NaN(0xd)", "NaN(0xd)", .toNearestOrEven)
    /* ddqls032 */ self.plus128("-NaN(0xd)", "-NaN(0xd)", .toNearestOrEven)
    /* ddqls033 */ self.plus128("sNaN(0xd)", "NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* ddqls034 */ self.plus128("-sNaN(0xd)", "-NaN(0xd)", .toNearestOrEven, .isInvalidOperation)
    /* ddqls035 */ self.plus128("NaN(0x46)", "NaN(0x46)", .toNearestOrEven)
    /* ddqls036 */ self.plus128("-NaN(0x46)", "-NaN(0x46)", .toNearestOrEven)
    /* ddqls037 */ self.plus128("sNaN(0x65)", "NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* ddqls038 */ self.plus128("-sNaN(0x65)", "-NaN(0x65)", .toNearestOrEven, .isInvalidOperation)
    /* dqpls001 */ self.plus128("+7.50", "7.50", .toNearestOrEven)
    /* dqpls011 */ self.plus128("Infinity", "Infinity", .toNearestOrEven)
    /* dqpls012 */ self.plus128("-Infinity", "-Infinity", .toNearestOrEven)
    /* dqpls101 */ self.plus128("7", "7", .toNearestOrEven)
    /* dqpls102 */ self.plus128("-7", "-7", .toNearestOrEven)
    /* dqpls103 */ self.plus128("75", "75", .toNearestOrEven)
    /* dqpls104 */ self.plus128("-75", "-75", .toNearestOrEven)
    /* dqpls105 */ self.plus128("7.50", "7.50", .toNearestOrEven)
    /* dqpls106 */ self.plus128("-7.50", "-7.50", .toNearestOrEven)
    /* dqpls107 */ self.plus128("7.500", "7.500", .toNearestOrEven)
    /* dqpls108 */ self.plus128("-7.500", "-7.500", .toNearestOrEven)
    /* dqpls111 */ self.plus128("0", "0", .toNearestOrEven)
    /* dqpls112 */ self.plus128("-0", "0", .toNearestOrEven)
    /* dqpls113 */ self.plus128("0E+4", "0E+4", .toNearestOrEven)
    /* dqpls114 */ self.plus128("-0E+4", "0E+4", .toNearestOrEven)
    /* dqpls115 */ self.plus128("0.0000", "0.0000", .toNearestOrEven)
    /* dqpls116 */ self.plus128("-0.0000", "0.0000", .toNearestOrEven)
    /* dqpls117 */ self.plus128("0E-141", "0E-141", .toNearestOrEven)
    /* dqpls118 */ self.plus128("-0E-141", "0E-141", .toNearestOrEven)
    /* dqpls121 */ self.plus128("2682682682682682682682682682682682", "2682682682682682682682682682682682", .toNearestOrEven)
    /* dqpls122 */ self.plus128("-2682682682682682682682682682682682", "-2682682682682682682682682682682682", .toNearestOrEven)
    /* dqpls123 */ self.plus128("1341341341341341341341341341341341", "1341341341341341341341341341341341", .toNearestOrEven)
    /* dqpls124 */ self.plus128("-1341341341341341341341341341341341", "-1341341341341341341341341341341341", .toNearestOrEven)
    /* dqpls131 */ self.plus128("9.999999999999999999999999999999999E+6144", "9.999999999999999999999999999999999E+6144", .toNearestOrEven)
    /* dqpls132 */ self.plus128("1E-6143", "1E-6143", .toNearestOrEven)
    /* dqpls133 */ self.plus128("1.000000000000000000000000000000000E-6143", "1.000000000000000000000000000000000E-6143", .toNearestOrEven)
    /* dqpls134 */ self.plus128("1E-6176", "1E-6176", .toNearestOrEven)
    /* dqpls135 */ self.plus128("-1E-6176", "-1E-6176", .toNearestOrEven)
    /* dqpls136 */ self.plus128("-1.000000000000000000000000000000000E-6143", "-1.000000000000000000000000000000000E-6143", .toNearestOrEven)
    /* dqpls137 */ self.plus128("-1E-6143", "-1E-6143", .toNearestOrEven)
    /* dqpls138 */ self.plus128("-9.999999999999999999999999999999999E+6144", "-9.999999999999999999999999999999999E+6144", .toNearestOrEven)
  }

  private func plus128(
    _ _arg0: String,
    _ _expected: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ _expectedStatus: DecimalStatus? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = +arg0
    let speleotroveResult = self.toSpeleotrove_unaryPlus(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
  }
}
