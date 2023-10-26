// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelRemTests: XCTestCase, IntelMixin {

  func test_bid32_rem() {
    self.bid32_rem("0", "[00000001]", "1.0", "[00000001]", "00")
    self.bid32_rem("0", "[00000800]", "[80000207]", "[8000001c]", "00")
    self.bid32_rem("0", "[00080001]", "1.0", "[00080001]", "00")
    self.bid32_rem("0", "0E+89", "1E-96", "[02800000]", "00")
    self.bid32_rem("0", "0E+89", "9.999999E+96", "[5f000000]", "00")
    self.bid32_rem("0", "0E+89", "Infinity", "[5f000000]", "00")
    self.bid32_rem("0", "1.0", "[00000001]", "[00000000]", "00")
    self.bid32_rem("0", "1.0", "[00080001]", "[80032a8c]", "00")
    self.bid32_rem("0", "1.0", "-1.0", "[32000000]", "00")
    self.bid32_rem("0", "1.0", "1.0", "[32000000]", "00")
    self.bid32_rem("0", "-1.0", "1.0", "[b2000000]", "00")
    self.bid32_rem("0", "1.0", "-1.0e-96", "[02000000]", "00")
    self.bid32_rem("0", "1.0", "1.0e-96", "[02000000]", "00")
    self.bid32_rem("0", "1.0", "[6098967f]", "[020f4240]", "00")
    self.bid32_rem("0", "1.0", "[60989680]", "[7c000000]", "01")
    self.bid32_rem("0", "1.0", "[7c000000]", "[7c000000]", "00")
    self.bid32_rem("0", "1.0", "[7c8f423f]", "[7c0f423f]", "00")
    self.bid32_rem("0", "1.0", "[7c8f4240]", "[7c000000]", "00")
    self.bid32_rem("0", "1.0", "[7e100000]", "[7c000000]", "01")
    self.bid32_rem("0", "1.0", "[7e100100]", "[7c000100]", "01")
    self.bid32_rem("0", "1.0", "[7e8f423f]", "[7c0f423f]", "01")
    self.bid32_rem("0", "1.0", "[7e8f4240]", "[7c000000]", "01")
    self.bid32_rem("0", "1.0", "[80000001]", "[00000000]", "00")
    self.bid32_rem("0", "1.0", "-9.999999e-95", "[000003e8]", "00")
    self.bid32_rem("0", "1.0", "9.999999e-95", "[000003e8]", "00")
    self.bid32_rem("0", "1.0", "-9.999999e96", "[3200000a]", "00")
    self.bid32_rem("0", "1.0", "9.999999e96", "[3200000a]", "00")
    self.bid32_rem("0", "1.0e-96", "1.0", "[0200000a]", "00")
    self.bid32_rem("0", "-1.0e-96", "1.0", "[8200000a]", "00")
    self.bid32_rem("0", "1.0", "[fc100000]", "[fc000000]", "00")
    self.bid32_rem("0", "1.0", "[fc100100]", "[fc000100]", "00")
    self.bid32_rem("0", "1.0", "[fe000000]", "[fc000000]", "01")
    self.bid32_rem("0", "1.234567E+95", "1E+90", "[df000003]", "00")
    self.bid32_rem("0", "1E+89", "1E+90", "[5f000001]", "00")
    self.bid32_rem("0", "[2f6bcdb3]", "[ebf7fe2f]", "[2f6bcdb3]", "00")
    self.bid32_rem("0", "[3c000000]", "[866d2bef]", "[06000000]", "00")
    self.bid32_rem("0", "[6098967f]", "1.0", "[6098967f]", "00")
    self.bid32_rem("0", "[60989680]", "1.0", "[02000000]", "00")
    self.bid32_rem("0", "[78000000]", "[0796bd0c]", "[7c000000]", "01")
    self.bid32_rem("0", "[7c000000]", "1.0", "[7c000000]", "00")
    self.bid32_rem("0", "[7c8f423f]", "1.0", "[7c0f423f]", "00")
    self.bid32_rem("0", "[7c8f423f]", "[7e100000]", "[7c0f423f]", "01")
    self.bid32_rem("0", "[7c8f423f]", "Infinity", "[7c0f423f]", "00")
    self.bid32_rem("0", "[7c8f4240]", "1.0", "[7c000000]", "00")
    self.bid32_rem("0", "[7e100000]", "1.0", "[7c000000]", "01")
    self.bid32_rem("0", "[7e100100]", "1.0", "[7c000100]", "01")
    self.bid32_rem("0", "[7e8f423f]", "1.0", "[7c0f423f]", "01")
    self.bid32_rem("0", "[7e8f4240]", "1.0", "[7c000000]", "01")
    self.bid32_rem("0", "[80000001]", "1.0", "[80000001]", "00")
    self.bid32_rem("0", "9.999999e-95", "1.0", "[6018967f]", "00")
    self.bid32_rem("0", "-9.999999e-95", "1.0", "[e018967f]", "00")
    self.bid32_rem("0", "9.999999e96", "1.0", "[32000000]", "00")
    self.bid32_rem("0", "-9.999999e96", "1.0", "[b2000000]", "00")
    self.bid32_rem("0", "[db800000]", "[77f06aff]", "[db800000]", "00")
    self.bid32_rem("0", "[debfe57f]", "[f8000000]", "[debfe57f]", "00")
    self.bid32_rem("0", "[fc100000]", "1.0", "[fc000000]", "00")
    self.bid32_rem("0", "[fc100100]", "1.0", "[fc000100]", "00")
    self.bid32_rem("0", "[fe000000]", "1.0", "[fc000000]", "01")
    self.bid32_rem("0", "Infinity", "0E+89", "[7c000000]", "01")
    self.bid32_rem("0", "Infinity", "NaN", "[7c000000]", "00")
  }

  private func bid32_rem(
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
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.remainder(dividingBy: arg1, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)

    let result2 = self.remainderFromTruncatingRemainder(arg0, dividingBy: arg1)
    self.assertEqual(result2, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid64_rem() {
    self.bid64_rem("0", "[0000400000000000]", "[0000002180400729]", "[0000000205b252af]", "00")
    self.bid64_rem("0", "-0", "0", "[7c00000000000000]", "01")
    self.bid64_rem("0", "0", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[00cd1505de2b28ef]", "[79ea3cfdff7ff7f7]", "[00cd1505de2b28ef]", "00")
    self.bid64_rem("0", "[08cd000000000000]", "[9446e2ab9830b5ea]", "[08cd000000000000]", "00")
    self.bid64_rem("0", "[08df000000000000]", "[19a0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[09f7000000000000]", "[c460000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[0c5e124ac21e0813]", "[662800c290a8d383]", "[0c5e124ac21e0813]", "00")
    self.bid64_rem("0", "+0.E0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_rem("0", "[0e8e26762eb6381c]", "[6ac6b8ae924112db]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "0", "Infinity", "[31c0000000000000]", "00")
    self.bid64_rem("0", "-0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("0", "0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[10d5ec568879c7f0]", "[a2e0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[238ce60ca6074db3]", "[7ffff4f5f9d7f4fe]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[2fbd095f29c987f4]", "[899d711b92e3e213]", "[098c994ddddf3df7]", "00")
    self.bid64_rem("0", "[4353d1d8a93c5ef9]", "[4390503cd8b20c4e]", "[4353d1d8a93c5ef9]", "00")
    self.bid64_rem("0", "[498aff06888ef77e]", "[1740000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[4d7bf08237c1ea3c]", "[5dceaba82e5bb7ee]", "[4d7bf08237c1ea3c]", "00")
    self.bid64_rem("0", "[5d030482e0a24502]", "[06dac3bbaa189e4e]", "[86c9e499bd65bf52]", "00")
    self.bid64_rem("0", "[6fdffdfffffd7eff]", "[0100042000483400]", "[0100000000000000]", "00")
    self.bid64_rem("0", "[75be35dff5dcf9bf]", "[edff6fedffc6e5df]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[8d40000000000000]", "[5f80000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[a48805a0f2caf9f8]", "[c360000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[afb236d07e3effc6]", "[5240000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[d34e2038ec42ae38]", "[0000100000000000]", "[8000000000000000]", "00")
    self.bid64_rem("0", "[da0793cd0c6c3581]", "[5940000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[dffdfffd7f7fffcd]", "[dfe52f777d5fe9df]", "[5fe11ccf70bf7b6d]", "00")
    self.bid64_rem("0", "[ec3a5d024e224441]", "[fab38185513508ad]", "[ec3a5d024e224441]", "00")
    self.bid64_rem("0", "[ed85b2c7ffaadfae]", "[63099bb2b1f32d17]", "[8c20000000000000]", "00")
    self.bid64_rem("0", "[f6ffb9f5f57fffef]", "[fdfba3f7afbdefff]", "[fc00000000000000]", "00")
    self.bid64_rem("0", "[fb1e6454d100e9d9]", "[00a30b0000040410]", "[7c00000000000000]", "01")
    self.bid64_rem("0", "[fefffdeffffbffba]", "[80010000a2408000]", "[fc00000000000000]", "01")
    self.bid64_rem("0", "[ffffeffff7effff7]", "[ffbdffffbd7dffff]", "[fc00000000000000]", "01")
    self.bid64_rem("0", "-Infinity", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("0", "Infinity", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("0", "SNaN", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("0", "SNaN", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("1", "-0", "0", "[7c00000000000000]", "01")
    self.bid64_rem("1", "0", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[08cd000000000000]", "[9446e2ab9830b5ea]", "[08cd000000000000]", "00")
    self.bid64_rem("1", "[08df000000000000]", "[19a0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[09f7000000000000]", "[c460000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "+0.E0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_rem("1", "0", "Infinity", "[31c0000000000000]", "00")
    self.bid64_rem("1", "-0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("1", "0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[10d5ec568879c7f0]", "[a2e0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[498aff06888ef77e]", "[1740000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[4d7bf08237c1ea3c]", "[5dceaba82e5bb7ee]", "[4d7bf08237c1ea3c]", "00")
    self.bid64_rem("1", "[8d40000000000000]", "[5f80000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[a48805a0f2caf9f8]", "[c360000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[afb236d07e3effc6]", "[5240000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "[da0793cd0c6c3581]", "[5940000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("1", "-Infinity", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("1", "Infinity", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("1", "SNaN", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("1", "SNaN", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("2", "-0", "0", "[7c00000000000000]", "01")
    self.bid64_rem("2", "0", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[08cd000000000000]", "[9446e2ab9830b5ea]", "[08cd000000000000]", "00")
    self.bid64_rem("2", "[08df000000000000]", "[19a0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[09f7000000000000]", "[c460000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "+0.E0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_rem("2", "0", "Infinity", "[31c0000000000000]", "00")
    self.bid64_rem("2", "-0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("2", "0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[10d5ec568879c7f0]", "[a2e0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[498aff06888ef77e]", "[1740000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[4d7bf08237c1ea3c]", "[5dceaba82e5bb7ee]", "[4d7bf08237c1ea3c]", "00")
    self.bid64_rem("2", "[8d40000000000000]", "[5f80000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[a48805a0f2caf9f8]", "[c360000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[afb236d07e3effc6]", "[5240000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "[da0793cd0c6c3581]", "[5940000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("2", "-Infinity", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("2", "Infinity", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("2", "SNaN", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("2", "SNaN", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("3", "-0", "0", "[7c00000000000000]", "01")
    self.bid64_rem("3", "0", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[08cd000000000000]", "[9446e2ab9830b5ea]", "[08cd000000000000]", "00")
    self.bid64_rem("3", "[08df000000000000]", "[19a0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[09f7000000000000]", "[c460000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "+0.E0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_rem("3", "0", "Infinity", "[31c0000000000000]", "00")
    self.bid64_rem("3", "-0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("3", "0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[10d5ec568879c7f0]", "[a2e0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[498aff06888ef77e]", "[1740000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[4d7bf08237c1ea3c]", "[5dceaba82e5bb7ee]", "[4d7bf08237c1ea3c]", "00")
    self.bid64_rem("3", "[8d40000000000000]", "[5f80000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[a48805a0f2caf9f8]", "[c360000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[afb236d07e3effc6]", "[5240000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "[da0793cd0c6c3581]", "[5940000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("3", "-Infinity", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("3", "Infinity", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("3", "SNaN", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("3", "SNaN", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("4", "-0", "0", "[7c00000000000000]", "01")
    self.bid64_rem("4", "0", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[08cd000000000000]", "[9446e2ab9830b5ea]", "[08cd000000000000]", "00")
    self.bid64_rem("4", "[08df000000000000]", "[19a0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[09f7000000000000]", "[c460000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "+0.E0", "QNaN", "[7c00000000000000]", "00")
    self.bid64_rem("4", "0", "Infinity", "[31c0000000000000]", "00")
    self.bid64_rem("4", "-0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("4", "0", "SNaN", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[10d5ec568879c7f0]", "[a2e0000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[498aff06888ef77e]", "[1740000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[4d7bf08237c1ea3c]", "[5dceaba82e5bb7ee]", "[4d7bf08237c1ea3c]", "00")
    self.bid64_rem("4", "[8d40000000000000]", "[5f80000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[a48805a0f2caf9f8]", "[c360000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[afb236d07e3effc6]", "[5240000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "[da0793cd0c6c3581]", "[5940000000000000]", "[7c00000000000000]", "01")
    self.bid64_rem("4", "-Infinity", "-0", "[7c00000000000000]", "01")
    self.bid64_rem("4", "Infinity", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("4", "SNaN", "Infinity", "[7c00000000000000]", "01")
    self.bid64_rem("4", "SNaN", "SNaN", "[7c00000000000000]", "01")
  }

  private func bid64_rem(
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
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.remainder(dividingBy: arg1, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)

    let result2 = self.remainderFromTruncatingRemainder(arg0, dividingBy: arg1)
    self.assertEqual(result2, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }

  func test_bid128_rem() {
    self.bid128_rem("0", "[0000008002452014,5e7ff56d67eb67a5]", "[000000c100000020,d277330430a0ee20]", "[80000040fdbae00c73f73d96c8b5867b]", "00")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[0065420a01b95380,dfae38016de45fb4]", "[96b1104022ac3cca,72c2b81d8fec995e]", "[0065420a01b95380dfae38016de45fb4]", "00")
    self.bid128_rem("0", "-0", "-0.E0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[010009020c420002,5ff98fbff95edf7e]", "[0104102400200020,f7ffffdef5efffff]", "[010009020c4200025ff98fbff95edf7e]", "00")
    self.bid128_rem("0", "[020000001320124c,79a07e3c04b31fb0]", "[ffffffffffffffff,9056a2027e3103c0]", "[fc000000000000000000000000000000]", "01")
    self.bid128_rem("0", "0", "-Infinity", "[30400000000000000000000000000000]", "00")
    self.bid128_rem("0", "-0", "-Infinity", "[b0400000000000000000000000000000]", "00")
    self.bid128_rem("0", "-0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "-0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[2000020002083001,af1b166bffda5dde]", "[2000000404224000,0000000000000000]", "[20000001f50a7001af1b166bffda5dde]", "00")
    self.bid128_rem("0", "[2000040000002200,f7fffffffd7fffff]", "[0100000000000000,0000000000000001]", "[01000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[25765e1113026459,e37ff77afe7ffdff]", "[fbffdff7bfb7ffa7,201a7081325d1c12]", "[25765e1113026459e37ff77afe7ffdff]", "00")
    self.bid128_rem("0", "[26741c0590811072,ffffffff6ef7ffff]", "[0000000000000000,0300040220100840]", "[8000000000000000015515ab6c6033c0]", "00")
    self.bid128_rem("0", "[397cdc9a254ff562,99bc2af7b316f57c]", "[268d807293a0dcac,afddbd631e831cbb]", "[a68c1d3c3991cbb19eee601c8bdcb12c]", "00")
    self.bid128_rem("0", "[3a1db514f8af9733,fefeffefffffffff]", "[c48ac2bddb9295e8,0110484000234290]", "[3a1db514f8af9733fefeffefffffffff]", "00")
    self.bid128_rem("0", "[3a46a1388afe6e50,5418c8e8d3d4bd4b]", "[7e0016f259f8f0aa,f6426a11cf634d38]", "[7c0016f259f8f0aaf6426a11cf634d38]", "01")
    self.bid128_rem("0", "[3aaf3f4db47ae4f2,3b2705d283e3d160]", "[c6626c7f2d14a3a1,0d507aea3bae04b8]", "[3aaf3f4db47ae4f23b2705d283e3d160]", "00")
    self.bid128_rem("0", "[4082000215010400,1f7dbeffb7fdff7d]", "[bfffbfff7ffa7fbf,240c30b8380ad037]", "[bffe0708356252ac4b444f585a0c6d93]", "00")
    self.bid128_rem("0", "[4dbc000000000000,0000000000000000]", "[4d138600f520137d,2001e957c4b7cc57]", "[4d120000000000000000000000000000]", "00")
    self.bid128_rem("0", "[55401804998161f1,6b735f43ecd46f95]", "[7800000000000000,0000000000000000]", "[55401804998161f16b735f43ecd46f95]", "00")
    self.bid128_rem("0", "[623df7ae457861bf,0e300840402b221c]", "[632cddb83f415035,db7e6ff75558f103]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "[8000000000000000,f8ba388cd7bc1c1b]", "[8040280400c45401,fefd71fd65bbeffd]", "[8000000000000000f8ba388cd7bc1c1b]", "00")
    self.bid128_rem("0", "[80060803004a1208,bde3f7effba3efbd]", "[3691feee73b72bd9,614cbbcb3aadc4f3]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[97f3ca2bca3dcd34,321ba8822721f58f]", "[8000000000000000,bae106a1402505d6]", "[000000000000000025bf9a7041265ffe]", "00")
    self.bid128_rem("0", "[9a00000000000000,0000000000000000]", "[bc58000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[9c5f9589d6c5fa51,caa6dcb43a12852e]", "[0080000000000000,0001000000000000]", "[80800000000000000000000000000000]", "00")
    self.bid128_rem("0", "[a1a32dc578f676e4,5bfb68dece45b7d8]", "[bc46000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[a7f734b7f7e7a516,229ddcc454df042c]", "[0000000000000002,9fc80ebfc7fed6d1]", "[800000000000000118eb45cf8f8cc645]", "00")
    self.bid128_rem("0", "[a9f8000000000000,0000000000000000]", "[419ecd52cafad77c,1c15d4445e2c728b]", "[a9f80000000000000000000000000000]", "00")
    self.bid128_rem("0", "[d75fff7bffffffff,084410100a41019d]", "[fe37efefde7bf7d7,c000906283812080]", "[fc002fefde7bf7d7c000906283812080]", "01")
    self.bid128_rem("0", "[f2c66c7b3c127bf9,0210014041804890]", "[838123dae0852091,0000000000000008]", "[83800000000000000000000000000000]", "00")
    self.bid128_rem("0", "[f363427e81567740,1012e9212556b005]", "[0200000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[f800000000000000,0000000000000000]", "[dabe000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[fade065e7bff6fbf,805415821d030f92]", "[a8c595b58b10f056,fdbeaf79d6fbbf9f]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "[ffae1f7bbbdfac9f,a1d2e802c5278780]", "[d0434d8a6060e814,0302011024001300]", "[fc001f7bbbdfac9fa1d2e802c5278780]", "01")
    self.bid128_rem("0", "-Infinity", "-0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("0", "-Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "QNaN", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("1", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("1", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("1", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "[0065420a01b95380,dfae38016de45fb4]", "[96b1104022ac3cca,72c2b81d8fec995e]", "[0065420a01b95380dfae38016de45fb4]", "00")
    self.bid128_rem("1", "-0", "-0.E0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "0", "-Infinity", "[30400000000000000000000000000000]", "00")
    self.bid128_rem("1", "-0", "-Infinity", "[b0400000000000000000000000000000]", "00")
    self.bid128_rem("1", "-0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("1", "-0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "[397cdc9a254ff562,99bc2af7b316f57c]", "[268d807293a0dcac,afddbd631e831cbb]", "[a68c1d3c3991cbb19eee601c8bdcb12c]", "00")
    self.bid128_rem("1", "[3a46a1388afe6e50,5418c8e8d3d4bd4b]", "[7e0016f259f8f0aa,f6426a11cf634d38]", "[7c0016f259f8f0aaf6426a11cf634d38]", "01")
    self.bid128_rem("1", "[3aaf3f4db47ae4f2,3b2705d283e3d160]", "[c6626c7f2d14a3a1,0d507aea3bae04b8]", "[3aaf3f4db47ae4f23b2705d283e3d160]", "00")
    self.bid128_rem("1", "[4dbc000000000000,0000000000000000]", "[4d138600f520137d,2001e957c4b7cc57]", "[4d120000000000000000000000000000]", "00")
    self.bid128_rem("1", "[55401804998161f1,6b735f43ecd46f95]", "[7800000000000000,0000000000000000]", "[55401804998161f16b735f43ecd46f95]", "00")
    self.bid128_rem("1", "[9a00000000000000,0000000000000000]", "[bc58000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "[a1a32dc578f676e4,5bfb68dece45b7d8]", "[bc46000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "[a9f8000000000000,0000000000000000]", "[419ecd52cafad77c,1c15d4445e2c728b]", "[a9f80000000000000000000000000000]", "00")
    self.bid128_rem("1", "[f800000000000000,0000000000000000]", "[dabe000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "-Infinity", "-0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("1", "-Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("1", "Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("1", "QNaN", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("2", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("2", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("2", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "[0065420a01b95380,dfae38016de45fb4]", "[96b1104022ac3cca,72c2b81d8fec995e]", "[0065420a01b95380dfae38016de45fb4]", "00")
    self.bid128_rem("2", "-0", "-0.E0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "0", "-Infinity", "[30400000000000000000000000000000]", "00")
    self.bid128_rem("2", "-0", "-Infinity", "[b0400000000000000000000000000000]", "00")
    self.bid128_rem("2", "-0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("2", "-0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "[397cdc9a254ff562,99bc2af7b316f57c]", "[268d807293a0dcac,afddbd631e831cbb]", "[a68c1d3c3991cbb19eee601c8bdcb12c]", "00")
    self.bid128_rem("2", "[3a46a1388afe6e50,5418c8e8d3d4bd4b]", "[7e0016f259f8f0aa,f6426a11cf634d38]", "[7c0016f259f8f0aaf6426a11cf634d38]", "01")
    self.bid128_rem("2", "[3aaf3f4db47ae4f2,3b2705d283e3d160]", "[c6626c7f2d14a3a1,0d507aea3bae04b8]", "[3aaf3f4db47ae4f23b2705d283e3d160]", "00")
    self.bid128_rem("2", "[4dbc000000000000,0000000000000000]", "[4d138600f520137d,2001e957c4b7cc57]", "[4d120000000000000000000000000000]", "00")
    self.bid128_rem("2", "[55401804998161f1,6b735f43ecd46f95]", "[7800000000000000,0000000000000000]", "[55401804998161f16b735f43ecd46f95]", "00")
    self.bid128_rem("2", "[9a00000000000000,0000000000000000]", "[bc58000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "[a1a32dc578f676e4,5bfb68dece45b7d8]", "[bc46000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "[a9f8000000000000,0000000000000000]", "[419ecd52cafad77c,1c15d4445e2c728b]", "[a9f80000000000000000000000000000]", "00")
    self.bid128_rem("2", "[f800000000000000,0000000000000000]", "[dabe000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "-Infinity", "-0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("2", "-Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("2", "Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("2", "QNaN", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("3", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("3", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("3", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "[0065420a01b95380,dfae38016de45fb4]", "[96b1104022ac3cca,72c2b81d8fec995e]", "[0065420a01b95380dfae38016de45fb4]", "00")
    self.bid128_rem("3", "-0", "-0.E0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "0", "-Infinity", "[30400000000000000000000000000000]", "00")
    self.bid128_rem("3", "-0", "-Infinity", "[b0400000000000000000000000000000]", "00")
    self.bid128_rem("3", "-0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("3", "-0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "[397cdc9a254ff562,99bc2af7b316f57c]", "[268d807293a0dcac,afddbd631e831cbb]", "[a68c1d3c3991cbb19eee601c8bdcb12c]", "00")
    self.bid128_rem("3", "[3a46a1388afe6e50,5418c8e8d3d4bd4b]", "[7e0016f259f8f0aa,f6426a11cf634d38]", "[7c0016f259f8f0aaf6426a11cf634d38]", "01")
    self.bid128_rem("3", "[3aaf3f4db47ae4f2,3b2705d283e3d160]", "[c6626c7f2d14a3a1,0d507aea3bae04b8]", "[3aaf3f4db47ae4f23b2705d283e3d160]", "00")
    self.bid128_rem("3", "[4dbc000000000000,0000000000000000]", "[4d138600f520137d,2001e957c4b7cc57]", "[4d120000000000000000000000000000]", "00")
    self.bid128_rem("3", "[55401804998161f1,6b735f43ecd46f95]", "[7800000000000000,0000000000000000]", "[55401804998161f16b735f43ecd46f95]", "00")
    self.bid128_rem("3", "[9a00000000000000,0000000000000000]", "[bc58000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "[a1a32dc578f676e4,5bfb68dece45b7d8]", "[bc46000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "[a9f8000000000000,0000000000000000]", "[419ecd52cafad77c,1c15d4445e2c728b]", "[a9f80000000000000000000000000000]", "00")
    self.bid128_rem("3", "[f800000000000000,0000000000000000]", "[dabe000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "-Infinity", "-0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("3", "-Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("3", "Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("3", "QNaN", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("4", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("4", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid128_rem("4", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "[0065420a01b95380,dfae38016de45fb4]", "[96b1104022ac3cca,72c2b81d8fec995e]", "[0065420a01b95380dfae38016de45fb4]", "00")
    self.bid128_rem("4", "-0", "-0.E0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "0", "-Infinity", "[30400000000000000000000000000000]", "00")
    self.bid128_rem("4", "-0", "-Infinity", "[b0400000000000000000000000000000]", "00")
    self.bid128_rem("4", "-0", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("4", "-0", "SNaN", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "[397cdc9a254ff562,99bc2af7b316f57c]", "[268d807293a0dcac,afddbd631e831cbb]", "[a68c1d3c3991cbb19eee601c8bdcb12c]", "00")
    self.bid128_rem("4", "[3a46a1388afe6e50,5418c8e8d3d4bd4b]", "[7e0016f259f8f0aa,f6426a11cf634d38]", "[7c0016f259f8f0aaf6426a11cf634d38]", "01")
    self.bid128_rem("4", "[3aaf3f4db47ae4f2,3b2705d283e3d160]", "[c6626c7f2d14a3a1,0d507aea3bae04b8]", "[3aaf3f4db47ae4f23b2705d283e3d160]", "00")
    self.bid128_rem("4", "[4dbc000000000000,0000000000000000]", "[4d138600f520137d,2001e957c4b7cc57]", "[4d120000000000000000000000000000]", "00")
    self.bid128_rem("4", "[55401804998161f1,6b735f43ecd46f95]", "[7800000000000000,0000000000000000]", "[55401804998161f16b735f43ecd46f95]", "00")
    self.bid128_rem("4", "[9a00000000000000,0000000000000000]", "[bc58000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "[a1a32dc578f676e4,5bfb68dece45b7d8]", "[bc46000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "[a9f8000000000000,0000000000000000]", "[419ecd52cafad77c,1c15d4445e2c728b]", "[a9f80000000000000000000000000000]", "00")
    self.bid128_rem("4", "[f800000000000000,0000000000000000]", "[dabe000000000000,0000000000000000]", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "-Infinity", "-0", "[7c000000000000000000000000000000]", "01")
    self.bid128_rem("4", "-Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("4", "Infinity", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("4", "QNaN", "QNaN", "[7c000000000000000000000000000000]", "00")
    self.bid128_rem("0", "99", "66", "-33", "00")
  }

  private func bid128_rem(
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
    guard let expectedStatus = self.parseStatus(_expectedStatus, file, line) else { return }

    var status = DecimalStatus()
    let result = arg0.remainder(dividingBy: arg1, status: &status)
    self.assertEqual(result, expected, .fuzzyStatus, file, line)

    let result2 = self.remainderFromTruncatingRemainder(arg0, dividingBy: arg1)
    self.assertEqual(result2, expected, .fuzzyStatus, file, line)
    self.assertStatus(status, expectedStatus, .fuzzyStatus, file, line)
  }
}
