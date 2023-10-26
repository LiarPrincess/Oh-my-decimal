// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelRoundTests: XCTestCase, IntelMixin {

  func test_bid32_round_integral_exact() {
    self.bid32_round_integral_exact("0", "[00000001]", "[32800000]", "20")
    self.bid32_round_integral_exact("0", "[00080001]", "[32800000]", "20")
    self.bid32_round_integral_exact("0", "1.0", "[32800001]", "00")
    self.bid32_round_integral_exact("0", "-1.0", "[b2800001]", "00")
    self.bid32_round_integral_exact("0", "1.0e-96", "[32800000]", "20")
    self.bid32_round_integral_exact("0", "-1.0e-96", "[b2800000]", "20")
    self.bid32_round_integral_exact("0", "[6098967f]", "[32800000]", "20")
    self.bid32_round_integral_exact("0", "[60989680]", "[32800000]", "00")
    self.bid32_round_integral_exact("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_round_integral_exact("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_round_integral_exact("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_round_integral_exact("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_round_integral_exact("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_round_integral_exact("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_round_integral_exact("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_round_integral_exact("0", "[80000001]", "[b2800000]", "20")
    self.bid32_round_integral_exact("0", "9.999999e-95", "[32800000]", "20")
    self.bid32_round_integral_exact("0", "-9.999999e-95", "[b2800000]", "20")
    self.bid32_round_integral_exact("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_round_integral_exact("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_round_integral_exact("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_round_integral_exact("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_round_integral_exact("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_round_integral_exact(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(rounding, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_round_integral_nearest_away() {
    self.bid32_round_integral_nearest_away("0", "[00000001]", "[32800000]", "00")
    self.bid32_round_integral_nearest_away("0", "[00080001]", "[32800000]", "00")
    self.bid32_round_integral_nearest_away("0", "1.0", "[32800001]", "00")
    self.bid32_round_integral_nearest_away("0", "-1.0", "[b2800001]", "00")
    self.bid32_round_integral_nearest_away("0", "1.0e-96", "[32800000]", "00")
    self.bid32_round_integral_nearest_away("0", "-1.0e-96", "[b2800000]", "00")
    self.bid32_round_integral_nearest_away("0", "[6098967f]", "[32800000]", "00")
    self.bid32_round_integral_nearest_away("0", "[60989680]", "[32800000]", "00")
    self.bid32_round_integral_nearest_away("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_round_integral_nearest_away("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_round_integral_nearest_away("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_round_integral_nearest_away("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_round_integral_nearest_away("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_round_integral_nearest_away("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_round_integral_nearest_away("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_round_integral_nearest_away("0", "[80000001]", "[b2800000]", "00")
    self.bid32_round_integral_nearest_away("0", "9.999999e-95", "[32800000]", "00")
    self.bid32_round_integral_nearest_away("0", "-9.999999e-95", "[b2800000]", "00")
    self.bid32_round_integral_nearest_away("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_round_integral_nearest_away("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_round_integral_nearest_away("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_round_integral_nearest_away("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_round_integral_nearest_away("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_round_integral_nearest_away(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.toNearestOrAwayFromZero, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_round_integral_nearest_even() {
    self.bid32_round_integral_nearest_even("0", "[00000001]", "[32800000]", "00")
    self.bid32_round_integral_nearest_even("0", "[00080001]", "[32800000]", "00")
    self.bid32_round_integral_nearest_even("0", "1.0", "[32800001]", "00")
    self.bid32_round_integral_nearest_even("0", "-1.0", "[b2800001]", "00")
    self.bid32_round_integral_nearest_even("0", "1.0e-96", "[32800000]", "00")
    self.bid32_round_integral_nearest_even("0", "-1.0e-96", "[b2800000]", "00")
    self.bid32_round_integral_nearest_even("0", "[6098967f]", "[32800000]", "00")
    self.bid32_round_integral_nearest_even("0", "[60989680]", "[32800000]", "00")
    self.bid32_round_integral_nearest_even("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_round_integral_nearest_even("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_round_integral_nearest_even("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_round_integral_nearest_even("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_round_integral_nearest_even("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_round_integral_nearest_even("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_round_integral_nearest_even("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_round_integral_nearest_even("0", "[80000001]", "[b2800000]", "00")
    self.bid32_round_integral_nearest_even("0", "9.999999e-95", "[32800000]", "00")
    self.bid32_round_integral_nearest_even("0", "-9.999999e-95", "[b2800000]", "00")
    self.bid32_round_integral_nearest_even("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_round_integral_nearest_even("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_round_integral_nearest_even("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_round_integral_nearest_even("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_round_integral_nearest_even("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_round_integral_nearest_even(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.toNearestOrEven, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_round_integral_negative() {
    self.bid32_round_integral_negative("0", "[00000001]", "[32800000]", "00")
    self.bid32_round_integral_negative("0", "[00080001]", "[32800000]", "00")
    self.bid32_round_integral_negative("0", "1.0", "[32800001]", "00")
    self.bid32_round_integral_negative("0", "-1.0", "[b2800001]", "00")
    self.bid32_round_integral_negative("0", "1.0e-96", "[32800000]", "00")
    self.bid32_round_integral_negative("0", "-1.0e-96", "[b2800001]", "00")
    self.bid32_round_integral_negative("0", "[6098967f]", "[32800000]", "00")
    self.bid32_round_integral_negative("0", "[60989680]", "[32800000]", "00")
    self.bid32_round_integral_negative("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_round_integral_negative("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_round_integral_negative("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_round_integral_negative("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_round_integral_negative("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_round_integral_negative("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_round_integral_negative("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_round_integral_negative("0", "[80000001]", "[b2800001]", "00")
    self.bid32_round_integral_negative("0", "9.999999e-95", "[32800000]", "00")
    self.bid32_round_integral_negative("0", "-9.999999e-95", "[b2800001]", "00")
    self.bid32_round_integral_negative("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_round_integral_negative("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_round_integral_negative("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_round_integral_negative("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_round_integral_negative("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_round_integral_negative(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.down, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_round_integral_positive() {
    self.bid32_round_integral_positive("0", "[00000001]", "[32800001]", "00")
    self.bid32_round_integral_positive("0", "[00080001]", "[32800001]", "00")
    self.bid32_round_integral_positive("0", "1.0", "[32800001]", "00")
    self.bid32_round_integral_positive("0", "-1.0", "[b2800001]", "00")
    self.bid32_round_integral_positive("0", "1.0e-96", "[32800001]", "00")
    self.bid32_round_integral_positive("0", "-1.0e-96", "[b2800000]", "00")
    self.bid32_round_integral_positive("0", "[6098967f]", "[32800001]", "00")
    self.bid32_round_integral_positive("0", "[60989680]", "[32800000]", "00")
    self.bid32_round_integral_positive("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_round_integral_positive("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_round_integral_positive("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_round_integral_positive("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_round_integral_positive("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_round_integral_positive("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_round_integral_positive("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_round_integral_positive("0", "[80000001]", "[b2800000]", "00")
    self.bid32_round_integral_positive("0", "9.999999e-95", "[32800001]", "00")
    self.bid32_round_integral_positive("0", "-9.999999e-95", "[b2800000]", "00")
    self.bid32_round_integral_positive("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_round_integral_positive("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_round_integral_positive("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_round_integral_positive("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_round_integral_positive("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_round_integral_positive(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.up, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_round_integral_zero() {
    self.bid32_round_integral_zero("0", "[00000001]", "[32800000]", "00")
    self.bid32_round_integral_zero("0", "[00080001]", "[32800000]", "00")
    self.bid32_round_integral_zero("0", "1.0", "[32800001]", "00")
    self.bid32_round_integral_zero("0", "-1.0", "[b2800001]", "00")
    self.bid32_round_integral_zero("0", "1.0e-96", "[32800000]", "00")
    self.bid32_round_integral_zero("0", "-1.0e-96", "[b2800000]", "00")
    self.bid32_round_integral_zero("0", "[6098967f]", "[32800000]", "00")
    self.bid32_round_integral_zero("0", "[60989680]", "[32800000]", "00")
    self.bid32_round_integral_zero("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_round_integral_zero("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_round_integral_zero("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_round_integral_zero("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_round_integral_zero("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_round_integral_zero("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_round_integral_zero("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_round_integral_zero("0", "[80000001]", "[b2800000]", "00")
    self.bid32_round_integral_zero("0", "9.999999e-95", "[32800000]", "00")
    self.bid32_round_integral_zero("0", "-9.999999e-95", "[b2800000]", "00")
    self.bid32_round_integral_zero("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_round_integral_zero("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_round_integral_zero("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_round_integral_zero("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_round_integral_zero("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_round_integral_zero(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.towardZero, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_round_integral_exact() {
    self.bid64_round_integral_exact("0", "[0000000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_exact("0", "[008f2530eb6db2a1]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "-0", "[b1c0000000000000]", "00")
    self.bid64_round_integral_exact("0", "[19361b3b0211add7]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[2a0492c0be73d94b]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[30b0c259a51afc52]", "[31c000000047faea]", "20")
    self.bid64_round_integral_exact("0", "[31a2c800c054c05b]", "[31c04733466ee009]", "20")
    self.bid64_round_integral_exact("0", "[31a6fef2b97fbb45]", "[31c0b31845bff920]", "20")
    self.bid64_round_integral_exact("0", "-3548.867894472667E0", "[b1c0000000000ddd]", "20")
    self.bid64_round_integral_exact("0", "+38863664.57647E0", "[31c0000002510331]", "20")
    self.bid64_round_integral_exact("0", "[3a6cf1ef71ca14ba]", "[3a6cf1ef71ca14ba]", "00")
    self.bid64_round_integral_exact("0", "[3d40000000000000]", "[3d40000000000000]", "00")
    self.bid64_round_integral_exact("0", "[68cfd1541eb6185b]", "[31c0000000000000]", "00")
    self.bid64_round_integral_exact("0", "[7288138c89db4604]", "[7288138c89db4604]", "00")
    self.bid64_round_integral_exact("0", "[8040000100009001]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[96bee03b9a3f8c6b]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "-9.989989988998E0", "[b1c000000000000a]", "20")
    self.bid64_round_integral_exact("0", "-9.99999E0", "[b1c000000000000a]", "20")
    self.bid64_round_integral_exact("0", "[9d3c1033181234e4]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[a441ee3e74f4e7fa]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[a5ccb6d4ce793502]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[b00000090100a806]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("0", "[b1b7a5f91cfda896]", "[b1c25d65b6195da9]", "20")
    self.bid64_round_integral_exact("0", "[c08fc338e9a8d033]", "[c08fc338e9a8d033]", "00")
    self.bid64_round_integral_exact("0", "[c2559f8764346614]", "[c2559f8764346614]", "00")
    self.bid64_round_integral_exact("0", "[c3e3e893b025b31a]", "[c3e3e893b025b31a]", "00")
    self.bid64_round_integral_exact("0", "[ec02f18088363b22]", "[b1c0000000000062]", "20")
    self.bid64_round_integral_exact("0", "[fbbfc9f9e9bdfffd]", "[f800000000000000]", "00")
    self.bid64_round_integral_exact("0", "[fd7fefedfeffda52]", "[fc00000000000000]", "00")
    self.bid64_round_integral_exact("0", "[ffffffffffffffff]", "[fc00000000000000]", "01")
    self.bid64_round_integral_exact("0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_round_integral_exact("1", "[008f2530eb6db2a1]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("1", "-0", "[b1c0000000000000]", "00")
    self.bid64_round_integral_exact("1", "[1025090a2e144640]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("1", "[19361b3b0211add7]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("1", "[2a0492c0be73d94b]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("1", "[300011811304a942]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("1", "[30b0c259a51afc52]", "[31c000000047fae9]", "20")
    self.bid64_round_integral_exact("1", "-3548.867894472667E0", "[b1c0000000000ddd]", "20")
    self.bid64_round_integral_exact("1", "+38863664.57647E0", "[31c0000002510330]", "20")
    self.bid64_round_integral_exact("1", "[3a6cf1ef71ca14ba]", "[3a6cf1ef71ca14ba]", "00")
    self.bid64_round_integral_exact("1", "[3d40000000000000]", "[3d40000000000000]", "00")
    self.bid64_round_integral_exact("1", "[8040000100009001]", "[b1c0000000000001]", "20")
    self.bid64_round_integral_exact("1", "[96bee03b9a3f8c6b]", "[b1c0000000000001]", "20")
    self.bid64_round_integral_exact("1", "-9.989989988998E0", "[b1c000000000000a]", "20")
    self.bid64_round_integral_exact("1", "-9.99999E0", "[b1c000000000000a]", "20")
    self.bid64_round_integral_exact("1", "[9d3c1033181234e4]", "[b1c0000000000001]", "20")
    self.bid64_round_integral_exact("1", "[a441ee3e74f4e7fa]", "[b1c0000000000001]", "20")
    self.bid64_round_integral_exact("1", "[a5ccb6d4ce793502]", "[b1c0000000000001]", "20")
    self.bid64_round_integral_exact("1", "[b00000090100a806]", "[b1c0000000000001]", "20")
    self.bid64_round_integral_exact("1", "[b1b7a5f91cfda896]", "[b1c25d65b6195da9]", "20")
    self.bid64_round_integral_exact("1", "[c08fc338e9a8d033]", "[c08fc338e9a8d033]", "00")
    self.bid64_round_integral_exact("1", "[c2559f8764346614]", "[c2559f8764346614]", "00")
    self.bid64_round_integral_exact("1", "SNaN", "[7c00000000000000]", "01")
    self.bid64_round_integral_exact("2", "[008f2530eb6db2a1]", "[31c0000000000001]", "20")
    self.bid64_round_integral_exact("2", "-0", "[b1c0000000000000]", "00")
    self.bid64_round_integral_exact("2", "[1025090a2e144640]", "[31c0000000000001]", "20")
    self.bid64_round_integral_exact("2", "[19361b3b0211add7]", "[31c0000000000001]", "20")
    self.bid64_round_integral_exact("2", "[2a0492c0be73d94b]", "[31c0000000000001]", "20")
    self.bid64_round_integral_exact("2", "[300011811304a942]", "[31c0000000000001]", "20")
    self.bid64_round_integral_exact("2", "[30b0c259a51afc52]", "[31c000000047faea]", "20")
    self.bid64_round_integral_exact("2", "-3548.867894472667E0", "[b1c0000000000ddc]", "20")
    self.bid64_round_integral_exact("2", "+38863664.57647E0", "[31c0000002510331]", "20")
    self.bid64_round_integral_exact("2", "[3a6cf1ef71ca14ba]", "[3a6cf1ef71ca14ba]", "00")
    self.bid64_round_integral_exact("2", "[3d40000000000000]", "[3d40000000000000]", "00")
    self.bid64_round_integral_exact("2", "[8040000100009001]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("2", "[96bee03b9a3f8c6b]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("2", "-9.989989988998E0", "[b1c0000000000009]", "20")
    self.bid64_round_integral_exact("2", "-9.99999E0", "[b1c0000000000009]", "20")
    self.bid64_round_integral_exact("2", "[9d3c1033181234e4]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("2", "[a441ee3e74f4e7fa]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("2", "[a5ccb6d4ce793502]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("2", "[b00000090100a806]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("2", "[b1b7a5f91cfda896]", "[b1c25d65b6195da8]", "20")
    self.bid64_round_integral_exact("2", "[c08fc338e9a8d033]", "[c08fc338e9a8d033]", "00")
    self.bid64_round_integral_exact("2", "[c2559f8764346614]", "[c2559f8764346614]", "00")
    self.bid64_round_integral_exact("2", "SNaN", "[7c00000000000000]", "01")
    self.bid64_round_integral_exact("3", "[008f2530eb6db2a1]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "-0", "[b1c0000000000000]", "00")
    self.bid64_round_integral_exact("3", "[19361b3b0211add7]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[2a0492c0be73d94b]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[30b0c259a51afc52]", "[31c000000047fae9]", "20")
    self.bid64_round_integral_exact("3", "-3548.867894472667E0", "[b1c0000000000ddc]", "20")
    self.bid64_round_integral_exact("3", "+38863664.57647E0", "[31c0000002510330]", "20")
    self.bid64_round_integral_exact("3", "[3a6cf1ef71ca14ba]", "[3a6cf1ef71ca14ba]", "00")
    self.bid64_round_integral_exact("3", "[3d40000000000000]", "[3d40000000000000]", "00")
    self.bid64_round_integral_exact("3", "[8040000100009001]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[96bee03b9a3f8c6b]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "-9.989989988998E0", "[b1c0000000000009]", "20")
    self.bid64_round_integral_exact("3", "-9.99999E0", "[b1c0000000000009]", "20")
    self.bid64_round_integral_exact("3", "[9d3c1033181234e4]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[a441ee3e74f4e7fa]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[a5ccb6d4ce793502]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[b00000090100a806]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("3", "[b1b7a5f91cfda896]", "[b1c25d65b6195da8]", "20")
    self.bid64_round_integral_exact("3", "[c08fc338e9a8d033]", "[c08fc338e9a8d033]", "00")
    self.bid64_round_integral_exact("3", "[c2559f8764346614]", "[c2559f8764346614]", "00")
    self.bid64_round_integral_exact("3", "SNaN", "[7c00000000000000]", "01")
    self.bid64_round_integral_exact("4", "[008f2530eb6db2a1]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "-0", "[b1c0000000000000]", "00")
    self.bid64_round_integral_exact("4", "[19361b3b0211add7]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "[2a0492c0be73d94b]", "[31c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "[30b0c259a51afc52]", "[31c000000047faea]", "20")
    self.bid64_round_integral_exact("4", "[31a2c800c054c05b]", "[31c04733466ee009]", "20")
    self.bid64_round_integral_exact("4", "-3548.867894472667E0", "[b1c0000000000ddd]", "20")
    self.bid64_round_integral_exact("4", "+38863664.57647E0", "[31c0000002510331]", "20")
    self.bid64_round_integral_exact("4", "[3a6cf1ef71ca14ba]", "[3a6cf1ef71ca14ba]", "00")
    self.bid64_round_integral_exact("4", "[3d40000000000000]", "[3d40000000000000]", "00")
    self.bid64_round_integral_exact("4", "[96bee03b9a3f8c6b]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "-9.989989988998E0", "[b1c000000000000a]", "20")
    self.bid64_round_integral_exact("4", "-9.99999E0", "[b1c000000000000a]", "20")
    self.bid64_round_integral_exact("4", "[9d3c1033181234e4]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "[a441ee3e74f4e7fa]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "[a5ccb6d4ce793502]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "[b00000090100a806]", "[b1c0000000000000]", "20")
    self.bid64_round_integral_exact("4", "[b1b7a5f91cfda896]", "[b1c25d65b6195da9]", "20")
    self.bid64_round_integral_exact("4", "[c2559f8764346614]", "[c2559f8764346614]", "00")
    self.bid64_round_integral_exact("4", "[ec02f18088363b22]", "[b1c0000000000062]", "20")
    self.bid64_round_integral_exact("4", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_round_integral_exact(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(rounding, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_round_integral_nearest_away() {
    self.bid64_round_integral_nearest_away("0", "[0000000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[001040000000140c]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "0", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[0ebf000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[3000042000096042]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[318ad42b83214976]", "[31c01bb8c14fb160]", "00")
    self.bid64_round_integral_nearest_away("0", "[344d663e925522bd]", "[344d663e925522bd]", "00")
    self.bid64_round_integral_nearest_away("0", "[352287c45d071d0f]", "[352287c45d071d0f]", "00")
    self.bid64_round_integral_nearest_away("0", "[38191e30b4b7f718]", "[38191e30b4b7f718]", "00")
    self.bid64_round_integral_nearest_away("0", "[42e06477388fc706]", "[42e06477388fc706]", "00")
    self.bid64_round_integral_nearest_away("0", "[44d139ed5c11b67e]", "[44d139ed5c11b67e]", "00")
    self.bid64_round_integral_nearest_away("0", "[65315f0102f71959]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[ae7ce2cf6b3dec4b]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[b11650001088834b]", "[b1c0000176577647]", "00")
    self.bid64_round_integral_nearest_away("0", "[b1a0000000000000]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[b840000000000000]", "[b840000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[c46d127074d850c9]", "[c46d127074d850c9]", "00")
    self.bid64_round_integral_nearest_away("0", "[c59e55d5feef1bfe]", "[c59e55d5feef1bfe]", "00")
    self.bid64_round_integral_nearest_away("0", "[e9884af887152ee2]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[ecf9bf677edce7ce]", "[ecf9bf677edce7ce]", "00")
    self.bid64_round_integral_nearest_away("0", "[f2f5d1ebb9b6abc8]", "[cbc0000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "[ffffffffffffffff]", "[fc00000000000000]", "01")
    self.bid64_round_integral_nearest_away("0", "Infinity", "[7800000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_round_integral_nearest_away("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_round_integral_nearest_away(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.toNearestOrAwayFromZero, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_round_integral_nearest_even() {
    self.bid64_round_integral_nearest_even("0", "[0000000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[01c0409004000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "0", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[122f3ec26c27b361]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[1966790cc80a1b3a]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[298800870a018249]", "[31c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[317a83d36ac8f188]", "[31c006c9aef46cc9]", "00")
    self.bid64_round_integral_nearest_even("0", "[3c23b3355cc7ef47]", "[3c23b3355cc7ef47]", "00")
    self.bid64_round_integral_nearest_even("0", "[3ff1f7fcf3a1edb5]", "[3ff1f7fcf3a1edb5]", "00")
    self.bid64_round_integral_nearest_even("0", "[5b7366576d65013c]", "[5b7366576d65013c]", "00")
    self.bid64_round_integral_nearest_even("0", "[5bd9b8c6ef328b2d]", "[5bd9b8c6ef328b2d]", "00")
    self.bid64_round_integral_nearest_even("0", "[5f20000000000000]", "[5f20000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[9520000000000000]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[a65cf4be4d29a63d]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[b000080120100a00]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[b0659b9f04fb2cb8]", "[b1c0000000003da9]", "00")
    self.bid64_round_integral_nearest_even("0", "[b1bf3cbdefdffd7d]", "[b1c31fac97fccc8c]", "00")
    self.bid64_round_integral_nearest_even("0", "[bdc2f88bb868c381]", "[bdc2f88bb868c381]", "00")
    self.bid64_round_integral_nearest_even("0", "[c061cab98a3cb4df]", "[c061cab98a3cb4df]", "00")
    self.bid64_round_integral_nearest_even("0", "[c21fc0e99bd80e06]", "[c21fc0e99bd80e06]", "00")
    self.bid64_round_integral_nearest_even("0", "[ef2dc5ade35a42ad]", "[bca0000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[f7f261ea3cbdff7e]", "[f7f261ea3cbdff7e]", "00")
    self.bid64_round_integral_nearest_even("0", "[fa4eb56f810680a4]", "[f800000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "[fffff6fbefffe7ff]", "[fc00000000000000]", "01")
    self.bid64_round_integral_nearest_even("0", "Infinity", "[7800000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "-Infinity", "[f800000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_round_integral_nearest_even("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_round_integral_nearest_even(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.toNearestOrEven, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_round_integral_negative() {
    self.bid64_round_integral_negative("0", "[0000000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[1698b6c95a90f99f]", "[31c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[2000009001000200]", "[31c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[30004914028800b8]", "[31c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[3118016000000808]", "[31c0000192be48a5]", "00")
    self.bid64_round_integral_negative("0", "[34600b6036223007]", "[34600b6036223007]", "00")
    self.bid64_round_integral_negative("0", "[3749dc7f132d3d0a]", "[3749dc7f132d3d0a]", "00")
    self.bid64_round_integral_negative("0", "[44f487fdb8b4c243]", "[44f487fdb8b4c243]", "00")
    self.bid64_round_integral_negative("0", "[6c60335ab86bec39]", "[31c0526efcb96633]", "00")
    self.bid64_round_integral_negative("0", "[6d38b17f82fad382]", "[6d38b17f82fad382]", "00")
    self.bid64_round_integral_negative("0", "[8c00000000000000]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[8dc0508521cd5127]", "[b1c0000000000001]", "00")
    self.bid64_round_integral_negative("0", "[9946650664f4f9e3]", "[b1c0000000000001]", "00")
    self.bid64_round_integral_negative("0", "[9b0a451b3665f421]", "[b1c0000000000001]", "00")
    self.bid64_round_integral_negative("0", "[9c409dc20851aa82]", "[b1c0000000000001]", "00")
    self.bid64_round_integral_negative("0", "[aa20000000000000]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[b000381285510401]", "[b1c0000000000001]", "00")
    self.bid64_round_integral_negative("0", "[b136af255daae29d]", "[b1c0000eddc56bd6]", "00")
    self.bid64_round_integral_negative("0", "[b3d4e28068cf485d]", "[b3d4e28068cf485d]", "00")
    self.bid64_round_integral_negative("0", "[bb7ef9b05c9e0cd4]", "[bb7ef9b05c9e0cd4]", "00")
    self.bid64_round_integral_negative("0", "[ca9ded372218bb92]", "[ca9ded372218bb92]", "00")
    self.bid64_round_integral_negative("0", "[cda2c902b15861e0]", "[cda2c902b15861e0]", "00")
    self.bid64_round_integral_negative("0", "[e5faab2e7bfde8f7]", "[b1c0000000000001]", "00")
    self.bid64_round_integral_negative("0", "[ea4c5fde262f578d]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_negative("0", "[f986cc74d2071536]", "[f800000000000000]", "00")
    self.bid64_round_integral_negative("0", "[fe3effdfdb433b5f]", "[fc02ffdfdb433b5f]", "01")
    self.bid64_round_integral_negative("0", "[fffffffffffffdff]", "[fc00000000000000]", "01")
    self.bid64_round_integral_negative("0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_round_integral_negative("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_round_integral_negative(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.down, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_round_integral_positive() {
    self.bid64_round_integral_positive("0", "[0000000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[0040040010100800]", "[31c0000000000001]", "00")
    self.bid64_round_integral_positive("0", "[01aca948242e8ce9]", "[31c0000000000001]", "00")
    self.bid64_round_integral_positive("0", "0", "[31c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[08c1000000000000]", "[31c0000000000001]", "00")
    self.bid64_round_integral_positive("0", "-0", "[b1c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[3000182000200204]", "[31c0000000000001]", "00")
    self.bid64_round_integral_positive("0", "[318fffee5cb1f7cb]", "[31c028f595682e00]", "00")
    self.bid64_round_integral_positive("0", "[38e3152cbfc0d32e]", "[38e3152cbfc0d32e]", "00")
    self.bid64_round_integral_positive("0", "[3ba0000000000000]", "[3ba0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[41fecceb44f309d5]", "[41fecceb44f309d5]", "00")
    self.bid64_round_integral_positive("0", "[4ae3a0950988606c]", "[4ae3a0950988606c]", "00")
    self.bid64_round_integral_positive("0", "[557d63bf6a3df7ae]", "[557d63bf6a3df7ae]", "00")
    self.bid64_round_integral_positive("0", "[8b61791ce8584f32]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[94c0000000000000]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[a7ddebcc9a46edc1]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[b00041b61a454101]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[b02050acaed32bff]", "[b1c0000000000008]", "00")
    self.bid64_round_integral_positive("0", "[bc9faa0346fd925b]", "[bc9faa0346fd925b]", "00")
    self.bid64_round_integral_positive("0", "[c7e1158478b3e876]", "[c7e1158478b3e876]", "00")
    self.bid64_round_integral_positive("0", "[dae29979b6bc48ce]", "[dae29979b6bc48ce]", "00")
    self.bid64_round_integral_positive("0", "[e043498baef72083]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_positive("0", "[ecaa15bc91e764ec]", "[ecaa15bc91e764ec]", "00")
    self.bid64_round_integral_positive("0", "[f6465d2110be89d5]", "[d900000000000000]", "00")
    self.bid64_round_integral_positive("0", "[fd39ef5fbdcf73d4]", "[fc01ef5fbdcf73d4]", "00")
    self.bid64_round_integral_positive("0", "[ffdbfff73ffbffb7]", "[fc00000000000000]", "01")
    self.bid64_round_integral_positive("0", "Infinity", "[7800000000000000]", "00")
    self.bid64_round_integral_positive("0", "-Infinity", "[f800000000000000]", "00")
    self.bid64_round_integral_positive("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_round_integral_positive(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.up, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_round_integral_zero() {
    self.bid64_round_integral_zero("0", "[0000000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[00e0000000000000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "0", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "+10011001001110000.010E0", "[31e38e7ec7da0a98]", "00")
    self.bid64_round_integral_zero("0", "[12f48c419c7c162c]", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[1c7c77621629c5c1]", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[2004000040600010]", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[300008313e021000]", "[31c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[3044020248482608]", "[31c0000000000468]", "00")
    self.bid64_round_integral_zero("0", "[3ba71f380a6bd963]", "[3ba71f380a6bd963]", "00")
    self.bid64_round_integral_zero("0", "[3dc0000000000000]", "[3dc0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[72f8031406c00cd0]", "[72f8031406c00cd0]", "00")
    self.bid64_round_integral_zero("0", "[97380e63bd57041b]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[a80231d6acd74f18]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[aea9db49a45d7aaf]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[b1bc6ea70343d80e]", "[b1c2d7dd8053959b]", "00")
    self.bid64_round_integral_zero("0", "[b3c3f729d481bb82]", "[b3c3f729d481bb82]", "00")
    self.bid64_round_integral_zero("0", "[b44956b0e6f1d142]", "[b44956b0e6f1d142]", "00")
    self.bid64_round_integral_zero("0", "[bd1807d37267366f]", "[bd1807d37267366f]", "00")
    self.bid64_round_integral_zero("0", "[c7998a089b34fdcc]", "[c7998a089b34fdcc]", "00")
    self.bid64_round_integral_zero("0", "[d582a26bd30897ec]", "[d582a26bd30897ec]", "00")
    self.bid64_round_integral_zero("0", "[eabafffbfdfdffff]", "[b1c0000000000000]", "00")
    self.bid64_round_integral_zero("0", "[ede38ae279475ae0]", "[b780000000000000]", "00")
    self.bid64_round_integral_zero("0", "[fdbfe96ffbdff9e7]", "[fc00000000000000]", "00")
    self.bid64_round_integral_zero("0", "[ff7ffffffffffeff]", "[fc00000000000000]", "01")
    self.bid64_round_integral_zero("0", "-Infinity", "[f800000000000000]", "00")
    self.bid64_round_integral_zero("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_round_integral_zero(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.towardZero, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_round_integral_exact() {
    self.bid128_round_integral_exact("0", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[08ba054b6c1ab0d6,309b227aa7c22b95]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "+110001010110.1011011E0", "[3040000000000000000000199c9235be]", "20")
    self.bid128_round_integral_exact("0", "[1e5c1f24c0fe8797,defcac74117b0cc9]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "[24ae17bee0e3ca29,e64a0dd36e6d274d]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "-28997.76477725255E0", "[b0400000000000000000000000007146]", "20")
    self.bid128_round_integral_exact("0", "[2ffebe978c67d78e,ffffffffffffffff]", "[30400000000000000000000000000004]", "20")
    self.bid128_round_integral_exact("0", "[2fff7ebfbfde27ef,1f9dbff5fff6feb7]", "[30400000000000000000000000000008]", "20")
    self.bid128_round_integral_exact("0", "[3000001100644834,dff2f3fda57dffbf]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "[30000124185042ce,0005010802580040]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "[3021102400604230,7dffffffffffffff]", "[304000000000000007a8fadb5278e2ff]", "20")
    self.bid128_round_integral_exact("0", "[3085ED09BEAD87C0378D8E63ffffffff]", "[3085ed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_exact("0", "[3085ED09BEAD87C0378D8E6400000000]", "[30840000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "+339.94496647435E0", "[30400000000000000000000000000154]", "20")
    self.bid128_round_integral_exact("0", "[34d177895e82ee6c,266dce427f0e636b]", "[34d177895e82ee6c266dce427f0e636b]", "00")
    self.bid128_round_integral_exact("0", "[34f2000000000000,0000000000000000]", "[34f20000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[38b6683c503065eb,bd416fdde5141f1f]", "[38b6683c503065ebbd416fdde5141f1f]", "00")
    self.bid128_round_integral_exact("0", "[3CB2314DC6448D9338C15B09ffffffff]", "[3cb2314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_round_integral_exact("0", "[3CB2314DC6448D9338C15B0A00000000]", "[3cb2314dc6448d9338c15b0a00000000]", "00")
    self.bid128_round_integral_exact("0", "[4000000000000000,0000000000000000]", "[40000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[4000000000000000,0010000001000000]", "[40000000000000000010000001000000]", "00")
    self.bid128_round_integral_exact("0", "[4000000000000000,c4338043a5414cb2]", "[4000000000000000c4338043a5414cb2]", "00")
    self.bid128_round_integral_exact("0", "[5380000000000000,0000000000000000]", "[53800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[549324c31ab70f16,ab9398820d688392]", "[549324c31ab70f16ab9398820d688392]", "00")
    self.bid128_round_integral_exact("0", "[5580000000000000,0000000000000000]", "[55800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[5dcd49df3e7d88e2,78ce9b3144080941]", "[5dcd49df3e7d88e278ce9b3144080941]", "00")
    self.bid128_round_integral_exact("0", "-6.86E0", "[b0400000000000000000000000000007]", "20")
    self.bid128_round_integral_exact("0", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "+7899.8E0", "[30400000000000000000000000001edc]", "20")
    self.bid128_round_integral_exact("0", "[7b7fff3fffffffd7,0000000100200010]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[7c7c1b7f2fbf6d99,a4eee97fed89bfb6]", "[7c001b7f2fbf6d99a4eee97fed89bfb6]", "00")
    self.bid128_round_integral_exact("0", "[7e001610a0331c9f,4c52387d7a6b092d]", "[7c001610a0331c9f4c52387d7a6b092d]", "01")
    self.bid128_round_integral_exact("0", "[7e0030a6ef58ac7b,fb4a59d4957d7c8c]", "[7c0030a6ef58ac7bfb4a59d4957d7c8c]", "01")
    self.bid128_round_integral_exact("0", "[7fdefd3de9edfff9,1000000100000002]", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("0", "[8074365d65a03590,252713e848731924]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "+87657877775585.88988E0", "[304000000000000000004fb970aaa4e2]", "20")
    self.bid128_round_integral_exact("0", "+8898.89989998888988E0", "[304000000000000000000000000022c3]", "20")
    self.bid128_round_integral_exact("0", "[abdf5533fa4ac286,c708ee91b4212b7d]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("0", "[b028d1f599126efe,f0c55b88759cfb19]", "[b0400000000000e6da4ed3e24b169cca]", "20")
    self.bid128_round_integral_exact("0", "[b03c6412434c7aa9,94478c5d88208396]", "[b04001002ec0c3c96033ea5d1866b9a3]", "20")
    self.bid128_round_integral_exact("0", "[b03f1641bd51ed55,86ded64d39546dd3]", "[b0401bd35fbb64888d7caf07b8eed7c8]", "20")
    self.bid128_round_integral_exact("0", "[b03f1d0e64018455,1400c80004404001]", "[b0401c8170668d3bb533473333a00666]", "20")
    self.bid128_round_integral_exact("0", "[ced23192100d01a8,0000000000010000]", "[ced23192100d01a80000000000010000]", "00")
    self.bid128_round_integral_exact("0", "[cf7857626020a415,2b8c08f3b3977709]", "[cf7857626020a4152b8c08f3b3977709]", "00")
    self.bid128_round_integral_exact("0", "[d017240c70b8180a,fffdefffffffcfff]", "[d017240c70b8180afffdefffffffcfff]", "00")
    self.bid128_round_integral_exact("0", "[d0c6000000000000,0000000000000000]", "[d0c60000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[DF7FED09BEAD87C0378D8E63ffffffff]", "[df7fed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_exact("0", "[DF7FED09BEAD87C0378D8E6400000000]", "[df7e0000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[dffdffeffffffffe,b41cc7d64bac9de5]", "[dffc0000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[e6090373da40c483,645c658f35bfda55]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[f7bfea5e5fdf372f,7fedffdfffdeeeff]", "[defe0000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[f9af9232acad6ed4,64d3b9942770a269]", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("0", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("0", "[fe001704d5fba551,de2b0f3945b66e3d]", "[fc001704d5fba551de2b0f3945b66e3d]", "01")
    self.bid128_round_integral_exact("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("1", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("1", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "[08ba054b6c1ab0d6,309b227aa7c22b95]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("1", "+110001010110.1011011E0", "[3040000000000000000000199c9235be]", "20")
    self.bid128_round_integral_exact("1", "[1e5c1f24c0fe8797,defcac74117b0cc9]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("1", "[24ae17bee0e3ca29,e64a0dd36e6d274d]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("1", "-28997.76477725255E0", "[b0400000000000000000000000007146]", "20")
    self.bid128_round_integral_exact("1", "[30000124185042ce,0005010802580040]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("1", "[301040a630c04022,63eed167206e394e]", "[3040000000000000000000004e27f3d9]", "20")
    self.bid128_round_integral_exact("1", "+339.94496647435E0", "[30400000000000000000000000000153]", "20")
    self.bid128_round_integral_exact("1", "[34d177895e82ee6c,266dce427f0e636b]", "[34d177895e82ee6c266dce427f0e636b]", "00")
    self.bid128_round_integral_exact("1", "[34f2000000000000,0000000000000000]", "[34f20000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "[38b6683c503065eb,bd416fdde5141f1f]", "[38b6683c503065ebbd416fdde5141f1f]", "00")
    self.bid128_round_integral_exact("1", "[5380000000000000,0000000000000000]", "[53800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "[549324c31ab70f16,ab9398820d688392]", "[549324c31ab70f16ab9398820d688392]", "00")
    self.bid128_round_integral_exact("1", "[5580000000000000,0000000000000000]", "[55800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "[5dcd49df3e7d88e2,78ce9b3144080941]", "[5dcd49df3e7d88e278ce9b3144080941]", "00")
    self.bid128_round_integral_exact("1", "-6.86E0", "[b0400000000000000000000000000007]", "20")
    self.bid128_round_integral_exact("1", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "+7899.8E0", "[30400000000000000000000000001edb]", "20")
    self.bid128_round_integral_exact("1", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "[7e001610a0331c9f,4c52387d7a6b092d]", "[7c001610a0331c9f4c52387d7a6b092d]", "01")
    self.bid128_round_integral_exact("1", "[7e0030a6ef58ac7b,fb4a59d4957d7c8c]", "[7c0030a6ef58ac7bfb4a59d4957d7c8c]", "01")
    self.bid128_round_integral_exact("1", "[8074365d65a03590,252713e848731924]", "[b0400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("1", "+87657877775585.88988E0", "[304000000000000000004fb970aaa4e1]", "20")
    self.bid128_round_integral_exact("1", "+8898.89989998888988E0", "[304000000000000000000000000022c2]", "20")
    self.bid128_round_integral_exact("1", "[9b7985c933695132,f4b17f880577399d]", "[b0400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("1", "[abdf5533fa4ac286,c708ee91b4212b7d]", "[b0400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("1", "[b00000402048c240,7fef7f3fefb4f7f7]", "[b0400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("1", "[b00d71b799eb740d,92e00060000850cc]", "[b0400000000000000000000004783824]", "20")
    self.bid128_round_integral_exact("1", "[b028d1f599126efe,f0c55b88759cfb19]", "[b0400000000000e6da4ed3e24b169ccb]", "20")
    self.bid128_round_integral_exact("1", "[b03c6412434c7aa9,94478c5d88208396]", "[b04001002ec0c3c96033ea5d1866b9a3]", "20")
    self.bid128_round_integral_exact("1", "[cf7857626020a415,2b8c08f3b3977709]", "[cf7857626020a4152b8c08f3b3977709]", "00")
    self.bid128_round_integral_exact("1", "[d0c6000000000000,0000000000000000]", "[d0c60000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("1", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("1", "[fe001704d5fba551,de2b0f3945b66e3d]", "[fc001704d5fba551de2b0f3945b66e3d]", "01")
    self.bid128_round_integral_exact("1", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("2", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("2", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "[08ba054b6c1ab0d6,309b227aa7c22b95]", "[30400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("2", "+110001010110.1011011E0", "[3040000000000000000000199c9235bf]", "20")
    self.bid128_round_integral_exact("2", "[1e5c1f24c0fe8797,defcac74117b0cc9]", "[30400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("2", "[24ae17bee0e3ca29,e64a0dd36e6d274d]", "[30400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("2", "-28997.76477725255E0", "[b0400000000000000000000000007145]", "20")
    self.bid128_round_integral_exact("2", "[30000124185042ce,0005010802580040]", "[30400000000000000000000000000001]", "20")
    self.bid128_round_integral_exact("2", "[301040a630c04022,63eed167206e394e]", "[3040000000000000000000004e27f3da]", "20")
    self.bid128_round_integral_exact("2", "[3021102400604230,7dffffffffffffff]", "[304000000000000007a8fadb5278e2ff]", "20")
    self.bid128_round_integral_exact("2", "[303a95000928d000,651051d10c4c1500]", "[3040002624df876041a3169c1cf0b752]", "20")
    self.bid128_round_integral_exact("2", "+339.94496647435E0", "[30400000000000000000000000000154]", "20")
    self.bid128_round_integral_exact("2", "[34d177895e82ee6c,266dce427f0e636b]", "[34d177895e82ee6c266dce427f0e636b]", "00")
    self.bid128_round_integral_exact("2", "[34f2000000000000,0000000000000000]", "[34f20000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "[38b6683c503065eb,bd416fdde5141f1f]", "[38b6683c503065ebbd416fdde5141f1f]", "00")
    self.bid128_round_integral_exact("2", "[5380000000000000,0000000000000000]", "[53800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "[549324c31ab70f16,ab9398820d688392]", "[549324c31ab70f16ab9398820d688392]", "00")
    self.bid128_round_integral_exact("2", "[5580000000000000,0000000000000000]", "[55800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "[5dcd49df3e7d88e2,78ce9b3144080941]", "[5dcd49df3e7d88e278ce9b3144080941]", "00")
    self.bid128_round_integral_exact("2", "-6.86E0", "[b0400000000000000000000000000006]", "20")
    self.bid128_round_integral_exact("2", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "+7899.8E0", "[30400000000000000000000000001edc]", "20")
    self.bid128_round_integral_exact("2", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "[7e001610a0331c9f,4c52387d7a6b092d]", "[7c001610a0331c9f4c52387d7a6b092d]", "01")
    self.bid128_round_integral_exact("2", "[7e0030a6ef58ac7b,fb4a59d4957d7c8c]", "[7c0030a6ef58ac7bfb4a59d4957d7c8c]", "01")
    self.bid128_round_integral_exact("2", "[8074365d65a03590,252713e848731924]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("2", "+87657877775585.88988E0", "[304000000000000000004fb970aaa4e2]", "20")
    self.bid128_round_integral_exact("2", "+8898.89989998888988E0", "[304000000000000000000000000022c3]", "20")
    self.bid128_round_integral_exact("2", "[9b7985c933695132,f4b17f880577399d]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("2", "[abdf5533fa4ac286,c708ee91b4212b7d]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("2", "[b00000402048c240,7fef7f3fefb4f7f7]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("2", "[b028d1f599126efe,f0c55b88759cfb19]", "[b0400000000000e6da4ed3e24b169cca]", "20")
    self.bid128_round_integral_exact("2", "[b03c6412434c7aa9,94478c5d88208396]", "[b04001002ec0c3c96033ea5d1866b9a2]", "20")
    self.bid128_round_integral_exact("2", "[cf7857626020a415,2b8c08f3b3977709]", "[cf7857626020a4152b8c08f3b3977709]", "00")
    self.bid128_round_integral_exact("2", "[d0c6000000000000,0000000000000000]", "[d0c60000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("2", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("2", "[fe001704d5fba551,de2b0f3945b66e3d]", "[fc001704d5fba551de2b0f3945b66e3d]", "01")
    self.bid128_round_integral_exact("2", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("3", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "[08ba054b6c1ab0d6,309b227aa7c22b95]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "+110001010110.1011011E0", "[3040000000000000000000199c9235be]", "20")
    self.bid128_round_integral_exact("3", "[1e5c1f24c0fe8797,defcac74117b0cc9]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "[24ae17bee0e3ca29,e64a0dd36e6d274d]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "-28997.76477725255E0", "[b0400000000000000000000000007145]", "20")
    self.bid128_round_integral_exact("3", "[30000124185042ce,0005010802580040]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "[301040a630c04022,63eed167206e394e]", "[3040000000000000000000004e27f3d9]", "20")
    self.bid128_round_integral_exact("3", "+339.94496647435E0", "[30400000000000000000000000000153]", "20")
    self.bid128_round_integral_exact("3", "[34d177895e82ee6c,266dce427f0e636b]", "[34d177895e82ee6c266dce427f0e636b]", "00")
    self.bid128_round_integral_exact("3", "[34f2000000000000,0000000000000000]", "[34f20000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "[38b6683c503065eb,bd416fdde5141f1f]", "[38b6683c503065ebbd416fdde5141f1f]", "00")
    self.bid128_round_integral_exact("3", "[5380000000000000,0000000000000000]", "[53800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "[549324c31ab70f16,ab9398820d688392]", "[549324c31ab70f16ab9398820d688392]", "00")
    self.bid128_round_integral_exact("3", "[5580000000000000,0000000000000000]", "[55800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "[5dcd49df3e7d88e2,78ce9b3144080941]", "[5dcd49df3e7d88e278ce9b3144080941]", "00")
    self.bid128_round_integral_exact("3", "-6.86E0", "[b0400000000000000000000000000006]", "20")
    self.bid128_round_integral_exact("3", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "+7899.8E0", "[30400000000000000000000000001edb]", "20")
    self.bid128_round_integral_exact("3", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "[7e001610a0331c9f,4c52387d7a6b092d]", "[7c001610a0331c9f4c52387d7a6b092d]", "01")
    self.bid128_round_integral_exact("3", "[7e0030a6ef58ac7b,fb4a59d4957d7c8c]", "[7c0030a6ef58ac7bfb4a59d4957d7c8c]", "01")
    self.bid128_round_integral_exact("3", "[8074365d65a03590,252713e848731924]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "+87657877775585.88988E0", "[304000000000000000004fb970aaa4e1]", "20")
    self.bid128_round_integral_exact("3", "+8898.89989998888988E0", "[304000000000000000000000000022c2]", "20")
    self.bid128_round_integral_exact("3", "[abdf5533fa4ac286,c708ee91b4212b7d]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("3", "[b028d1f599126efe,f0c55b88759cfb19]", "[b0400000000000e6da4ed3e24b169cca]", "20")
    self.bid128_round_integral_exact("3", "[b03c6412434c7aa9,94478c5d88208396]", "[b04001002ec0c3c96033ea5d1866b9a2]", "20")
    self.bid128_round_integral_exact("3", "[cf7857626020a415,2b8c08f3b3977709]", "[cf7857626020a4152b8c08f3b3977709]", "00")
    self.bid128_round_integral_exact("3", "[d0c6000000000000,0000000000000000]", "[d0c60000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("3", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("3", "[fe001704d5fba551,de2b0f3945b66e3d]", "[fc001704d5fba551de2b0f3945b66e3d]", "01")
    self.bid128_round_integral_exact("3", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("4", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "[08ba054b6c1ab0d6,309b227aa7c22b95]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "+110001010110.1011011E0", "[3040000000000000000000199c9235be]", "20")
    self.bid128_round_integral_exact("4", "[24ae17bee0e3ca29,e64a0dd36e6d274d]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "-28997.76477725255E0", "[b0400000000000000000000000007146]", "20")
    self.bid128_round_integral_exact("4", "[2ffebe978c67d78e,ffffffffffffffff]", "[30400000000000000000000000000004]", "20")
    self.bid128_round_integral_exact("4", "[2fff7ebfbfde27ef,1f9dbff5fff6feb7]", "[30400000000000000000000000000008]", "20")
    self.bid128_round_integral_exact("4", "[3000001100644834,dff2f3fda57dffbf]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "[30000124185042ce,0005010802580040]", "[30400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "[3021102400604230,7dffffffffffffff]", "[304000000000000007a8fadb5278e2ff]", "20")
    self.bid128_round_integral_exact("4", "+339.94496647435E0", "[30400000000000000000000000000154]", "20")
    self.bid128_round_integral_exact("4", "[34d177895e82ee6c,266dce427f0e636b]", "[34d177895e82ee6c266dce427f0e636b]", "00")
    self.bid128_round_integral_exact("4", "[34f2000000000000,0000000000000000]", "[34f20000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "[38b6683c503065eb,bd416fdde5141f1f]", "[38b6683c503065ebbd416fdde5141f1f]", "00")
    self.bid128_round_integral_exact("4", "[5380000000000000,0000000000000000]", "[53800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "[549324c31ab70f16,ab9398820d688392]", "[549324c31ab70f16ab9398820d688392]", "00")
    self.bid128_round_integral_exact("4", "[5580000000000000,0000000000000000]", "[55800000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "[5dcd49df3e7d88e2,78ce9b3144080941]", "[5dcd49df3e7d88e278ce9b3144080941]", "00")
    self.bid128_round_integral_exact("4", "-6.86E0", "[b0400000000000000000000000000007]", "20")
    self.bid128_round_integral_exact("4", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "+7899.8E0", "[30400000000000000000000000001edc]", "20")
    self.bid128_round_integral_exact("4", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "[7e001610a0331c9f,4c52387d7a6b092d]", "[7c001610a0331c9f4c52387d7a6b092d]", "01")
    self.bid128_round_integral_exact("4", "[7e0030a6ef58ac7b,fb4a59d4957d7c8c]", "[7c0030a6ef58ac7bfb4a59d4957d7c8c]", "01")
    self.bid128_round_integral_exact("4", "[8074365d65a03590,252713e848731924]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "+87657877775585.88988E0", "[304000000000000000004fb970aaa4e2]", "20")
    self.bid128_round_integral_exact("4", "+8898.89989998888988E0", "[304000000000000000000000000022c3]", "20")
    self.bid128_round_integral_exact("4", "[abdf5533fa4ac286,c708ee91b4212b7d]", "[b0400000000000000000000000000000]", "20")
    self.bid128_round_integral_exact("4", "[b028d1f599126efe,f0c55b88759cfb19]", "[b0400000000000e6da4ed3e24b169cca]", "20")
    self.bid128_round_integral_exact("4", "[b03c6412434c7aa9,94478c5d88208396]", "[b04001002ec0c3c96033ea5d1866b9a3]", "20")
    self.bid128_round_integral_exact("4", "[b03f1641bd51ed55,86ded64d39546dd3]", "[b0401bd35fbb64888d7caf07b8eed7c8]", "20")
    self.bid128_round_integral_exact("4", "[cf7857626020a415,2b8c08f3b3977709]", "[cf7857626020a4152b8c08f3b3977709]", "00")
    self.bid128_round_integral_exact("4", "[d0c6000000000000,0000000000000000]", "[d0c60000000000000000000000000000]", "00")
    self.bid128_round_integral_exact("4", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("4", "[fe001704d5fba551,de2b0f3945b66e3d]", "[fc001704d5fba551de2b0f3945b66e3d]", "01")
    self.bid128_round_integral_exact("4", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_exact("0", "18446744073709551616500E-3", "18446744073709551616E+0", "20")
    self.bid128_round_integral_exact("0", "18446744073709551616000E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_exact("1", "18446744073709551616500E-3", "18446744073709551616E+0", "20")
    self.bid128_round_integral_exact("2", "18446744073709551616500E-3", "18446744073709551617E+0", "20")
    self.bid128_round_integral_exact("3", "18446744073709551616500E-3", "18446744073709551616E+0", "20")
    self.bid128_round_integral_exact("1", "18446744073709551616000E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_exact("2", "18446744073709551616000E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_exact("3", "18446744073709551616000E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_exact("0", "91E-1", "9", "20")
    self.bid128_round_integral_exact("1", "91E-1", "9", "20")
    self.bid128_round_integral_exact("2", "91E-1", "10", "20")
    self.bid128_round_integral_exact("3", "91E-1", "9", "20")
    self.bid128_round_integral_exact("0", "90001E-4", "9", "20")
    self.bid128_round_integral_exact("1", "90001E-4", "9", "20")
    self.bid128_round_integral_exact("2", "90001E-4", "10", "20")
    self.bid128_round_integral_exact("3", "90001E-4", "9", "20")
    self.bid128_round_integral_exact("0", "96000000000000000000008778781E-23", "960000", "20")
    self.bid128_round_integral_exact("0", "900000000000000000000001E-23", "9", "20")
    self.bid128_round_integral_exact("1", "96000000000000000000008778781E-23", "960000", "20")
    self.bid128_round_integral_exact("1", "900000000000000000000001E-23", "9", "20")
    self.bid128_round_integral_exact("2", "900000000000000000000001E-23", "10", "20")
    self.bid128_round_integral_exact("2", "96000000000000000000008778781E-23", "960001", "20")
    self.bid128_round_integral_exact("3", "900000000000000000000001E-23", "9", "20")
    self.bid128_round_integral_exact("3", "96000000000000000000008778781E-23", "960000", "20")
    self.bid128_round_integral_exact("4", "900000000000000000000001E-23", "9", "20")
    self.bid128_round_integral_exact("4", "96000000000000000000008778781E-23", "960000", "20")
    self.bid128_round_integral_exact("4", "91E-1", "9", "20")
    self.bid128_round_integral_exact("4", "90001E-4", "9", "20")
    self.bid128_round_integral_exact("4", "18446744073709551616500E-3", "18446744073709551617E+0", "20")
    self.bid128_round_integral_exact("4", "18446744073709551616000E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_exact("0", "205000E-4", "20", "20")
    self.bid128_round_integral_exact("0", "205001E-4", "21", "20")
    self.bid128_round_integral_exact("0", "2050000000000000000000000E-23", "20", "20")
  }

  private func bid128_round_integral_exact(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(rounding, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_round_integral_nearest_away() {
    self.bid128_round_integral_nearest_away("0", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "-0", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[2302c79015100297,0880000400000022]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[3000000403046800,001a0b3a1e13586c]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[300a7b92c29201de,583800049020c098]", "[30400000000000000000000000263e7c]", "00")
    self.bid128_round_integral_nearest_away("0", "[303b546416c082af,75718cb88378ed1e]", "[3040005723dcdd508f38b08654197705]", "00")
    self.bid128_round_integral_nearest_away("0", "[3085ED09BEAD87C0378D8E63ffffffff]", "[3085ed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_nearest_away("0", "[3085ED09BEAD87C0378D8E6400000000]", "[30840000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[3CB2314DC6448D9338C15B09ffffffff]", "[3cb2314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_round_integral_nearest_away("0", "[3CB2314DC6448D9338C15B0A00000000]", "[3cb2314dc6448d9338c15b0a00000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[4000000000000000,0000000000000000]", "[40000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[4040000180208800,70348ac055972310]", "[404000018020880070348ac055972310]", "00")
    self.bid128_round_integral_nearest_away("0", "[4080000000000000,0040903404480000]", "[40800000000000000040903404480000]", "00")
    self.bid128_round_integral_nearest_away("0", "[4400000000000000,0010800000400000]", "[44000000000000000010800000400000]", "00")
    self.bid128_round_integral_nearest_away("0", "[78e7382cdde6bfe9,1d9aa291ad44b335]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[7e00000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_nearest_away("0", "[7e001413f2933444,97bf81501d92e628]", "[7c001413f293344497bf81501d92e628]", "01")
    self.bid128_round_integral_nearest_away("0", "[7e001e7001298e7e,45efdd84925ef8fa]", "[7c001e7001298e7e45efdd84925ef8fa]", "01")
    self.bid128_round_integral_nearest_away("0", "[7e00217e424424d0,276223680476b578]", "[7c00217e424424d0276223680476b578]", "01")
    self.bid128_round_integral_nearest_away("0", "[7e002bcf6d09c0b6,cd4a95361d2d757d]", "[7c002bcf6d09c0b6cd4a95361d2d757d]", "01")
    self.bid128_round_integral_nearest_away("0", "[afff7fbfdffff3eb,6d8e1e34f5e0bbe4]", "[b0400000000000000000000000000008]", "00")
    self.bid128_round_integral_nearest_away("0", "[b025683257a4c0b2,e968c6dafbb4a1ac]", "[b040000000000003f5dd0a28364c1ca2]", "00")
    self.bid128_round_integral_nearest_away("0", "[c82ed9104de96110,8746987bd570811c]", "[c82ed9104de961108746987bd570811c]", "00")
    self.bid128_round_integral_nearest_away("0", "[db9b13d408c7fee1,a1e472f7fc304ae6]", "[db9b13d408c7fee1a1e472f7fc304ae6]", "00")
    self.bid128_round_integral_nearest_away("0", "[DF7FED09BEAD87C0378D8E63ffffffff]", "[df7fed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_nearest_away("0", "[DF7FED09BEAD87C0378D8E6400000000]", "[df7e0000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[dfa5f9b538f9441d,4f03792cbde10b60]", "[dfa40000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[e002a2f5a825ddc4,a1063108080c8c28]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[fbe86f74adfb5fad,088284ea23902252]", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[fddff79fc5bcbffd,fffeffefdff7ffff]", "[fc000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "[fe00133f591b479b,c7c6516e558528d1]", "[fc00133f591b479bc7c6516e558528d1]", "01")
    self.bid128_round_integral_nearest_away("0", "[fe002371a21bfd42,548f4f6b11c2ceba]", "[fc002371a21bfd42548f4f6b11c2ceba]", "01")
    self.bid128_round_integral_nearest_away("0", "[fe002e75147f7853,0af4f9fc56a3e25f]", "[fc002e75147f78530af4f9fc56a3e25f]", "01")
    self.bid128_round_integral_nearest_away("0", "[fe002ff8ab0c9174,2bd0b3760bb4d665]", "[fc002ff8ab0c91742bd0b3760bb4d665]", "01")
    self.bid128_round_integral_nearest_away("0", "[ffeffbffffe6ffef,2000000000040000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_nearest_away("0", "-Infinity", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_away("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_nearest_away("0", "18446744073709551616500E-3", "18446744073709551617E+0", "00")
    self.bid128_round_integral_nearest_away("0", "900000000000000000000001E-23", "9", "00")
  }

  private func bid128_round_integral_nearest_away(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.toNearestOrAwayFromZero, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_round_integral_nearest_even() {
    self.bid128_round_integral_nearest_even("0", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "-0", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[3000000060081000,658c42208884a010]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[3001400000002010,ffffe8e77ffbfdf7]", "[30400000000000000000000000000041]", "00")
    self.bid128_round_integral_nearest_even("0", "[303c84a9c4090924,a881e505a7542dd8]", "[304001539e1ecf73910b89f86064ae8a]", "00")
    self.bid128_round_integral_nearest_even("0", "[303e81c2d0398347,dcafe585defb1fe5]", "[30400cf9e19f59ed961196f3c97f8330]", "00")
    self.bid128_round_integral_nearest_even("0", "[3085ED09BEAD87C0378D8E63ffffffff]", "[3085ed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_nearest_even("0", "[3085ED09BEAD87C0378D8E6400000000]", "[30840000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[3CB2314DC6448D9338C15B09ffffffff]", "[3cb2314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_round_integral_nearest_even("0", "[3CB2314DC6448D9338C15B0A00000000]", "[3cb2314dc6448d9338c15b0a00000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[3f4836d53889b4b0,b9e6c9ff6fe5fff7]", "[3f4836d53889b4b0b9e6c9ff6fe5fff7]", "00")
    self.bid128_round_integral_nearest_even("0", "[4000000000000000,0000000000000000]", "[40000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[4000000000000000,0c3522204a902821]", "[40000000000000000c3522204a902821]", "00")
    self.bid128_round_integral_nearest_even("0", "[4140000000000000,0004400000001800]", "[41400000000000000004400000001800]", "00")
    self.bid128_round_integral_nearest_even("0", "[488080c21440030a,45c352ae05f7ca95]", "[488080c21440030a45c352ae05f7ca95]", "00")
    self.bid128_round_integral_nearest_even("0", "[7acdf567db3a6915,9a859ae63a9f889c]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[7e000c337e6ca979,447968a6af3e155b]", "[7c000c337e6ca979447968a6af3e155b]", "01")
    self.bid128_round_integral_nearest_even("0", "[7e002667f89f6fe4,105a8b590ab81f56]", "[7c002667f89f6fe4105a8b590ab81f56]", "01")
    self.bid128_round_integral_nearest_even("0", "[7e0029d324b819ac,59f16667ff456c9b]", "[7c0029d324b819ac59f16667ff456c9b]", "01")
    self.bid128_round_integral_nearest_even("0", "[8229809401845ed0,249944e50c2c4e3e]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[b02ec313a85b8cea,3f1a65dfb58b4ebf]", "[b0400000000345d932451cf442781680]", "00")
    self.bid128_round_integral_nearest_even("0", "[bd080ae6518374eb,e3b6da828802961c]", "[bd080ae6518374ebe3b6da828802961c]", "00")
    self.bid128_round_integral_nearest_even("0", "[d77fffeeffbedfff,fffffffffffffbff]", "[d77e0000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[d8ffb23fee9786e2,fefbeb7fb7f99fb6]", "[d8ffb23fee9786e2fefbeb7fb7f99fb6]", "00")
    self.bid128_round_integral_nearest_even("0", "[DF7FED09BEAD87C0378D8E63ffffffff]", "[df7fed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_nearest_even("0", "[DF7FED09BEAD87C0378D8E6400000000]", "[df7e0000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[ebfdfefd7e36b163,e8c7e4baa92e7bdc]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[fa918e40178d2389,6abfea84476d92c1]", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "[fdff5ff7fffffefb,7d7d87364da34f2d]", "[fc001ff7fffffefb7d7d87364da34f2d]", "00")
    self.bid128_round_integral_nearest_even("0", "[fe0002b7e26df762,35ab7f58a136d72a]", "[fc0002b7e26df76235ab7f58a136d72a]", "01")
    self.bid128_round_integral_nearest_even("0", "[fe00126fba1c1afc,d27b58d7b26d9855]", "[fc00126fba1c1afcd27b58d7b26d9855]", "01")
    self.bid128_round_integral_nearest_even("0", "[fe001b8b5af30648,e03fb062625ec69d]", "[fc001b8b5af30648e03fb062625ec69d]", "01")
    self.bid128_round_integral_nearest_even("0", "[fe0022c25476ccf7,e52dea461f294667]", "[fc0022c25476ccf7e52dea461f294667]", "01")
    self.bid128_round_integral_nearest_even("0", "[fe002517a20f5706,ce416fbe679dcfbc]", "[fc002517a20f5706ce416fbe679dcfbc]", "01")
    self.bid128_round_integral_nearest_even("0", "[fe002fbbf6ad3928,d23ec1161e3218b1]", "[fc002fbbf6ad3928d23ec1161e3218b1]", "01")
    self.bid128_round_integral_nearest_even("0", "[ffbfeafe7fffbf7f,882000a020209850]", "[fc002afe7fffbf7f882000a020209850]", "01")
    self.bid128_round_integral_nearest_even("0", "[fffdbfffffffffbf,feff9effa5faacdd]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_nearest_even("0", "-Infinity", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_nearest_even("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_nearest_even("0", "18446744073709551616500E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_nearest_even("0", "91E-1", "9", "00")
    self.bid128_round_integral_nearest_even("1", "91E-1", "9", "00")
    self.bid128_round_integral_nearest_even("2", "91E-1", "9", "00")
    self.bid128_round_integral_nearest_even("3", "91E-1", "9", "00")
    self.bid128_round_integral_nearest_even("0", "90001E-4", "9", "00")
    self.bid128_round_integral_nearest_even("1", "90001E-4", "9", "00")
    self.bid128_round_integral_nearest_even("2", "90001E-4", "9", "00")
    self.bid128_round_integral_nearest_even("3", "90001E-4", "9", "00")
    self.bid128_round_integral_nearest_even("0", "96000000000000000000008778781E-23", "960000", "00")
    self.bid128_round_integral_nearest_even("0", "900000000000000000000001E-23", "9", "00")
    self.bid128_round_integral_nearest_even("0", "205000E-4", "20", "00")
    self.bid128_round_integral_nearest_even("0", "205001E-4", "21", "00")
    self.bid128_round_integral_nearest_even("0", "2050000000000000000000000E-23", "20", "00")
    self.bid128_round_integral_nearest_even("0", "96E-1", "10", "00")
  }

  private func bid128_round_integral_nearest_even(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.toNearestOrEven, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_round_integral_negative() {
    self.bid128_round_integral_negative("0", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "-0", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[2e356032ef374a1e,f5c18b58d399db18]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[3000000062020000,7ffffcfffff7bfcd]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[303c50a05d300f59,044b8170c010c4e1]", "[304000ce6754f5e9d9a498559b8549a6]", "00")
    self.bid128_round_integral_negative("0", "[3085ED09BEAD87C0378D8E63ffffffff]", "[3085ed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_negative("0", "[3085ED09BEAD87C0378D8E6400000000]", "[30840000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[3CB2314DC6448D9338C15B09ffffffff]", "[3cb2314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_round_integral_negative("0", "[3CB2314DC6448D9338C15B0A00000000]", "[3cb2314dc6448d9338c15b0a00000000]", "00")
    self.bid128_round_integral_negative("0", "[4000000000000000,0008202000000010]", "[40000000000000000008202000000010]", "00")
    self.bid128_round_integral_negative("0", "[4000000000000000,7842d7d33f5ceefa]", "[40000000000000007842d7d33f5ceefa]", "00")
    self.bid128_round_integral_negative("0", "[4040000000000000,0000000000000000]", "[40400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[4b97bef1c61c8d7d,62beb8870c3e5a1e]", "[4b97bef1c61c8d7d62beb8870c3e5a1e]", "00")
    self.bid128_round_integral_negative("0", "[50803f0e5867db6a,e10832b0bce6cf06]", "[50803f0e5867db6ae10832b0bce6cf06]", "00")
    self.bid128_round_integral_negative("0", "[7a1d7af6782abeba,ce4a15e54f6dfed8]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[7c0565465f077246,16e83dcb6ad99200]", "[7c0025465f07724616e83dcb6ad99200]", "00")
    self.bid128_round_integral_negative("0", "[7e00000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_negative("0", "[7e00241b05c9feb6,d734042769d02c5b]", "[7c00241b05c9feb6d734042769d02c5b]", "01")
    self.bid128_round_integral_negative("0", "[a16faece37bfee32,636cd40894ffd68c]", "[b0400000000000000000000000000001]", "00")
    self.bid128_round_integral_negative("0", "[b000040305101002,a7cdedb5e6cdb867]", "[b0400000000000000000000000000001]", "00")
    self.bid128_round_integral_negative("0", "[b011563badf876dc,84bb2c08fc0eb1c3]", "[b040000000000000000000019dbc0584]", "00")
    self.bid128_round_integral_negative("0", "[b0165915736885ac,d0e5bd967af7e273]", "[b040000000000000000001a4afb2510a]", "00")
    self.bid128_round_integral_negative("0", "[b03e647f5c4e49b4,5b5269f8727019ec]", "[b0400a0cbc6e3a920921d765a50b35cb]", "00")
    self.bid128_round_integral_negative("0", "[bea827b3ca5b5a1d,8134b2004751a05f]", "[bea827b3ca5b5a1d8134b2004751a05f]", "00")
    self.bid128_round_integral_negative("0", "[d47a91fd09312878,789b88bf70d14784]", "[d47a91fd09312878789b88bf70d14784]", "00")
    self.bid128_round_integral_negative("0", "[d4c64d1faca949b1,856d026daa624159]", "[d4c64d1faca949b1856d026daa624159]", "00")
    self.bid128_round_integral_negative("0", "[DF7FED09BEAD87C0378D8E63ffffffff]", "[df7fed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_negative("0", "[DF7FED09BEAD87C0378D8E6400000000]", "[df7e0000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[dfc7ee97ff8effef,ffbfdff5bfffff7f]", "[dfc60000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[eab3a9be174202d2,3bafe9fb9b748a30]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[f2f5d1ebb9b6abc8,030df3ffb920c07b]", "[cbd60000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[f9fde572f9d4e39d,ffff3dae53c71fad]", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_negative("0", "[fe000ff3d59a5d91,e4d0467d3a915507]", "[fc000ff3d59a5d91e4d0467d3a915507]", "01")
    self.bid128_round_integral_negative("0", "[fe001698682e86aa,57b2178fa9c3d382]", "[fc001698682e86aa57b2178fa9c3d382]", "01")
    self.bid128_round_integral_negative("0", "[ff6ffffffdffdfff,3f7fffffff79fdfd]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_negative("0", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "-Infinity", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_negative("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_negative("0", "-91E-1", "-10", "00")
    self.bid128_round_integral_negative("0", "-90001E-4", "-10", "00")
    self.bid128_round_integral_negative("0", "900000000000000000000001E-23", "9", "00")
    self.bid128_round_integral_negative("0", "-9600000000000000000000000E-23", "-96", "00")
    self.bid128_round_integral_negative("0", "-900000000000000000000001E-23", "-10", "00")
  }

  private func bid128_round_integral_negative(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.down, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_round_integral_positive() {
    self.bid128_round_integral_positive("0", "[0000013228000800,5abfeffcfdab9cf9]", "[30400000000000000000000000000001]", "00")
    self.bid128_round_integral_positive("0", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000001]", "00")
    self.bid128_round_integral_positive("0", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "-0", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[144d870e00169404,3c9f5f5597637768]", "[30400000000000000000000000000001]", "00")
    self.bid128_round_integral_positive("0", "[1f6aefe24c11d374,ba7425c25f9c9cfb]", "[30400000000000000000000000000001]", "00")
    self.bid128_round_integral_positive("0", "[230ae00c50234d59,84b43c93d47ddb1d]", "[30400000000000000000000000000001]", "00")
    self.bid128_round_integral_positive("0", "[30000092000a0601,4688a5a1a0869764]", "[30400000000000000000000000000001]", "00")
    self.bid128_round_integral_positive("0", "[30000c1e1274dac8,8201763020002400]", "[30400000000000000000000000000003]", "00")
    self.bid128_round_integral_positive("0", "[30218c1808010000,8203000000000060]", "[30400000000000000b26283a94e63700]", "00")
    self.bid128_round_integral_positive("0", "[303b65bebb06e334,efffbfdffbffedff]", "[3040005b952dd4b50b81061472af1a9c]", "00")
    self.bid128_round_integral_positive("0", "[303f7eae427fdfe3,ffffffffffffffff]", "[30402644a03ffcca0000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[3085ED09BEAD87C0378D8E63ffffffff]", "[3085ed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_positive("0", "[3085ED09BEAD87C0378D8E6400000000]", "[30840000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[3CB2314DC6448D9338C15B09ffffffff]", "[3cb2314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_round_integral_positive("0", "[3CB2314DC6448D9338C15B0A00000000]", "[3cb2314dc6448d9338c15b0a00000000]", "00")
    self.bid128_round_integral_positive("0", "[4000000000000000,0000000000000000]", "[40000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[4000000000000000,b3c02053e084c426]", "[4000000000000000b3c02053e084c426]", "00")
    self.bid128_round_integral_positive("0", "[4008000000000000,0003400080000002]", "[40080000000000000003400080000002]", "00")
    self.bid128_round_integral_positive("0", "[400a042801020ec0,2105a1c861202064]", "[400a042801020ec02105a1c861202064]", "00")
    self.bid128_round_integral_positive("0", "[524096290ce6c59f,4d1bf826a836324f]", "[524096290ce6c59f4d1bf826a836324f]", "00")
    self.bid128_round_integral_positive("0", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[7a4044a1606f738b,e482a60ca002b521]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[7dd1c6d9c9f5ebf3,de9dce62137a6f68]", "[7c0006d9c9f5ebf3de9dce62137a6f68]", "00")
    self.bid128_round_integral_positive("0", "[7e000466e2af7726,ac13727a266a84f3]", "[7c000466e2af7726ac13727a266a84f3]", "01")
    self.bid128_round_integral_positive("0", "[7e002a20d924994a,ad08dc73e845f988]", "[7c002a20d924994aad08dc73e845f988]", "01")
    self.bid128_round_integral_positive("0", "[840476e3e0e003d0,ed7a9b12fffe7ab9]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[91785bbb00ce5c43,81e70483653d7dc7]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[a95a2e2078a547b7,a5a1d77ceb55286b]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[b000000a8104a108,ef7b67bfbafb9bbe]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[b4683219a7b1d2fb,2c042824b39685d8]", "[b4683219a7b1d2fb2c042824b39685d8]", "00")
    self.bid128_round_integral_positive("0", "[c1666d0c2c12d6ef,d9bae4a380161961]", "[c1666d0c2c12d6efd9bae4a380161961]", "00")
    self.bid128_round_integral_positive("0", "[cdf9f5d1eab026a3,ff33aed2fba1c1e9]", "[cdf80000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[d41c000000000000,0000000000000000]", "[d41c0000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[DF7FED09BEAD87C0378D8E63ffffffff]", "[df7fed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_positive("0", "[DF7FED09BEAD87C0378D8E6400000000]", "[df7e0000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[e6dfaef705bb178c,a8410b0600200002]", "[b0400000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[f6ffb9f7f57fffef,0008000000001800]", "[dbfe0000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[fbd2a56cbeeebbb7,3bb45f0fee418e90]", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "[fffb3cddd2bf4eff,0000000009200801]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_positive("0", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_positive("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_positive("0", "18446744073709551616500E-3", "18446744073709551617E+0", "00")
    self.bid128_round_integral_positive("0", "18446744073709551616000E-3", "18446744073709551616E+0", "00")
    self.bid128_round_integral_positive("0", "91E-1", "10", "00")
    self.bid128_round_integral_positive("0", "90001E-4", "10", "00")
    self.bid128_round_integral_positive("0", "900000000000000000000001E-23", "10", "00")
    self.bid128_round_integral_positive("0", "9600000000000000000000000E-23", "96", "00")
  }

  private func bid128_round_integral_positive(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.up, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_round_integral_zero() {
    self.bid128_round_integral_zero("0", "[0001ed09bead87c0378d8e62ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[0001ed09bead87c0378d8e64ffffffff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[00fe000000000000,0000000000000000]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[2492beeb9d818053,fadd8970151c961a]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[27a38809decba00c,cc0598806ece1d9a]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[2dc3a5281c1849a2,4f461b5ebca8dd1e]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[300000060168010c,9dffdc62bffcfdff]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[3030000030020000,05c8c405674035c0]", "[30400000000000080deb7b0eb5c64be5]", "00")
    self.bid128_round_integral_zero("0", "[3085ED09BEAD87C0378D8E63ffffffff]", "[3085ed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_zero("0", "[3085ED09BEAD87C0378D8E6400000000]", "[30840000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[3bce6aaf63364afd,867250e924da783c]", "[3bce6aaf63364afd867250e924da783c]", "00")
    self.bid128_round_integral_zero("0", "[3CB2314DC6448D9338C15B09ffffffff]", "[3cb2314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_round_integral_zero("0", "[3CB2314DC6448D9338C15B0A00000000]", "[3cb2314dc6448d9338c15b0a00000000]", "00")
    self.bid128_round_integral_zero("0", "[4040000000000000,66220a61d0b92ae1]", "[404000000000000066220a61d0b92ae1]", "00")
    self.bid128_round_integral_zero("0", "[40e0e8defd166f7d,713a2065cb6900c1]", "[40e0e8defd166f7d713a2065cb6900c1]", "00")
    self.bid128_round_integral_zero("0", "[4800000000000000,0008020380402048]", "[48000000000000000008020380402048]", "00")
    self.bid128_round_integral_zero("0", "[4bc1ad7fe049e6d7,a36c954ebdadd082]", "[4bc1ad7fe049e6d7a36c954ebdadd082]", "00")
    self.bid128_round_integral_zero("0", "[5008000000000000,0000000000000000]", "[50080000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[5090051000a02440,5dadbe8e7ff9a4de]", "[5090051000a024405dadbe8e7ff9a4de]", "00")
    self.bid128_round_integral_zero("0", "[54baf41602df4c7d,5181ede05fd46419]", "[54baf41602df4c7d5181ede05fd46419]", "00")
    self.bid128_round_integral_zero("0", "[690468555ed4f0f7,d9922fd589adef8f]", "[30400000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[793f338fb569875d,9bcfc4a588776b15]", "[78000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[7e00000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_zero("0", "[7e00058b1d247b3c,0aea9b0ae91383b4]", "[7c00058b1d247b3c0aea9b0ae91383b4]", "01")
    self.bid128_round_integral_zero("0", "[7e0009cfe015573e,0113c46b265de9cd]", "[7c0009cfe015573e0113c46b265de9cd]", "01")
    self.bid128_round_integral_zero("0", "[7e000b1e271ef7e0,ca5a6e6fa8843815]", "[7c000b1e271ef7e0ca5a6e6fa8843815]", "01")
    self.bid128_round_integral_zero("0", "[7e00116e883f67b1,a6ad2561d94e47ab]", "[7c00116e883f67b1a6ad2561d94e47ab]", "01")
    self.bid128_round_integral_zero("0", "[7e0024f56b1a83cf,2f341fcb73df6e9c]", "[7c0024f56b1a83cf2f341fcb73df6e9c]", "01")
    self.bid128_round_integral_zero("0", "[afff767edef7bdff,bafcb11eee5ecff2]", "[b0400000000000000000000000000007]", "00")
    self.bid128_round_integral_zero("0", "[b03c503938e36cdb,6a313861c9b75003]", "[b04000cd5f49f449dfc82c15753797d7]", "00")
    self.bid128_round_integral_zero("0", "[b6ccc46c69e989c2,359f45f752afa94c]", "[b6ccc46c69e989c2359f45f752afa94c]", "00")
    self.bid128_round_integral_zero("0", "[b96dfc6073fc763d,fd73e6c85c99363f]", "[b96c0000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[c2769a11a18238f0,7684855ad8d00fdc]", "[c2769a11a18238f07684855ad8d00fdc]", "00")
    self.bid128_round_integral_zero("0", "[c8d61646db2d3907,eef4c54a43c62ebd]", "[c8d61646db2d3907eef4c54a43c62ebd]", "00")
    self.bid128_round_integral_zero("0", "[d307801862a1a51b,67fdd7704d99d231]", "[d307801862a1a51b67fdd7704d99d231]", "00")
    self.bid128_round_integral_zero("0", "[dd03e68cc977e82c,3eb804abab546268]", "[dd03e68cc977e82c3eb804abab546268]", "00")
    self.bid128_round_integral_zero("0", "[DF7FED09BEAD87C0378D8E63ffffffff]", "[df7fed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_round_integral_zero("0", "[DF7FED09BEAD87C0378D8E6400000000]", "[df7e0000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[f7fcfc7dfffefff9,fffffeffffffffee]", "[dff20000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[fb7fbf5dfffdeafc,3fad1f7bbadf27f2]", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "[fdbecffbffebf53f,0905800000008000]", "[fc000ffbffebf53f0905800000008000]", "00")
    self.bid128_round_integral_zero("0", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_zero("0", "[fe001c1551ff726e,85f8d5226cf76148]", "[fc001c1551ff726e85f8d5226cf76148]", "01")
    self.bid128_round_integral_zero("0", "[fff77ff9f7fcffbd,fdffffffffffffff]", "[fc000000000000000000000000000000]", "01")
    self.bid128_round_integral_zero("0", "-Infinity", "[f8000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_round_integral_zero("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_round_integral_zero("0", "18446744073709551616500E-3", "18446744073709551616E+0", "00")
  }

  private func bid128_round_integral_zero(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.rounded(.towardZero, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.toIntel_round(status: &status)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }
}
