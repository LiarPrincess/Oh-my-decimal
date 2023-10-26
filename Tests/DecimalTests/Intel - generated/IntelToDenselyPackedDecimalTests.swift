// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelToDenselyPackedDecimalTests: XCTestCase, IntelMixin {

  func test_bid_to_dpd128() {
    self.bid_to_dpd128("0", "[00018a6e32246c99c60ad85000000001]", "[60000000000000000000000000000001]", "00")
    self.bid_to_dpd128("0", "[0001bbbbf868fa2cfecc335a0000000b]", "[64000000000000000000000000000011]", "00")
    self.bid_to_dpd128("0", "[0001ed09bead87c0378d8e62ffffffff]", "[64000ff3fcff3fcff3fcffa7f850cb83]", "00")
    self.bid_to_dpd128("0", "[0001ed09bead87c0378d8e64ffffffff]", "[00000000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[2000c5371912364ce3056c2800000001]", "[30000000000000000000000000000001]", "00")
    self.bid_to_dpd128("0", "[20018a6e32246c99c60ad850000000c9]", "[68000000000000000000000000000101]", "00")
    self.bid_to_dpd128("0", "[40000000000000000000000000000001]", "[40000000000000000000000000000001]", "00")
    self.bid_to_dpd128("0", "[4000c5371912364ce3056c2800000001]", "[50000000000000000000000000000001]", "00")
    self.bid_to_dpd128("0", "[40018a6e32246c99c60ad85000000fa1]", "[70000000000000000000000000001001]", "00")
    self.bid_to_dpd128("0", "[5ffc0000000000000000000000000001]", "[43ff8000000000000000000000000001]", "00")
    self.bid_to_dpd128("0", "[5fffed09bead87c0378d8e63fffffffe]", "[77ffcff3fcff3fcff3fcff3fcff3fcfe]", "00")
    self.bid_to_dpd128("0", "[5fffed09bead87c0378d8e63ffffffff]", "[77ffcff3fcff3fcff3fcff3fcff3fcff]", "00")
    self.bid_to_dpd128("0", "[7c000000000000000000000000000001]", "[7c000000000000000000000000000001]", "00")
    self.bid_to_dpd128("0", "[7c00314dc6448d9338c15b0b00000000]", "[7c000000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[7c003fffffffffff38c15b0affffffff]", "[7c000000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[d1ebb9a6abc8f235,0000000000001010]", "[f23d7ddf1f7514dce5d92444fb9ce00c]", "00")
    self.bid_to_dpd128("0", "[d75ffffbffffffff,000400c000000100]", "[c2ebc000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[e9d2f58ff58a18ae,17828fe467e1f528]", "[a0e94000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[fa8c419c31b4b492,e48b05e2288b0459]", "[f8000000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[fefffdfddffdff6f,eefffd68fdffb87f]", "[fe000000000000000000000000000000]", "00")
    self.bid_to_dpd128("0", "[7c000000000000000000000000000001]", "[7c000000000000000000000000000001]", "00")
  }

  private func bid_to_dpd128(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDenselyPackedDecimal128(_expected, file, line) else { return }

    let result = arg0.decimalEncoding
    self.assertInt(result, expected, file, line)
  }

  func test_bid_to_dpd32() {
    self.bid_to_dpd32("0", "[04000000]", "[00800000]", "00")
    self.bid_to_dpd32("0", "[0fff0000]", "[61f68c72]", "00")
    self.bid_to_dpd32("0", "[607fffff]", "[00300000]", "00")
    self.bid_to_dpd32("0", "[60989680]", "[00400000]", "00")
    self.bid_to_dpd32("0", "[69911d3e]", "[6cca4106]", "00")
    self.bid_to_dpd32("0", "[78000000]", "[78000000]", "00")
    self.bid_to_dpd32("0", "[7c000001]", "[7c000001]", "00")
    self.bid_to_dpd32("0", "[7c0be6ce]", "[7c0fe58e]", "00")
    self.bid_to_dpd32("0", "[7c0fffff]", "[7c000000]", "00")
    self.bid_to_dpd32("0", "[7c1f4240]", "[7c000000]", "00")
    self.bid_to_dpd32("0", "[f1644411]", "[f0bda0f7]", "00")
    self.bid_to_dpd32("0", "[fe000000]", "[fe000000]", "00")
    self.bid_to_dpd32("0", "[7c0f423f]", "[7c03fcff]", "00")
  }

  private func bid_to_dpd32(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDenselyPackedDecimal32(_expected, file, line) else { return }

    let result = arg0.decimalEncoding
    self.assertInt(result, expected, file, line)
  }

  func test_bid_to_dpd64() {
    self.bid_to_dpd64("0", "[0020002800000000]", "[0004003c7dec6c4c]", "00")
    self.bid_to_dpd64("0", "[002000a000000000]", "[000400dacdaf9de0]", "00")
    self.bid_to_dpd64("0", "[0060002800000000]", "[000c003c7dec6c4c]", "00")
    self.bid_to_dpd64("0", "[7c00000000000001]", "[7c00000000000001]", "00")
    self.bid_to_dpd64("0", "[8c0b7fb109411dd3]", "[8d8136c8c4b062f9]", "00")
    self.bid_to_dpd64("0", "[cfcd6c91c703bfcc]", "[cdfbf8b206241eae]", "00")
    self.bid_to_dpd64("0", "[dfff5f7f5fdfa6fb]", "[f3fc3ce91dc02243]", "00")
    self.bid_to_dpd64("0", "[e943604fa1585191]", "[eca3dda65909d765]", "00")
    self.bid_to_dpd64("0", "[e9adeffdfbbfc9f9]", "[a0d4000000000000]", "00")
    self.bid_to_dpd64("0", "[f8779eb18c7a5a7f]", "[f800000000000000]", "00")
    self.bid_to_dpd64("0", "[ff32ffdbfd0b7aa8]", "[fe024c5c161ea4ec]", "00")
    self.bid_to_dpd64("0", "[ffffffffffdf3fff]", "[fe00000000000000]", "00")
    self.bid_to_dpd64("0", "[7c00000000000001]", "[7c00000000000001]", "00")
  }

  private func bid_to_dpd64(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDenselyPackedDecimal64(_expected, file, line) else { return }

    let result = arg0.decimalEncoding
    self.assertInt(result, expected, file, line)
  }
}
