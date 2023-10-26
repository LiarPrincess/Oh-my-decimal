import Decimal
import Foundation

// Base
private typealias BID = Decimal32.BitPattern
private let bitWidth = BID.bitWidth
private let signWidth = 1
private let combinationWidth = 11
private let emax = 96
private let exponentBias = 101
private let precisionInDigits = 7
private let maxDecimalDigits: BID = 9_999_999
// Derived
private let maxSignedExponent = emax - precisionInDigits + 1
private let maxBiasedExponent = BID(maxSignedExponent + exponentBias)
private let combinationHighBitsWidth = 2
private let combinationHighBits11Mask: BID = 0b11 << (bitWidth - signWidth - 2)
private let combinationExponentWidth = combinationWidth - 5
private let exponentWidth = combinationExponentWidth + 2
private let exponentShift_00_01_10 = bitWidth - signWidth - exponentWidth
private let maxSignificand_00_01_10: BID = 1 << exponentShift_00_01_10
private let exponentShift_11 = bitWidth - signWidth - combinationHighBitsWidth - exponentWidth
private let significandMask_11: BID = (1 << exponentShift_11) - 1

/// Produce all positive `Decimals32`.
///
/// This will iterate all 1 910 000 000 possible values in ~2min.
func forEveryDecimal32(f: (Decimal32) -> Void) {
  let start = Date()

  for exponent in 0...maxBiasedExponent {
    if exponent.isMultiple(of: 10) {
      print("\(exponent)/\(maxBiasedExponent) <- current exponent")
    }

    for significand in 0...maxDecimalDigits {
      let decimal = pack(
        biasedExponent: exponent,
        significand: significand
      )

      f(decimal)
    }
  }

  let end = Date()
  let duration = end.timeIntervalSince1970 - start.timeIntervalSince1970
  print("Total: \(duration)s")
}

private func pack(
  biasedExponent: Decimal32.BitPattern,
  significand: Decimal32.BitPattern
) -> Decimal32 {
  if significand < maxSignificand_00_01_10 {
    let e = biasedExponent << exponentShift_00_01_10
    return Decimal32(binaryEncoding: e | significand)
  }

  // Add significand, without leading bits
  let e = biasedExponent << exponentShift_11
  let s = significand & significandMask_11
  return Decimal32(binaryEncoding: combinationHighBits11Mask | e | s)
}
