import XCTest
@testable import Decimal

// Sometimes Swift and Intel have different semantic for a given operation.
// This code converts Swift result to Intel result.
extension IntelMixin {

  /// Fix 0, NaN and Infinity.
  /// There is a difference between Swift and Intel.
  func convertToIntelLogB<T: DecimalMixin>(_ arg0: T, exponent: Int) -> Int32 {
    if arg0._isInfinite && exponent == Int.max { return Int32.max }
    if arg0._isNaN && exponent == Int.max { return Int32.min }
    if arg0._isZero && exponent == Int.min { return Int32.min }
    return Int32(exponent)
  }

  typealias IntelFrexp<T> = (exponent: Int32, significand: T)

  /// There is a difference between Swift and Intel.
  func convertToIntelFrexp<T: DecimalMixin>(
    _ arg0: T,
    exponent: Int,
    significand: T
  ) -> IntelFrexp<T> {
    let e: Int32

    if arg0._isInfinite && exponent == Int.max { e = 0 }
    else if arg0._isNaN && exponent == Int.max { e = 0 }
    else if arg0._isZero && exponent == Int.min { e = 0 }
    else { e = Int32(exponent) + 1 }

    var s = significand
    let copySign = arg0.bid & T.signMask

    if arg0._isSignalingNaN && significand._isSignalingNaN {
      s = T(canonical: copySign | T.nanQuietMask)
    }
    else if arg0._isNaN && significand._isNaN { } // Nothing to do
    else if arg0._isZero && arg0._isZero { } // Nothing to do
    else if arg0._isInfinite && significand._isInfinite { } // Nothing to do
    else {
      // Basically: exponent -= 1
      let exponentShift: Int
      let significandMask: T.BID

      if significand._isSet(T.combinationHighBits11Mask) {
        exponentShift = T.exponentShift_11
        significandMask = T.combinationHighBits11Mask | T.significandMask_11
      } else {
        exponentShift = T.exponentShift_00_01_10
        significandMask = T.significandMask_00_01_10
      }

      let oldExponent = (significand.bid >> exponentShift) & T.exponentMask
      let newExponent = (oldExponent - 1) << exponentShift
      assert(oldExponent != 0)

      let copySignificand = significand.bid & significandMask
      s = T(canonical: copySign | newExponent | copySignificand)
    }

    return (e, s)
  }
}
