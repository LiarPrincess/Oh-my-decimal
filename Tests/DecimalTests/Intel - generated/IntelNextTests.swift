// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelNextTests: XCTestCase, IntelMixin {

  func test_bid32_nextdown() {
    self.bid32_nextdown("0", "[00000001]", "[00000000]", "00")
    self.bid32_nextdown("0", "[00080001]", "[00080000]", "00")
    self.bid32_nextdown("0", "1.0", "[6bd8967f]", "00")
    self.bid32_nextdown("0", "-1.0", "[af8f4241]", "00")
    self.bid32_nextdown("0", "1.0e-96", "[0001869f]", "00")
    self.bid32_nextdown("0", "-1.0e-96", "[800186a1]", "00")
    self.bid32_nextdown("0", "[6098967f]", "[6098967e]", "00")
    self.bid32_nextdown("0", "[60989680]", "[80000001]", "00")
    self.bid32_nextdown("0", "[78000000]", "[77f8967f]", "00")
    self.bid32_nextdown("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_nextdown("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_nextdown("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_nextdown("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_nextdown("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_nextdown("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_nextdown("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_nextdown("0", "[80000001]", "[80000002]", "00")
    self.bid32_nextdown("0", "9.999999e-95", "[6018967e]", "00")
    self.bid32_nextdown("0", "-9.999999e-95", "[808f4240]", "00")
    self.bid32_nextdown("0", "9.999999e96", "[77f8967e]", "00")
    self.bid32_nextdown("0", "-9.999999e96", "[f8000000]", "00")
    self.bid32_nextdown("0", "[f8000000]", "[f8000000]", "00")
    self.bid32_nextdown("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_nextdown("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_nextdown("0", "[fe000000]", "[fc000000]", "01")
    self.bid32_nextdown("0", "-Infinity", "[f8000000]", "00")
  }

  private func bid32_nextdown(
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
    let result = arg0.nextDown(status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid32_nextup() {
    self.bid32_nextup("0", "[00000001]", "[00000002]", "00")
    self.bid32_nextup("0", "[00080001]", "[00080002]", "00")
    self.bid32_nextup("0", "1.0", "[2f8f4241]", "00")
    self.bid32_nextup("0", "1.0e-96", "[000186a1]", "00")
    self.bid32_nextup("0", "-1.0e-96", "[8001869f]", "00")
    self.bid32_nextup("0", "-1.0", "[ebd8967f]", "00")
    self.bid32_nextup("0", "[6098967f]", "[028f4240]", "00")
    self.bid32_nextup("0", "[60989680]", "[00000001]", "00")
    self.bid32_nextup("0", "[78000000]", "[78000000]", "00")
    self.bid32_nextup("0", "[7c000000]", "[7c000000]", "00")
    self.bid32_nextup("0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_nextup("0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_nextup("0", "[7e100000]", "[7c000000]", "01")
    self.bid32_nextup("0", "[7e100100]", "[7c000100]", "01")
    self.bid32_nextup("0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_nextup("0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_nextup("0", "[80000001]", "[80000000]", "00")
    self.bid32_nextup("0", "9.999999e-95", "[008f4240]", "00")
    self.bid32_nextup("0", "-9.999999e-95", "[e018967e]", "00")
    self.bid32_nextup("0", "9.999999e96", "[78000000]", "00")
    self.bid32_nextup("0", "-9.999999e96", "[f7f8967e]", "00")
    self.bid32_nextup("0", "[f8000000]", "[f7f8967f]", "00")
    self.bid32_nextup("0", "[fc100000]", "[fc000000]", "00")
    self.bid32_nextup("0", "[fc100100]", "[fc000100]", "00")
    self.bid32_nextup("0", "[fe000000]", "[fc000000]", "01")
  }

  private func bid32_nextup(
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
    let result = arg0.nextUp(status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_nextdown() {
    self.bid64_nextdown("0", "0", "[8000000000000001]", "00")
    self.bid64_nextdown("0", "[0c1d000000000000]", "[0c1cffffffffffff]", "00")
    self.bid64_nextdown("0", "[0d75000000000000]", "[0d74ffffffffffff]", "00")
    self.bid64_nextdown("0", "[27516c0657ef1ffd]", "[27516c0657ef1ffc]", "00")
    self.bid64_nextdown("0", "[416c58fc2e4160da]", "[416c58fc2e4160d9]", "00")
    self.bid64_nextdown("0", "[50386843f6afe19e]", "[50386843f6afe19d]", "00")
    self.bid64_nextdown("0", "[62882f9275e02fc3]", "[62882f9275e02fc2]", "00")
    self.bid64_nextdown("0", "-9.999999999999999E+384", "[f800000000000000]", "00")
    self.bid64_nextdown("0", "[c9843e391c357fde]", "[c9843e391c357fdf]", "00")
    self.bid64_nextdown("0", "[d240000000000000]", "[8000000000000001]", "00")
    self.bid64_nextdown("0", "[d31486bbc8fec197]", "[d31486bbc8fec198]", "00")
    self.bid64_nextdown("0", "[e532f9fe51c8a6a8]", "[e532f9fe51c8a6a9]", "00")
    self.bid64_nextdown("0", "[e5dbffffbfcef7ff]", "[8000000000000001]", "00")
    self.bid64_nextdown("0", "[f9eeffffffffffff]", "[f800000000000000]", "00")
    self.bid64_nextdown("0", "[fdede6ef9ff97778]", "[fc01e6ef9ff97778]", "00")
    self.bid64_nextdown("0", "[ff9fbf177bffff3f]", "[fc00000000000000]", "01")
    self.bid64_nextdown("0", "Infinity", "[77fb86f26fc0ffff]", "00")
    self.bid64_nextdown("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_nextdown(
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
    let result = arg0.nextDown(status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_nextup() {
    self.bid64_nextup("0", "-0", "[0000000000000001]", "00")
    self.bid64_nextup("0", "0", "[0000000000000001]", "00")
    self.bid64_nextup("0", "[0a8f000000000000]", "[0a8f000000000001]", "00")
    self.bid64_nextup("0", "[13db565cac306fea]", "[13db565cac306feb]", "00")
    self.bid64_nextup("0", "[17f282113bf9676e]", "[17f282113bf9676f]", "00")
    self.bid64_nextup("0", "[31053b4613944f66]", "[31053b4613944f67]", "00")
    self.bid64_nextup("0", "[69b57008e85ecab0]", "[0000000000000001]", "00")
    self.bid64_nextup("0", "[7a8fa7f2780e1ad1]", "[7800000000000000]", "00")
    self.bid64_nextup("0", "[8000000000000001]", "[8000000000000000]", "00")
    self.bid64_nextup("0", "[8a2dcc9108ec7029]", "[8a2dcc9108ec7028]", "00")
    self.bid64_nextup("0", "[9400000000000001]", "[e48386f26fc0ffff]", "00")
    self.bid64_nextup("0", "9.999999999999999E-383", "[00238d7ea4c68000]", "00")
    self.bid64_nextup("0", "9.999999999999999E+384", "[7800000000000000]", "00")
    self.bid64_nextup("0", "[b200000000000000]", "[0000000000000001]", "00")
    self.bid64_nextup("0", "[bd1e154561fbf070]", "[bd1e154561fbf06f]", "00")
    self.bid64_nextup("0", "[dc3ce68178886155]", "[dc3ce68178886154]", "00")
    self.bid64_nextup("0", "[de5a53458d01e348]", "[de5a53458d01e347]", "00")
    self.bid64_nextup("0", "[f15905fd8cfcf93f]", "[f15905fd8cfcf93e]", "00")
    self.bid64_nextup("0", "[fdeddfdff9ffde5f]", "[fc01dfdff9ffde5f]", "00")
    self.bid64_nextup("0", "[ff3e59edeff968f2]", "[fc0259edeff968f2]", "01")
    self.bid64_nextup("0", "[fffffffffeffffff]", "[fc00000000000000]", "01")
    self.bid64_nextup("0", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_nextup(
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
    let result = arg0.nextUp(status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_nextdown() {
    self.bid128_nextdown("0", "[0000000000000000,0000000000000001]", "[00000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62fffffffe]", "00")
    self.bid128_nextdown("0", "[0001ed09bead87c0378d8e64ffffffff]", "[80000000000000000000000000000001]", "00")
    self.bid128_nextdown("0", "[0040000000000000,0000000000000002]", "[000009dc5ada82b70b59df01ffffffff]", "00")
    self.bid128_nextdown("0", "[0080000000000000,0000000000000001]", "[003ded09bead87c0378d8e63ffffffff]", "00")
    self.bid128_nextdown("0", "-0", "[80000000000000000000000000000001]", "00")
    self.bid128_nextdown("0", "0", "[80000000000000000000000000000001]", "00")
    self.bid128_nextdown("0", "[1dc2205f885182d0,5c4d7fcc63056120]", "[1dc143bb532f1c239b06fdfbde35cb3f]", "00")
    self.bid128_nextdown("0", "[2297188ee5995a16,571813d4cb7ca060]", "[2297188ee5995a16571813d4cb7ca05f]", "00")
    self.bid128_nextdown("0", "[380a24e29845b5f2,60cd9cf82855437a]", "[380970d9f2b91b77c80821b19354a2c3]", "00")
    self.bid128_nextdown("0", "[380bcf9425550818,1807cc6de69fcee7]", "[380bcf94255508181807cc6de69fcee6]", "00")
    self.bid128_nextdown("0", "[6ffff2fd7eefff9f,5801404100000401]", "[80000000000000000000000000000001]", "00")
    self.bid128_nextdown("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[7e00000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_nextdown("0", "[7e000b4bdd5ec3e2,4d174387ac15f085]", "[7c000b4bdd5ec3e24d174387ac15f085]", "01")
    self.bid128_nextdown("0", "[8bae000000000000,0000000000000000]", "[80000000000000000000000000000001]", "00")
    self.bid128_nextdown("0", "-9.999999999999999999999999999999999E+6144", "[f8000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[f8fa90e5dcfb4727,540dba68bc2a5f7d]", "[f8000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[fdbffffd9ff7c3ff,7ff3be5e87fe7747]", "[fc000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_nextdown("0", "[fe000574f7d3802a,d93137567a500098]", "[fc000574f7d3802ad93137567a500098]", "01")
    self.bid128_nextdown("0", "[fe00243684088649,0784a9055dbc2753]", "[fc002436840886490784a9055dbc2753]", "01")
    self.bid128_nextdown("0", "[ffffbfffffffffff,fa8cdfac7ffefdf7]", "[fc000000000000000000000000000000]", "01")
    self.bid128_nextdown("0", "Infinity", "[5fffed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_nextdown("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_nextdown("0", "1", "[2ffded09bead87c0378d8e63ffffffff]", "00")
    self.bid128_nextdown("0", "[7c00314dc6448d9338c15b0a00000001]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[7c00314dc6448d9338c15b0a00000001]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "[7c00314dc6448d9338c15b09ffffffff]", "[7c00314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_nextdown("0", "[7c00314dc6448d9338c15b0a00000001]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextdown("0", "4294967296", "[3010d3c21bcecceda0ffffffffffffff]", "00")
    self.bid128_nextdown("0", "4294967296", "[3010d3c21bcecceda0ffffffffffffff]", "00")
    self.bid128_nextdown("0", "4294967295", "[3010d3c21bcdf92b853133125effffff]", "00")
    self.bid128_nextdown("0", "4294967295", "[3010d3c21bcdf92b853133125effffff]", "00")
  }

  private func bid128_nextdown(
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
    let result = arg0.nextDown(status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_nextup() {
    self.bid128_nextup("0", "-0", "[00000000000000000000000000000001]", "00")
    self.bid128_nextup("0", "0", "[00000000000000000000000000000001]", "00")
    self.bid128_nextup("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e6300000000]", "00")
    self.bid128_nextup("0", "[0001ed09bead87c0378d8e64ffffffff]", "[00000000000000000000000000000001]", "00")
    self.bid128_nextup("0", "[0028000000000000,0000008000000000]", "[000002b5e3af16b18800000000000001]", "00")
    self.bid128_nextup("0", "[1dc2205f885182d0,5c4d7fcc63056120]", "[1dc143bb532f1c239b06fdfbde35cb41]", "00")
    self.bid128_nextup("0", "[2297188ee5995a16,571813d4cb7ca060]", "[2297188ee5995a16571813d4cb7ca061]", "00")
    self.bid128_nextup("0", "[380a24e29845b5f2,60cd9cf82855437a]", "[380970d9f2b91b77c80821b19354a2c5]", "00")
    self.bid128_nextup("0", "[380bcf9425550818,1807cc6de69fcee7]", "[380bcf94255508181807cc6de69fcee8]", "00")
    self.bid128_nextup("0", "[3aadf9ad6b4fdbf5,f79bfcb6fdeb8fd8]", "[00000000000000000000000000000001]", "00")
    self.bid128_nextup("0", "[782d2f94d69006ec,2196c0c64c5c5d60]", "[78000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[7e00000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_nextup("0", "[7e000b4bdd5ec3e2,4d174387ac15f085]", "[7c000b4bdd5ec3e24d174387ac15f085]", "01")
    self.bid128_nextup("0", "[8000000000000000,0000000000000001]", "[80000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[8080000000000000,0000000000000001]", "[803ded09bead87c0378d8e63ffffffff]", "00")
    self.bid128_nextup("0", "[8bae000000000000,0000000000000000]", "[00000000000000000000000000000001]", "00")
    self.bid128_nextup("0", "9.999999999999999999999999999999999E-6143", "[0002314dc6448d9338c15b0a00000000]", "00")
    self.bid128_nextup("0", "9.999999999999999999999999999999999E+6144", "[78000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[fdffb5e7ffbbaf77,a4dd7e5ad5fed731]", "[fc000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[fe00000000000000,0000000000000000]", "[fc000000000000000000000000000000]", "01")
    self.bid128_nextup("0", "[fe000574f7d3802a,d93137567a500098]", "[fc000574f7d3802ad93137567a500098]", "01")
    self.bid128_nextup("0", "[fe00243684088649,0784a9055dbc2753]", "[fc002436840886490784a9055dbc2753]", "01")
    self.bid128_nextup("0", "[fffffffff77fffff,ffffffffdfffff7b]", "[fc000000000000000000000000000000]", "01")
    self.bid128_nextup("0", "Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "-Infinity", "[dfffed09bead87c0378d8e63ffffffff]", "00")
    self.bid128_nextup("0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_nextup("0", "1", "[2ffe314dc6448d9338c15b0a00000001]", "00")
    self.bid128_nextup("0", "[7c00314dc6448d9338c15b0a00000001]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[7c00314dc6448d9338c15b0a00000001]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "[7c00314dc6448d9338c15b09ffffffff]", "[7c00314dc6448d9338c15b09ffffffff]", "00")
    self.bid128_nextup("0", "[7c00314dc6448d9338c15b0a00000001]", "[7c000000000000000000000000000000]", "00")
    self.bid128_nextup("0", "4294967296", "[3010d3c21bcecceda100000000000001]", "00")
    self.bid128_nextup("0", "4294967296", "[3010d3c21bcecceda100000000000001]", "00")
    self.bid128_nextup("0", "4294967295", "[3010d3c21bcdf92b853133125f000001]", "00")
    self.bid128_nextup("0", "4294967295", "[3010d3c21bcdf92b853133125f000001]", "00")
  }

  private func bid128_nextup(
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
    let result = arg0.nextUp(status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }
}
