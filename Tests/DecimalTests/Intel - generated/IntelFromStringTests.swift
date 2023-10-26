// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelFromStringTests: XCTestCase, IntelMixin {

  func test_bid32_from_string() {
    self.bid32_from_string("0", "1.0000015", "[2f8f4242]", "20")
    self.bid32_from_string("0", "1.0", "[3200000a]", "00")
    self.bid32_from_string("0", "-1.0", "[b200000a]", "00")
    self.bid32_from_string("0", "1.0e-96", "[0200000a]", "00")
    self.bid32_from_string("0", "-1.0e-96", "[8200000a]", "00")
    self.bid32_from_string("0", "9.999999e-95", "[6018967f]", "00")
    self.bid32_from_string("0", "-9.999999e-95", "[e018967f]", "00")
    self.bid32_from_string("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_from_string("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_from_string("0", "+inf", "[78000000]", "00")
    self.bid32_from_string("0", "+Inf", "[78000000]", "00")
    self.bid32_from_string("0", "+INF", "[78000000]", "00")
    self.bid32_from_string("0", "+NaN", "[7c000000]", "00")
    self.bid32_from_string("0", "+NAN", "[7c000000]", "00")
    self.bid32_from_string("0", "-nan", "[fc000000]", "00")
    self.bid32_from_string("0", "+SNaN", "[7e000000]", "00")
    self.bid32_from_string("0", "+SNAN", "[7e000000]", "00")
    self.bid32_from_string("0", "-snan", "[fe000000]", "00")
    self.bid32_from_string("1", "1.0000015", "[2f8f4241]", "20")
    self.bid32_from_string("2", "1.0000015", "[2f8f4242]", "20")
    self.bid32_from_string("3", "1.0000015", "[2f8f4241]", "20")
    self.bid32_from_string("4", "1.0000015", "[2f8f4242]", "20")
    self.bid32_from_string("2", "-9.9999995", "[ebf8967f]", "20")
    self.bid32_from_string("1", "-9.9999995", "[b00f4240]", "20")
    self.bid32_from_string("0", "9.9999995", "[300f4240]", "20")
    self.bid32_from_string("2", "9.9999995", "[300f4240]", "20")
    self.bid32_from_string("4", "9.9999995", "[300f4240]", "20")
    self.bid32_from_string("3", "9.9999995", "[6bf8967f]", "20")
    self.bid32_from_string("1", "9.9999995", "[6bf8967f]", "20")
    self.bid32_from_string("0", ".0", "[32000000]", "00")
    self.bid32_from_string("0", "000.0", "[32000000]", "00")
    self.bid32_from_string("0", "0.0000000000000000000000000000000000001001", "[1e8003e9]", "00")
    self.bid32_from_string("1", "0.0000000000000000000000000000000000001001", "[1e8003e9]", "00")
    self.bid32_from_string("0", "0.", "[32800000]", "00")
    self.bid32_from_string("0", "1.", "[32800001]", "00")
    self.bid32_from_string("0", "a", "[7c000000]", "00")
    self.bid32_from_string("0", "..", "[7c000000]", "00")
    self.bid32_from_string("0", "1..", "[7c000000]", "00")
    self.bid32_from_string("0", "0.0.", "[7c000000]", "00")
    self.bid32_from_string("0", "1.0000005", "[2f8f4240]", "20")
    self.bid32_from_string("2", "1.0000005", "[2f8f4241]", "20")
    self.bid32_from_string("4", "1.0000005", "[2f8f4241]", "20")
    self.bid32_from_string("3", "1.0000005", "[2f8f4240]", "20")
    self.bid32_from_string("1", "1.0000005", "[2f8f4240]", "20")
    self.bid32_from_string("0", "1.00000051", "[2f8f4241]", "20")
    self.bid32_from_string("2", "1.00000051", "[2f8f4241]", "20")
    self.bid32_from_string("4", "1.00000051", "[2f8f4241]", "20")
    self.bid32_from_string("3", "1.00000051", "[2f8f4240]", "20")
    self.bid32_from_string("1", "1.00000051", "[2f8f4240]", "20")
    self.bid32_from_string("0", "1.0000004999999999999999", "[2f8f4240]", "20")
    self.bid32_from_string("2", "1.0000004999999999999999", "[2f8f4241]", "20")
    self.bid32_from_string("1", "1.0000004999999999999999", "[2f8f4240]", "20")
    self.bid32_from_string("4", "1.0000004999999999999999", "[2f8f4240]", "20")
    self.bid32_from_string("3", "1.0000004999999999999999", "[2f8f4240]", "20")
    self.bid32_from_string("0", "1.1E2", "[3300000b]", "00")
    self.bid32_from_string("0", "1.1P2", "[7c000000]", "00")
    self.bid32_from_string("0", "1.1EE", "[7c000000]", "00")
    self.bid32_from_string("0", "1.1P-2", "[7c000000]", "00")
    self.bid32_from_string("0", "1.1E-2E", "[7c000000]", "00")
    self.bid32_from_string("0", "1.0000015", "[2f8f4242]", "20")
    self.bid32_from_string("2", "1.0000015", "[2f8f4242]", "20")
    self.bid32_from_string("4", "1.0000015", "[2f8f4242]", "20")
    self.bid32_from_string("3", "1.0000015", "[2f8f4241]", "20")
    self.bid32_from_string("1", "1.0000015", "[2f8f4241]", "20")
    self.bid32_from_string("0", "+INF", "[78000000]", "00")
    self.bid32_from_string("0", "+INFi", "[7c000000]", "00")
    self.bid32_from_string("0", "+NAN", "[7c000000]", "00")
    self.bid32_from_string("0", "+SNAN", "[7e000000]", "00")
    self.bid32_from_string("0", "+SNAN", "[7e000000]", "00")
    self.bid32_from_string("0", "+inf", "[78000000]", "00")
    self.bid32_from_string("0", "+nan", "[7c000000]", "00")
    self.bid32_from_string("0", "+snan", "[7e000000]", "00")
    self.bid32_from_string("0", "+INFINITY", "[78000000]", "00")
    self.bid32_from_string("0", "+infinity", "[78000000]", "00")
    self.bid32_from_string("0", "+INFiNITY", "[78000000]", "00")
    self.bid32_from_string("0", "+INFINITYi", "[7c000000]", "00")
    self.bid32_from_string("0", "INF", "[78000000]", "00")
    self.bid32_from_string("0", "INFi", "[7c000000]", "00")
    self.bid32_from_string("0", "NAN", "[7c000000]", "00")
    self.bid32_from_string("0", "SNAN", "[7e000000]", "00")
    self.bid32_from_string("0", "SNAN", "[7e000000]", "00")
    self.bid32_from_string("0", "inf", "[78000000]", "00")
    self.bid32_from_string("0", "nan", "[7c000000]", "00")
    self.bid32_from_string("0", "snan", "[7e000000]", "00")
    self.bid32_from_string("0", "INFINITY", "[78000000]", "00")
    self.bid32_from_string("0", "infinity", "[78000000]", "00")
    self.bid32_from_string("0", "INFiNITY", "[78000000]", "00")
    self.bid32_from_string("0", "INFINITYi", "[7c000000]", "00")
    self.bid32_from_string("0", "1E-102", "[00000000]", "30")
  }

  private func bid32_from_string(
    _ _rounding: String,
    _ arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = Decimal32(arg0, rounding: rounding, status: &status)
    let resultIntel = self.toIntel_parse(arg0, rounding, &status, result: result)
    self.assertEqual(resultIntel, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_from_string() {
    self.bid64_from_string("0", "12345678901234565", "1234567890123456e1", "20")
    self.bid64_from_string("0", "+Inf", "[7800000000000000]", "00")
    self.bid64_from_string("0", "+NaN", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "+SNaN", "[7e00000000000000]", "00")
    self.bid64_from_string("1", "12345678901234565", "1234567890123456e1", "20")
    self.bid64_from_string("2", "12345678901234565", "1234567890123457e1", "20")
    self.bid64_from_string("3", "12345678901234565", "1234567890123456e1", "20")
    self.bid64_from_string("4", "12345678901234565", "1234567890123457e1", "20")
    self.bid64_from_string("2", "-9.9999999999999995", "[ebfb86f26fc0ffff]", "20")
    self.bid64_from_string("1", "-9.9999999999999995", "[b0038d7ea4c68000]", "20")
    self.bid64_from_string("0", "9.9999999999999995", "[30038d7ea4c68000]", "20")
    self.bid64_from_string("2", "9.9999999999999995", "[30038d7ea4c68000]", "20")
    self.bid64_from_string("4", "9.9999999999999995", "[30038d7ea4c68000]", "20")
    self.bid64_from_string("3", "9.9999999999999995", "[6bfb86f26fc0ffff]", "20")
    self.bid64_from_string("1", "9.9999999999999995", "[6bfb86f26fc0ffff]", "20")
    self.bid64_from_string("0", "1.0000000000000015", "[2fe38d7ea4c68002]", "20")
    self.bid64_from_string("2", "1.0000000000000015", "[2fe38d7ea4c68002]", "20")
    self.bid64_from_string("4", "1.0000000000000015", "[2fe38d7ea4c68002]", "20")
    self.bid64_from_string("3", "1.0000000000000015", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("1", "1.0000000000000015", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("1", "000.0", "[31a0000000000000]", "00")
    self.bid64_from_string("1", "0.0000000000000000000000000000000000000000000001001", "[2ba00000000003e9]", "00")
    self.bid64_from_string("1", "0.0000000000000000000000000000000000000000000001001", "[2ba00000000003e9]", "00")
    self.bid64_from_string("0", "0.", "[31c0000000000000]", "00")
    self.bid64_from_string("0", "1.", "[31c0000000000001]", "00")
    self.bid64_from_string("0", "1..", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "1.0000000000000005", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("2", "1.0000000000000005", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("4", "1.0000000000000005", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("3", "1.0000000000000005", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("1", "1.0000000000000005", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("0", "1.00000000000000051", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("2", "1.00000000000000051", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("4", "1.00000000000000051", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("3", "1.00000000000000051", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("1", "1.00000000000000051", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("0", "1.0000000000000004999999999999999", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("2", "1.0000000000000004999999999999999", "[2fe38d7ea4c68001]", "20")
    self.bid64_from_string("1", "1.0000000000000004999999999999999", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("4", "1.0000000000000004999999999999999", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("3", "1.0000000000000004999999999999999", "[2fe38d7ea4c68000]", "20")
    self.bid64_from_string("0", "1.1E2", "[31e000000000000b]", "00")
    self.bid64_from_string("0", "1.1P2", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "1.1EE", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "1.1P-2", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "1.1E-2E", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "+INF", "[7800000000000000]", "00")
    self.bid64_from_string("0", "+INFi", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "+NAN", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "+SNAN", "[7e00000000000000]", "00")
    self.bid64_from_string("0", "+SNAN", "[7e00000000000000]", "00")
    self.bid64_from_string("0", "+inf", "[7800000000000000]", "00")
    self.bid64_from_string("0", "+nan", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "+snan", "[7e00000000000000]", "00")
    self.bid64_from_string("0", "+INFINITY", "[7800000000000000]", "00")
    self.bid64_from_string("0", "+infinity", "[7800000000000000]", "00")
    self.bid64_from_string("0", "+INFiNITY", "[7800000000000000]", "00")
    self.bid64_from_string("0", "+INFINITYi", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "INF", "[7800000000000000]", "00")
    self.bid64_from_string("0", "INFi", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "NAN", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "SNAN", "[7e00000000000000]", "00")
    self.bid64_from_string("0", "SNAN", "[7e00000000000000]", "00")
    self.bid64_from_string("0", "inf", "[7800000000000000]", "00")
    self.bid64_from_string("0", "nan", "[7c00000000000000]", "00")
    self.bid64_from_string("0", "snan", "[7e00000000000000]", "00")
    self.bid64_from_string("0", "INFINITY", "[7800000000000000]", "00")
    self.bid64_from_string("0", "infinity", "[7800000000000000]", "00")
    self.bid64_from_string("0", "INFiNITY", "[7800000000000000]", "00")
    self.bid64_from_string("0", "INFINITYi", "[7c00000000000000]", "00")
  }

  private func bid64_from_string(
    _ _rounding: String,
    _ arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = Decimal64(arg0, rounding: rounding, status: &status)
    let resultIntel = self.toIntel_parse(arg0, rounding, &status, result: result)
    self.assertEqual(resultIntel, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_from_string() {
    self.bid128_from_string("0", "0e6176", "0e6111", "00")
    self.bid128_from_string("0", "12345678901234567890123456789012345", "1234567890123456789012345678901234e1", "20")
    self.bid128_from_string("1", "12345678901234567890123456789012345", "1234567890123456789012345678901234e1", "20")
    self.bid128_from_string("2", "12345678901234567890123456789012345", "1234567890123456789012345678901235e1", "20")
    self.bid128_from_string("3", "12345678901234567890123456789012345", "1234567890123456789012345678901234e1", "20")
    self.bid128_from_string("4", "12345678901234567890123456789012345", "1234567890123456789012345678901235e1", "20")
    self.bid128_from_string("2", "-9.9999999999999999999999999999999995", "[afffed09bead87c0378d8e63ffffffff]", "20")
    self.bid128_from_string("1", "-9.9999999999999999999999999999999995", "[b000314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("0", "9.9999999999999999999999999999999995", "[3000314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("2", "9.9999999999999999999999999999999995", "[3000314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("4", "9.9999999999999999999999999999999995", "[3000314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("3", "9.9999999999999999999999999999999995", "[2fffed09bead87c0378d8e63ffffffff]", "20")
    self.bid128_from_string("1", "9.9999999999999999999999999999999995", "[2fffed09bead87c0378d8e63ffffffff]", "20")
    self.bid128_from_string("0", "1.0000000000000000000000000000000015", "[2ffe314dc6448d9338c15b0a00000002]", "20")
    self.bid128_from_string("2", "1.0000000000000000000000000000000015", "[2ffe314dc6448d9338c15b0a00000002]", "20")
    self.bid128_from_string("4", "1.0000000000000000000000000000000015", "[2ffe314dc6448d9338c15b0a00000002]", "20")
    self.bid128_from_string("3", "1.0000000000000000000000000000000015", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("1", "1.0000000000000000000000000000000015", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("1", "000.0", "[303e0000000000000000000000000000]", "00")
    self.bid128_from_string("1", "0.0000000000000000000000000000000000000000000000000000000000000001001", "[2fba00000000000000000000000003e9]", "00")
    self.bid128_from_string("1", "0.0000000000000000000000000000000000000000000000000000000000000001001", "[2fba00000000000000000000000003e9]", "00")
    self.bid128_from_string("0", "0.", "[30400000000000000000000000000000]", "00")
    self.bid128_from_string("0", "1.", "[30400000000000000000000000000001]", "00")
    self.bid128_from_string("0", "1..", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "1.0000000000000000000000000000000005", "[2ffe314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("2", "1.0000000000000000000000000000000005", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("4", "1.0000000000000000000000000000000005", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("3", "1.0000000000000000000000000000000005", "[2ffe314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("1", "1.0000000000000000000000000000000005", "[2ffe314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("0", "1.00000000000000000000000000000000051", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("2", "1.00000000000000000000000000000000051", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("4", "1.00000000000000000000000000000000051", "[2ffe314dc6448d9338c15b0a00000001]", "20")
    self.bid128_from_string("3", "1.00000000000000000000000000000000051", "[2ffe314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("1", "1.00000000000000000000000000000000051", "[2ffe314dc6448d9338c15b0a00000000]", "20")
    self.bid128_from_string("0", "1.9999999999999999999999999990000004999999999999999", "[2ffe629b8c891b267182b613fff0bdc0]", "20")
    self.bid128_from_string("2", "1.9999999999999999999999999990000004999999999999999", "[2ffe629b8c891b267182b613fff0bdc1]", "20")
    self.bid128_from_string("1", "1.9999999999999999999999999990000004999999999999999", "[2ffe629b8c891b267182b613fff0bdc0]", "20")
    self.bid128_from_string("4", "1.9999999999999999999999999990000004999999999999999", "[2ffe629b8c891b267182b613fff0bdc0]", "20")
    self.bid128_from_string("3", "1.9999999999999999999999999990000004999999999999999", "[2ffe629b8c891b267182b613fff0bdc0]", "20")
    self.bid128_from_string("0", "1.1E2", "[3042000000000000000000000000000b]", "00")
    self.bid128_from_string("0", "1.1P2", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "1.1EE", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "1.1P-2", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "1.1E-2E", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+INF", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+INFi", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+NAN", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+SNAN", "[7e000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+SNAN", "[7e000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+inf", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+nan", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+snan", "[7e000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+INFINITY", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+INFiNITY", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "+INFINITYi", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "INF", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "INFi", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "NAN", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "SNAN", "[7e000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "SNAN", "[7e000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "inf", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "nan", "[7c000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "snan", "[7e000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "INFINITY", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "INFiNITY", "[78000000000000000000000000000000]", "00")
    self.bid128_from_string("0", "INFINITYi", "[7c000000000000000000000000000000]", "00")
  }

  private func bid128_from_string(
    _ _rounding: String,
    _ arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = Decimal128(arg0, rounding: rounding, status: &status)
    let resultIntel = self.toIntel_parse(arg0, rounding, &status, result: result)
    self.assertEqual(resultIntel, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }
}
