// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelToStringTests: XCTestCase, IntelMixin {

  func test_bid32_to_string() {
    self.bid32_to_string("0", "[0200000a]", "+1.0e-96", "00")
    self.bid32_to_string("0", "[3200000a]", "+1.0", "00")
    self.bid32_to_string("0", "[6018967f]", "+9.999999e-95", "00")
    self.bid32_to_string("0", "[77f8967f]", "+9.999999e96", "00")
    self.bid32_to_string("0", "[78000000]", "+Inf", "00")
    self.bid32_to_string("0", "[78000200]", "+Inf", "00")
    self.bid32_to_string("0", "[7c000000]", "+NaN", "00")
    self.bid32_to_string("0", "[7c000200]", "+NaN", "00")
    self.bid32_to_string("0", "[7e000000]", "+SNaN", "00")
    self.bid32_to_string("0", "[7e000200]", "+SNaN", "00")
    self.bid32_to_string("0", "[8200000a]", "-1.0e-96", "00")
    self.bid32_to_string("0", "[b200000a]", "-1.0", "00")
    self.bid32_to_string("0", "[e018967f]", "-9.999999e-95", "00")
    self.bid32_to_string("0", "[f7f8967f]", "-9.999999e96", "00")
    self.bid32_to_string("0", "[f8000000]", "-Inf", "00")
    self.bid32_to_string("0", "[f8fff000]", "-Inf", "00")
    self.bid32_to_string("0", "[fc000000]", "-NaN", "00")
    self.bid32_to_string("0", "[fcfff000]", "-NaN", "00")
    self.bid32_to_string("0", "[fe000000]", "-SNaN", "00")
    self.bid32_to_string("0", "[fefff000]", "-SNaN", "00")
  }

  private func bid32_to_string(
    _ _rounding: String,
    _ _arg0: String,
    _ expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    // Dummy assign 'status', so that the compiler does not complain.
    status = DecimalStatus()

    let result = String(arg0)
    let resultIntel = self.toIntel_toString(arg0, result: result)
    self.assertToString(Decimal32.self, resultIntel, expected, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_to_string() {
    self.bid64_to_string("0", "[31c0000000000037]", "+55E+0", "00")
    self.bid64_to_string("0", "[64ff55cb7bb8be2b]", "+0E-239", "00")
    self.bid64_to_string("0", "[69dbb75d7734cd9e]", "+0E-83", "00")
    self.bid64_to_string("0", "[6ddd5f2bc961d9c6]", "+0E+45", "00")
    self.bid64_to_string("0", "[7933324ba39af65d]", "+Inf", "00")
    self.bid64_to_string("0", "[7c03ffffffffffff]", "+NaN", "00")
    self.bid64_to_string("0", "[7e00000000000000]", "+SNaN", "00")
    self.bid64_to_string("0", "[be20000000000014]", "-20E+99", "00")
    self.bid64_to_string("0", "[ff9ef506fff9e3bf]", "-SNaN", "00")
    self.bid64_to_string("0", "[ffdbb3ffaefefdff]", "-SNaN", "00")
    self.bid64_to_string("3", "[f8f0000000000001]", "-Inf", "00")
    self.bid64_to_string("3", "[fcf0000000000000]", "-NaN", "00")
  }

  private func bid64_to_string(
    _ _rounding: String,
    _ _arg0: String,
    _ expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    // Dummy assign 'status', so that the compiler does not complain.
    status = DecimalStatus()

    let result = String(arg0)
    let resultIntel = self.toIntel_toString(arg0, result: result)
    self.assertToString(Decimal64.self, resultIntel, expected, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_to_string() {
    self.bid128_to_string("0", "[0001ed09bead87c0378d8e62ffffffff]", "+9999999999999999999999995705032703E-6176", "00")
    self.bid128_to_string("0", "[0001ed09bead87c0378d8e64ffffffff]", "+0E-6176", "00")
    self.bid128_to_string("0", "[30400000000000000000000000000010]", "+16E+0", "00")
    self.bid128_to_string("0", "[60000000000000000000000000000000]", "+0E-6176", "00")
    self.bid128_to_string("0", "[69dbb75d7734cd9e1234567890123456]", "+0E-1129", "00")
    self.bid128_to_string("0", "[79003fffffffffff38c15b08ffffffff]", "+Inf", "00")
    self.bid128_to_string("0", "[79100000000000000000000000000000]", "+Inf", "00")
    self.bid128_to_string("0", "[7c003fffffffffff38c15b08ffffffff]", "+NaN", "00")
    self.bid128_to_string("0", "[7c003fffffffffff38c15b0affffffff]", "+NaN", "00")
    self.bid128_to_string("0", "[7e000000000000000000000000000000]", "+SNaN", "00")
    self.bid128_to_string("0", "[7eff3fffffffffffffffffffffffffff]", "+SNaN", "00")
    self.bid128_to_string("0", "[b0fa0000000000000000000001312d00]", "-20000000E+93", "00")
    self.bid128_to_string("0", "[e0000000000000000000000000000001]", "-0E-6176", "00")
    self.bid128_to_string("0", "[f9003fffffffffff38c15b08ffffffff]", "-Inf", "00")
    self.bid128_to_string("1", "[0001ed09bead87c0378d8e62ffffffff]", "+9999999999999999999999995705032703E-6176", "00")
    self.bid128_to_string("1", "[0001ed09bead87c0378d8e64ffffffff]", "+0E-6176", "00")
    self.bid128_to_string("1", "[7c003fffffffffff38c15b08ffffffff]", "+NaN", "00")
    self.bid128_to_string("1", "[7c003fffffffffff38c15b0affffffff]", "+NaN", "00")
    self.bid128_to_string("2", "[0001ed09bead87c0378d8e62ffffffff]", "+9999999999999999999999995705032703E-6176", "00")
    self.bid128_to_string("2", "[0001ed09bead87c0378d8e64ffffffff]", "+0E-6176", "00")
    self.bid128_to_string("2", "[7c003fffffffffff38c15b08ffffffff]", "+NaN", "00")
    self.bid128_to_string("2", "[7c003fffffffffff38c15b0affffffff]", "+NaN", "00")
    self.bid128_to_string("3", "[0001ed09bead87c0378d8e62ffffffff]", "+9999999999999999999999995705032703E-6176", "00")
    self.bid128_to_string("3", "[0001ed09bead87c0378d8e64ffffffff]", "+0E-6176", "00")
    self.bid128_to_string("3", "[7c003fffffffffff38c15b08ffffffff]", "+NaN", "00")
    self.bid128_to_string("3", "[7c003fffffffffff38c15b0affffffff]", "+NaN", "00")
    self.bid128_to_string("3", "[fe003fffffffffffffffffffffffffff]", "-SNaN", "00")
    self.bid128_to_string("4", "[0001ed09bead87c0378d8e62ffffffff]", "+9999999999999999999999995705032703E-6176", "00")
    self.bid128_to_string("4", "[0001ed09bead87c0378d8e64ffffffff]", "+0E-6176", "00")
    self.bid128_to_string("4", "[7c003fffffffffff38c15b08ffffffff]", "+NaN", "00")
    self.bid128_to_string("4", "[7c003fffffffffff38c15b0affffffff]", "+NaN", "00")
  }

  private func bid128_to_string(
    _ _rounding: String,
    _ _arg0: String,
    _ expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    // Dummy assign 'status', so that the compiler does not complain.
    status = DecimalStatus()

    let result = String(arg0)
    let resultIntel = self.toIntel_toString(arg0, result: result)
    self.assertToString(Decimal128.self, resultIntel, expected, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }
}
