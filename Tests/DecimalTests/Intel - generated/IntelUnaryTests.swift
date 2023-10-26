// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelUnaryTests: XCTestCase, IntelMixin {

  func test_bid32_negate() {
    self.bid32_negate("0", "[00000001]", "[80000001]", "00")
    self.bid32_negate("0", "[00080001]", "[80080001]", "00")
    self.bid32_negate("0", "-1.0", "[3200000a]", "00")
    self.bid32_negate("0", "1.0", "[b200000a]", "00")
    self.bid32_negate("0", "-1.0e-96", "[0200000a]", "00")
    self.bid32_negate("0", "1.0e-96", "[8200000a]", "00")
    self.bid32_negate("0", "[6098967f]", "[e098967f]", "00")
    self.bid32_negate("0", "[60989680]", "[e0989680]", "00")
    self.bid32_negate("0", "[7c000000]", "[fc000000]", "00")
    self.bid32_negate("0", "[7c8f423f]", "[fc8f423f]", "00")
    self.bid32_negate("0", "[7c8f4240]", "[fc8f4240]", "00")
    self.bid32_negate("0", "[7e100000]", "[fe100000]", "00")
    self.bid32_negate("0", "[7e100100]", "[fe100100]", "00")
    self.bid32_negate("0", "[7e8f423f]", "[fe8f423f]", "00")
    self.bid32_negate("0", "[7e8f4240]", "[fe8f4240]", "00")
    self.bid32_negate("0", "[80000001]", "[00000001]", "00")
    self.bid32_negate("0", "-9.999999e-95", "[6018967f]", "00")
    self.bid32_negate("0", "9.999999e-95", "[e018967f]", "00")
    self.bid32_negate("0", "-9.999999e96", "[77f8967f]", "00")
    self.bid32_negate("0", "9.999999e96", "[f7f8967f]", "00")
    self.bid32_negate("0", "[fc100000]", "[7c100000]", "00")
    self.bid32_negate("0", "[fc100100]", "[7c100100]", "00")
    self.bid32_negate("0", "[fe000000]", "[7e000000]", "00")
  }

  private func bid32_negate(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal32(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal32(_expected, file, line) else { return }

    let result1 = -arg0
    self.assertEqual(result1, expected, .fuzzyStatus, file, line)

    var result2 = arg0
    result2.negate()
    self.assertEqual(result2, expected, .fuzzyStatus, file, line)
  }

  func test_bid64_negate() {
    self.bid64_negate("0", "-0", "[31c0000000000000]", "00")
    self.bid64_negate("0", "0", "[b1c0000000000000]", "00")
    self.bid64_negate("0", "[0bd1000000000000]", "[8bd1000000000000]", "00")
    self.bid64_negate("0", "[0fcf000000000000]", "[8fcf000000000000]", "00")
    self.bid64_negate("0", "[13c0000000000000]", "[93c0000000000000]", "00")
    self.bid64_negate("0", "[286e30609a2e0627]", "[a86e30609a2e0627]", "00")
    self.bid64_negate("0", "[454b948762d28008]", "[c54b948762d28008]", "00")
    self.bid64_negate("0", "[51d48f690517f435]", "[d1d48f690517f435]", "00")
    self.bid64_negate("0", "[61e2cf8004a62830]", "[e1e2cf8004a62830]", "00")
    self.bid64_negate("0", "[9e592e1cd58718c1]", "[1e592e1cd58718c1]", "00")
    self.bid64_negate("0", "[b080000000000000]", "[3080000000000000]", "00")
    self.bid64_negate("0", "[b7ef8416f3c99d8b]", "[37ef8416f3c99d8b]", "00")
    self.bid64_negate("0", "[d4acd4c449d27624]", "[54acd4c449d27624]", "00")
    self.bid64_negate("0", "Infinity", "[f800000000000000]", "00")
    self.bid64_negate("0", "QNaN", "[fc00000000000000]", "00")
    self.bid64_negate("0", "SNaN", "[fe00000000000000]", "00")
  }

  private func bid64_negate(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal64(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal64(_expected, file, line) else { return }

    let result1 = -arg0
    self.assertEqual(result1, expected, .fuzzyStatus, file, line)

    var result2 = arg0
    result2.negate()
    self.assertEqual(result2, expected, .fuzzyStatus, file, line)
  }

  func test_bid128_negate() {
    self.bid128_negate("0", "[0001ed09bead87c0378d8e62ffffffff]", "[8001ed09bead87c0378d8e62ffffffff]", "00")
    self.bid128_negate("0", "[0001ed09bead87c0378d8e64ffffffff]", "[8001ed09bead87c0378d8e64ffffffff]", "00")
    self.bid128_negate("0", "-0", "[30400000000000000000000000000000]", "00")
    self.bid128_negate("0", "0", "[b0400000000000000000000000000000]", "00")
    self.bid128_negate("0", "[126fdbaf02bceaee,d9697b435c361fe1]", "[926fdbaf02bceaeed9697b435c361fe1]", "00")
    self.bid128_negate("0", "[2b237eb316d839ca,2d37d68b0227c11e]", "[ab237eb316d839ca2d37d68b0227c11e]", "00")
    self.bid128_negate("0", "[4e1c2958e3bd4c51,6f86468008d2aa28]", "[ce1c2958e3bd4c516f86468008d2aa28]", "00")
    self.bid128_negate("0", "[50d3b7f263af5b88,b87a6768ec8b46d0]", "[d0d3b7f263af5b88b87a6768ec8b46d0]", "00")
    self.bid128_negate("0", "[50d9e61cdd280bd8,e25a31953ffc0a48]", "[d0d9e61cdd280bd8e25a31953ffc0a48]", "00")
    self.bid128_negate("0", "[7c003fffffffffff38c15b08ffffffff]", "[fc003fffffffffff38c15b08ffffffff]", "00")
    self.bid128_negate("0", "[7c003fffffffffff38c15b0affffffff]", "[fc003fffffffffff38c15b0affffffff]", "00")
    self.bid128_negate("0", "[8daa55a8f5cff6db,55b5bea4a37b8a72]", "[0daa55a8f5cff6db55b5bea4a37b8a72]", "00")
    self.bid128_negate("0", "[9b147225df5ff554,350ecd34592da44a]", "[1b147225df5ff554350ecd34592da44a]", "00")
    self.bid128_negate("0", "[9e477b02c3805ef4,b738f98b244817dd]", "[1e477b02c3805ef4b738f98b244817dd]", "00")
    self.bid128_negate("0", "[a21e1edbb763cb70,4d680be7caaddd1a]", "[221e1edbb763cb704d680be7caaddd1a]", "00")
    self.bid128_negate("0", "[aa1a04dcb7d4ea0f,8363e10e1240d936]", "[2a1a04dcb7d4ea0f8363e10e1240d936]", "00")
    self.bid128_negate("0", "[fffffffffeffffba,b0086298e0a00010]", "[7ffffffffeffffbab0086298e0a00010]", "00")
    self.bid128_negate("0", "-Infinity", "[78000000000000000000000000000000]", "00")
    self.bid128_negate("0", "Infinity", "[f8000000000000000000000000000000]", "00")
    self.bid128_negate("0", "QNaN", "[fc000000000000000000000000000000]", "00")
    self.bid128_negate("0", "SNaN", "[fe000000000000000000000000000000]", "00")
  }

  private func bid128_negate(
    _ _rounding: String,
    _ _arg0: String,
    _ _expected: String,
    _ _expectedStatus: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let arg0 = self.parseDecimal128(_arg0, file, line) else { return }
    guard let expected = self.parseDecimal128(_expected, file, line) else { return }

    let result1 = -arg0
    self.assertEqual(result1, expected, .fuzzyStatus, file, line)

    var result2 = arg0
    result2.negate()
    self.assertEqual(result2, expected, .fuzzyStatus, file, line)
  }
}
