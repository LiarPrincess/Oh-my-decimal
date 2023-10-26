// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelPropertyTests: XCTestCase, IntelMixin {

  func test_bid32_abs() {
    self.bid32_abs("0", "[00000001]", "[00000001]", "00")
    self.bid32_abs("0", "[00080001]", "[00080001]", "00")
    self.bid32_abs("0", "-1.0", "[3200000a]", "00")
    self.bid32_abs("0", "1.0", "[3200000a]", "00")
    self.bid32_abs("0", "-1.0e-96", "[0200000a]", "00")
    self.bid32_abs("0", "1.0e-96", "[0200000a]", "00")
    self.bid32_abs("0", "[6098967f]", "[6098967f]", "00")
    self.bid32_abs("0", "[60989680]", "[60989680]", "00")
    self.bid32_abs("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_abs("0", "[7c8f423f]", "[7c8f423f]", "00")
    self.bid32_abs("0", "[7c8f4240]", "[7c8f4240]", "00")
    self.bid32_abs("0", "[7e100000]", "[7e100000]", "00")
    self.bid32_abs("0", "[7e100100]", "[7e100100]", "00")
    self.bid32_abs("0", "[7e8f423f]", "[7e8f423f]", "00")
    self.bid32_abs("0", "[7e8f4240]", "[7e8f4240]", "00")
    self.bid32_abs("0", "[80000001]", "[00000001]", "00")
    self.bid32_abs("0", "-9.999999e-95", "[6018967f]", "00")
    self.bid32_abs("0", "9.999999e-95", "[6018967f]", "00")
    self.bid32_abs("0", "-9.999999e96", "[77f8967f]", "00")
    self.bid32_abs("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_abs("0", "[fc100000]", "[7c100000]", "00")
    self.bid32_abs("0", "[fc100100]", "[7c100100]", "00")
    self.bid32_abs("0", "[fe000000]", "[7e000000]", "00")
  }

  private func bid32_abs(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }

    let result = arg0.magnitude
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid32_class() {
    self.bid32_class("0", "[00082041]", "7", "00")
    self.bid32_class("0", "[27000000]", "6", "00")
    self.bid32_class("0", "[328f423f]", "8", "00")
    self.bid32_class("0", "[607fffff]", "6", "00")
    self.bid32_class("0", "[658c3437]", "8", "00")
    self.bid32_class("0", "[78000000]", "9", "00")
    self.bid32_class("0", "[78000001]", "9", "00")
    self.bid32_class("0", "[78001000]", "9", "00")
    self.bid32_class("0", "[780fffff]", "9", "00")
    self.bid32_class("0", "[78f00000]", "9", "00")
    self.bid32_class("0", "[78f00001]", "9", "00")
    self.bid32_class("0", "[78ffffff]", "9", "00")
    self.bid32_class("0", "[7c000000]", "1", "00")
    self.bid32_class("0", "[7c000001]", "1", "00")
    self.bid32_class("0", "[7c001000]", "1", "00")
    self.bid32_class("0", "[7c0f4240]", "1", "00")
    self.bid32_class("0", "[7c0fffff]", "1", "00")
    self.bid32_class("0", "[7c8f423f]", "1", "00")
    self.bid32_class("0", "[7c8f4240]", "1", "00")
    self.bid32_class("0", "[7c8f4241]", "1", "00")
    self.bid32_class("0", "[7cf00000]", "1", "00")
    self.bid32_class("0", "[7cf00001]", "1", "00")
    self.bid32_class("0", "[7cffffff]", "1", "00")
    self.bid32_class("0", "[7e000000]", "0", "00")
    self.bid32_class("0", "[7e000001]", "0", "00")
    self.bid32_class("0", "[7e000100]", "0", "00")
    self.bid32_class("0", "[7e0f4240]", "0", "00")
    self.bid32_class("0", "[7e0fffff]", "0", "00")
    self.bid32_class("0", "[7e8f423f]", "0", "00")
    self.bid32_class("0", "[7e8f4240]", "0", "00")
    self.bid32_class("0", "[7e8f4241]", "0", "00")
    self.bid32_class("0", "[7ef00000]", "0", "00")
    self.bid32_class("0", "[7ef00001]", "0", "00")
    self.bid32_class("0", "[7effffff]", "0", "00")
    self.bid32_class("0", "[8298e75f]", "3", "00")
    self.bid32_class("0", "[f420b31f]", "3", "00")
    self.bid32_class("0", "[f71fffff]", "5", "00")
    self.bid32_class("0", "[f8000000]", "2", "00")
    self.bid32_class("0", "[f8000001]", "2", "00")
    self.bid32_class("0", "[f8001000]", "2", "00")
    self.bid32_class("0", "[f80fffff]", "2", "00")
    self.bid32_class("0", "[f8f00000]", "2", "00")
    self.bid32_class("0", "[f8f00001]", "2", "00")
    self.bid32_class("0", "[f8ffffff]", "2", "00")
    self.bid32_class("0", "[fc000000]", "1", "00")
    self.bid32_class("0", "[fc000001]", "1", "00")
    self.bid32_class("0", "[fc001000]", "1", "00")
    self.bid32_class("0", "[fc0f4240]", "1", "00")
    self.bid32_class("0", "[fc0fffff]", "1", "00")
    self.bid32_class("0", "[fc8f423f]", "1", "00")
    self.bid32_class("0", "[fc8f4240]", "1", "00")
    self.bid32_class("0", "[fc8f4241]", "1", "00")
    self.bid32_class("0", "[fcf00000]", "1", "00")
    self.bid32_class("0", "[fcf00001]", "1", "00")
    self.bid32_class("0", "[fcffffff]", "1", "00")
    self.bid32_class("0", "[fe000000]", "0", "00")
    self.bid32_class("0", "[fe000001]", "0", "00")
    self.bid32_class("0", "[fe000100]", "0", "00")
    self.bid32_class("0", "[fe0fffff]", "0", "00")
    self.bid32_class("0", "[fe8f423f]", "0", "00")
    self.bid32_class("0", "[fe8f4240]", "0", "00")
    self.bid32_class("0", "[fe8f4241]", "0", "00")
    self.bid32_class("0", "[fef00000]", "0", "00")
    self.bid32_class("0", "[fef00001]", "0", "00")
    self.bid32_class("0", "[feffffff]", "0", "00")
    self.bid32_class("0", "[00000000]", "6", "00")
    self.bid32_class("0", "[80000000]", "5", "00")
    self.bid32_class("0", "[00000001]", "7", "00")
    self.bid32_class("0", "[80000001]", "4", "00")
  }

  private func bid32_class(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.floatingPointClass
    self.assertFloatingPointClass(result, expected, file, line)
  }

  func test_bid32_isCanonical() {
    self.bid32_isCanonical("0", "[00000001]", "1", "00")
    self.bid32_isCanonical("0", "[00080001]", "1", "00")
    self.bid32_isCanonical("0", "-1.0", "1", "00")
    self.bid32_isCanonical("0", "1.0", "1", "00")
    self.bid32_isCanonical("0", "-1.0e-96", "1", "00")
    self.bid32_isCanonical("0", "1.0e-96", "1", "00")
    self.bid32_isCanonical("0", "[6098967f]", "1", "00")
    self.bid32_isCanonical("0", "[60989680]", "0", "00")
    self.bid32_isCanonical("0", "[7c000000]", "1", "00")
    self.bid32_isCanonical("0", "[7c8f423f]", "0", "00")
    self.bid32_isCanonical("0", "[7c8f4240]", "0", "00")
    self.bid32_isCanonical("0", "[7e100000]", "0", "00")
    self.bid32_isCanonical("0", "[7e100100]", "0", "00")
    self.bid32_isCanonical("0", "[7e8f423f]", "0", "00")
    self.bid32_isCanonical("0", "[7e8f4240]", "0", "00")
    self.bid32_isCanonical("0", "[80000001]", "1", "00")
    self.bid32_isCanonical("0", "-9.999999e-95", "1", "00")
    self.bid32_isCanonical("0", "9.999999e-95", "1", "00")
    self.bid32_isCanonical("0", "-9.999999e96", "1", "00")
    self.bid32_isCanonical("0", "9.999999e96", "1", "00")
    self.bid32_isCanonical("0", "[f8000000]", "1", "00")
    self.bid32_isCanonical("0", "[f8001000]", "0", "00")
    self.bid32_isCanonical("0", "[f8400000]", "0", "00")
    self.bid32_isCanonical("0", "[fc100000]", "0", "00")
    self.bid32_isCanonical("0", "[fc100100]", "0", "00")
    self.bid32_isCanonical("0", "[fe000000]", "1", "00")
    self.bid32_isCanonical("0", "[7c0F4240]", "0", "00")
  }

  private func bid32_isCanonical(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isCanonical
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isFinite() {
    self.bid32_isFinite("0", "[00000001]", "1", "00")
    self.bid32_isFinite("0", "[00080001]", "1", "00")
    self.bid32_isFinite("0", "-1.0", "1", "00")
    self.bid32_isFinite("0", "1.0", "1", "00")
    self.bid32_isFinite("0", "-1.0e-96", "1", "00")
    self.bid32_isFinite("0", "1.0e-96", "1", "00")
    self.bid32_isFinite("0", "[6098967f]", "1", "00")
    self.bid32_isFinite("0", "[60989680]", "1", "00")
    self.bid32_isFinite("0", "[7c000000]", "0", "00")
    self.bid32_isFinite("0", "[7c8f423f]", "0", "00")
    self.bid32_isFinite("0", "[7c8f4240]", "0", "00")
    self.bid32_isFinite("0", "[7e100000]", "0", "00")
    self.bid32_isFinite("0", "[7e100100]", "0", "00")
    self.bid32_isFinite("0", "[7e8f423f]", "0", "00")
    self.bid32_isFinite("0", "[7e8f4240]", "0", "00")
    self.bid32_isFinite("0", "[80000001]", "1", "00")
    self.bid32_isFinite("0", "-9.999999e-95", "1", "00")
    self.bid32_isFinite("0", "9.999999e-95", "1", "00")
    self.bid32_isFinite("0", "-9.999999e96", "1", "00")
    self.bid32_isFinite("0", "9.999999e96", "1", "00")
    self.bid32_isFinite("0", "[fc100000]", "0", "00")
    self.bid32_isFinite("0", "[fc100100]", "0", "00")
    self.bid32_isFinite("0", "[fe000000]", "0", "00")
  }

  private func bid32_isFinite(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isFinite
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isInf() {
    self.bid32_isInf("0", "[00000001]", "0", "00")
    self.bid32_isInf("0", "[00080001]", "0", "00")
    self.bid32_isInf("0", "-1.0", "0", "00")
    self.bid32_isInf("0", "1.0", "0", "00")
    self.bid32_isInf("0", "-1.0e-96", "0", "00")
    self.bid32_isInf("0", "1.0e-96", "0", "00")
    self.bid32_isInf("0", "[6098967f]", "0", "00")
    self.bid32_isInf("0", "[60989680]", "0", "00")
    self.bid32_isInf("0", "[7c000000]", "0", "00")
    self.bid32_isInf("0", "[7c8f423f]", "0", "00")
    self.bid32_isInf("0", "[7c8f4240]", "0", "00")
    self.bid32_isInf("0", "[7e100000]", "0", "00")
    self.bid32_isInf("0", "[7e100100]", "0", "00")
    self.bid32_isInf("0", "[7e8f423f]", "0", "00")
    self.bid32_isInf("0", "[7e8f4240]", "0", "00")
    self.bid32_isInf("0", "[80000001]", "0", "00")
    self.bid32_isInf("0", "-9.999999e-95", "0", "00")
    self.bid32_isInf("0", "9.999999e-95", "0", "00")
    self.bid32_isInf("0", "-9.999999e96", "0", "00")
    self.bid32_isInf("0", "9.999999e96", "0", "00")
    self.bid32_isInf("0", "[fc100000]", "0", "00")
    self.bid32_isInf("0", "[fc100100]", "0", "00")
    self.bid32_isInf("0", "[fe000000]", "0", "00")
  }

  private func bid32_isInf(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isInfinite
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isNaN() {
    self.bid32_isNaN("0", "[00000001]", "0", "00")
    self.bid32_isNaN("0", "[00080001]", "0", "00")
    self.bid32_isNaN("0", "-1.0", "0", "00")
    self.bid32_isNaN("0", "1.0", "0", "00")
    self.bid32_isNaN("0", "-1.0e-96", "0", "00")
    self.bid32_isNaN("0", "1.0e-96", "0", "00")
    self.bid32_isNaN("0", "[6098967f]", "0", "00")
    self.bid32_isNaN("0", "[60989680]", "0", "00")
    self.bid32_isNaN("0", "[7c000000]", "1", "00")
    self.bid32_isNaN("0", "[7c8f423f]", "1", "00")
    self.bid32_isNaN("0", "[7c8f4240]", "1", "00")
    self.bid32_isNaN("0", "[7e100000]", "1", "00")
    self.bid32_isNaN("0", "[7e100100]", "1", "00")
    self.bid32_isNaN("0", "[7e8f423f]", "1", "00")
    self.bid32_isNaN("0", "[7e8f4240]", "1", "00")
    self.bid32_isNaN("0", "[80000001]", "0", "00")
    self.bid32_isNaN("0", "-9.999999e-95", "0", "00")
    self.bid32_isNaN("0", "9.999999e-95", "0", "00")
    self.bid32_isNaN("0", "-9.999999e96", "0", "00")
    self.bid32_isNaN("0", "9.999999e96", "0", "00")
    self.bid32_isNaN("0", "[fc100000]", "1", "00")
    self.bid32_isNaN("0", "[fc100100]", "1", "00")
    self.bid32_isNaN("0", "[fe000000]", "1", "00")
  }

  private func bid32_isNaN(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isNaN
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isNormal() {
    self.bid32_isNormal("0", "[00000001]", "0", "00")
    self.bid32_isNormal("0", "[00080001]", "0", "00")
    self.bid32_isNormal("0", "[029259a6]", "1", "00")
    self.bid32_isNormal("0", "[02f69ec8]", "1", "00")
    self.bid32_isNormal("0", "[0a800000]", "0", "00")
    self.bid32_isNormal("0", "-1.0", "1", "00")
    self.bid32_isNormal("0", "1.0", "1", "00")
    self.bid32_isNormal("0", "-1.0e-96", "0", "00")
    self.bid32_isNormal("0", "1.0e-96", "0", "00")
    self.bid32_isNormal("0", "[6098967f]", "1", "00")
    self.bid32_isNormal("0", "[60989680]", "0", "00")
    self.bid32_isNormal("0", "[7c000000]", "0", "00")
    self.bid32_isNormal("0", "[7c8f423f]", "0", "00")
    self.bid32_isNormal("0", "[7c8f4240]", "0", "00")
    self.bid32_isNormal("0", "[7e100000]", "0", "00")
    self.bid32_isNormal("0", "[7e100100]", "0", "00")
    self.bid32_isNormal("0", "[7e8f423f]", "0", "00")
    self.bid32_isNormal("0", "[7e8f4240]", "0", "00")
    self.bid32_isNormal("0", "[80000001]", "0", "00")
    self.bid32_isNormal("0", "[82f69ec3]", "1", "00")
    self.bid32_isNormal("0", "[82f69ec8]", "1", "00")
    self.bid32_isNormal("0", "-9.999999e-95", "1", "00")
    self.bid32_isNormal("0", "9.999999e-95", "1", "00")
    self.bid32_isNormal("0", "-9.999999e96", "1", "00")
    self.bid32_isNormal("0", "9.999999e96", "1", "00")
    self.bid32_isNormal("0", "[fc100000]", "0", "00")
    self.bid32_isNormal("0", "[fc100100]", "0", "00")
    self.bid32_isNormal("0", "[fe000000]", "0", "00")
  }

  private func bid32_isNormal(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isNormal
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isSignaling() {
    self.bid32_isSignaling("0", "[00000001]", "0", "00")
    self.bid32_isSignaling("0", "[00080001]", "0", "00")
    self.bid32_isSignaling("0", "-1.0", "0", "00")
    self.bid32_isSignaling("0", "1.0", "0", "00")
    self.bid32_isSignaling("0", "-1.0e-96", "0", "00")
    self.bid32_isSignaling("0", "1.0e-96", "0", "00")
    self.bid32_isSignaling("0", "[6098967f]", "0", "00")
    self.bid32_isSignaling("0", "[60989680]", "0", "00")
    self.bid32_isSignaling("0", "[7c000000]", "0", "00")
    self.bid32_isSignaling("0", "[7c8f423f]", "0", "00")
    self.bid32_isSignaling("0", "[7c8f4240]", "0", "00")
    self.bid32_isSignaling("0", "[7e100000]", "1", "00")
    self.bid32_isSignaling("0", "[7e100100]", "1", "00")
    self.bid32_isSignaling("0", "[7e8f423f]", "1", "00")
    self.bid32_isSignaling("0", "[7e8f4240]", "1", "00")
    self.bid32_isSignaling("0", "[80000001]", "0", "00")
    self.bid32_isSignaling("0", "-9.999999e-95", "0", "00")
    self.bid32_isSignaling("0", "9.999999e-95", "0", "00")
    self.bid32_isSignaling("0", "-9.999999e96", "0", "00")
    self.bid32_isSignaling("0", "9.999999e96", "0", "00")
    self.bid32_isSignaling("0", "[fc100000]", "0", "00")
    self.bid32_isSignaling("0", "[fc100100]", "0", "00")
    self.bid32_isSignaling("0", "[fe000000]", "1", "00")
  }

  private func bid32_isSignaling(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isSignalingNaN
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isSigned() {
    self.bid32_isSigned("0", "[00000001]", "0", "00")
    self.bid32_isSigned("0", "[00080001]", "0", "00")
    self.bid32_isSigned("0", "1.0", "0", "00")
    self.bid32_isSigned("0", "-1.0", "1", "00")
    self.bid32_isSigned("0", "1.0e-96", "0", "00")
    self.bid32_isSigned("0", "-1.0e-96", "1", "00")
    self.bid32_isSigned("0", "[6098967f]", "0", "00")
    self.bid32_isSigned("0", "[60989680]", "0", "00")
    self.bid32_isSigned("0", "[7c000000]", "0", "00")
    self.bid32_isSigned("0", "[7c8f423f]", "0", "00")
    self.bid32_isSigned("0", "[7c8f4240]", "0", "00")
    self.bid32_isSigned("0", "[7e100000]", "0", "00")
    self.bid32_isSigned("0", "[7e100100]", "0", "00")
    self.bid32_isSigned("0", "[7e8f423f]", "0", "00")
    self.bid32_isSigned("0", "[7e8f4240]", "0", "00")
    self.bid32_isSigned("0", "[80000001]", "1", "00")
    self.bid32_isSigned("0", "9.999999e-95", "0", "00")
    self.bid32_isSigned("0", "-9.999999e-95", "1", "00")
    self.bid32_isSigned("0", "9.999999e96", "0", "00")
    self.bid32_isSigned("0", "-9.999999e96", "1", "00")
    self.bid32_isSigned("0", "[fc100000]", "1", "00")
    self.bid32_isSigned("0", "[fc100100]", "1", "00")
    self.bid32_isSigned("0", "[fe000000]", "1", "00")
  }

  private func bid32_isSigned(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.sign
    self.assertSign(result, expected, file, line)
  }

  func test_bid32_isSubnormal() {
    self.bid32_isSubnormal("0", "[00000001]", "1", "00")
    self.bid32_isSubnormal("0", "[00080001]", "1", "00")
    self.bid32_isSubnormal("0", "[0292599f]", "0", "00")
    self.bid32_isSubnormal("0", "[029259a4]", "0", "00")
    self.bid32_isSubnormal("0", "[029259a6]", "0", "00")
    self.bid32_isSubnormal("0", "[02f69ec8]", "0", "00")
    self.bid32_isSubnormal("0", "-1.0", "0", "00")
    self.bid32_isSubnormal("0", "1.0", "0", "00")
    self.bid32_isSubnormal("0", "-1.0e-96", "1", "00")
    self.bid32_isSubnormal("0", "1.0e-96", "1", "00")
    self.bid32_isSubnormal("0", "[6098967f]", "0", "00")
    self.bid32_isSubnormal("0", "[60989680]", "0", "00")
    self.bid32_isSubnormal("0", "[7c000000]", "0", "00")
    self.bid32_isSubnormal("0", "[7c8f423f]", "0", "00")
    self.bid32_isSubnormal("0", "[7c8f4240]", "0", "00")
    self.bid32_isSubnormal("0", "[7e100000]", "0", "00")
    self.bid32_isSubnormal("0", "[7e100100]", "0", "00")
    self.bid32_isSubnormal("0", "[7e8f423f]", "0", "00")
    self.bid32_isSubnormal("0", "[7e8f4240]", "0", "00")
    self.bid32_isSubnormal("0", "[80000001]", "1", "00")
    self.bid32_isSubnormal("0", "-9.999999e-95", "0", "00")
    self.bid32_isSubnormal("0", "9.999999e-95", "0", "00")
    self.bid32_isSubnormal("0", "-9.999999e96", "0", "00")
    self.bid32_isSubnormal("0", "9.999999e96", "0", "00")
    self.bid32_isSubnormal("0", "[bf800000]", "0", "00")
    self.bid32_isSubnormal("0", "[fc100000]", "0", "00")
    self.bid32_isSubnormal("0", "[fc100100]", "0", "00")
    self.bid32_isSubnormal("0", "[fe000000]", "0", "00")
  }

  private func bid32_isSubnormal(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isSubnormal
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_isZero() {
    self.bid32_isZero("0", "[00000001]", "0", "00")
    self.bid32_isZero("0", "[00080001]", "0", "00")
    self.bid32_isZero("0", "-1.0", "0", "00")
    self.bid32_isZero("0", "1.0", "0", "00")
    self.bid32_isZero("0", "-1.0e-96", "0", "00")
    self.bid32_isZero("0", "1.0e-96", "0", "00")
    self.bid32_isZero("0", "[6098967f]", "0", "00")
    self.bid32_isZero("0", "[60989680]", "1", "00")
    self.bid32_isZero("0", "[7c000000]", "0", "00")
    self.bid32_isZero("0", "[7c8f423f]", "0", "00")
    self.bid32_isZero("0", "[7c8f4240]", "0", "00")
    self.bid32_isZero("0", "[7e100000]", "0", "00")
    self.bid32_isZero("0", "[7e100100]", "0", "00")
    self.bid32_isZero("0", "[7e8f423f]", "0", "00")
    self.bid32_isZero("0", "[7e8f4240]", "0", "00")
    self.bid32_isZero("0", "[80000001]", "0", "00")
    self.bid32_isZero("0", "-9.999999e-95", "0", "00")
    self.bid32_isZero("0", "9.999999e-95", "0", "00")
    self.bid32_isZero("0", "-9.999999e96", "0", "00")
    self.bid32_isZero("0", "9.999999e96", "0", "00")
    self.bid32_isZero("0", "[fc100000]", "0", "00")
    self.bid32_isZero("0", "[fc100100]", "0", "00")
    self.bid32_isZero("0", "[fe000000]", "0", "00")
  }

  private func bid32_isZero(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isZero
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_abs() {
    self.bid64_abs("0", "-0", "[31c0000000000000]", "00")
    self.bid64_abs("0", "[0c2f000000000000]", "[0c2f000000000000]", "00")
    self.bid64_abs("0", "[0eada90166c6c0e3]", "[0eada90166c6c0e3]", "00")
    self.bid64_abs("0", "[3a52266e9c893405]", "[3a52266e9c893405]", "00")
    self.bid64_abs("0", "[4820000000000000]", "[4820000000000000]", "00")
    self.bid64_abs("0", "[4c25e2eef8bedf06]", "[4c25e2eef8bedf06]", "00")
    self.bid64_abs("0", "[5972aa2ec1ca6dac]", "[5972aa2ec1ca6dac]", "00")
    self.bid64_abs("0", "[673828de6d87f005]", "[673828de6d87f005]", "00")
    self.bid64_abs("0", "[6efa41c0e86b768b]", "[6efa41c0e86b768b]", "00")
    self.bid64_abs("0", "[e15b6196405c5cd9]", "[615b6196405c5cd9]", "00")
    self.bid64_abs("0", "[edfb16881efb7901]", "[6dfb16881efb7901]", "00")
    self.bid64_abs("0", "[f4724d2349d55f24]", "[74724d2349d55f24]", "00")
    self.bid64_abs("0", "Infinity", "[7800000000000000]", "00")
    self.bid64_abs("0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_abs("0", "SNaN", "[7e00000000000000]", "00")
  }

  private func bid64_abs(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = arg0.magnitude
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid64_class() {
    self.bid64_class("0", "[0000000040100000]", "7", "00")
    self.bid64_class("0", "-0", "5", "00")
    self.bid64_class("0", "0", "6", "00")
    self.bid64_class("0", "[069a36c8f9c09818]", "8", "00")
    self.bid64_class("0", "[1000000000000000]", "6", "00")
    self.bid64_class("0", "[18ebf0eb84027607]", "8", "00")
    self.bid64_class("0", "[2407f5972ed7b76b]", "8", "00")
    self.bid64_class("0", "[3e2a85a98df1a62e]", "8", "00")
    self.bid64_class("0", "[72bb05ed5f217403]", "8", "00")
    self.bid64_class("0", "[73dc9f0cefef8aef]", "6", "00")
    self.bid64_class("0", "[74a23c8f2229106a]", "8", "00")
    self.bid64_class("0", "[79fffade57fabf5b]", "9", "00")
    self.bid64_class("0", "[8c32d9f830270c43]", "3", "00")
    self.bid64_class("0", "[97c4180a6666476d]", "3", "00")
    self.bid64_class("0", "[a5247757cbba3ba7]", "3", "00")
    self.bid64_class("0", "[b61b100697ed86c3]", "3", "00")
    self.bid64_class("0", "[b6ee2fa4068519a5]", "3", "00")
    self.bid64_class("0", "[c1e50e97c4a1cb96]", "3", "00")
    self.bid64_class("0", "[f0c3ae213f30b8d8]", "5", "00")
    self.bid64_class("0", "[fbfffefffffffeff]", "2", "00")
    self.bid64_class("0", "[fde7bf7f3d7bafd8]", "1", "00")
    self.bid64_class("0", "[fffefffffffffeff]", "0", "00")
    self.bid64_class("0", "-Infinity", "2", "00")
    self.bid64_class("0", "Infinity", "9", "00")
    self.bid64_class("0", "QNaN", "1", "00")
    self.bid64_class("0", "SNaN", "0", "00")
    self.bid64_class("0", "[8000000040100000]", "4", "00")
  }

  private func bid64_class(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.floatingPointClass
    self.assertFloatingPointClass(result, expected, file, line)
  }

  func test_bid64_isCanonical() {
    self.bid64_isCanonical("0", "-0", "1", "00")
    self.bid64_isCanonical("0", "0", "1", "00")
    self.bid64_isCanonical("0", "0E-83", "1", "00")
    self.bid64_isCanonical("0", "[2811086419027808]", "1", "00")
    self.bid64_isCanonical("0", "[292fc3f6cda18948]", "1", "00")
    self.bid64_isCanonical("0", "[5473faef406b0fcd]", "1", "00")
    self.bid64_isCanonical("0", "[68e3435409c48c01]", "1", "00")
    self.bid64_isCanonical("0", "[75ab31f57ab709dd]", "1", "00")
    self.bid64_isCanonical("0", "[79d06c1de91c42f2]", "0", "00")
    self.bid64_isCanonical("0", "[7e03f3e1e4c85d17]", "0", "00")
    self.bid64_isCanonical("0", "[a802003113f8e3a6]", "1", "00")
    self.bid64_isCanonical("0", "[b58bfd8821f2492a]", "1", "00")
    self.bid64_isCanonical("0", "[b9a0e346782c737f]", "1", "00")
    self.bid64_isCanonical("0", "[c1eef72624bcf3e9]", "1", "00")
    self.bid64_isCanonical("0", "[c22931d2363b48da]", "1", "00")
    self.bid64_isCanonical("0", "[ddc28edd86a0e0dc]", "1", "00")
    self.bid64_isCanonical("0", "[e125a4d69af506a9]", "0", "00")
    self.bid64_isCanonical("0", "[f800000000000000]", "1", "00")
    self.bid64_isCanonical("0", "[f800000001000000]", "0", "00")
    self.bid64_isCanonical("0", "[f810000000000000]", "0", "00")
    self.bid64_isCanonical("0", "[fe00c3d109f0dda6]", "1", "00")
    self.bid64_isCanonical("0", "[fffffeffffffffff]", "0", "00")
    self.bid64_isCanonical("0", "-Infinity", "1", "00")
    self.bid64_isCanonical("0", "Infinity", "1", "00")
    self.bid64_isCanonical("0", "QNaN", "1", "00")
    self.bid64_isCanonical("0", "SNaN", "1", "00")
  }

  private func bid64_isCanonical(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isCanonical
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isFinite() {
    self.bid64_isFinite("0", "-0", "1", "00")
    self.bid64_isFinite("0", "0", "1", "00")
    self.bid64_isFinite("0", "[1608af5cb4593bf4]", "1", "00")
    self.bid64_isFinite("0", "[2a166dfc84e76865]", "1", "00")
    self.bid64_isFinite("0", "[54c0000000000000]", "1", "00")
    self.bid64_isFinite("0", "[85c107f0c960db7e]", "1", "00")
    self.bid64_isFinite("0", "[99b52df1feac4415]", "1", "00")
    self.bid64_isFinite("0", "[a5d5d70134196a1a]", "1", "00")
    self.bid64_isFinite("0", "[af20000000000000]", "1", "00")
    self.bid64_isFinite("0", "[bec96a9433a05fc7]", "1", "00")
    self.bid64_isFinite("0", "[c235bf6d4565f8c4]", "1", "00")
    self.bid64_isFinite("0", "[dc5055f8523440b9]", "1", "00")
    self.bid64_isFinite("0", "[e8fd289d8852613a]", "1", "00")
    self.bid64_isFinite("0", "-Infinity", "0", "00")
    self.bid64_isFinite("0", "QNaN", "0", "00")
    self.bid64_isFinite("0", "SNaN", "0", "00")
  }

  private func bid64_isFinite(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isFinite
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isInf() {
    self.bid64_isInf("0", "-0", "0", "00")
    self.bid64_isInf("0", "0", "0", "00")
    self.bid64_isInf("0", "[0e2a000000000000]", "0", "00")
    self.bid64_isInf("0", "[426bd93b6d5a55ff]", "0", "00")
    self.bid64_isInf("0", "[452ed318d6be629d]", "0", "00")
    self.bid64_isInf("0", "[83b9dd4ef6f10188]", "0", "00")
    self.bid64_isInf("0", "[8b5d556f8b318648]", "0", "00")
    self.bid64_isInf("0", "[931f66ce5754afaa]", "0", "00")
    self.bid64_isInf("0", "[9840000000000000]", "0", "00")
    self.bid64_isInf("0", "[9e2fe80093f4056b]", "0", "00")
    self.bid64_isInf("0", "[c57708cdda260a7c]", "0", "00")
    self.bid64_isInf("0", "[dc929d20fa722a17]", "0", "00")
    self.bid64_isInf("0", "[ddaedd7658bad294]", "0", "00")
    self.bid64_isInf("0", "Infinity", "1", "00")
    self.bid64_isInf("0", "QNaN", "0", "00")
    self.bid64_isInf("0", "SNaN", "0", "00")
  }

  private func bid64_isInf(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isInfinite
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isNaN() {
    self.bid64_isNaN("0", "0", "0", "00")
    self.bid64_isNaN("0", "[2437f7cf38a63db8]", "0", "00")
    self.bid64_isNaN("0", "[2d8cedba6d10597e]", "0", "00")
    self.bid64_isNaN("0", "[385ba1cbb8c2bcf9]", "0", "00")
    self.bid64_isNaN("0", "[6031b795cfce0912]", "0", "00")
    self.bid64_isNaN("0", "[81c72ce22dc94c5d]", "0", "00")
    self.bid64_isNaN("0", "[bd673245d19d51eb]", "0", "00")
    self.bid64_isNaN("0", "[d11909bcbc0ef969]", "0", "00")
    self.bid64_isNaN("0", "[d6124b4e9e27cf82]", "0", "00")
    self.bid64_isNaN("0", "[db70d6ecf4cea09e]", "0", "00")
    self.bid64_isNaN("0", "[e649f50970cd7b28]", "0", "00")
    self.bid64_isNaN("0", "-Infinity", "0", "00")
    self.bid64_isNaN("0", "Infinity", "0", "00")
    self.bid64_isNaN("0", "QNaN", "1", "00")
  }

  private func bid64_isNaN(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isNaN
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isNormal() {
    self.bid64_isNormal("0", "0", "0", "00")
    self.bid64_isNormal("0", "[0000000000000000]", "0", "00")
    self.bid64_isNormal("0", "[0000000220000880]", "0", "00")
    self.bid64_isNormal("0", "[0042000880060800]", "1", "00")
    self.bid64_isNormal("0", "[0f19eda8ce8d0d7c]", "1", "00")
    self.bid64_isNormal("0", "[1240000000000000]", "0", "00")
    self.bid64_isNormal("0", "[176ca85dbd0e3ed8]", "1", "00")
    self.bid64_isNormal("0", "[1b77fad26e664ee7]", "1", "00")
    self.bid64_isNormal("0", "[20f6514fb338a22c]", "1", "00")
    self.bid64_isNormal("0", "[56867713cac397e3]", "1", "00")
    self.bid64_isNormal("0", "[6489214a172fbc88]", "1", "00")
    self.bid64_isNormal("0", "[6eaba7a5b910bc03]", "0", "00")
    self.bid64_isNormal("0", "[94206ef326033fa3]", "1", "00")
    self.bid64_isNormal("0", "[bbdd8c9fffac1f7b]", "1", "00")
    self.bid64_isNormal("0", "[c3bdd7e750efbf92]", "1", "00")
    self.bid64_isNormal("0", "[e97982db520f3b12]", "1", "00")
    self.bid64_isNormal("0", "[f56adf1cb46269c8]", "1", "00")
    self.bid64_isNormal("0", "[fdeffefd7c367377]", "0", "00")
    self.bid64_isNormal("0", "-Infinity", "0", "00")
    self.bid64_isNormal("0", "Infinity", "0", "00")
    self.bid64_isNormal("0", "QNaN", "0", "00")
  }

  private func bid64_isNormal(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isNormal
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isSignaling() {
    self.bid64_isSignaling("0", "-0", "0", "00")
    self.bid64_isSignaling("0", "0", "0", "00")
    self.bid64_isSignaling("0", "[15ad2a086b455100]", "0", "00")
    self.bid64_isSignaling("0", "[4781bd5bd459fb0e]", "0", "00")
    self.bid64_isSignaling("0", "[55dc18613ae0c22c]", "0", "00")
    self.bid64_isSignaling("0", "[57c9b7b52a49a843]", "0", "00")
    self.bid64_isSignaling("0", "[7e00000000000000]", "1", "00")
    self.bid64_isSignaling("0", "[7e00000100000000]", "1", "00")
    self.bid64_isSignaling("0", "[7e03ffffffffffff]", "1", "00")
    self.bid64_isSignaling("0", "[92943f53462b5700]", "0", "00")
    self.bid64_isSignaling("0", "[975027601b33db1d]", "0", "00")
    self.bid64_isSignaling("0", "[9e80000000000000]", "0", "00")
    self.bid64_isSignaling("0", "[a920000000000000]", "0", "00")
    self.bid64_isSignaling("0", "[ac40000000000000]", "0", "00")
    self.bid64_isSignaling("0", "[bcba996cf19c6391]", "0", "00")
    self.bid64_isSignaling("0", "[fe00000000000000]", "1", "00")
    self.bid64_isSignaling("0", "[fef0000000000000]", "1", "00")
    self.bid64_isSignaling("0", "-Infinity", "0", "00")
    self.bid64_isSignaling("0", "Infinity", "0", "00")
    self.bid64_isSignaling("0", "QNaN", "0", "00")
  }

  private func bid64_isSignaling(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isSignalingNaN
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isSigned() {
    self.bid64_isSigned("0", "0", "0", "00")
    self.bid64_isSigned("0", "[0000000000000000]", "0", "00")
    self.bid64_isSigned("0", "-0", "1", "00")
    self.bid64_isSigned("0", "[09ef000000000000]", "0", "00")
    self.bid64_isSigned("0", "[0e651dcf38049e2c]", "0", "00")
    self.bid64_isSigned("0", "[18f64159f3d889fe]", "0", "00")
    self.bid64_isSigned("0", "[57c0000000000000]", "0", "00")
    self.bid64_isSigned("0", "[8550e8a519089ef9]", "1", "00")
    self.bid64_isSigned("0", "[8fad471547a7465b]", "1", "00")
    self.bid64_isSigned("0", "[b2e180325c4db3a2]", "1", "00")
    self.bid64_isSigned("0", "[c0563045a9951137]", "1", "00")
    self.bid64_isSigned("0", "[c600000000000000]", "1", "00")
    self.bid64_isSigned("0", "[d5c48a1beee6bc7f]", "1", "00")
    self.bid64_isSigned("0", "Infinity", "0", "00")
    self.bid64_isSigned("0", "-Infinity", "1", "00")
    self.bid64_isSigned("0", "SNaN", "0", "00")
  }

  private func bid64_isSigned(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.sign
    self.assertSign(result, expected, file, line)
  }

  func test_bid64_isSubnormal() {
    self.bid64_isSubnormal("0", "-0", "0", "00")
    self.bid64_isSubnormal("0", "[0000000000000000]", "0", "00")
    self.bid64_isSubnormal("0", "[0000010000200040]", "1", "00")
    self.bid64_isSubnormal("0", "[01c306b99e03c3d7]", "0", "00")
    self.bid64_isSubnormal("0", "[0ababb959e64802b]", "0", "00")
    self.bid64_isSubnormal("0", "[480968bfcbd60383]", "0", "00")
    self.bid64_isSubnormal("0", "[59b702267f365f3e]", "0", "00")
    self.bid64_isSubnormal("0", "[6041008000280000]", "0", "00")
    self.bid64_isSubnormal("0", "[a9e07f5c486a9a54]", "0", "00")
    self.bid64_isSubnormal("0", "[c1b9fe97c57e987d]", "0", "00")
    self.bid64_isSubnormal("0", "[ceae0a0b6eb9fdfd]", "0", "00")
    self.bid64_isSubnormal("0", "[cfab61eda6d26c24]", "0", "00")
    self.bid64_isSubnormal("0", "[d609b99364c503d0]", "0", "00")
    self.bid64_isSubnormal("0", "[d612fd2145e1c711]", "0", "00")
    self.bid64_isSubnormal("0", "[de7b2a9a4ac39479]", "0", "00")
    self.bid64_isSubnormal("0", "[e33f4bdedd9ec7e9]", "0", "00")
    self.bid64_isSubnormal("0", "[f04a0d0a231ac1dc]", "0", "00")
    self.bid64_isSubnormal("0", "[fffffffffffffbff]", "0", "00")
    self.bid64_isSubnormal("0", "-Infinity", "0", "00")
    self.bid64_isSubnormal("0", "Infinity", "0", "00")
    self.bid64_isSubnormal("0", "QNaN", "0", "00")
    self.bid64_isSubnormal("0", "SNaN", "0", "00")
  }

  private func bid64_isSubnormal(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isSubnormal
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_isZero() {
    self.bid64_isZero("0", "[0040000000400100]", "0", "00")
    self.bid64_isZero("0", "-0", "1", "00")
    self.bid64_isZero("0", "0", "1", "00")
    self.bid64_isZero("0", "[24bc3644801d9a0b]", "0", "00")
    self.bid64_isZero("0", "[37da90406448ed2e]", "0", "00")
    self.bid64_isZero("0", "+5296735256349.E0", "0", "00")
    self.bid64_isZero("0", "[5d19e6a9d4638f11]", "0", "00")
    self.bid64_isZero("0", "[602386F26FC0FFFE]", "0", "00")
    self.bid64_isZero("0", "[602386f26fc0ffff]", "0", "00")
    self.bid64_isZero("0", "[602386f26fc10000]", "1", "00")
    self.bid64_isZero("0", "[602386f26fc1ffff]", "1", "00")
    self.bid64_isZero("0", "[6810002824290208]", "0", "00")
    self.bid64_isZero("0", "[81ffe75f5a52a8ff]", "0", "00")
    self.bid64_isZero("0", "[833dc51c3126fa2c]", "0", "00")
    self.bid64_isZero("0", "[930d09c739e98afe]", "0", "00")
    self.bid64_isZero("0", "[97eb0dbbc170e5b7]", "0", "00")
    self.bid64_isZero("0", "[a765d9338f33beea]", "0", "00")
    self.bid64_isZero("0", "[e3d27d04304a8332]", "0", "00")
    self.bid64_isZero("0", "[ee7b7a44bc674485]", "0", "00")
    self.bid64_isZero("0", "[ffffffffffffffff]", "0", "00")
    self.bid64_isZero("0", "-Infinity", "0", "00")
    self.bid64_isZero("0", "Infinity", "0", "00")
    self.bid64_isZero("0", "QNaN", "0", "00")
    self.bid64_isZero("0", "SNaN", "0", "00")
  }

  private func bid64_isZero(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isZero
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_abs() {
    self.bid128_abs("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_abs("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_abs("0", "-0", "[30400000000000000000000000000000]", "00")
    self.bid128_abs("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_abs("0", "[20491165061c532a,535089a5c8f9da39]", "[20491165061c532a535089a5c8f9da39]", "00")
    self.bid128_abs("0", "[21213a1853ae801d,a7a83cd1c3bfc8cb]", "[21213a1853ae801da7a83cd1c3bfc8cb]", "00")
    self.bid128_abs("0", "[3577621b973eb09d,7e1681d2fc2fd1a3]", "[3577621b973eb09d7e1681d2fc2fd1a3]", "00")
    self.bid128_abs("0", "[3d78000000000000,0000000000000000]", "[3d780000000000000000000000000000]", "00")
    self.bid128_abs("0", "[3f62000000000000,0000000000000000]", "[3f620000000000000000000000000000]", "00")
    self.bid128_abs("0", "[54f99570af8fbdf8,9052e356786395d7]", "[54f99570af8fbdf89052e356786395d7]", "00")
    self.bid128_abs("0", "[59170c2b2d753371,caddbeb2aa9e9d19]", "[59170c2b2d753371caddbeb2aa9e9d19]", "00")
    self.bid128_abs("0", "[7800000000000000,0000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_abs("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_abs("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "00")
    self.bid128_abs("0", "[812c000000000000,0000000000000000]", "[012c0000000000000000000000000000]", "00")
    self.bid128_abs("0", "[a050785cc4df5814,4acbb40b269da9e3]", "[2050785cc4df58144acbb40b269da9e3]", "00")
    self.bid128_abs("0", "[bc92000000000000,0000000000000000]", "[3c920000000000000000000000000000]", "00")
    self.bid128_abs("0", "-Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_abs("0", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_abs("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_abs("0", "SNaN", "[7e000000000000000000000000000000]", "00")
  }

  private func bid128_abs(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = arg0.magnitude
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid128_class() {
    self.bid128_class("0", "[0001ed09bead87c0378d8e62ffffffff]", "8", "00")
    self.bid128_class("0", "[0001ed09bead87c0378d8e64ffffffff]", "6", "00")
    self.bid128_class("0", "[0029314dc6448d9338c15b09ffffffff]", "8", "00")
    self.bid128_class("0", "[0029314dc6448d9338c15b0a00000000]", "8", "00")
    self.bid128_class("0", "[002a0000000000000000000000000000]", "6", "00")
    self.bid128_class("0", "[002a000000000000000009184E729FFF]", "8", "00")
    self.bid128_class("0", "[002a000000000000000009184E72A000]", "8", "00")
    self.bid128_class("0", "-0E-15", "5", "00")
    self.bid128_class("0", "0E-15", "6", "00")
    self.bid128_class("0", "-0E+368", "5", "00")
    self.bid128_class("0", "0E+368", "6", "00")
    self.bid128_class("0", "0E+6110", "6", "00")
    self.bid128_class("0", "-0E+6111", "5", "00")
    self.bid128_class("0", "-1.2345678901234568E-6160", "4", "00")
    self.bid128_class("0", "1.2345678901234568E-6160", "7", "00")
    self.bid128_class("0", "-1.234567890123456E+383", "3", "00")
    self.bid128_class("0", "1.234567890123456E+383", "8", "00")
    self.bid128_class("0", "1E+367", "8", "00")
    self.bid128_class("0", "-1E+368", "3", "00")
    self.bid128_class("0", "-1E+6109", "3", "00")
    self.bid128_class("0", "1E+6109", "8", "00")
    self.bid128_class("0", "-1E-6176", "4", "00")
    self.bid128_class("0", "1E-6176", "7", "00")
    self.bid128_class("0", "[60000000000000000000000000000000]", "6", "00")
    self.bid128_class("0", "[6003b75d7734cd9e1234567890123456]", "6", "00")
    self.bid128_class("0", "[69dbb75d7734cd9e1234567890123456]", "6", "00")
    self.bid128_class("0", "[78000000000000000000000000000000]", "9", "00")
    self.bid128_class("0", "[78000000000000000000000000000001]", "9", "00")
    self.bid128_class("0", "[7c000000000000000000000000000000]", "1", "00")
    self.bid128_class("0", "[7c000000000000000000000000000001]", "1", "00")
    self.bid128_class("0", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_class("0", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_class("0", "[7e000000000000000000000000000000]", "0", "00")
    self.bid128_class("0", "[7e000000000000000000000000000001]", "0", "00")
    self.bid128_class("0", "[e0000000000000000000000000000001]", "5", "00")
    self.bid128_class("0", "[e003b75d7734cd9e1234567890123456]", "5", "00")
    self.bid128_class("0", "[e9dbb75d7734cd9e1234567890123456]", "5", "00")
    self.bid128_class("0", "[f8000000000000000000000000000000]", "2", "00")
    self.bid128_class("0", "[fc000000000000000000000000000000]", "1", "00")
    self.bid128_class("0", "[fc000000000000000000000000000001]", "1", "00")
    self.bid128_class("0", "[fe000000000000000000000000000000]", "0", "00")
    self.bid128_class("0", "[fe000000000000000000000000000001]", "0", "00")
    self.bid128_class("0", "-Infinity", "2", "00")
    self.bid128_class("0", "Infinity", "9", "00")
    self.bid128_class("0", "[0040000000000000,0000000000000001]", "7", "00")
    self.bid128_class("0", "[0000314DC6448D93FFFFFFFFFFFFFFFF]", "8", "00")
    self.bid128_class("0", "[0000314DC6448D93ffffffff00000000]", "8", "00")
    self.bid128_class("0", "[002A000000000000FFFFFFFFFFFFFFFF]", "8", "00")
    self.bid128_class("0", "[0028000000000000FFFFFFFFFFFFFFFF]", "8", "00")
    self.bid128_class("0", "[002A000000000000000000E8D4A51000]", "8", "00")
    self.bid128_class("0", "[002A000000000000000000E8D4A51001]", "8", "00")
    self.bid128_class("0", "[002A000000000000000000E8D4A50FFF]", "7", "00")
    self.bid128_class("0", "[0000314DC6448D9338C15B0A00000001]", "8", "00")
    self.bid128_class("0", "[0000314DC6448D9338C15B0A00000000]", "8", "00")
    self.bid128_class("0", "[0000314DC6448D9338C15B09FFFFFFFF]", "7", "00")
    self.bid128_class("0", "[802A000000000000000000E8D4A51000]", "3", "00")
    self.bid128_class("0", "[802A000000000000000000E8D4A51001]", "3", "00")
    self.bid128_class("0", "[802A000000000000000000E8D4A50FFF]", "4", "00")
    self.bid128_class("0", "[8000314DC6448D9338C15B0A00000001]", "3", "00")
    self.bid128_class("0", "[8000314DC6448D9338C15B0A00000000]", "3", "00")
    self.bid128_class("0", "[8000314DC6448D9338C15B09FFFFFFFF]", "4", "00")
  }

  private func bid128_class(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.floatingPointClass
    self.assertFloatingPointClass(result, expected, file, line)
  }

  func test_bid128_isCanonical() {
    self.bid128_isCanonical("0", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_isCanonical("0", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_isCanonical("0", "-0", "1", "00")
    self.bid128_isCanonical("0", "0", "1", "00")
    self.bid128_isCanonical("0", "[171dc93a3a721a43,b58542fdde27b555]", "1", "00")
    self.bid128_isCanonical("0", "[23155fa1ce3b63e7,054decfe550b4e45]", "1", "00")
    self.bid128_isCanonical("0", "[3a2e024cc9d0b53e,05182193ee969dbd]", "1", "00")
    self.bid128_isCanonical("0", "[4089bca971360a7d,5aeff4e6bf411c39]", "1", "00")
    self.bid128_isCanonical("0", "[5dbb7d927efefd2f,f33f8f17fefffdff]", "1", "00")
    self.bid128_isCanonical("0", "[6085008102161490,ffdffeeff7ffbfff]", "0", "00")
    self.bid128_isCanonical("0", "[7c0013e87ada0359,835044d68d872147]", "1", "00")
    self.bid128_isCanonical("0", "[7c00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_isCanonical("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isCanonical("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isCanonical("0", "[816d4d6ec11d6302,5b6461da887f2291]", "1", "00")
    self.bid128_isCanonical("0", "[94ac069b0f87925b,e19b1e3d5736e4b3]", "1", "00")
    self.bid128_isCanonical("0", "[a1d3aac268268694,dcad90cc10d00253]", "1", "00")
    self.bid128_isCanonical("0", "[be362574fcd0f5ab,f3a57ff131f5cfdb]", "1", "00")
    self.bid128_isCanonical("0", "[c9816c991a0af8f1,270fa52aebd97dcc]", "1", "00")
    self.bid128_isCanonical("0", "[d8c92b6df1c41607,55a964589af7ae58]", "1", "00")
    self.bid128_isCanonical("0", "[f800000000000000,0000000000000000]", "1", "00")
    self.bid128_isCanonical("0", "[f800000001000000,0000000000000000]", "0", "00")
    self.bid128_isCanonical("0", "[f810000000000000,0000000000000000]", "0", "00")
    self.bid128_isCanonical("0", "[fa79d291c68723e9,bf36ffd4dbefc63f]", "0", "00")
    self.bid128_isCanonical("0", "[fe00381d0020a920,ff6f3fff9ff3cd7e]", "0", "00")
    self.bid128_isCanonical("0", "[ffffffffffffffff,1000000000000000]", "0", "00")
    self.bid128_isCanonical("0", "-Infinity", "1", "00")
    self.bid128_isCanonical("0", "Infinity", "1", "00")
    self.bid128_isCanonical("0", "QNaN", "1", "00")
    self.bid128_isCanonical("0", "SNaN", "1", "00")
  }

  private func bid128_isCanonical(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isCanonical
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isFinite() {
    self.bid128_isFinite("0", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_isFinite("0", "[0001ed09bead87c0378d8e64ffffffff]", "1", "00")
    self.bid128_isFinite("0", "-0", "1", "00")
    self.bid128_isFinite("0", "0", "1", "00")
    self.bid128_isFinite("0", "[069ebbde47cecaf6,46be7beaba7b59b2]", "1", "00")
    self.bid128_isFinite("0", "[0e3676b062a501d1,0b09be374b9584af]", "1", "00")
    self.bid128_isFinite("0", "[0e89a019d51dfb52,6d3d4f5cec95045e]", "1", "00")
    self.bid128_isFinite("0", "[2fc2e6f5db986999,e05bf17d978fe530]", "1", "00")
    self.bid128_isFinite("0", "[38f8c0be302ea603,57e8f20e5933296f]", "1", "00")
    self.bid128_isFinite("0", "+5296735256349.E0", "1", "00")
    self.bid128_isFinite("0", "[587840394b1e4028,1e9750988e309c82]", "1", "00")
    self.bid128_isFinite("0", "[7c0013fea80d776e,4da30049fb4205a6]", "0", "00")
    self.bid128_isFinite("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isFinite("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isFinite("0", "[a34647a87b5d409d,0b81a865d0b81418]", "1", "00")
    self.bid128_isFinite("0", "[b1a03c62cd15d1e3,984fecd726ec37f2]", "1", "00")
    self.bid128_isFinite("0", "[b1cc5b6aee8fe1c3,d7ba66922fd8e8d7]", "1", "00")
    self.bid128_isFinite("0", "[b596000000000000,0000000000000000]", "1", "00")
    self.bid128_isFinite("0", "-Infinity", "0", "00")
    self.bid128_isFinite("0", "Infinity", "0", "00")
    self.bid128_isFinite("0", "QNaN", "0", "00")
    self.bid128_isFinite("0", "SNaN", "0", "00")
  }

  private func bid128_isFinite(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isFinite
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isInf() {
    self.bid128_isInf("0", "-0", "0", "00")
    self.bid128_isInf("0", "0", "0", "00")
    self.bid128_isInf("0", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_isInf("0", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_isInf("0", "[0a57e401d7f2f4bf,1a0275159b396b2a]", "0", "00")
    self.bid128_isInf("0", "[3737d5460658b655,02508fbbc30ff543]", "0", "00")
    self.bid128_isInf("0", "[5902fa4ce8711964,0b0601200002a041]", "0", "00")
    self.bid128_isInf("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isInf("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isInf("0", "[8cd4ffbce0ecd8e2,7cba342f141e4231]", "0", "00")
    self.bid128_isInf("0", "[8dd84ed793886329,1f6560ffe1332f11]", "0", "00")
    self.bid128_isInf("0", "[935d9c0d11b20b30,9b8116fd41f5394f]", "0", "00")
    self.bid128_isInf("0", "[94bc000000000000,0000000000000000]", "0", "00")
    self.bid128_isInf("0", "[9b6e000000000000,0000000000000000]", "0", "00")
    self.bid128_isInf("0", "[a9a7b8e122afeacc,d57a83774becaedb]", "0", "00")
    self.bid128_isInf("0", "[b05fafc0064a7b31,37c23276a8be7ed3]", "0", "00")
    self.bid128_isInf("0", "[be42bd49b8cd1d75,9da62cb45a360a56]", "0", "00")
    self.bid128_isInf("0", "Infinity", "1", "00")
    self.bid128_isInf("0", "QNaN", "0", "00")
    self.bid128_isInf("0", "SNaN", "0", "00")
  }

  private func bid128_isInf(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isInfinite
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isNaN() {
    self.bid128_isNaN("0", "-0", "0", "00")
    self.bid128_isNaN("0", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_isNaN("0", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_isNaN("0", "[21e4000000000000,0000000000000000]", "0", "00")
    self.bid128_isNaN("0", "[2a21676f21ef0401,08e2139097e4f45c]", "0", "00")
    self.bid128_isNaN("0", "[4194000000000000,0000000000000000]", "0", "00")
    self.bid128_isNaN("0", "[7800000000000000,0000000000000000]", "0", "00")
    self.bid128_isNaN("0", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_isNaN("0", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_isNaN("0", "[80ed2b9d1a450027,32c4bfcbb8b15c1b]", "0", "00")
    self.bid128_isNaN("0", "[95165ea3a5f0caf6,6ba829819d59b6e2]", "0", "00")
    self.bid128_isNaN("0", "[b0a9c89c8400622c,4764c72807e8a958]", "0", "00")
    self.bid128_isNaN("0", "[cacbd04a2ef781fd,33f2c1bcab363a74]", "0", "00")
    self.bid128_isNaN("0", "[da34655b3c4627e7,f91a483887abf433]", "0", "00")
    self.bid128_isNaN("0", "-Infinity", "0", "00")
    self.bid128_isNaN("0", "Infinity", "0", "00")
    self.bid128_isNaN("0", "QNaN", "1", "00")
  }

  private func bid128_isNaN(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isNaN
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isNormal() {
    self.bid128_isNormal("0", "-0", "0", "00")
    self.bid128_isNormal("0", "0", "0", "00")
    self.bid128_isNormal("0", "[0000000000000000,0000000000000000]", "0", "00")
    self.bid128_isNormal("0", "[0000000000000000,ff7eff7efde9eb6f]", "0", "00")
    self.bid128_isNormal("0", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_isNormal("0", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_isNormal("0", "[0040000000000000,0010040010214040]", "1", "00")
    self.bid128_isNormal("0", "[03f4000000000000,0000000000000000]", "0", "00")
    self.bid128_isNormal("0", "[0978000000000000,0000000000000000]", "0", "00")
    self.bid128_isNormal("0", "[1a6a000000000000,0000000000000000]", "0", "00")
    self.bid128_isNormal("0", "[25d9f797bbcaf773,fffffddf7efcfff2]", "0", "00")
    self.bid128_isNormal("0", "[35ace066c705811c,32d5b5ac007a79e4]", "1", "00")
    self.bid128_isNormal("0", "[42ec000000000000,0000000000000000]", "0", "00")
    self.bid128_isNormal("0", "[49580caebdff5a96,16f246996cb5d380]", "1", "00")
    self.bid128_isNormal("0", "[4f2e07ed4464f530,f2b733c46e098dfa]", "1", "00")
    self.bid128_isNormal("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isNormal("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isNormal("0", "[818260b7152cc2d1,e918ef83f6aaf170]", "1", "00")
    self.bid128_isNormal("0", "[83c9ce9c16120142,5481842016081200]", "1", "00")
    self.bid128_isNormal("0", "[9d083f98b8a95884,16a840ca162eead0]", "1", "00")
    self.bid128_isNormal("0", "[9f777faa7f240d67,872dedfcdfe2fa8e]", "1", "00")
    self.bid128_isNormal("0", "[a9634862e4a48380,9e678b2e978fb31c]", "1", "00")
    self.bid128_isNormal("0", "[fffdffffffbffff7,fffbf7fcf7f5edf7]", "0", "00")
    self.bid128_isNormal("0", "-Infinity", "0", "00")
    self.bid128_isNormal("0", "Infinity", "0", "00")
    self.bid128_isNormal("0", "QNaN", "0", "00")
    self.bid128_isNormal("0", "SNaN", "0", "00")
  }

  private func bid128_isNormal(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isNormal
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isSignaling() {
    self.bid128_isSignaling("0", "-0", "0", "00")
    self.bid128_isSignaling("0", "0", "0", "00")
    self.bid128_isSignaling("0", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_isSignaling("0", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_isSignaling("0", "[041044f2703fe2d8,fd85989865ebe87b]", "0", "00")
    self.bid128_isSignaling("0", "[13aa000000000000,0000000000000000]", "0", "00")
    self.bid128_isSignaling("0", "[3664db3ee13f5c05,0db8edd219ca964c]", "0", "00")
    self.bid128_isSignaling("0", "[7c00061ccb0a291e,65f549f4dc5e31c4]", "0", "00")
    self.bid128_isSignaling("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isSignaling("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isSignaling("0", "[82b17468499ab719,19d2bb2c0fb23df0]", "0", "00")
    self.bid128_isSignaling("0", "[858a2ae1be255ac2,e5c96a599c35a1e2]", "0", "00")
    self.bid128_isSignaling("0", "[86d4c3261d14ad32,41fa2f426682032a]", "0", "00")
    self.bid128_isSignaling("0", "[a294a762989a4354,3e8759e80229fe58]", "0", "00")
    self.bid128_isSignaling("0", "[a3ea377d806481be,43653c96237e2c57]", "0", "00")
    self.bid128_isSignaling("0", "[fe00000000000000,0000000000000000]", "1", "00")
    self.bid128_isSignaling("0", "-Infinity", "0", "00")
    self.bid128_isSignaling("0", "Infinity", "0", "00")
    self.bid128_isSignaling("0", "SNaN", "1", "00")
  }

  private func bid128_isSignaling(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isSignalingNaN
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isSigned() {
    self.bid128_isSigned("0", "0", "0", "00")
    self.bid128_isSigned("0", "[0d1b4a11dd2b2c2d,4d69c430aae5a351]", "0", "00")
    self.bid128_isSigned("0", "[1010080201c40408,0200000808020000]", "0", "00")
    self.bid128_isSigned("0", "[1da7727000019412,043034285964b3e5]", "0", "00")
    self.bid128_isSigned("0", "[291faf7540e31c98,a37ad09f66370b5c]", "0", "00")
    self.bid128_isSigned("0", "[32ed04cf2a6dd797,3b5689f82fd08e7b]", "0", "00")
    self.bid128_isSigned("0", "[4f33bb3daf404b48,2895c9fcdd30262f]", "0", "00")
    self.bid128_isSigned("0", "[5bd983e54f226f4e,447f2d30f6d2853d]", "0", "00")
    self.bid128_isSigned("0", "[5d037a9f76ec79f3,169e495eb8705c03]", "0", "00")
    self.bid128_isSigned("0", "[7800000000000000,0000000000000000]", "0", "00")
    self.bid128_isSigned("0", "[d4aa000000000000,0000000000000000]", "1", "00")
    self.bid128_isSigned("0", "[dabc266156593af8,4fd97dc923bc7064]", "1", "00")
    self.bid128_isSigned("0", "Infinity", "0", "00")
    self.bid128_isSigned("0", "-Infinity", "1", "00")
    self.bid128_isSigned("0", "QNaN", "0", "00")
  }

  private func bid128_isSigned(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.sign
    self.assertSign(result, expected, file, line)
  }

  func test_bid128_isSubnormal() {
    self.bid128_isSubnormal("0", "-0", "0", "00")
    self.bid128_isSubnormal("0", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_isSubnormal("0", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_isSubnormal("0", "[0002000000000000,07a63158fbd6b32f]", "1", "00")
    self.bid128_isSubnormal("0", "[0008000000000000,0002000000000000]", "1", "00")
    self.bid128_isSubnormal("0", "[001020104460001d,09012838901080cd]", "0", "00")
    self.bid128_isSubnormal("0", "[0820000000000000,0000000000000000]", "0", "00")
    self.bid128_isSubnormal("0", "[1b0b59df37c84a5a,5ca7168a8feedcb1]", "0", "00")
    self.bid128_isSubnormal("0", "[1b4cc22b9c3e09bd,8a09c2efa4609a41]", "0", "00")
    self.bid128_isSubnormal("0", "[238f2cfa1d644f69,5cf1e547007227bd]", "0", "00")
    self.bid128_isSubnormal("0", "[247e394a27efd967,381010001400081c]", "0", "00")
    self.bid128_isSubnormal("0", "[264a000000000000,0000000000000000]", "0", "00")
    self.bid128_isSubnormal("0", "[402afbe261e6cd8a,65a1629af55f94be]", "0", "00")
    self.bid128_isSubnormal("0", "[4636000000000000,0000000000000000]", "0", "00")
    self.bid128_isSubnormal("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isSubnormal("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isSubnormal("0", "[8000001400000004,ffffffffffffffef]", "1", "00")
    self.bid128_isSubnormal("0", "[92a9700a58e271c4,5f52b6c080f12c07]", "0", "00")
    self.bid128_isSubnormal("0", "[a83e000000000000,0000000000000000]", "0", "00")
    self.bid128_isSubnormal("0", "[befbefbfaf5bdfdd,addfe727ecde7d3b]", "0", "00")
    self.bid128_isSubnormal("0", "[d754ce3bc22f555f,79c8815335535001]", "0", "00")
    self.bid128_isSubnormal("0", "[d900000000000000,0000000000000000]", "0", "00")
    self.bid128_isSubnormal("0", "[fdfdf7ff7ffdf7bf,ffffefffffffffaf]", "0", "00")
    self.bid128_isSubnormal("0", "-Infinity", "0", "00")
    self.bid128_isSubnormal("0", "Infinity", "0", "00")
    self.bid128_isSubnormal("0", "QNaN", "0", "00")
    self.bid128_isSubnormal("0", "SNaN", "0", "00")
  }

  private func bid128_isSubnormal(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isSubnormal
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_isZero() {
    self.bid128_isZero("0", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_isZero("0", "[0001ed09bead87c0378d8e64ffffffff]", "1", "00")
    self.bid128_isZero("0", "-0", "1", "00")
    self.bid128_isZero("0", "0", "1", "00")
    self.bid128_isZero("0", "[0ee8000000000000,0000000000000000]", "1", "00")
    self.bid128_isZero("0", "[13ee9ca2e80fd3a8,07c0d8414c535392]", "0", "00")
    self.bid128_isZero("0", "[31de9b1749a9038c,04b0b67e429838c2]", "0", "00")
    self.bid128_isZero("0", "[3b6ffefffd79ddfd,3304651402b7cb82]", "1", "00")
    self.bid128_isZero("0", "[789b88be70d10384,ffffffffffffffff]", "0", "00")
    self.bid128_isZero("0", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_isZero("0", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_isZero("0", "[7e0028d5f55d1b90,cd0683a16d4f6440]", "0", "00")
    self.bid128_isZero("0", "[892747418097592c,11a5167c09ca2055]", "0", "00")
    self.bid128_isZero("0", "[8aa0c8dafc695d02,42fb6071b7550296]", "0", "00")
    self.bid128_isZero("0", "[9ee35adc537f2993,21571042d581776a]", "0", "00")
    self.bid128_isZero("0", "[af52000000000000,0000000000000000]", "1", "00")
    self.bid128_isZero("0", "[b37ef809e2d1f6a6,2badece51a0eddd9]", "0", "00")
    self.bid128_isZero("0", "[b8249c80a0002a5e,9fc635c5912fb958]", "0", "00")
    self.bid128_isZero("0", "[d8e96a50ff859c40,1b0d91d7b39d89c8]", "0", "00")
    self.bid128_isZero("0", "-Infinity", "0", "00")
    self.bid128_isZero("0", "Infinity", "0", "00")
    self.bid128_isZero("0", "QNaN", "0", "00")
    self.bid128_isZero("0", "SNaN", "0", "00")
  }

  private func bid128_isZero(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.isZero
    self.assertBool(result, expected, file, line)
  }
}
