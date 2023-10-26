import XCTest
import Foundation
import Cbid
@testable import Decimal

class Experiments: XCTestCase {

  func test_main() {
    let separator = String(repeating: "-", count: 80)
    print(separator)
    defer { print(separator) }

    func pad<T: CustomStringConvertible>(_ t: T, _ count: Int) -> String {
      let s = String(describing: t)
      let c = max(0, count - s.count)
      return s + String(repeating: " ", count: c)
    }

    func pad(_ d: Double, _ count: Int = 0) -> String {
      let s = String(format: "%20f", arguments: [d])
      return pad(s, count)
    }
  }

  func test_parsing() {
    let n123 = Decimal64("123")
    XCTAssert(n123?.isFinite ?? false)
    XCTAssert(n123?.isCanonical ?? false)

    let qNaN = Decimal64("nan")
    XCTAssert(qNaN?.isNaN ?? false)

    let sNaN = Decimal64("snan")
    XCTAssert(sNaN?.isSignalingNaN ?? false)

    XCTAssertNil(Decimal64(""))
    XCTAssertNil(Decimal64("xxx"))
  }

  func test_infinity() {
    let plus = Decimal64.infinity
    XCTAssert(plus.isInfinite)
    XCTAssert(plus.isCanonical)

    let minus = -Decimal64.infinity
    XCTAssert(minus.isInfinite)
    XCTAssert(minus.isCanonical)
  }

  func test_nan() {
    let qNaN = Decimal64.nan
    XCTAssert(qNaN.isNaN)
    XCTAssert(!qNaN.isSignalingNaN)
    XCTAssert(qNaN.isCanonical)

    let sNaN = Decimal64.signalingNaN
    XCTAssert(sNaN.isNaN)
    XCTAssert(sNaN.isSignalingNaN)
    XCTAssert(sNaN.isCanonical)
  }

  func test_zero() {
    let plus = Decimal64.zero
    XCTAssert(plus.isZero)
    XCTAssert(plus.isCanonical)

    let minus = -Decimal64.zero
    XCTAssert(minus.isZero)
    XCTAssert(minus.isCanonical)
  }

  func test_pi() {
    let pi = Decimal64.pi

    // From docs:
    /// This value is rounded toward zero to keep user computations with angles
    /// from inadvertently ending up in the wrong quadrant. A type that conforms
    /// to the `FloatingPoint` protocol provides the value for `pi` at its best
    /// possible precision.
    let s = "3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647"
    var status = ExceptionStatus()
    let piStr = Decimal64._parse(s, rounding: .towardZero, status: &status)!

    XCTAssertEqual(piStr, pi)

    // Decimal64.dumpEncoding()
    // piStr.dump("str")
    // pi.dump("str")

    // let piStrUnpack = piStr.unpack()
    // let piUnpack = pi.unpack()

    // print(piStr == pi)
    // print("isNegative:")
    // print(" ", piStrUnpack.isNegative)
    // print(" ", piUnpack.isNegative)
    // print("significand:")
    // print(" ", piStrUnpack.significand)
    // print(" ", piUnpack.significand)
    // print("biasedExponent:")
    // print(" ", piStrUnpack.biasedExponent, Decimal64.removeBias(biasedExponent: piStrUnpack.biasedExponent))
    // print(" ", piUnpack.biasedExponent, Decimal64.removeBias(biasedExponent: piUnpack.biasedExponent))
  }

  func test_to_int() {
    if Int.bitWidth >= 64 {
      let max = Decimal64(Int64.max, rounding: .towardZero)
      let maxResult = Int(max)
      XCTAssertEqual(maxResult, 9223372036854775000, "Original: \(Int64.max)")

      let min = Decimal64(Int64.min, rounding: .towardZero)
      let minResult = Int(min)
      XCTAssertEqual(minResult, -9223372036854775000, "Original: \(Int64.min)")

      let maxU = Decimal64(UInt64.max, rounding: .towardZero)
      let maxResultU = UInt(maxU)
      XCTAssertEqual(maxResultU, 18446744073709550000, "Original: \(UInt64.max)")
    }

    let max = Decimal64(Int32.max, rounding: .towardZero)
    let maxResult = Int(max)
    XCTAssertEqual(maxResult, 2147483647, "Original: \(Int32.max)")

    let min = Decimal64(Int32.min, rounding: .towardZero)
    let minResult = Int(min)
    XCTAssertEqual(minResult, -2147483648, "Original: \(Int32.min)")

    let maxU = Decimal64(UInt32.max, rounding: .towardZero)
    let maxResultU = UInt(maxU)
    XCTAssertEqual(maxResultU, 4294967295, "Original: \(UInt32.max)")
  }

  func test_to_int64() {
    let d1 = Decimal64(1)
    XCTAssertEqual(Int64(d1), 1)
    XCTAssertEqual(Int64(exactly: d1), 1)

    let d1_5 = Decimal64("1.5")!
    XCTAssertEqual(Int64(d1_5), 1)
    XCTAssertEqual(Int64(exactly: d1_5), nil)
  }

