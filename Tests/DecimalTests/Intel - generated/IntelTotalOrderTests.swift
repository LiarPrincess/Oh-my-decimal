// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import XCTest
@testable import Decimal

class IntelTotalOrderTests: XCTestCase, IntelMixin {

  func test_bid32_totalOrder() {
    self.bid32_totalOrder("0", "[00000000]", "[21020082]", "1", "00")
    self.bid32_totalOrder("0", "[00000001]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[00080001]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "0E+89", "Infinity", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[00000001]", "0", "00")
    self.bid32_totalOrder("0", "1.0", "[00080001]", "0", "00")
    self.bid32_totalOrder("0", "1.00", "1", "1", "00")
    self.bid32_totalOrder("0", "1.0", "-1.0", "0", "00")
    self.bid32_totalOrder("0", "-1.0", "1.0", "1", "00")
    self.bid32_totalOrder("0", "1.0", "1.0", "1", "00")
    self.bid32_totalOrder("0", "1.0", "-1.0e-96", "0", "00")
    self.bid32_totalOrder("0", "1.0", "1.0e-96", "0", "00")
    self.bid32_totalOrder("0", "1.0", "[6098967f]", "0", "00")
    self.bid32_totalOrder("0", "1.0", "[60989680]", "0", "00")
    self.bid32_totalOrder("0", "1.0", "[7c000000]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[7c8f423f]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[7c8f4240]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[7e100000]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[7e100100]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[7e8f423f]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[7e8f4240]", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[80000001]", "0", "00")
    self.bid32_totalOrder("0", "1.0", "-9.999999e-95", "0", "00")
    self.bid32_totalOrder("0", "1.0", "9.999999e-95", "0", "00")
    self.bid32_totalOrder("0", "1.0", "-9.999999e96", "0", "00")
    self.bid32_totalOrder("0", "1.0", "9.999999e96", "1", "00")
    self.bid32_totalOrder("0", "1.0E+91", "1.234567E+95", "1", "00")
    self.bid32_totalOrder("0", "-1.0e-96", "1.0", "1", "00")
    self.bid32_totalOrder("0", "1.0e-96", "1.0", "1", "00")
    self.bid32_totalOrder("0", "1.0", "[fc100000]", "0", "00")
    self.bid32_totalOrder("0", "1.0", "[fc100100]", "0", "00")
    self.bid32_totalOrder("0", "1.0", "[fe000000]", "0", "00")
    self.bid32_totalOrder("0", "1", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[1913a25c]", "[17b56781]", "0", "00")
    self.bid32_totalOrder("0", "1E+89", "1E+90", "1", "00")
    self.bid32_totalOrder("0", "[3f000000]", "[01000000]", "0", "00")
    self.bid32_totalOrder("0", "[6098967f]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[60989680]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[78000000]", "[0a43704a]", "0", "00")
    self.bid32_totalOrder("0", "[7c000000]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[7c8f423f]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[7c8f423f]", "[7e100000]", "0", "00")
    self.bid32_totalOrder("0", "[7c8f423f]", "Infinity", "0", "00")
    self.bid32_totalOrder("0", "[7c8f4240]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[7e0afbfe]", "[7e000000]", "0", "00")
    self.bid32_totalOrder("0", "[7e0efddf]", "[7e07fffd]", "0", "00")
    self.bid32_totalOrder("0", "[7e100000]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[7e100100]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[7e8f423f]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[7e8f4240]", "1.0", "0", "00")
    self.bid32_totalOrder("0", "[80000001]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[90752206]", "[91045f9f]", "0", "00")
    self.bid32_totalOrder("0", "-9.999999e-95", "1.0", "1", "00")
    self.bid32_totalOrder("0", "9.999999e-95", "1.0", "1", "00")
    self.bid32_totalOrder("0", "9.999999e96", "1.0", "0", "00")
    self.bid32_totalOrder("0", "-9.999999e96", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[e9ee807c]", "[f8000000]", "0", "00")
    self.bid32_totalOrder("0", "[f8000000]", "[a7031841]", "1", "00")
    self.bid32_totalOrder("0", "[fc000000]", "[fe000000]", "1", "00")
    self.bid32_totalOrder("0", "[fc100000]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[fc100100]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[fe000000]", "1.0", "1", "00")
    self.bid32_totalOrder("0", "[fe000000]", "[fe0de7ff]", "0", "00")
    self.bid32_totalOrder("0", "[fe077e9f]", "[fe09ff9f]", "0", "00")
    self.bid32_totalOrder("0", "[fe07ffea]", "[fe000000]", "1", "00")
    self.bid32_totalOrder("0", "Infinity", "0E+89", "0", "00")
    self.bid32_totalOrder("0", "Infinity", "NaN", "1", "00")
    self.bid32_totalOrder("0", "[7e000000]", "[7e0b297f]", "1", "00")
    self.bid32_totalOrder("0", "[7c0f423f]", "NaN", "0", "00")
    self.bid32_totalOrder("0", "[7c000000]", "[7e000000]", "0", "00")
    self.bid32_totalOrder("0", "[7e000000]", "[7c000000]", "1", "00")
    self.bid32_totalOrder("0", "[fc000000]", "[fe000000]", "1", "00")
    self.bid32_totalOrder("0", "[fe000000]", "[fc000000]", "0", "00")
    self.bid32_totalOrder("0", "[7e000002]", "[7e000001]", "0", "00")
    self.bid32_totalOrder("0", "[7c000001]", "[7c000002]", "1", "00")
    self.bid32_totalOrder("0", "[fe000002]", "[fe000001]", "1", "00")
    self.bid32_totalOrder("0", "[78000001]", "[78000002]", "1", "00")
    self.bid32_totalOrder("0", "0", "1", "1", "00")
    self.bid32_totalOrder("0", "-0", "-1", "0", "00")
    self.bid32_totalOrder("0", "-1", "-0", "1", "00")
    self.bid32_totalOrder("0", "-12", "-10", "1", "00")
    self.bid32_totalOrder("0", "10", "12", "1", "00")
    self.bid32_totalOrder("0", "-10", "-12", "0", "00")
    self.bid32_totalOrder("0", "-2E+10", "-10", "1", "00")
    self.bid32_totalOrder("0", "10", "2E+10", "1", "00")
    self.bid32_totalOrder("0", "-10", "-2E+10", "0", "00")
    self.bid32_totalOrder("0", "99", "1E+2", "1", "00")
    self.bid32_totalOrder("0", "-99", "-1E+2", "0", "00")
    self.bid32_totalOrder("0", "-101", "-1E+2", "1", "00")
    self.bid32_totalOrder("0", "101", "1E+2", "0", "00")
    self.bid32_totalOrder("0", "[77f89680]", "[77f89681]", "1", "00")
  }

  private func bid32_totalOrder(
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

    let result = arg0.isTotallyOrdered(belowOrEqualTo: arg1)
    self.assertBool(result, expected, file, line)
  }

  func test_bid32_totalOrderMag() {
    self.bid32_totalOrderMag("0", "[00000000]", "[2d63d55d]", "1", "00")
    self.bid32_totalOrderMag("0", "[00000001]", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "[00080001]", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "[02080082]", "[00185004]", "0", "00")
    self.bid32_totalOrderMag("0", "0E+89", "0E+90", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[00000001]", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "[00080001]", "0", "00")
    self.bid32_totalOrderMag("0", "1.00", "1", "1", "00")
    self.bid32_totalOrderMag("0", "-1.0", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "-1.0", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "-1.0e-96", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "1.0e-96", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "[6098967f]", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "[60989680]", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7c000000]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7c8f423f]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7c8f4240]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7e100000]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7e100100]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7e8f423f]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[7e8f4240]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[80000001]", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "-9.999999e-95", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "9.999999e-95", "0", "00")
    self.bid32_totalOrderMag("0", "1.0", "-9.999999e96", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "9.999999e96", "1", "00")
    self.bid32_totalOrderMag("0", "-1.0e-96", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "1.0e-96", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[fc100000]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[fc100100]", "1", "00")
    self.bid32_totalOrderMag("0", "1.0", "[fe000000]", "1", "00")
    self.bid32_totalOrderMag("0", "1", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[39800000]", "[08000000]", "0", "00")
    self.bid32_totalOrderMag("0", "[4d6627c2]", "[00000000]", "0", "00")
    self.bid32_totalOrderMag("0", "[6098967f]", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "[60989680]", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "[7c000000]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[7c8f423f]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[7c8f423f]", "[7e100000]", "0", "00")
    self.bid32_totalOrderMag("0", "[7c8f423f]", "Infinity", "0", "00")
    self.bid32_totalOrderMag("0", "[7c8f4240]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[7e100000]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[7e100100]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[7e8f423f]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[7e8f4240]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[80000001]", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "[97f94c0c]", "[19a20ab1]", "1", "00")
    self.bid32_totalOrderMag("0", "-9.999999e-95", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "9.999999e-95", "1.0", "1", "00")
    self.bid32_totalOrderMag("0", "-9.999999e96", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "9.999999e96", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[bbaea547]", "[78000000]", "1", "00")
    self.bid32_totalOrderMag("0", "[f8000000]", "[04421908]", "0", "00")
    self.bid32_totalOrderMag("0", "[fc100000]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[fc100100]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[fe000000]", "1.0", "0", "00")
    self.bid32_totalOrderMag("0", "[fe000000]", "[fe000000]", "1", "00")
    self.bid32_totalOrderMag("0", "[fe0dedcf]", "[fe0affff]", "0", "00")
    self.bid32_totalOrderMag("0", "[fe0effff]", "[fe000000]", "0", "00")
    self.bid32_totalOrderMag("0", "Infinity", "NaN", "1", "00")
    self.bid32_totalOrderMag("0", "[7c000000]", "[7e000000]", "0", "00")
    self.bid32_totalOrderMag("0", "[7e000000]", "[7c000000]", "1", "00")
    self.bid32_totalOrderMag("0", "[fc000000]", "[fe000000]", "0", "00")
    self.bid32_totalOrderMag("0", "[fe000000]", "[fc000000]", "1", "00")
    self.bid32_totalOrderMag("0", "[78000000]", "[78000000]", "1", "00")
    self.bid32_totalOrderMag("0", "[f8000000]", "[f8000000]", "1", "00")
    self.bid32_totalOrderMag("0", "[32800001]", "[2F8F4240]", "0", "00")
    self.bid32_totalOrderMag("0", "[b2800001]", "[AF8F4240]", "0", "00")
    self.bid32_totalOrderMag("0", "[7e000002]", "[7e000001]", "0", "00")
    self.bid32_totalOrderMag("0", "[7c000001]", "[7c000002]", "1", "00")
    self.bid32_totalOrderMag("0", "[78000001]", "[78000002]", "1", "00")
    self.bid32_totalOrderMag("0", "101", "1E+2", "0", "00")
    self.bid32_totalOrderMag("0", "99", "1E+2", "1", "00")
    self.bid32_totalOrderMag("0", "1E+2", "101", "1", "00")
    self.bid32_totalOrderMag("0", "1E+2", "99", "0", "00")
  }

  private func bid32_totalOrderMag(
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

    let arg0Mag = arg0.magnitude
    let arg1Mag = arg1.magnitude
    let result = arg0Mag.isTotallyOrdered(belowOrEqualTo: arg1Mag)
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_totalOrder() {
    self.bid64_totalOrder("0", "0", "-0", "0", "00")
    self.bid64_totalOrder("0", "[0000000000000000]", "[0000000000000000]", "1", "00")
    self.bid64_totalOrder("0", "[0000000000000000]", "[6aeb34ffd6033a6b]", "1", "00")
    self.bid64_totalOrder("0", "[0006082180080050]", "[6dce1c55d77c6627]", "0", "00")
    self.bid64_totalOrder("0", "[0010230100040000]", "[0000000000000000]", "0", "00")
    self.bid64_totalOrder("0", "[0c3b000000000000]", "[be33a88e4eb91a55]", "0", "00")
    self.bid64_totalOrder("0", "-0", "QNaN", "1", "00")
    self.bid64_totalOrder("0", "0", "QNaN", "1", "00")
    self.bid64_totalOrder("0", "0", "SNaN", "1", "00")
    self.bid64_totalOrder("0", "1.0", "1", "1", "00")
    self.bid64_totalOrder("0", "1", "1.0", "0", "00")
    self.bid64_totalOrder("0", "[3c7e3b50324cdad4]", "[1f8869a841318bd3]", "0", "00")
    self.bid64_totalOrder("0", "[3f60e6ce2fb54e99]", "[8560efb99fe1a25a]", "0", "00")
    self.bid64_totalOrder("0", "[4151292dc7ddfb1f]", "[7bfffe6ecafbffff]", "1", "00")
    self.bid64_totalOrder("0", "[41849debe6a63955]", "[dbffacb4c26fd3d7]", "0", "00")
    self.bid64_totalOrder("0", "[44b806eafb78769d]", "[0640000000000000]", "0", "00")
    self.bid64_totalOrder("0", "[4b6d62a46e996446]", "[e3c8c6341743c275]", "0", "00")
    self.bid64_totalOrder("0", "[66e2cfdfe3bfbfdf]", "[e76a78fade4d5645]", "0", "00")
    self.bid64_totalOrder("0", "[751e6e94d0717b7e]", "[2a1f1efd5d0ad7da]", "1", "00")
    self.bid64_totalOrder("0", "[7bfb891c1f1ffc2f]", "[1af564ed868185c2]", "0", "00")
    self.bid64_totalOrder("0", "[7dab90d3d035a79a]", "[7dfb854bdd6bbd27]", "1", "00")
    self.bid64_totalOrder("0", "[7eff8406185cfc33]", "[7ff3dfdbb7dbccdf]", "0", "00")
    self.bid64_totalOrder("0", "[7f6cb6613f7fcf9f]", "[7d4bbd7355a38753]", "1", "00")
    self.bid64_totalOrder("0", "[7ffdfdfffbeb6fff]", "[7edb7be3d55e3ff6]", "1", "00")
    self.bid64_totalOrder("0", "[7ffffffedff99ffb]", "[fddadb79ef5f5fff]", "0", "00")
    self.bid64_totalOrder("0", "[8532eede32e2a8cf]", "[47080932e15557fb]", "1", "00")
    self.bid64_totalOrder("0", "[9be87b086d79f76a]", "[fcf3f1f5adbde7ef]", "0", "00")
    self.bid64_totalOrder("0", "[a2eb6743df3efd23]", "[49dce550ac84506e]", "1", "00")
    self.bid64_totalOrder("0", "[a3267a003b7ab3de]", "[ba58fbd307145e22]", "0", "00")
    self.bid64_totalOrder("0", "[afa2e30e0bbf5cbc]", "[a26ddb6b5f642f7e]", "1", "00")
    self.bid64_totalOrder("0", "[c301c82408095502]", "[c1db421e000440e8]", "1", "00")
    self.bid64_totalOrder("0", "[cc2ae74b8f509bd5]", "[cc84166baa1cff47]", "0", "00")
    self.bid64_totalOrder("0", "[d10505fc78a67979]", "[9cc0000000000000]", "1", "00")
    self.bid64_totalOrder("0", "[d9b8810fefc917b0]", "[44cd418c6d196c9f]", "1", "00")
    self.bid64_totalOrder("0", "[e0c377cb6a1bfd75]", "[ec0b6505adc3dd15]", "0", "00")
    self.bid64_totalOrder("0", "[e7f2d9d4efddf9ed]", "[9ecca8e8e2e6225b]", "1", "00")
    self.bid64_totalOrder("0", "[f4dd3a17d84856c2]", "[efbed79af883dff7]", "1", "00")
    self.bid64_totalOrder("0", "[f7ffdfffefbf7fff]", "[f7fffffffffaff7f]", "1", "00")
    self.bid64_totalOrder("0", "[f8f48edf7b7eed66]", "[9828040808fe386d]", "1", "00")
    self.bid64_totalOrder("0", "[fdedcae7dddedc7b]", "[fcf697bfb2f5be8d]", "0", "00")
    self.bid64_totalOrder("0", "[ffbffd77ffdbbf6e]", "[fffeafdbfffef7ff]", "0", "00")
    self.bid64_totalOrder("0", "[ffbffffffeffdfff]", "[ffffffffffffffff]", "1", "00")
    self.bid64_totalOrder("0", "[ffffeffbffefbfff]", "[f4fe78fdf4e4e9d7]", "1", "00")
    self.bid64_totalOrder("0", "[ffffffffffffffff]", "[fd9c97fbff77fff7]", "0", "00")
    self.bid64_totalOrder("0", "-Infinity", "Infinity", "1", "00")
    self.bid64_totalOrder("0", "Infinity", "SNaN", "1", "00")
    self.bid64_totalOrder("0", "QNaN", "0", "0", "00")
    self.bid64_totalOrder("0", "QNaN", "Infinity", "0", "00")
    self.bid64_totalOrder("0", "[7c00000000000000]", "[7e00000000000000]", "0", "00")
    self.bid64_totalOrder("0", "[7e00000000000000]", "[7c00000000000000]", "1", "00")
    self.bid64_totalOrder("0", "[fc00000000000000]", "[fe00000000000000]", "1", "00")
    self.bid64_totalOrder("0", "[fe00000000000000]", "[fc00000000000000]", "0", "00")
    self.bid64_totalOrder("0", "[fc03000000000002]", "[fc03000000000001]", "1", "00")
    self.bid64_totalOrder("0", "[7e03000000000001]", "[7e03000000000002]", "1", "00")
    self.bid64_totalOrder("0", "+Inf", "[7800000000000001]", "1", "00")
    self.bid64_totalOrder("0", "-2", "-Inf", "0", "00")
    self.bid64_totalOrder("0", "+0E+2", "+0", "0", "00")
    self.bid64_totalOrder("0", "-0", "-1.0", "0", "00")
    self.bid64_totalOrder("0", "123", "124E+1", "1", "00")
    self.bid64_totalOrder("0", "123E+20", "124E+1", "0", "00")
    self.bid64_totalOrder("0", "124", "1E+20", "1", "00")
    self.bid64_totalOrder("0", "-1E+14", "-10000E+10", "1", "00")
    self.bid64_totalOrder("0", "-1E+14", "-10001E+10", "0", "00")
    self.bid64_totalOrder("0", "1E+14", "10000E+10", "0", "00")
    self.bid64_totalOrder("0", "1E+14", "10001E+10", "1", "00")
    self.bid64_totalOrder("0", "-10000E+10", "-1E+14", "0", "00")
    self.bid64_totalOrder("0", "-10001E+10", "-1E+14", "1", "00")
    self.bid64_totalOrder("0", "10000E+10", "1E+14", "1", "00")
    self.bid64_totalOrder("0", "10001E+10", "1E+14", "0", "00")
  }

  private func bid64_totalOrder(
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

    let result = arg0.isTotallyOrdered(belowOrEqualTo: arg1)
    self.assertBool(result, expected, file, line)
  }

  func test_bid64_totalOrderMag() {
    self.bid64_totalOrderMag("0", "[0000000000000000]", "[0000000000000000]", "1", "00")
    self.bid64_totalOrderMag("0", "[0000000000000000]", "[d20670083d534a46]", "1", "00")
    self.bid64_totalOrderMag("0", "0", "-0", "1", "00")
    self.bid64_totalOrderMag("0", "[00483400205a0108]", "[add057004d852602]", "1", "00")
    self.bid64_totalOrderMag("0", "[00b38b8003045514]", "[0200000200000010]", "1", "00")
    self.bid64_totalOrderMag("0", "[0805627795f7eba4]", "[fff6fffffff7fffd]", "1", "00")
    self.bid64_totalOrderMag("0", "[0b00940c0b1b4608]", "[fa41ef73c1309469]", "1", "00")
    self.bid64_totalOrderMag("0", "[0e805bff31e759b3]", "[1ca72375d331f47e]", "1", "00")
    self.bid64_totalOrderMag("0", "-0", "QNaN", "1", "00")
    self.bid64_totalOrderMag("0", "0", "QNaN", "1", "00")
    self.bid64_totalOrderMag("0", "0", "SNaN", "1", "00")
    self.bid64_totalOrderMag("0", "1.0", "1", "1", "00")
    self.bid64_totalOrderMag("0", "[1042838468a08140]", "[0000000000000000]", "0", "00")
    self.bid64_totalOrderMag("0", "1", "1.0", "0", "00")
    self.bid64_totalOrderMag("0", "[114c9d58a9875a64]", "[b7ee522b503e48ec]", "1", "00")
    self.bid64_totalOrderMag("0", "[1ac0000000000000]", "[0ae3000000000000]", "1", "00")
    self.bid64_totalOrderMag("0", "[41ea521fb46122c8]", "[c680b612e2260824]", "1", "00")
    self.bid64_totalOrderMag("0", "[562c25bc1f510abe]", "[f0db2d59a451555a]", "0", "00")
    self.bid64_totalOrderMag("0", "[6485f1b24ce8f132]", "[46a4d9ff4d79acc6]", "1", "00")
    self.bid64_totalOrderMag("0", "[7de33f7afafffbe7]", "[ff3e7ecffaee79bb]", "0", "00")
    self.bid64_totalOrderMag("0", "[7ebfbeccd7abf5fd]", "[f3a8462662a1b521]", "0", "00")
    self.bid64_totalOrderMag("0", "[7ff7f7d77ff3955d]", "[ffffcfbfffffffff]", "1", "00")
    self.bid64_totalOrderMag("0", "[7fff7fb3fff7fbff]", "[ffffbfdffffffffe]", "0", "00")
    self.bid64_totalOrderMag("0", "[8019705df2d97759]", "[39f7cd4942b7e9bd]", "1", "00")
    self.bid64_totalOrderMag("0", "[861f7326409d7e2f]", "[98b2ffef06945516]", "1", "00")
    self.bid64_totalOrderMag("0", "[9760a805c4aca603]", "[690eb432257773e3]", "0", "00")
    self.bid64_totalOrderMag("0", "[9cff4f9fbb20d24c]", "[c3904953ae1cae58]", "1", "00")
    self.bid64_totalOrderMag("0", "[ae94a16fa3e37d1e]", "[c7474bda93dac462]", "1", "00")
    self.bid64_totalOrderMag("0", "[b1c17d35c37c6403]", "[b0de5d7824d03b0b]", "0", "00")
    self.bid64_totalOrderMag("0", "[d200000000000000]", "[eec1895edf539d95]", "1", "00")
    self.bid64_totalOrderMag("0", "[df8dafd6481a0b9b]", "[f41933285dc060a0]", "0", "00")
    self.bid64_totalOrderMag("0", "[ebb10b24d1cc0719]", "[c22aa1ef3bb5db78]", "1", "00")
    self.bid64_totalOrderMag("0", "[ebfffbffffffffff]", "[6e97e7f87bc60295]", "1", "00")
    self.bid64_totalOrderMag("0", "[eff968927d3c49e4]", "[923a2ad67a9ea634]", "0", "00")
    self.bid64_totalOrderMag("0", "[f81696b10870a09a]", "[4de22fca6a2c3fa4]", "0", "00")
    self.bid64_totalOrderMag("0", "[ff7b3ebefedc78fc]", "[ffb6ffff7f7ffff3]", "0", "00")
    self.bid64_totalOrderMag("0", "-Infinity", "Infinity", "1", "00")
    self.bid64_totalOrderMag("0", "Infinity", "SNaN", "1", "00")
    self.bid64_totalOrderMag("0", "QNaN", "0", "0", "00")
    self.bid64_totalOrderMag("0", "QNaN", "Infinity", "0", "00")
    self.bid64_totalOrderMag("0", "[7c00000000000000]", "[7e00000000000000]", "0", "00")
    self.bid64_totalOrderMag("0", "[7e00000000000000]", "[7c00000000000000]", "1", "00")
    self.bid64_totalOrderMag("0", "[fc00000000000000]", "[fe00000000000000]", "0", "00")
    self.bid64_totalOrderMag("0", "[fe00000000000000]", "[fc00000000000000]", "1", "00")
    self.bid64_totalOrderMag("0", "[7800000000000000]", "[7800000000000000]", "1", "00")
    self.bid64_totalOrderMag("0", "[f800000000000000]", "[f800000000000000]", "1", "00")
    self.bid64_totalOrderMag("0", "[31C0000000000001]", "[2FE38D7EA4C68000]", "0", "00")
    self.bid64_totalOrderMag("0", "[B1C0000000000001]", "[AFE38D7EA4C68000]", "0", "00")
    self.bid64_totalOrderMag("0", "[7c03000000000001]", "[7c03000000000002]", "1", "00")
    self.bid64_totalOrderMag("0", "Inf", "[7800000000000001]", "1", "00")
    self.bid64_totalOrderMag("0", "0E+2", "0", "0", "00")
    self.bid64_totalOrderMag("0", "1E+14", "10001E+10", "1", "00")
    self.bid64_totalOrderMag("0", "10001E+10", "1E+14", "0", "00")
    self.bid64_totalOrderMag("0", "1E+14", "10000E+10", "0", "00")
  }

  private func bid64_totalOrderMag(
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

    let arg0Mag = arg0.magnitude
    let arg1Mag = arg1.magnitude
    let result = arg0Mag.isTotallyOrdered(belowOrEqualTo: arg1Mag)
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_totalOrder() {
    self.bid128_totalOrder("0", "[0000000000000000,ffffffffffffffff]", "[0000000000000000,ffffffffffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0000800001000200,028008416282930c]", "[0020008101001000,2020400c02040100]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrder("0", "[0004000020130048,25fa092c1e1ee6c8]", "[0000400000000000,0cd15632d0300103]", "1", "00")
    self.bid128_totalOrder("0", "[004a580447021010,018f6f3bbd0d2b88]", "[0084008281a14083,fb7dfdffff77ffff]", "1", "00")
    self.bid128_totalOrder("0", "[0d000c1446001003,fff5ffffffffffff]", "[08002e0002094414,78f0040000120004]", "0", "00")
    self.bid128_totalOrder("0", "0", "-Infinity", "0", "00")
    self.bid128_totalOrder("0", "0", "QNaN", "1", "00")
    self.bid128_totalOrder("0", "1.0", "1", "1", "00")
    self.bid128_totalOrder("0", "1", "1.0", "0", "00")
    self.bid128_totalOrder("0", "[133a000000000000,0000000000000000]", "[2ade000000000000,0000000000000000]", "1", "00")
    self.bid128_totalOrder("0", "[14802824191014a1,779d8daf351dfbee]", "[144d08441c682a02,8020066102104124]", "0", "00")
    self.bid128_totalOrder("0", "[185f5fa24d678c66,b29a0597043e64fc]", "[6400200200000000,2fffddfefff3e34e]", "0", "00")
    self.bid128_totalOrder("0", "[246b0a5e3e2f0324,8efd6c2a05a2acea]", "[278b7fd44a9b967a,a629ff533ce0677a]", "1", "00")
    self.bid128_totalOrder("0", "[32696fa0fd49eb8d,f7318b060050df56]", "[bac66c3159b9fa68,2e68dc8db7f63bd8]", "0", "00")
    self.bid128_totalOrder("0", "[3a28583606597e4c,b960d8f0ddd43c6b]", "[34fe000000000000,0000000000000000]", "0", "00")
    self.bid128_totalOrder("0", "[53ae5da8aee8ba2e,8dfcb7418d496b79]", "[bbc600ff3db059c2,1ee248bdb3d15c2c]", "0", "00")
    self.bid128_totalOrder("0", "[58ba441288e818be,bc6faf765177bea8]", "[c391142a9af6d586,7fd21fc8b8784561]", "0", "00")
    self.bid128_totalOrder("0", "[6afe92605d9dbde4,1406dc372a61e19d]", "[6e67cd1242f59aad,8bc82ab07f0ec0b7]", "1", "00")
    self.bid128_totalOrder("0", "[7bef7f677f3afb5f,1348491fb70fa9ca]", "[4244302914040e41,f9485447f5f41a0b]", "0", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrder("0", "[7f38682481572d59,0b67b82e477cd7de]", "[7fd6165ccd7e3941,55c06abeb13d164a]", "0", "00")
    self.bid128_totalOrder("0", "[7f92e6cefdbfdbf5,acfef76ffcf9fdfe]", "[7c634f77456b79ab,c09a0440490302b8]", "1", "00")
    self.bid128_totalOrder("0", "[7fbddf7fe0f7fcef,0000000000000044]", "[5538785dc81d8f21,69efe5ec26c4cc1c]", "0", "00")
    self.bid128_totalOrder("0", "[7fbfffffffffefff,dfbffeffdbff3fd3]", "[7e77797e867ffee6,fe47ae03f239dee9]", "1", "00")
    self.bid128_totalOrder("0", "[7fdcd2f4deacbfad,83fef3574ff7cf17]", "[7edfbefe5d3fff9f,df96ca7b7356e9ea]", "0", "00")
    self.bid128_totalOrder("0", "[84805120d24f0803,97907a7f05a0db1a]", "[df7fbff77f7bbdbf,16baefbfbfffbffd]", "0", "00")
    self.bid128_totalOrder("0", "[9321daf777a7c9f7,45012202bd800100]", "[c0a4e6830729b80d,0000008000000900]", "0", "00")
    self.bid128_totalOrder("0", "[95c6a7ea4b25d7cf,6c8e2de8dcd31341]", "[0000000000100000,6086088f8a13d900]", "1", "00")
    self.bid128_totalOrder("0", "[b4ed28f193776566,50ede266cec5a024]", "[8500081120808040,9fa00800188f365c]", "1", "00")
    self.bid128_totalOrder("0", "[b78f9a2ad65fd8af,c2fdac509f2bdc67]", "[b5e738ae96c4c8f6,974cd11cdcd27cc8]", "1", "00")
    self.bid128_totalOrder("0", "[bfbffeff4fffff9f,ffffffffffffcfff]", "[efef96ffddfffd9e,6c964cc486963418]", "1", "00")
    self.bid128_totalOrder("0", "[cb79c5a0de13eb98,e8aecf850026cca6]", "[3cfba2a583390d06,4d0547c14266f9e3]", "1", "00")
    self.bid128_totalOrder("0", "[ddf2cc200b3b8941,afcf7ffef1ffff79]", "[fbdfb7ffa99fff7b,93bbb3f53fec6fc6]", "0", "00")
    self.bid128_totalOrder("0", "[dee13a4422840ac7,080a21756dda1bfe]", "[a5ae000000000000,0000000000000000]", "1", "00")
    self.bid128_totalOrder("0", "[e0a24502dd0784c2,364c30b8f85ed837]", "[a7b1e02861f61979,68317a09807c26cf]", "0", "00")
    self.bid128_totalOrder("0", "[f77ffffff7ffb9f7,ffffffffffffffff]", "[feef85516b0b4d6c,2de2a3a4a70855ca]", "0", "00")
    self.bid128_totalOrder("0", "[f800000000000000,0000000000000000]", "[4c094a8ea1ef7251,af241ec9d388942a]", "1", "00")
    self.bid128_totalOrder("0", "[fbeeb7ff032f7ff7,0000200012010000]", "[e7efd96f747f796f,ffffffffffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[fdf2ff2dff6bbf7a,2818000001000250]", "[ff2c8f8b4b10c818,5c26005e04e5b158]", "1", "00")
    self.bid128_totalOrder("0", "[feffeffffedefdff,bffb587655e7a90e]", "[ff6edfefffefffdd,a0002655100208c8]", "1", "00")
    self.bid128_totalOrder("0", "[ffeffbffbfbacdff,529db3ce9947f86b]", "[1bfe5c2f9969b3f7,bfe3fbfdffdffe7f]", "1", "00")
    self.bid128_totalOrder("0", "[ffffffff7fdffdff,4cb54af98e997b8a]", "[fffdfefdfdfff777,0100000000008084]", "1", "00")
    self.bid128_totalOrder("0", "[ffffffffffffffff,ffefdfffffffff9f]", "[ffbc1f7fbbddcc7f,0150880281258400]", "0", "00")
    self.bid128_totalOrder("0", "Infinity", "0", "0", "00")
    self.bid128_totalOrder("0", "Infinity", "QNaN", "1", "00")
    self.bid128_totalOrder("0", "-Infinity", "SNaN", "1", "00")
    self.bid128_totalOrder("0", "Infinity", "SNaN", "1", "00")
    self.bid128_totalOrder("0", "QNaN", "0", "0", "00")
    self.bid128_totalOrder("0", "QNaN", "-Infinity", "0", "00")
    self.bid128_totalOrder("0", "SNaN", "QNaN", "1", "00")
    self.bid128_totalOrder("0", "[7c00314dc6448d9338c15b09ffffffff]", "[7c00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[fc00314dc6448d9338c15b09ffffffff]", "[fc00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[7c00314dc6448d9338c15b09ffffffff]", "[7c00314dc6448d9338c15b0a00000000]", "0", "00")
    self.bid128_totalOrder("0", "[fc00314dc6448d9338c15b09ffffffff]", "[fc00314dc6448d9338c15b0a00000000]", "1", "00")
    self.bid128_totalOrder("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrder("0", "[fc00314dc6448d9338c15b0a00000000]", "[fc00314dc6448d9338c15b09ffffffff]", "0", "00")
    self.bid128_totalOrder("0", "[7c000000000000000000000000000000]", "[7e000000000000000000000000000000]", "0", "00")
    self.bid128_totalOrder("0", "[7e000000000000000000000000000000]", "[7c000000000000000000000000000000]", "1", "00")
    self.bid128_totalOrder("0", "[fc000000000000000000000000000000]", "[fe000000000000000000000000000000]", "1", "00")
    self.bid128_totalOrder("0", "[fe000000000000000000000000000000]", "[fc000000000000000000000000000000]", "0", "00")
    self.bid128_totalOrder("0", "11E+3", "8E+2", "0", "00")
    self.bid128_totalOrder("0", "-12323E-21", "-21324E-122", "1", "00")
    self.bid128_totalOrder("0", "1E+40", "100000000000000000000E+20", "0", "00")
    self.bid128_totalOrder("0", "100000000000000000000E+20", "1E+40", "1", "00")
    self.bid128_totalOrder("0", "-1E+40", "-100000000000000000000E+20", "1", "00")
    self.bid128_totalOrder("0", "-100000000000000000000E+20", "-1E+40", "0", "00")
    self.bid128_totalOrder("0", "+Inf", "+Inf", "1", "00")
    self.bid128_totalOrder("0", "[78000000000000000000000000000001]", "+Inf", "1", "00")
    self.bid128_totalOrder("0", "1", "+Inf", "1", "00")
    self.bid128_totalOrder("0", "-0", "-0E-2", "1", "00")
    self.bid128_totalOrder("0", "1E+40", "9999999999999999999E+20", "0", "00")
    self.bid128_totalOrder("0", "1E+40", "100000000000000000001E+20", "1", "00")
    self.bid128_totalOrder("0", "-1E+40", "-9999999999999999999E+20", "1", "00")
    self.bid128_totalOrder("0", "-1E+40", "-100000000000000000001E+20", "0", "00")
    self.bid128_totalOrder("0", "9999999999999999999E+20", "1E+40", "1", "00")
    self.bid128_totalOrder("0", "100000000000000000001E+20", "1E+40", "0", "00")
    self.bid128_totalOrder("0", "-9999999999999999999E+20", "-1E+40", "0", "00")
    self.bid128_totalOrder("0", "-100000000000000000001E+20", "-1E+40", "1", "00")
    self.bid128_totalOrder("0", "1E+20", "1000000000000000E+5", "0", "00")
    self.bid128_totalOrder("0", "-1E+20", "-1000000000000000E+5", "1", "00")
    self.bid128_totalOrder("0", "-1E+20", "-1000000000000001E+5", "0", "00")
    self.bid128_totalOrder("0", "1E+20", "1000000000000001E+5", "1", "00")
    self.bid128_totalOrder("0", "1000000000000000E+5", "1E+20", "1", "00")
    self.bid128_totalOrder("0", "-1000000000000000E+5", "-1E+20", "0", "00")
    self.bid128_totalOrder("0", "-1000000000000001E+5", "-1E+20", "1", "00")
    self.bid128_totalOrder("0", "1000000000000001E+5", "1E+20", "0", "00")
    self.bid128_totalOrder("0", "-99999999999999999999999E+20", "-999999999999999999999999999999E+1", "1", "00")
    self.bid128_totalOrder("0", "1E+1", "1E+35", "1", "00")
  }

  private func bid128_totalOrder(
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

    let result = arg0.isTotallyOrdered(belowOrEqualTo: arg1)
    self.assertBool(result, expected, file, line)
  }

  func test_bid128_totalOrderMag() {
    self.bid128_totalOrderMag("0", "[0000000000000000,ffffffffffffffff]", "[0000000000000000,ffffffffffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e62ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e62ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e64ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[0001ed09bead87c0378d8e64ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "0", "-0", "1", "00")
    self.bid128_totalOrderMag("0", "[0028314020110011,e6ac6b687fdf8799]", "[0000508709422280,cffbffd796feef77]", "0", "00")
    self.bid128_totalOrderMag("0", "[003fbc5db19556c4,7f5c8cd6a1b1f29f]", "[007c01b21f5380be,1a0a082210006c07]", "1", "00")
    self.bid128_totalOrderMag("0", "[0210a24480458100,581bf32f8507f4cb]", "[9dce33bbbd6a92f1,302ddfeacd6c884e]", "1", "00")
    self.bid128_totalOrderMag("0", "[088dda260a6cc577,fffeffffffeffffd]", "[0002000003814020,fffbdb57fabe5e73]", "0", "00")
    self.bid128_totalOrderMag("0", "1.0", "1", "1", "00")
    self.bid128_totalOrderMag("0", "1", "1.0", "0", "00")
    self.bid128_totalOrderMag("0", "[276a000000000000,0000000000000000]", "[be5753c0543a6cf9,c8d5b1e8301dadec]", "1", "00")
    self.bid128_totalOrderMag("0", "[2a129da1c2c8ab57,c05bf2f3a3dd6c79]", "[24b76ab1cf5b1ccf,7bdb02f454ec5262]", "0", "00")
    self.bid128_totalOrderMag("0", "[3550000000000000,0000000000000000]", "[d47d8d9d12923a2f,df4548763768b5c4]", "1", "00")
    self.bid128_totalOrderMag("0", "[4000280084800001,adeaa717a9cb1212]", "[bfdba7ce3f6fefbd,b81fe6de106e659d]", "0", "00")
    self.bid128_totalOrderMag("0", "[4dd2000000000000,0000000000000000]", "[ce0c000000000000,0000000000000000]", "1", "00")
    self.bid128_totalOrderMag("0", "[5169449868718a6a,c0159130231f8508]", "[d1ffd1569cfa3483,e96b8cbb20bf3378]", "1", "00")
    self.bid128_totalOrderMag("0", "[5b52000000000000,0000000000000000]", "[7e00147c43f054b1,ad3a93204a1da3d9]", "1", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b08ffffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b08ffffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e62ffffffff]", "0", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b0affffffff]", "[0001ed09bead87c0378d8e64ffffffff]", "0", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b08ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[7c003fffffffffff38c15b0affffffff]", "[7c003fffffffffff38c15b0affffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[82190be94470063f,10401000c0508100]", "[82247014e98cc58c,01162860c1040200]", "1", "00")
    self.bid128_totalOrderMag("0", "[86269a7979ca2d87,4978b5044e274c0a]", "[d5b8b907c86dbdcb,94841026237637ed]", "1", "00")
    self.bid128_totalOrderMag("0", "[89052df8fc1fffe8,b97605d51a4d31d8]", "[ca41a994068522df,cc95eb1728935769]", "1", "00")
    self.bid128_totalOrderMag("0", "[affafda2ee0927d4,40a387e5f875866b]", "[7800000000000000,0000000000000000]", "1", "00")
    self.bid128_totalOrderMag("0", "[bc161ffd96c45d0d,615042fd53173352]", "[eb7de35af4f967bb,fdff5dfb6deffdfe]", "0", "00")
    self.bid128_totalOrderMag("0", "[be53197ffac646e2,ef8ba7eecb1f798b]", "[fadc2fd79bc3de5b,7ef77ff5f7f78b7f]", "1", "00")
    self.bid128_totalOrderMag("0", "[cd648f28071ceffd,84e53b0e64b782fb]", "[d5d831cbf0718403,2fe43caf13be00bb]", "1", "00")
    self.bid128_totalOrderMag("0", "[d75ffb7b77efff1d,b1440e2a480d018a]", "[f3151396fee635a0,02bb952491cb9fbb]", "0", "00")
    self.bid128_totalOrderMag("0", "[da9eb397b9a8a0e7,667c064baeeb9399]", "[a168cfa21b0d15db,8b8d052f84264e13]", "0", "00")
    self.bid128_totalOrderMag("0", "[edf53ff1f7fcf3a5,1000821c0b10266c]", "[ff3ded162f7635f7,0818580950004148]", "1", "00")
    self.bid128_totalOrderMag("0", "[eeaf6da8b4958a35,3e6b3e71cdf8871c]", "[42e6362eb8e491c5,9901200038910e58]", "1", "00")
    self.bid128_totalOrderMag("0", "[efffeffbf7ffffff,f7ef5ffeddf9defa]", "[3ffffff7fffff7ff,84084b013e452495]", "1", "00")
    self.bid128_totalOrderMag("0", "[fa56994806d37cc8,5af4e64953940c4f]", "[5e0e5ebce21eb6bb,feefdefd3b6ff3ef]", "0", "00")
    self.bid128_totalOrderMag("0", "[fc002aa35b8e7285,75fa419351eef6dc]", "[b22837a2d039a8bf,438738bbbbc1eb45]", "0", "00")
    self.bid128_totalOrderMag("0", "[fef7fefffaffffff,fffffeffeffedaff]", "[03de304a7b96c292,3f63a7c7fffb6fdf]", "0", "00")
    self.bid128_totalOrderMag("0", "[ff3af6697ebbffff,3ed6db7d1db085ee]", "[7c5f158e134285fb,cb700965f8b4ea03]", "1", "00")
    self.bid128_totalOrderMag("0", "[ff3fdffcfeffdbbe,cbfe75e3bded5b74]", "[fe4feef72fc7fff6,1ecc263683f984d3]", "1", "00")
    self.bid128_totalOrderMag("0", "[fffad7edfe7f3336,0900100008013144]", "[ffffffffffffffff,4fb1ce6acb373b57]", "0", "00")
    self.bid128_totalOrderMag("0", "[ffffffffffffffff,3008004900200008]", "[fffeabffffffffff,95a2105266a63869]", "1", "00")
    self.bid128_totalOrderMag("0", "Infinity", "SNaN", "1", "00")
    self.bid128_totalOrderMag("0", "QNaN", "-0", "0", "00")
    self.bid128_totalOrderMag("0", "QNaN", "-Infinity", "0", "00")
    self.bid128_totalOrderMag("0", "SNaN", "-0", "0", "00")
    self.bid128_totalOrderMag("0", "SNaN", "0", "0", "00")
    self.bid128_totalOrderMag("0", "SNaN", "-2.3565784324E0", "0", "00")
    self.bid128_totalOrderMag("0", "SNaN", "-Infinity", "0", "00")
    self.bid128_totalOrderMag("0", "[7c00314dc6448d9338c15b09ffffffff]", "[7c00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[fc00314dc6448d9338c15b09ffffffff]", "[fc00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[7c00314dc6448d9338c15b09ffffffff]", "[7c00314dc6448d9338c15b0a00000000]", "0", "00")
    self.bid128_totalOrderMag("0", "[fc00314dc6448d9338c15b09ffffffff]", "[fc00314dc6448d9338c15b0a00000000]", "0", "00")
    self.bid128_totalOrderMag("0", "[7c00314dc6448d9338c15b0a00000000]", "[7c00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[fc00314dc6448d9338c15b0a00000000]", "[fc00314dc6448d9338c15b09ffffffff]", "1", "00")
    self.bid128_totalOrderMag("0", "[7c000000000000000000000000000000]", "[7e000000000000000000000000000000]", "0", "00")
    self.bid128_totalOrderMag("0", "[7e000000000000000000000000000000]", "[7c000000000000000000000000000000]", "1", "00")
    self.bid128_totalOrderMag("0", "[fc000000000000000000000000000000]", "[fe000000000000000000000000000000]", "0", "00")
    self.bid128_totalOrderMag("0", "[fe000000000000000000000000000000]", "[fc000000000000000000000000000000]", "1", "00")
    self.bid128_totalOrderMag("0", "[78000000000000000000000000000000]", "[78000000000000000000000000000000]", "1", "00")
    self.bid128_totalOrderMag("0", "[f8000000000000000000000000000000]", "[f8000000000000000000000000000000]", "1", "00")
    self.bid128_totalOrderMag("0", "[30400000000000000000000000000001]", "[2FFE314DC6448D9338C15B0A00000000]", "0", "00")
    self.bid128_totalOrderMag("0", "[b0400000000000000000000000000001]", "[AFFE314DC6448D9338C15B0A00000000]", "0", "00")
    self.bid128_totalOrderMag("0", "[78000000000000000000000000000001]", "+Inf", "1", "00")
    self.bid128_totalOrderMag("0", "1E+40", "9999999999999999999E+20", "0", "00")
    self.bid128_totalOrderMag("0", "1E+40", "100000000000000000001E+20", "1", "00")
    self.bid128_totalOrderMag("0", "9999999999999999999E+20", "1E+40", "1", "00")
    self.bid128_totalOrderMag("0", "100000000000000000001E+20", "1E+40", "0", "00")
    self.bid128_totalOrderMag("0", "1E+20", "1000000000000000E+5", "0", "00")
    self.bid128_totalOrderMag("0", "1E+20", "1000000000000001E+5", "1", "00")
    self.bid128_totalOrderMag("0", "1000000000000000E+5", "1E+20", "1", "00")
    self.bid128_totalOrderMag("0", "1000000000000001E+5", "1E+20", "0", "00")
    self.bid128_totalOrderMag("0", "1E+40", "100000000000000000000E+20", "0", "00")
    self.bid128_totalOrderMag("0", "100000000000000000000E+20", "1E+40", "1", "00")
  }

  private func bid128_totalOrderMag(
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

    let arg0Mag = arg0.magnitude
    let arg1Mag = arg1.magnitude
    let result = arg0Mag.isTotallyOrdered(belowOrEqualTo: arg1Mag)
    self.assertBool(result, expected, file, line)
  }
}
