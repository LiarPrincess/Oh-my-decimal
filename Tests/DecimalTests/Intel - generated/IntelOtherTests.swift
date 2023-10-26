// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelOtherTests: XCTestCase, IntelMixin {

  func test_bid32_copy() {
    self.bid32_copy("0", "[00000001]", "[00000001]", "00")
    self.bid32_copy("0", "[00080001]", "[00080001]", "00")
    self.bid32_copy("0", "1.0", "[3200000a]", "00")
    self.bid32_copy("0", "-1.0", "[b200000a]", "00")
    self.bid32_copy("0", "1.0e-96", "[0200000a]", "00")
    self.bid32_copy("0", "-1.0e-96", "[8200000a]", "00")
    self.bid32_copy("0", "[6098967f]", "[6098967f]", "00")
    self.bid32_copy("0", "[60989680]", "[60989680]", "00")
    self.bid32_copy("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_copy("0", "[7c8f423f]", "[7c8f423f]", "00")
    self.bid32_copy("0", "[7c8f4240]", "[7c8f4240]", "00")
    self.bid32_copy("0", "[7e100000]", "[7e100000]", "00")
    self.bid32_copy("0", "[7e100100]", "[7e100100]", "00")
    self.bid32_copy("0", "[7e8f423f]", "[7e8f423f]", "00")
    self.bid32_copy("0", "[7e8f4240]", "[7e8f4240]", "00")
    self.bid32_copy("0", "[80000001]", "[80000001]", "00")
    self.bid32_copy("0", "9.999999e-95", "[6018967f]", "00")
    self.bid32_copy("0", "-9.999999e-95", "[e018967f]", "00")
    self.bid32_copy("0", "9.999999e96", "[77f8967f]", "00")
    self.bid32_copy("0", "-9.999999e96", "[f7f8967f]", "00")
    self.bid32_copy("0", "[fc100000]", "[fc100000]", "00")
    self.bid32_copy("0", "[fc100100]", "[fc100100]", "00")
    self.bid32_copy("0", "[fe000000]", "[fe000000]", "00")
  }

  private func bid32_copy(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }

    let result = arg0
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid32_copySign() {
    self.bid32_copySign("0", "[00000001]", "1.0", "[00000001]", "00")
    self.bid32_copySign("0", "[00080001]", "1.0", "[00080001]", "00")
    self.bid32_copySign("0", "1.0", "[00000001]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[00080001]", "[3200000a]", "00")
    self.bid32_copySign("0", "-1.0", "1.0", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "1.0", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "-1.0", "[b200000a]", "00")
    self.bid32_copySign("0", "1.0", "1.0e-96", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "-1.0e-96", "[b200000a]", "00")
    self.bid32_copySign("0", "1.0", "[6098967f]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[60989680]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7c000000]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7c8f423f]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7c8f4240]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7e100000]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7e100100]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7e8f423f]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[7e8f4240]", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "[80000001]", "[b200000a]", "00")
    self.bid32_copySign("0", "1.0", "9.999999e-95", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "-9.999999e-95", "[b200000a]", "00")
    self.bid32_copySign("0", "1.0", "9.999999e96", "[3200000a]", "00")
    self.bid32_copySign("0", "1.0", "-9.999999e96", "[b200000a]", "00")
    self.bid32_copySign("0", "-1.0e-96", "1.0", "[0200000a]", "00")
    self.bid32_copySign("0", "1.0e-96", "1.0", "[0200000a]", "00")
    self.bid32_copySign("0", "1.0", "[fc100000]", "[b200000a]", "00")
    self.bid32_copySign("0", "1.0", "[fc100100]", "[b200000a]", "00")
    self.bid32_copySign("0", "1.0", "[fe000000]", "[b200000a]", "00")
    self.bid32_copySign("0", "[6098967f]", "1.0", "[6098967f]", "00")
    self.bid32_copySign("0", "[60989680]", "1.0", "[60989680]", "00")
    self.bid32_copySign("0", "[7c000000]", "1.0", "[7c000000]", "00")
    self.bid32_copySign("0", "[7c8f423f]", "1.0", "[7c8f423f]", "00")
    self.bid32_copySign("0", "[7c8f423f]", "[7e100000]", "[7c8f423f]", "00")
    self.bid32_copySign("0", "[7c8f423f]", "Infinity", "[7c8f423f]", "00")
    self.bid32_copySign("0", "[7c8f4240]", "1.0", "[7c8f4240]", "00")
    self.bid32_copySign("0", "[7e100000]", "1.0", "[7e100000]", "00")
    self.bid32_copySign("0", "[7e100100]", "1.0", "[7e100100]", "00")
    self.bid32_copySign("0", "[7e8f423f]", "1.0", "[7e8f423f]", "00")
    self.bid32_copySign("0", "[7e8f4240]", "1.0", "[7e8f4240]", "00")
    self.bid32_copySign("0", "[80000001]", "1.0", "[00000001]", "00")
    self.bid32_copySign("0", "-9.999999e-95", "1.0", "[6018967f]", "00")
    self.bid32_copySign("0", "9.999999e-95", "1.0", "[6018967f]", "00")
    self.bid32_copySign("0", "-9.999999e96", "1.0", "[77f8967f]", "00")
    self.bid32_copySign("0", "9.999999e96", "1.0", "[77f8967f]", "00")
    self.bid32_copySign("0", "[fc100000]", "1.0", "[7c100000]", "00")
    self.bid32_copySign("0", "[fc100100]", "1.0", "[7c100100]", "00")
    self.bid32_copySign("0", "[fe000000]", "1.0", "[7e000000]", "00")
    self.bid32_copySign("0", "Infinity", "NaN", "[78000000]", "00")
  }

  private func bid32_copySign(
    _ _rounding: String,
    _ _arg0: String,
    _ _arg1: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let arg1 = self.parseDecimal32(_arg1, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }

    let result = Decimal32(signOf: arg1, magnitudeOf: arg0)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid32_inf() {
    self.bid32_inf("0", "0", "[78000000]", "00")
  }

  private func bid32_inf(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseInt32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    // Dummy use for 'arg0, rounding, status', so that the compiler does not complain.
    _ = (arg0, rounding)
    // Dummy assign 'status', so that the compiler does not complain.
    status = DecimalStatus()

    let result = Decimal32.infinity
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_nan() {
    self.bid32_nan("0", "0", "[7c000000]", "00")
    self.bid32_nan("0", "1", "[7c000001]", "00")
    self.bid32_nan("0", "NULL", "[7c000000]", "00")
  }

  private func bid32_nan(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }

    let payload = arg0.bid & Decimal32.nanPayloadMask
    let result = Decimal32(nan: payload, signaling: false)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid32_radix() {
    self.bid32_radix("0", "[00000000]", "10", "00")
    self.bid32_radix("0", "1.0", "10", "00")
  }

  private func bid32_radix(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    // Dummy use for 'arg0', so that the compiler does not complain.
    _ = arg0

    let result = Decimal32.radix
    self.assertInt(result, Int(expected), file, line)
  }

  func test_bid64_copy() {
    self.bid64_copy("0", "0", "[31c0000000000000]", "00")
    self.bid64_copy("0", "-0", "[b1c0000000000000]", "00")
    self.bid64_copy("0", "[0b3b000000000000]", "[0b3b000000000000]", "00")
    self.bid64_copy("0", "[1bf1eb878bd92f90]", "[1bf1eb878bd92f90]", "00")
    self.bid64_copy("0", "[2ebc30b0f5d6db60]", "[2ebc30b0f5d6db60]", "00")
    self.bid64_copy("0", "[39924d7d31b3d9af]", "[39924d7d31b3d9af]", "00")
    self.bid64_copy("0", "[56a6a32dd0a507da]", "[56a6a32dd0a507da]", "00")
    self.bid64_copy("0", "[91a5e22e38f2f4eb]", "[91a5e22e38f2f4eb]", "00")
    self.bid64_copy("0", "[995a75bdbe299504]", "[995a75bdbe299504]", "00")
    self.bid64_copy("0", "[9a60000000000000]", "[9a60000000000000]", "00")
    self.bid64_copy("0", "[9d410f21af28e834]", "[9d410f21af28e834]", "00")
    self.bid64_copy("0", "[bebab2a41b98f61a]", "[bebab2a41b98f61a]", "00")
    self.bid64_copy("0", "[e118d2eb2d0c4469]", "[e118d2eb2d0c4469]", "00")
    self.bid64_copy("0", "Infinity", "[7800000000000000]", "00")
    self.bid64_copy("0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_copy("0", "SNaN", "[7e00000000000000]", "00")
  }

  private func bid64_copy(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = arg0
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid64_copySign() {
    self.bid64_copySign("0", "[0520000000000000]", "[1b127dee53a469e7]", "[0520000000000000]", "00")
    self.bid64_copySign("0", "-0", "QNaN", "[31c0000000000000]", "00")
    self.bid64_copySign("0", "0", "QNaN", "[31c0000000000000]", "00")
    self.bid64_copySign("0", "[2299f520e7149a87]", "[373c94e68d2e26db]", "[2299f520e7149a87]", "00")
    self.bid64_copySign("0", "[23a8cd8f9e2eac0c]", "[0774b2d5ad18740f]", "[23a8cd8f9e2eac0c]", "00")
    self.bid64_copySign("0", "[4def6a1c2cfef4d2]", "[db9829abdc4561c6]", "[cdef6a1c2cfef4d2]", "00")
    self.bid64_copySign("0", "[5b8cc119deccf705]", "[a3c0000000000000]", "[db8cc119deccf705]", "00")
    self.bid64_copySign("0", "[5ca6fcf6e6e84a72]", "[60c99559452e440e]", "[5ca6fcf6e6e84a72]", "00")
    self.bid64_copySign("0", "[5fdf3f7ff7bfea7e]", "[00211954a0720132]", "[5fdf3f7ff7bfea7e]", "00")
    self.bid64_copySign("0", "[8fbca9a831fcc222]", "[114fcafa66dfc639]", "[0fbca9a831fcc222]", "00")
    self.bid64_copySign("0", "[9b591709bbde6727]", "[a0b602281de43389]", "[9b591709bbde6727]", "00")
    self.bid64_copySign("0", "[a54ec523c670fa31]", "[05fe0fd2309b9c45]", "[254ec523c670fa31]", "00")
    self.bid64_copySign("0", "[e0e370966e25bd0d]", "[0da875a1d84f564d]", "[60e370966e25bd0d]", "00")
    self.bid64_copySign("0", "Infinity", "QNaN", "[7800000000000000]", "00")
    self.bid64_copySign("0", "QNaN", "-0", "[fc00000000000000]", "00")
    self.bid64_copySign("0", "QNaN", "Infinity", "[7c00000000000000]", "00")
    self.bid64_copySign("0", "QNaN", "-Infinity", "[fc00000000000000]", "00")
    self.bid64_copySign("0", "SNaN", "-0", "[fe00000000000000]", "00")
    self.bid64_copySign("0", "SNaN", "SNaN", "[7e00000000000000]", "00")
  }

  private func bid64_copySign(
    _ _rounding: String,
    _ _arg0: String,
    _ _arg1: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let arg1 = self.parseDecimal64(_arg1, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = Decimal64(signOf: arg1, magnitudeOf: arg0)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid64_inf() {
    self.bid64_inf("0", "0", "[7800000000000000]", "00")
  }

  private func bid64_inf(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseInt32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    // Dummy use for 'arg0, rounding, status', so that the compiler does not complain.
    _ = (arg0, rounding)
    // Dummy assign 'status', so that the compiler does not complain.
    status = DecimalStatus()

    let result = Decimal64.infinity
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_nan() {
    self.bid64_nan("0", "0", "[7c00000000000000]", "00")
    self.bid64_nan("0", "1", "[7c00000000000001]", "00")
    self.bid64_nan("0", "NULL", "[7c00000000000000]", "00")
  }

  private func bid64_nan(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let payload = arg0.bid & Decimal64.nanPayloadMask
    let result = Decimal64(nan: payload, signaling: false)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid64_radix() {
    self.bid64_radix("0", "[0000000000000000]", "10", "00")
    self.bid64_radix("0", "1.0", "10", "00")
  }

  private func bid64_radix(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    // Dummy use for 'arg0', so that the compiler does not complain.
    _ = arg0

    let result = Decimal64.radix
    self.assertInt(result, Int(expected), file, line)
  }

  func test_bid128_copy() {
    self.bid128_copy("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_copy("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_copy("0", "0", "[30400000000000000000000000000000]", "00")
    self.bid128_copy("0", "[0ab55d45ba5c2626,b47ddbc6aa021c95]", "[0ab55d45ba5c2626b47ddbc6aa021c95]", "00")
    self.bid128_copy("0", "-0", "[b0400000000000000000000000000000]", "00")
    self.bid128_copy("0", "[29443c736a0efa8b,a221e17adf1c9fc9]", "[29443c736a0efa8ba221e17adf1c9fc9]", "00")
    self.bid128_copy("0", "[4794000000000000,0000000000000000]", "[47940000000000000000000000000000]", "00")
    self.bid128_copy("0", "[7c0009caa3e842ab,b29f72dd820c15dc]", "[7c0009caa3e842abb29f72dd820c15dc]", "00")
    self.bid128_copy("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_copy("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "00")
    self.bid128_copy("0", "[88e252f2cc9f2c3f,6e07569844058777]", "[88e252f2cc9f2c3f6e07569844058777]", "00")
    self.bid128_copy("0", "[93a0000000000000,0000000000000000]", "[93a00000000000000000000000000000]", "00")
    self.bid128_copy("0", "[93cfd2202869ccd5,379d5f0716254290]", "[93cfd2202869ccd5379d5f0716254290]", "00")
    self.bid128_copy("0", "[ac891470e69092a1,6c8bb59894765b3d]", "[ac891470e69092a16c8bb59894765b3d]", "00")
    self.bid128_copy("0", "[cb5a000000000000,0000000000000000]", "[cb5a0000000000000000000000000000]", "00")
    self.bid128_copy("0", "[d3bb2e1467023578,a75d9f49ed048a17]", "[d3bb2e1467023578a75d9f49ed048a17]", "00")
    self.bid128_copy("0", "[fde7bf7f3dfbafd8,ffffbefbfff7fffe]", "[fde7bf7f3dfbafd8ffffbefbfff7fffe]", "00")
    self.bid128_copy("0", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_copy("0", "-Infinity", "[f8000000000000000000000000000000]", "00")
    self.bid128_copy("0", "SNaN", "[7e000000000000000000000000000000]", "00")
  }

  private func bid128_copy(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = arg0
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid128_copySign() {
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_copySign("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_copySign("0", "-0", "-0", "[b0400000000000000000000000000000]", "00")
    self.bid128_copySign("0", "-0", "-Infinity", "[b0400000000000000000000000000000]", "00")
    self.bid128_copySign("0", "[190c000000000000,0000000000000000]", "[b4ee000000000000,0000000000000000]", "[990c0000000000000000000000000000]", "00")
    self.bid128_copySign("0", "[24e465fbb1822777,803774e51267ccf2]", "[0662000000000000,0000000000000000]", "[24e465fbb1822777803774e51267ccf2]", "00")
    self.bid128_copySign("0", "[2e88000000000000,0000000000000000]", "[8dbfdda66712e3e7,fd5ff95b33eeb55c]", "[ae880000000000000000000000000000]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "00")
    self.bid128_copySign("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "00")
    self.bid128_copySign("0", "[885a000000000000,0000000000000000]", "[55c2000000000000,0000000000000000]", "[085a0000000000000000000000000000]", "00")
    self.bid128_copySign("0", "[8c78cd86d1408bbf,9c58c58d5f149b91]", "[5f58000000000000,0000000000000000]", "[0c78cd86d1408bbf9c58c58d5f149b91]", "00")
    self.bid128_copySign("0", "[b7eaa93ab4ec09af,34c13cdee30f13a9]", "[29efeb164e8e506f,4f310fb5b0c9f682]", "[37eaa93ab4ec09af34c13cdee30f13a9]", "00")
    self.bid128_copySign("0", "[bfcf3787f5c05b56,d1475745c9d0a484]", "[bcb7ddb5c38dac85,9dd421ddbc349c64]", "[bfcf3787f5c05b56d1475745c9d0a484]", "00")
    self.bid128_copySign("0", "[c92c000000000000,0000000000000000]", "[c64f7d71753ab941,57aac934ceffcb9e]", "[c92c0000000000000000000000000000]", "00")
    self.bid128_copySign("0", "[cf1cf4acfdffb59c,d1931d42e614aba5]", "[c17d0dc7cab49359,4e57a66491e7955e]", "[cf1cf4acfdffb59cd1931d42e614aba5]", "00")
    self.bid128_copySign("0", "[d2e4000000000000,0000000000000000]", "[4780757d59815b86,f86c2ca4c77a9fd7]", "[52e40000000000000000000000000000]", "00")
    self.bid128_copySign("0", "[f69a5c09a7fbd669,b109e139b2b3490f]", "[7ceafd3f733f8d07,4820a5f60c181a30]", "[769a5c09a7fbd669b109e139b2b3490f]", "00")
    self.bid128_copySign("0", "-Infinity", "0", "[78000000000000000000000000000000]", "00")
    self.bid128_copySign("0", "Infinity", "0", "[78000000000000000000000000000000]", "00")
    self.bid128_copySign("0", "-Infinity", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_copySign("0", "-Infinity", "QNaN", "[78000000000000000000000000000000]", "00")
    self.bid128_copySign("0", "Infinity", "QNaN", "[78000000000000000000000000000000]", "00")
    self.bid128_copySign("0", "QNaN", "SNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_copySign("0", "SNaN", "-Infinity", "[fe000000000000000000000000000000]", "00")
  }

  private func bid128_copySign(
    _ _rounding: String,
    _ _arg0: String,
    _ _arg1: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let arg1 = self.parseDecimal128(_arg1, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = Decimal128(signOf: arg1, magnitudeOf: arg0)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid128_inf() {
    self.bid128_inf("0", "0", "[78000000000000000000000000000000]", "00")
  }

  private func bid128_inf(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseInt32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    // Dummy use for 'arg0, rounding, status', so that the compiler does not complain.
    _ = (arg0, rounding)
    // Dummy assign 'status', so that the compiler does not complain.
    status = DecimalStatus()

    let result = Decimal128.infinity
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_nan() {
    self.bid128_nan("0", "0", "[7c000000000000000000000000000000]", "00")
    self.bid128_nan("0", "1", "[7c000000000000000000000000000001]", "00")
    self.bid128_nan("0", "NULL", "[7c000000000000000000000000000000]", "00")
  }

  private func bid128_nan(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let payload = arg0.bid & Decimal128.nanPayloadMask
    let result = Decimal128(nan: payload, signaling: false)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid128_radix() {
    self.bid128_radix("0", "1.0", "10", "00")
    self.bid128_radix("0", "[7c000000000000000000000000000000]", "10", "00")
  }

  private func bid128_radix(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    // Dummy use for 'arg0', so that the compiler does not complain.
    _ = arg0

    let result = Decimal128.radix
    self.assertInt(result, Int(expected), file, line)
  }
}