  func test_logb() {
    // let strings = [
    //   "inf",
    //   "nan",
    //   "snan",
    //   "0",
    //   "1",
    //   "4",
    //   "123",
    //   "0.123",
    //   "0.0123",
    //   "0.00123",
    //   "1.234",
    //   "12.34",
    //   "123.4",
    //   "123.0",
    //   "12333333333333333333.0",
    // ]

    // func sign(_ d: Double) -> String {
    //   return d.sign == .plus ? "+" : "-"
    // }

    // func pad<T>(_ d: T, _ count: Int) -> String {
    //   let s = String(describing: d)
    //   let padCount = max(0, count - s.count)
    //   return s + String(repeating: " ", count: padCount)
    // }

    // func format<T: Equatable>(_ d: T, significand: T, exponent: Int, result: T) -> String {
    //   return "\(pad(d, 10)) = \(pad(significand, 10)) ** \(pad(exponent, 4)) = \(pad(result, 10)) \(d == result)"
    // }

    // for s in strings {
    //   let d = Double(s)!
    //   let dm = Double("-" + s)!
    //   let dR =  Double(sign: .plus, exponent: d.exponent, significand: d.significand)
    //   let dmR = Double(sign: .plus, exponent: dm.exponent, significand: dm.significand)

    //   let dPlus = format(d, significand: d.significand, exponent: d.exponent, result: dR)
    //   let dMinus = format(dm, significand: dm.significand, exponent: dm.exponent, result: dmR)

    //   guard let c = Decimal64(s) else { fatalError() }
    //   let cm = -c
    //   let cR = Decimal64(sign: .plus, exponent: c.exponent, significand: c.significand, rounding: .towardZero)
    //   let cmR = Decimal64(sign: .plus, exponent: cm.exponent, significand: cm.significand, rounding: .towardZero)

    //   let cPlus = format(c, significand: c.significand, exponent: c.exponent, result: cR)
    //   let cMinus = format(cm, significand: cm.significand, exponent: cm.exponent, result: cmR)

    //   print("\(pad(s, 10)) | \(dPlus) | \(dMinus)")
    //   print("\(pad(s, 10)) | \(cPlus) | \(cMinus)")
    //   print()
    // }
  }

  func test_ulp() {
    // var doubles: [Double] = [0]
    // var decimals: [Decimal64] = [Decimal64(0)]

    // var d = 1.0
    // var dc = Decimal64(1)

    // for _ in 0..<30 {
    //   doubles.append(d)
    //   decimals.append(dc)
    //   d *= 2
    //   dc *= Decimal64(10)
    // }
    // doubles.append(.greatestFiniteMagnitude.nextDown)
    // doubles.append(.greatestFiniteMagnitude)
    // decimals.append(.greatestFiniteMagnitude.nextDown)
    // decimals.append(.greatestFiniteMagnitude)

    // print("======== DOUBLES ========")
    // for d in doubles {
    //   let ds = pad(d)
    //   let ulp = d.ulp
    //   let downDiff = d - d.nextDown
    //   let upDiff = d.nextUp - d
    //   print("\(ds) | \(ulp) | \(downDiff) (\(ulp == downDiff)) | \(upDiff) (\(ulp == upDiff))")
    // }

    // print()
    // print("======== DECIMALS ========")
    // for d in decimals {
    //   let ds = d.description
    //   let ulp = d.ulp
    //   let downDiff = d - d.nextDown
    //   let upDiff = d.nextUp - d
    //   print("\(ds) | \(ulp) | \(downDiff) (\(ulp == downDiff)) | \(upDiff) (\(ulp == upDiff))")
    // }
  }

  func test_greatestFiniteMagnitude_round() {
    // print("xx")
    // let gfm = Double.greatestFiniteMagnitude
    // let gfmUlpHalf = gfm.ulp / 2
    // print(gfm)
    // print(gfm + gfmUlpHalf.nextDown)
    // print(gfm + gfmUlpHalf)

    // print("xx")

    // let dfm = Decimal64.greatestFiniteMagnitude
    // let dfmUlpHalf = dfm.ulp / 2
    // print(dfm)
    // print(dfm + dfmUlpHalf.nextDown)
    // print(dfm.adding(other: dfmUlpHalf, rounding: .toNearestOrEven), "toNearestOrEven")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .toNearestOrAwayFromZero), "toNearestOrAwayFromZero")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .up), "up")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .down), "down")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .towardZero), "towardZero")
    // print()
    // print(Decimal64.leastNonzeroMagnitude)
    // print(Decimal64.leastNonzeroMagnitude.ulp)
    // print(Decimal64.leastNonzeroMagnitude.nextUp / 2 == Decimal64.leastNonzeroMagnitude)
  }
}
