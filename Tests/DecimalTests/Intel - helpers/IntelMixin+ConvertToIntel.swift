import XCTest
@testable import Decimal

// Sometimes Swift and Intel have different semantic for a given operation.
// This code converts Swift result to Intel result.
extension IntelMixin {

  func toIntel_toString<T: DecimalMixin>(
    _ arg0: T,
    result: String
  ) -> String {
    // Intel does not support nan payload
    if result.contains("nan"), let parenIndex = result.lastIndex(of: "(") {
      let noPayload = result[..<parenIndex]
      return String(noPayload)
    }

    return result
  }

  func toIntel_parse<T: DecimalMixin>(
    _ arg0: String,
    _ rounding: DecimalFloatingPointRoundingRule,
    _ status: inout DecimalStatus,
    result: T?
  ) -> T {
    if let result = result {
      return result
    }

    // In Swift parsing failure is 'nil', in Intel 'NaN' with sign.
    let first = arg0.first { !$0.isWhitespace }
    let isMinus = first == "-"
    let signMask = isMinus ? T.signMask : 0
    return T(canonical: signMask | T.nanQuietMask)
  }

  func toIntel_decimalToDecimal<Src: DecimalMixin, Dst: DecimalMixin>(
    _ arg0: Src,
    result: Dst,
    status: inout DecimalStatus
  ) -> Dst {
    // In Intel: sNaN -> qNaN + InvalidOperation
    // In Swift: sNaN -> sNaN
    if arg0._isSignalingNaN && result._isSignalingNaN {
      status.set(.isInvalidOperation)
      let preserveMask = ~Dst.nanSignalingMask
      let bid = (result.bid & preserveMask) | Dst.nanQuietMask
      return Dst(unchecked: bid)
    }

    return result
  }

  func toIntel_initFromDecimalEncoding<T: DecimalMixin>(expected: T) -> T {
    // Intel returns trash after the NaN bits. Clear them.
    if expected._isNaN {
      let keep = T.signMask | T.nanSignalingMask | T.nanPayloadMask
      return T(unchecked: expected.bid & keep)
    }

    return expected
  }

  func toIntel_round(status: inout DecimalStatus) {
    // Swift
    //   We implement 'roundToIntegralExact' which signals 'isInexact'.
    // IEEE 754
    //   5.9 Details of operations to round a floating-point datum to integral value
    //   These operations shall not signal any exception except for signaling NaN
    //   input.
    status.clear(.isInexact)
  }

  func toIntel_scaleB<T: DecimalMixin>(
    _ arg0: T,
    _ exponent: Int,
    result: T,
    status: inout DecimalStatus
  ) -> T {
    if arg0._isSignalingNaN && result._isSignalingNaN && !status.isInvalidOperation {
      // Remove signaling flag
      status.set(.isInvalidOperation)
      let signaling = T.nanSignalingMask ^ T.nanQuietMask
      let bid = result.bid & ~signaling
      return T(unchecked: bid)
    }

    return result
  }

  func toIntel_logB<T: DecimalMixin>(_ arg0: T, result: Int) -> Int32 {
    if arg0._isInfinite && result == Int.max { return Int32.max }
    if arg0._isNaN && result == Int.max { return Int32.min }
    if arg0._isZero && result == Int.min { return Int32.min }
    return Int32(result)
  }

  typealias IntelFrexp<T: DecimalMixin> = (exponent: Int32, significand: T)

  func toIntel_frexp<T: DecimalMixin>(
    _ arg0: T,
    exponent: Int,
    significand: T
  ) -> IntelFrexp<T> {
    let intelExponent: Int32 = {
      if arg0._isInfinite && exponent == Int.max { return 0 }
      if arg0._isNaN && exponent == Int.max { return 0 }
      if arg0._isZero && exponent == Int.min { return 0 }
      return Int32(exponent) + 1
    }()

    let intelSignificand: T = {
      let copySign = arg0.bid & T.signMask

      if arg0._isSignalingNaN && significand._isSignalingNaN {
        return T(canonical: copySign | T.nanQuietMask)
      }

      let withSign = T(unchecked: copySign | (significand.bid & ~T.signMask))

      if arg0._isNaN && significand._isNaN { return withSign }
      if arg0._isZero && arg0._isZero { return withSign }
      if arg0._isInfinite && significand._isInfinite { return withSign }

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
      return T(canonical: copySign | newExponent | copySignificand)
    }()

    return (intelExponent, intelSignificand)
  }
}
