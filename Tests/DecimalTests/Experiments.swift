import XCTest
@testable import Decimal

// swiftlint:disable empty_xctest_method

private func pad<T: CustomStringConvertible>(_ t: T, _ count: Int = 10) -> String {
  let s = String(describing: t)
  let c = max(0, count - s.count)
  return String(repeating: " ", count: c) + s
}

class Experiments: XCTestCase {

  func test_main() {
    let separator = String(repeating: "-", count: 80)
    print(separator)
    defer { print(separator) }

    func forType<T: DecimalFloatingPoint & DecimalMixin>(_ t: T.Type) {
      // print(String(describing: T.self))
      // defer { print() }

    }

    forType(Decimal32.self)
    forType(Decimal64.self)
    forType(Decimal128.self)

    typealias T = Decimal64
  }

  func test_mostImportant_exponentTable() {
    // typealias T = Decimal64

    // let gfmPlus = +T.greatestFiniteMagnitude
    // let gfmMinus = -T.greatestFiniteMagnitude
    // let lnmPlus = +T.leastNonzeroMagnitude
    // let lnmMinus = -T.leastNonzeroMagnitude

    // // Exponent has nothing to do with +-greatestFiniteMagnitude!
    // // It is all about the sign!
    // // Exponent is for close to 0 / far from 0.
    // let testPlus = T(sign: .plus, exponent: 384, significand: 1) // 385 crashes
    // let testMinus = -testPlus

    // let xPlus = T(sign: .plus, exponent: -398, significand: 1)
    // let xMinus = -xPlus

    // print("+gfm", gfmPlus._finiteExponent)
    // print("-gfm", gfmMinus._finiteExponent)
    // print("+test", testPlus._finiteExponent, testPlus)
    // print("-test", testMinus._finiteExponent, testMinus)
    // print()
    // print("+lnm", lnmPlus._finiteExponent)
    // print("-lnm", lnmMinus._finiteExponent)
    // print("+x", xPlus._finiteExponent, xPlus.isZero)
    // print("-x", xMinus._finiteExponent, xMinus.isZero)
    // print()
    // print("exponentBias", T.exponentBias)
    // print("emax", T.emax, T.emax + T.exponentBias)
    // print("emin", T.emin, T.emin + T.exponentBias)
    // print()
    // print("", T._moveDecimalSeparatorRight(exponent: T.emax), "<< Solved max")
    // print(-T.exponentBias, "<< Solved min")
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
    // print(dfm.adding(other: dfmUlpHalf, rounding: .toNearestOrAwayFromZero), "toNearestOrAway")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .up), "up")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .down), "down")
    // print(dfm.adding(other: dfmUlpHalf, rounding: .towardZero), "towardZero")
    // print()
    // print(Decimal64.leastNonzeroMagnitude)
    // print(Decimal64.leastNonzeroMagnitude.ulp)
    // print(Decimal64.leastNonzeroMagnitude.nextUp / 2 == Decimal64.leastNonzeroMagnitude)
  }
}
