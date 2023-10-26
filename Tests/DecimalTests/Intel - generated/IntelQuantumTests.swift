// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelQuantumTests: XCTestCase, IntelMixin {

  func test_bid32_quantize() {
    self.bid32_quantize("0", "[00000001]", "1.0", "[32000000]", "20")
    self.bid32_quantize("0", "[00080001]", "1.0", "[32000000]", "20")
    self.bid32_quantize("0", "0.05", "1.0", "[32000000]", "20")
    self.bid32_quantize("0", "1.0", "[00000001]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "[00080001]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "-1.0", "[3200000a]", "00")
    self.bid32_quantize("0", "1.0", "1.0", "[3200000a]", "00")
    self.bid32_quantize("0", "-1.0", "1.0", "[b200000a]", "00")
    self.bid32_quantize("0", "1.0", "-1.0e-96", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "1.0e-96", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "[6098967f]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "[60989680]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "[7c000000]", "[7c000000]", "00")
    self.bid32_quantize("0", "1.0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_quantize("0", "1.0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_quantize("0", "1.0", "[7e100000]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "[7e100100]", "[7c000100]", "01")
    self.bid32_quantize("0", "1.0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_quantize("0", "1.0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "[80000001]", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "-9.999999e-95", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "9.999999e-95", "[7c000000]", "01")
    self.bid32_quantize("0", "1.0", "-9.999999e96", "[5f800000]", "20")
    self.bid32_quantize("0", "1.0", "9.999999e96", "[5f800000]", "20")
    self.bid32_quantize("0", "1.0e-96", "1.0", "[32000000]", "20")
    self.bid32_quantize("0", "-1.0e-96", "1.0", "[b2000000]", "20")
    self.bid32_quantize("0", "1.0", "[fc100000]", "[fc000000]", "00")
    self.bid32_quantize("0", "1.0", "[fc100100]", "[fc000100]", "00")
    self.bid32_quantize("0", "1.0", "[fe000000]", "[fc000000]", "01")
    self.bid32_quantize("0", "[6098967f]", "1.0", "[32000000]", "20")
    self.bid32_quantize("0", "[60989680]", "1.0", "[32000000]", "00")
    self.bid32_quantize("0", "[7c000000]", "1.0", "[7c000000]", "00")
    self.bid32_quantize("0", "[7c8f423f]", "1.0", "[7c0f423f]", "00")
    self.bid32_quantize("0", "[7c8f423f]", "[7e100000]", "[7c0f423f]", "01")
    self.bid32_quantize("0", "[7c8f423f]", "Infinity", "[7c0f423f]", "00")
    self.bid32_quantize("0", "[7c8f4240]", "1.0", "[7c000000]", "00")
    self.bid32_quantize("0", "[7e0f423f]", "0E+89", "[7c0f423f]", "01")
    self.bid32_quantize("0", "[7e100000]", "1.0", "[7c000000]", "01")
    self.bid32_quantize("0", "[7e100100]", "1.0", "[7c000100]", "01")
    self.bid32_quantize("0", "[7e8f423f]", "1.0", "[7c0f423f]", "01")
    self.bid32_quantize("0", "[7e8f4240]", "1.0", "[7c000000]", "01")
    self.bid32_quantize("0", "[80000001]", "1.0", "[b2000000]", "20")
    self.bid32_quantize("0", "9.999999e-95", "1.0", "[32000000]", "20")
    self.bid32_quantize("0", "-9.999999e-95", "1.0", "[b2000000]", "20")
    self.bid32_quantize("0", "-9.999999e96", "1.0", "[7c000000]", "01")
    self.bid32_quantize("0", "9.999999e96", "1.0", "[7c000000]", "01")
    self.bid32_quantize("0", "[f8000000]", "[b5000000]", "[7c000000]", "01")
    self.bid32_quantize("0", "[fc100000]", "1.0", "[fc000000]", "00")
    self.bid32_quantize("0", "[fc100100]", "1.0", "[fc000100]", "00")
    self.bid32_quantize("0", "[fe000000]", "1.0", "[fc000000]", "01")
    self.bid32_quantize("0", "[fe0dffbf]", "[f8000000]", "[fc0dffbf]", "01")
    self.bid32_quantize("0", "Infinity", "0E+89", "[7c000000]", "01")
    self.bid32_quantize("0", "Infinity", "Infinity", "[78000000]", "00")
    self.bid32_quantize("0", "Infinity", "NaN", "[7c000000]", "00")
    self.bid32_quantize("1", "[9304bb8a]", "[25d5e160]", "[a5800001]", "20")
    self.bid32_quantize("2", "1E-100", "0E+89", "[5f000001]", "20")
    self.bid32_quantize("2", "-1E-101", "0E-100", "[80800000]", "20")
    self.bid32_quantize("2", "-1E-96", "0E+89", "[df000000]", "20")
    self.bid32_quantize("2", "[9304bb8a]", "[25d5e160]", "[a5800000]", "20")
    self.bid32_quantize("2", "[98876a97]", "[e66dfaac]", "[998012fc]", "20")
    self.bid32_quantize("0", "1", "inf", "[7c000000]", "01")
  }

  private func bid32_quantize(
    _ _rounding: String,
    _ _arg0: String,
    _ _arg1: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let arg1 = self.parseDecimal32(_arg1, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.quantized(to: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_quantum() {
    self.bid32_quantum("0", "[35803039]", "[35800001]", "00")
    self.bid32_quantum("0", "[B5803039]", "[35800001]", "00")
    self.bid32_quantum("0", "[2D803039]", "[2D800001]", "00")
    self.bid32_quantum("0", "[AD803039]", "[2D800001]", "00")
    self.bid32_quantum("0", "[30003039]", "[30000001]", "00")
    self.bid32_quantum("0", "[B0003039]", "[30000001]", "00")
    self.bid32_quantum("0", "[3201E23A]", "[32000001]", "00")
    self.bid32_quantum("0", "[5F8F4240]", "[5F800001]", "00")
    self.bid32_quantum("0", "[DF8F4240]", "[5F800001]", "00")
    self.bid32_quantum("0", "[32800000]", "[32800001]", "00")
    self.bid32_quantum("0", "[B2800000]", "[32800001]", "00")
    self.bid32_quantum("0", "[00000001]", "[00000001]", "00")
    self.bid32_quantum("0", "[80000001]", "[00000001]", "00")
    self.bid32_quantum("0", "[00000000]", "[00000001]", "00")
    self.bid32_quantum("0", "[78000000]", "[78000000]", "00")
  }

  private func bid32_quantum(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }

    let result = arg0.quantum
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid32_sameQuantum() {
    self.bid32_sameQuantum("0", "[00000001]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[00080001]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[08005235]", "[f8000000]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[00000001]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[00080001]", "0", "00")
    self.bid32_sameQuantum("0", "-1.0", "1.0", "1", "00")
    self.bid32_sameQuantum("0", "1.0", "-1.0", "1", "00")
    self.bid32_sameQuantum("0", "1.0", "1.0", "1", "00")
    self.bid32_sameQuantum("0", "1.0", "-1.0e-96", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "1.0e-96", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[6098967f]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[60989680]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7c000000]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7c8f423f]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7c8f4240]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7e100000]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7e100100]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7e8f423f]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[7e8f4240]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[80000001]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "-9.999999e-95", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "9.999999e-95", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "-9.999999e96", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "9.999999e96", "0", "00")
    self.bid32_sameQuantum("0", "-1.0e-96", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "1.0e-96", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[fc100000]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[fc100100]", "0", "00")
    self.bid32_sameQuantum("0", "1.0", "[fe000000]", "0", "00")
    self.bid32_sameQuantum("0", "[6098967f]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[60989680]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7c000000]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7c8f423f]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7c8f423f]", "[7e100000]", "1", "00")
    self.bid32_sameQuantum("0", "[7c8f423f]", "Infinity", "0", "00")
    self.bid32_sameQuantum("0", "[7c8f4240]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7e100000]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7e100100]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7e8f423f]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[7e8f4240]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[80000001]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "-9.999999e-95", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "9.999999e-95", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "-9.999999e96", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "9.999999e96", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[fc100000]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[fc100100]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "[fe000000]", "1.0", "0", "00")
    self.bid32_sameQuantum("0", "Infinity", "NaN", "0", "00")
    self.bid32_sameQuantum("0", "Inf", "Inf", "1", "00")
  }

  private func bid32_sameQuantum(
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
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.sameQuantum(as: arg1)
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_quantize() {
    self.bid64_quantize("0", "[0010000000008840]", "[0008200000000000]", "[0010000000008840]", "00")
    self.bid64_quantize("0", "+0.100000000000000E0", "0", "[31c0000000000000]", "20")
    self.bid64_quantize("0", "[0167328ec74f5201]", "[0d32c63ff6c58ba1]", "[0d20000000000000]", "20")
    self.bid64_quantize("0", "[03e6e9b66952848c]", "[0400242300900000]", "[0400b0f8a421da0e]", "00")
    self.bid64_quantize("0", "[0485504280bb0225]", "[85f3d5406802cad2]", "[05e0000000003a6c]", "20")
    self.bid64_quantize("0", "[0b6d7dab3757f95c]", "[0f1a000000000000]", "[0f00000000000000]", "20")
    self.bid64_quantize("0", "-0", "Infinity", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "0", "Infinity", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "+10000.001E0", "0", "[31c0000000002710]", "20")
    self.bid64_quantize("0", "[110a535b742fee25]", "[0aa0000000000000]", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "+11100.0111E0", "-0", "[31c0000000002b5c]", "20")
    self.bid64_quantize("0", "[17000f3000025e50]", "[5b3c7bbf7fffff77]", "[5b20000000000000]", "20")
    self.bid64_quantize("0", "[2af0b487dd543b7c]", "[5a20000000000000]", "[5a20000000000000]", "20")
    self.bid64_quantize("0", "[3382796ae8b5f696]", "[a718b8eccb75970d]", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "-44789898.69E0", "-0", "[b1c0000002ab708b]", "20")
    self.bid64_quantize("0", "[54b861b448ed7806]", "[76d8e792243cb35a]", "[5b60000000000000]", "20")
    self.bid64_quantize("0", "+577897888665.59E0", "-0", "[31c000868d65fb9a]", "20")
    self.bid64_quantize("0", "+69.667775E0", "-0", "[31c0000000000046]", "20")
    self.bid64_quantize("0", "[6cde250888583608]", "[9fdbfffa18e44757]", "[1fc0000000000000]", "00")
    self.bid64_quantize("0", "[6e6139b93f663de3]", "[39933e55842625b8]", "[6e6139b93f663de3]", "00")
    self.bid64_quantize("0", "[70ab1534b98dc139]", "[c273ea4f5b38e5dd]", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "[7741a8b50a4fc84f]", "[0000000000000000]", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "[7800000000000000]", "[7800000000000001]", "[7800000000000000]", "00")
    self.bid64_quantize("0", "[7800000000000000]", "[7800000000000001]", "Infinity", "00")
    self.bid64_quantize("0", "[7800000000000001]", "[7800000000000000]", "[7800000000000000]", "00")
    self.bid64_quantize("0", "[87e8242e00822b4d]", "[0811f662040a12af]", "[8800d06b000d0454]", "20")
    self.bid64_quantize("0", "+889988989.89E0", "0", "[31c00000350c277e]", "20")
    self.bid64_quantize("0", "-89.9E0", "0", "[b1c000000000005a]", "20")
    self.bid64_quantize("0", "-998888.8E0", "0", "[b1c00000000f3de9]", "20")
    self.bid64_quantize("0", "+99989998.8E0", "-0", "[31c0000005f5b9ef]", "20")
    self.bid64_quantize("0", "[99eb9b73a3a105fb]", "[3bf36ab52824feaf]", "[bbe0000000000000]", "20")
    self.bid64_quantize("0", "[9b06bd679787ce84]", "[deddf11e9df0da97]", "[dec0000000000000]", "20")
    self.bid64_quantize("0", "[ac40000000000000]", "[23d0f641a05e8f21]", "[a3c0000000000000]", "00")
    self.bid64_quantize("0", "[afffefb7fffbfdff]", "[300838292921e020]", "[b00331926665ffcd]", "20")
    self.bid64_quantize("0", "[d7ea632b148b7c26]", "[41c0000000000000]", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "[f800000000000001]", "[7800000000000000]", "[f800000000000000]", "00")
    self.bid64_quantize("0", "[fbfffffffffffffd]", "[09000c1046401000]", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "[fffffbffffffffff]", "[ffffffffffffffff]", "[fc00000000000000]", "01")
    self.bid64_quantize("0", "-Infinity", "-0", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "Infinity", "0", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "Infinity", "Infinity", "[7800000000000000]", "00")
    self.bid64_quantize("0", "-Infinity", "Infinity", "[f800000000000000]", "00")
    self.bid64_quantize("0", "-Infinity", "QNaN", "[7c00000000000000]", "00")
    self.bid64_quantize("0", "QNaN", "0", "[7c00000000000000]", "00")
    self.bid64_quantize("0", "QNaN", "Infinity", "[7c00000000000000]", "00")
    self.bid64_quantize("0", "SNaN", "-0", "[7c00000000000000]", "01")
    self.bid64_quantize("0", "SNaN", "SNaN", "[7c00000000000000]", "01")
    self.bid64_quantize("1", "[91b300e0d5222151]", "[11effd5a146da9fe]", "[91e030a6169c8056]", "20")
    self.bid64_quantize("1", "[bfb7e5bcbdde7fac]", "[bfdffffffffefffb]", "[bfc263c612fca65e]", "00")
    self.bid64_quantize("2", "[0000403100001024]", "[c192e20b1f4c8c3b]", "[4180000000000001]", "20")
    self.bid64_quantize("2", "[91b300e0d5222151]", "[11effd5a146da9fe]", "[91e030a6169c8055]", "20")
    self.bid64_quantize("2", "[b1a9ff477a0846d9]", "[45efeb47474a92dd]", "[c5e0000000000000]", "20")
    self.bid64_quantize("2", "[bfb7e5bcbdde7fac]", "[bfdffffffffefffb]", "[bfc263c612fca65e]", "00")
  }

  private func bid64_quantize(
    _ _rounding: String,
    _ _arg0: String,
    _ _arg1: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let arg1 = self.parseDecimal64(_arg1, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.quantized(to: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_quantum() {
    self.bid64_quantum("0", "[3280000000003039]", "[3280000000000001]", "00")
    self.bid64_quantum("0", "[B280000000003039]", "[3280000000000001]", "00")
    self.bid64_quantum("0", "[3080000000003039]", "[3080000000000001]", "00")
    self.bid64_quantum("0", "[B080000000003039]", "[3080000000000001]", "00")
    self.bid64_quantum("0", "[3120000000003039]", "[3120000000000001]", "00")
    self.bid64_quantum("0", "[B120000000003039]", "[3120000000000001]", "00")
    self.bid64_quantum("0", "[31A000000001E23A]", "[31A0000000000001]", "00")
    self.bid64_quantum("0", "[5FE38D7EA4C68000]", "[5FE0000000000001]", "00")
    self.bid64_quantum("0", "[DFE38D7EA4C68000]", "[5FE0000000000001]", "00")
    self.bid64_quantum("0", "[31C0000000000000]", "[31C0000000000001]", "00")
    self.bid64_quantum("0", "[B1C0000000000000]", "[31C0000000000001]", "00")
    self.bid64_quantum("0", "[0000000000000001]", "[0000000000000001]", "00")
    self.bid64_quantum("0", "[8000000000000001]", "[0000000000000001]", "00")
    self.bid64_quantum("0", "[0000000000000000]", "[0000000000000001]", "00")
    self.bid64_quantum("0", "[7800000000000000]", "[7800000000000000]", "00")
  }

  private func bid64_quantum(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result = arg0.quantum
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid64_sameQuantum() {
    self.bid64_sameQuantum("0", "[0000000000000000]", "[698d80a4efe33f69]", "0", "00")
    self.bid64_sameQuantum("0", "0", "-0", "1", "00")
    self.bid64_sameQuantum("0", "-0", "SNaN", "0", "00")
    self.bid64_sameQuantum("0", "+1000000010.000000E0", "0", "0", "00")
    self.bid64_sameQuantum("0", "[29c95cda703c6a50]", "[97db1cf7f4ee8859]", "0", "00")
    self.bid64_sameQuantum("0", "[2dcb525f907dee77]", "[d93546fbedfc552e]", "0", "00")
    self.bid64_sameQuantum("0", "[471850f138942eeb]", "[5d7c6bc158b0b732]", "0", "00")
    self.bid64_sameQuantum("0", "[7c00000000000000]", "[fef3ffffffffffff]", "1", "00")
    self.bid64_sameQuantum("0", "[7e00000000000000]", "[7cf3ffffffffffff]", "1", "00")
    self.bid64_sameQuantum("0", "[7e2697ccba10d426]", "[fa2571792acbc717]", "0", "00")
    self.bid64_sameQuantum("0", "[8b7c50916fc999f4]", "[20909cda923baf84]", "0", "00")
    self.bid64_sameQuantum("0", "[8c9dce6f7b8ed1a6]", "[990793fa2ca53a1a]", "0", "00")
    self.bid64_sameQuantum("0", "[9920000000000000]", "[08c5000000000000]", "0", "00")
    self.bid64_sameQuantum("0", "[9ae0000000000000]", "[0e9c000000000000]", "0", "00")
    self.bid64_sameQuantum("0", "[a1926dee3ae9ff0a]", "[ba60000000000000]", "0", "00")
    self.bid64_sameQuantum("0", "[a23f9f5f02e2ccd6]", "[2f8167c39503829d]", "0", "00")
    self.bid64_sameQuantum("0", "[cbfc15ab001e11cc]", "[072486c8f96be096]", "0", "00")
    self.bid64_sameQuantum("0", "[d880000000000000]", "[c6bd8171578f2264]", "0", "00")
    self.bid64_sameQuantum("0", "[f4e4b9fff4ff6bf3]", "[3ccf6b9605feb0ac]", "0", "00")
    self.bid64_sameQuantum("0", "[fae73b5bf373db7f]", "[a9ceaee4c5dc851a]", "0", "00")
    self.bid64_sameQuantum("0", "Infinity", "-0.E0", "0", "00")
    self.bid64_sameQuantum("0", "Infinity", "Infinity", "1", "00")
    self.bid64_sameQuantum("0", "QNaN", "0", "0", "00")
    self.bid64_sameQuantum("0", "QNaN", "-Infinity", "0", "00")
    self.bid64_sameQuantum("0", "QNaN", "Infinity", "0", "00")
  }

  private func bid64_sameQuantum(
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
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.sameQuantum(as: arg1)
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_quantize() {
    self.bid128_quantize("0", "[0000000000000000,0000100060000000]", "[820566eb80e01394,18f566ef868385d2]", "[02040000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[0000000000000000,1610200006222111]", "[0002401020100241,fffff7f7efffffff]", "[00020000000000000234d000009d034e]", "20")
    self.bid128_quantize("0", "[0000074c00400450ffffffffffffffff]", "[8012011e02800364ed11b512401fe044]", "[0012000000001f5700cb7221e4090718]", "20")
    self.bid128_quantize("0", "[0000082810280a10,ffffffffffffffff]", "[00408000acdd28c0,f8ece02f0f48244c]", "[00400000000000000000000000000002]", "20")
    self.bid128_quantize("0", "[0000580481282100,6d42034c46a1f61f]", "[8000800100100200,d3f9dfb2c5cef66d]", "[00005804812821006d42034c46a1f61f]", "00")
    self.bid128_quantize("0", "[0000600000200002,0240010000080000]", "[0002500800100040,8018a69708d9bb40]", "[00020999999ccccd003999b333340000]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[001c1a6704b88825,dbfb7bfe86a7fbbe]", "[804a9f3bc0032f0c,2a802e4d7ed4eb0d]", "[004a000000000000000000013f2f84e3]", "20")
    self.bid128_quantize("0", "[0048340020520108,fffffff7ffffffff]", "[bfc05700cd8d2603,fadf57fabf5b59ff]", "[3fc00000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[01008424932b4901,3e84000801198090]", "[fefdbfbb77bef7d5,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "[0317ad53a2f38658,ac702810b78c8969]", "[7c000da427cacaa0,2adb73ee8e5b5d09]", "[7c000da427cacaa02adb73ee8e5b5d09]", "00")
    self.bid128_quantize("0", "[07a616f2d04f7332,fb0032afc8539c88]", "[8bd82f907f0b9928,4046d547d95d54b8]", "[0bd80000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[0e46000000000000,0000000000000000]", "[55b099499050918f,94d2a72b47746a89]", "[55b00000000000000000000000000000]", "00")
    self.bid128_quantize("0", "-0", "Infinity", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "0", "Infinity", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "-0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "-110000.0010E0", "-0", "[b040000000000000000000000001adb0]", "20")
    self.bid128_quantize("0", "+110.1110E0", "-0", "[3040000000000000000000000000006e]", "20")
    self.bid128_quantize("0", "[127ca4be7ad5bbfd,4498c20609a39545]", "[b2b4b68ea656aae4,143c13c5d6c97f46]", "[32b40000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[1460000000000000,0000000000000000]", "[15dc000000000000,0000000000000000]", "[15dc0000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[1542000000000000,0000000000000000]", "[5396e39f16ea88ac,86f61f04eb8a5f62]", "[53960000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[18658478fea66991,01929d3e1993abce]", "[9885acebc94b8554,aba2db078fcc5b91]", "[18840000000000000aef3d876944ddf5]", "20")
    self.bid128_quantize("0", "[2008800040004000416a159ca87aab48]", "[2013000008000422698d7b970a5c01b2]", "[2012000053e3001522a71ed3e683aaca]", "20")
    self.bid128_quantize("0", "-235966.842464759E0", "-0", "[b04000000000000000000000000399bf]", "20")
    self.bid128_quantize("0", "[2512000000000000,0000000000000000]", "[c390d9185dbc4017,026b514940e3dc94]", "[43900000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[258cf530be36efed,e87019c05db9b066]", "[ad0cc6f7d9582c43,4eed3d8189fc2cab]", "[2d0c0000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[278d4bdeb45d6a1b,3bd2aef591340174]", "[097eecb487fc4396,34d6bf3c517b9b96]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "[2f4a000000000000,0000000000000000]", "[497b8bb3a24afd37,bafe778ff9d91e43]", "[497a0000000000000000000000000000]", "00")
    self.bid128_quantize("0", "+3536258257868.3E0", "0", "[304000000000000000000337596ad3cc]", "20")
    self.bid128_quantize("0", "[36ca000000000000,0000000000000000]", "[9dec000000000000,0000000000000000]", "[1dec0000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[378d6995f3537d4c,b953fe8ffaa04ec6]", "[3c6cc5622e19c4b4,8fa2cd1f88e4bb1f]", "[3c6c0000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[3ebfbba58edd28f9,28da2fee723c8d53]", "[5585386f13b2c6eb,c74b158f64409529]", "[55840000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[4174000000000000,0000000000000000]", "[20983d15325e37cb,eb5d58cb61ee040c]", "[20980000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[487bd6cf88f54ebde851a54b7da97092]", "[f225cd5df9e39929249bcd1a45b817b2]", "[48960000000000052d36d9de86fb410f]", "20")
    self.bid128_quantize("0", "[48f355a706021ca0,4d48e40b3146118a]", "[eff968b27ffe5ded,9020a0c036120428]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "[5b11554467e1276f,3694dc660d713588]", "[7c0004df5c25ce73,a780ffdfbcdb9ca7]", "[7c0004df5c25ce73a780ffdfbcdb9ca7]", "00")
    self.bid128_quantize("0", "[6ffe7fbffffeffff,8e15c3020082088d]", "[f2bfa228d36adfab,320db63346df258f]", "[4afe0000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[78000000000000000000000000000000]", "[5ffe04ee2d6d415b85acef8100000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "[78000000000000000000000000000000]", "[78000000000000000000000000000001]", "[78000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[78000000000000000000000000000001]", "[78000000000000000000000000000000]", "[78000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[79a1e0a3be2f5c99,ff9ebfe374274b5f]", "[fbc19fe3ed75fa7d,0000244020800084]", "[78000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[7ebfbeccd7abf7fd,ffffeffffffffefb]", "[fdfff7fdfdff9ffb,154f9e0a8fb757a1]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "+88.898E0", "0", "[30400000000000000000000000000059]", "20")
    self.bid128_quantize("0", "+8989.88E0", "0", "[3040000000000000000000000000231e]", "20")
    self.bid128_quantize("0", "[8e339aa49d88979a,5467866bb6b67349]", "[a298000000000000,0000000000000000]", "[a2980000000000000000000000000000]", "20")
    self.bid128_quantize("0", "+96997.5E0", "0", "[30400000000000000000000000017ae6]", "20")
    self.bid128_quantize("0", "[a711835bb7fbf4fcfffef7ffbfffbfff]", "[69c9dbd1f8569db059f2b08e18c3d94a]", "[a7260000000010a30c9e15558eea132f]", "20")
    self.bid128_quantize("0", "[adff85b190fcaaac,5219533da67d59cf]", "[bbbd44f5451646d7,938da7fca7369c84]", "[bbbc0000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[ba549782656c1244,c82f4821be74a47c]", "[592516a2289ab46b,6c9615a262c38a5a]", "[d9240000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[bcbffbbddbdf9f73,0040000000420000]", "[808100001c041301,0000000000000040]", "[80800000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[cf839565fa9f7d3c,c86ab6eb6cd6c617]", "[50ff156783a76f70,15d42d741a58546a]", "[d0fe0000000000000000000000000000]", "20")
    self.bid128_quantize("0", "[d5d00499b55b2e23,eb11e80ebb7222f9]", "[fb01cf5383329669,0040002000008008]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "[fbcfe6e7fef79d7f,fffffbfffffbf7ff]", "[cb9f7dabefcfa7ee,d9c39e5bfadc3fd7]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "[fc00000000000000,0000000000000000]", "[51cb36ec6afc888d,ae06b38c3248f1ad]", "[fc000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "[ff7ddffffffdff7f,a6fdfbefdf686fff]", "[e130acd3a2a5938e,3f3bf4afc37a18d2]", "[fc001ffffffdff7fa6fdfbefdf686fff]", "01")
    self.bid128_quantize("0", "Infinity", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "-Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "QNaN", "-0", "[7c000000000000000000000000000000]", "00")
    self.bid128_quantize("0", "SNaN", "-0", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "SNaN", "QNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("0", "SNaN", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("1", "[0000008000004000,0fa4fae5db1944d8]", "[0040404041060000,2046024420006000]", "[00400000000000000000000000000000]", "20")
    self.bid128_quantize("1", "[0000074c00400450ffffffffffffffff]", "[8012011e02800364ed11b512401fe044]", "[0012000000001f5700cb7221e4090718]", "20")
    self.bid128_quantize("1", "[2008800040004000416a159ca87aab48]", "[2013000008000422698d7b970a5c01b2]", "[2012000053e3001522a71ed3e683aaca]", "20")
    self.bid128_quantize("1", "[487bd6cf88f54ebde851a54b7da97092]", "[f225cd5df9e39929249bcd1a45b817b2]", "[48960000000000052d36d9de86fb410e]", "20")
    self.bid128_quantize("1", "[78000000000000000000000000000000]", "[5ffe04ee2d6d415b85acef8100000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("1", "[8828fab4bc1daddd,70227c1045808242]", "[882ab42214100200,502c5007a28f9582]", "[882a191212cfc49624d03f9b3a26736d]", "00")
    self.bid128_quantize("1", "[a711835bb7fbf4fcfffef7ffbfffbfff]", "[69c9dbd1f8569db059f2b08e18c3d94a]", "[a7260000000010a30c9e15558eea132f]", "20")
    self.bid128_quantize("1", "[a76363b853b50105,af79156d828f06cb]", "[f7f7ffdbfff367fd,0040000000080004]", "[dfde0000000000000000000000000001]", "20")
    self.bid128_quantize("2", "[0000008000004000,0fa4fae5db1944d8]", "[0040404041060000,2046024420006000]", "[00400000000000000000000000000001]", "20")
    self.bid128_quantize("2", "[0000074c00400450ffffffffffffffff]", "[8012011e02800364ed11b512401fe044]", "[0012000000001f5700cb7221e4090719]", "20")
    self.bid128_quantize("2", "[00028040800a2040,5ddfffbfbf75ffff]", "[0010114024388c81,8bd73bd596f311cc]", "[0010000000d72bcb70e256688cb0e7ff]", "20")
    self.bid128_quantize("2", "[2008800040004000416a159ca87aab48]", "[2013000008000422698d7b970a5c01b2]", "[2012000053e3001522a71ed3e683aacb]", "20")
    self.bid128_quantize("2", "[487bd6cf88f54ebde851a54b7da97092]", "[f225cd5df9e39929249bcd1a45b817b2]", "[48960000000000052d36d9de86fb410f]", "20")
    self.bid128_quantize("2", "[78000000000000000000000000000000]", "[5ffe04ee2d6d415b85acef8100000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("2", "[8828fab4bc1daddd,70227c1045808242]", "[882ab42214100200,502c5007a28f9582]", "[882a191212cfc49624d03f9b3a26736d]", "00")
    self.bid128_quantize("2", "[a711835bb7fbf4fcfffef7ffbfffbfff]", "[69c9dbd1f8569db059f2b08e18c3d94a]", "[a7260000000010a30c9e15558eea132e]", "20")
    self.bid128_quantize("2", "[a76363b853b50105,af79156d828f06cb]", "[f7f7ffdbfff367fd,0040000000080004]", "[dfde0000000000000000000000000000]", "20")
    self.bid128_quantize("2", "[b366e0e4b7f9d218,7631d010364abdcf]", "[33a3c57766f0455b,b37286067a508e5b]", "[b3a200000000000000000000000011d1]", "20")
    self.bid128_quantize("3", "[0000074c00400450ffffffffffffffff]", "[8012011e02800364ed11b512401fe044]", "[0012000000001f5700cb7221e4090718]", "20")
    self.bid128_quantize("3", "[2008800040004000416a159ca87aab48]", "[2013000008000422698d7b970a5c01b2]", "[2012000053e3001522a71ed3e683aaca]", "20")
    self.bid128_quantize("3", "[487bd6cf88f54ebde851a54b7da97092]", "[f225cd5df9e39929249bcd1a45b817b2]", "[48960000000000052d36d9de86fb410e]", "20")
    self.bid128_quantize("3", "[78000000000000000000000000000000]", "[5ffe04ee2d6d415b85acef8100000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("3", "[a711835bb7fbf4fcfffef7ffbfffbfff]", "[69c9dbd1f8569db059f2b08e18c3d94a]", "[a7260000000010a30c9e15558eea132e]", "20")
    self.bid128_quantize("4", "[0000074c00400450ffffffffffffffff]", "[8012011e02800364ed11b512401fe044]", "[0012000000001f5700cb7221e4090718]", "20")
    self.bid128_quantize("4", "[2008800040004000416a159ca87aab48]", "[2013000008000422698d7b970a5c01b2]", "[2012000053e3001522a71ed3e683aaca]", "20")
    self.bid128_quantize("4", "[487bd6cf88f54ebde851a54b7da97092]", "[f225cd5df9e39929249bcd1a45b817b2]", "[48960000000000052d36d9de86fb410f]", "20")
    self.bid128_quantize("4", "[78000000000000000000000000000000]", "[5ffe04ee2d6d415b85acef8100000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_quantize("4", "[a711835bb7fbf4fcfffef7ffbfffbfff]", "[69c9dbd1f8569db059f2b08e18c3d94a]", "[a7260000000010a30c9e15558eea132f]", "20")
  }

  private func bid128_quantize(
    _ _rounding: String,
    _ _arg0: String,
    _ _arg1: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let rounding = self.parseRounding(_rounding, file, line) else { return }
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let arg1 = self.parseDecimal128(_arg1, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.quantized(to: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_quantum() {
    self.bid128_quantum("0", "[304C0000000000000000000000003039]", "[304C0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[B04C0000000000000000000000003039]", "[304C0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[302C0000000000000000000000003039]", "[302C0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[B02C0000000000000000000000003039]", "[302C0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[30360000000000000000000000003039]", "[30360000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[B0360000000000000000000000003039]", "[30360000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[303E000000000000000000000001E23A]", "[303E0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[5FFE314DC6448D9338C15B0A00000000]", "[5FFE0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[DFFE314DC6448D9338C15B0A00000000]", "[5FFE0000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[30400000000000000000000000000000]", "[30400000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[B0400000000000000000000000000000]", "[30400000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[00000000000000000000000000000001]", "[00000000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[80000000000000000000000000000001]", "[00000000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[00000000000000000000000000000000]", "[00000000000000000000000000000001]", "00")
    self.bid128_quantum("0", "[78000000000000000000000000000000]", "[78000000000000000000000000000000]", "00")
  }

  private func bid128_quantum(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result = arg0.quantum
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
  }

  func test_bid128_sameQuantum() {
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "0", "00")
    self.bid128_sameQuantum("0", "0", "-0", "1", "00")
    self.bid128_sameQuantum("0", "0", "0", "1", "00")
    self.bid128_sameQuantum("0", "[051c74281ad2cdb5,f119577a273dfe79]", "[df176c57b1339503,66495a5a3b54eda9]", "0", "00")
    self.bid128_sameQuantum("0", "[08d06098f22341df,7f5d008240ff8dd0]", "[3cecd8ccc6f2442c,d093bdbd23f43799]", "0", "00")
    self.bid128_sameQuantum("0", "-0", "SNaN", "0", "00")
    self.bid128_sameQuantum("0", "0", "SNaN", "0", "00")
    self.bid128_sameQuantum("0", "[17881f4ee218bad9,82f3e7c1878d47ef]", "[1f72000000000000,0000000000000000]", "0", "00")
    self.bid128_sameQuantum("0", "[3ccfe12d62401d52,1b5f04ac64412a34]", "[441e000000000000,0000000000000000]", "0", "00")
    self.bid128_sameQuantum("0", "[536290ca09fb8b86,52123b3cdeaf6c90]", "[bb8f2d13f90ccbb4,78d152167e7c5279]", "0", "00")
    self.bid128_sameQuantum("0", "[6ff7b7fff73fd3aa,fff7cdfff6ff5bcf]", "[efb9bc0e0d423190,ee325a636805251f]", "0", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_sameQuantum("0", "[7f5925b54c3d9dd6,c4414022fb251949]", "[a1d68282f8c99254,5101110280002040]", "0", "00")
    self.bid128_sameQuantum("0", "[8cd7b9b8bc4f202a,d2d914b2ed4bd0c4]", "[09654b47455a90b2,53a2421194503a32]", "0", "00")
    self.bid128_sameQuantum("0", "[8d8c53ded1fe4b28,b83e18a73f3dcc9f]", "[98624a824286a1b5,5dd6844c9d9f588b]", "0", "00")
    self.bid128_sameQuantum("0", "[9165bf5333bf3231,ce13539fd9473752]", "[f9aeaeedfaed7673,7cf58ad73712ed66]", "0", "00")
    self.bid128_sameQuantum("0", "[c5eac98dc305e7e2,3d40f5b48e2e469c]", "[35f8e672f8527b48,b69adb8222fcb612]", "0", "00")
    self.bid128_sameQuantum("0", "[c9d8803897920d28,05f51fbb0724ac1c]", "[a26c23a0e28474fa,27057eab64dc55d7]", "0", "00")
    self.bid128_sameQuantum("0", "[ce7ab182e60ef9f6,e7878a50950422c2]", "[196109cfaa417d79,727b4abe4cb75a32]", "0", "00")
    self.bid128_sameQuantum("0", "[d4ddaae62ab05fda,ea8d6cf791bf223d]", "[d9d55e041a032419,a0c2a34f3ee1bed7]", "0", "00")
    self.bid128_sameQuantum("0", "[e256138caf1cd6cf,fbffa5ffdfffdfff]", "[2000000000001a20,3feffa463c7b507f]", "0", "00")
    self.bid128_sameQuantum("0", "-Infinity", "-0", "0", "00")
    self.bid128_sameQuantum("0", "-Infinity", "0", "0", "00")
    self.bid128_sameQuantum("0", "Infinity", "Infinity", "1", "00")
    self.bid128_sameQuantum("0", "-Infinity", "QNaN", "0", "00")
    self.bid128_sameQuantum("0", "SNaN", "Infinity", "0", "00")
  }

  private func bid128_sameQuantum(
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
    guard let expected = self.parseInt32(_expected, file, line) else { return }

    let result = arg0.sameQuantum(as: arg1)
    self.assertBool(result, expected, file, line)
  }
}
