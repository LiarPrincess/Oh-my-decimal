import Cbid

// Those functions are in 'bid_internal.h'.
// For fun we will re-write them in Swift.
// Yu can also include the whole 'bid_internal.h' in 'Cbid' header if you want.

// MARK: - Pack

private enum ExponentOverflow<BID> {
  case overflow
  /// There is no overflow, but you have to use this `exponent` and `coefficient`.
  case noOverflow(exponent: BID, coefficient: BID)
}

extension DecimalMixin {

  /// Cbid: `fast_get_BID64_check_OF (BID_UINT64 sgn, int expon, BID_UINT64 coeff, int rmode, unsigned *fpsc)`.
  internal static func pack(
    isNegative: Bool,
    exponent: Int,
    coefficient: BID
  ) -> Self {
    let biased = Self._addBias(exponent: exponent)
    return Self.pack(
      isNegative: isNegative,
      biasedExponent: biased,
      coefficient: coefficient
    )
  }

  /// Cbid: `fast_get_BID64_check_OF (BID_UINT64 sgn, int expon, BID_UINT64 coeff, int rmode, unsigned *fpsc)`.
  internal static func pack(
    isNegative: Bool,
    biasedExponent exponentArg: BID,
    coefficient coefficientArg: BID
  ) -> Self {
    let sign = isNegative ? Self.signMask : 0
    let exponent: BID
    let coefficient: BID

    switch Self.checkExponentOverflow(biasedExponent: exponentArg, coefficient: coefficientArg) {
    case .overflow:
      Self.trapExponentOverflow(exponent: exponentArg, coefficient: coefficientArg)
    case let .noOverflow(exponent: e, coefficient: c):
      exponent = e
      coefficient = c
    }

    // Decimal64 with high combination bits 00, 01, 10:
    // |+hheeeee|eeesssss|ssssssss|ssssssss|ssssssss|ssssssss|ssssssss|ssssssss <- layout
    //             100000|00000000|00000000|00000000|00000000|00000000|00000000 <- max significand
    //
    // hh = 00,01,10
    // exponent = hheee…
    // significand = 0sss…
    let maxExponent_00_01_10: BID = 0b11 << (Self.exponentWidth - 2)
    let maxSignificand_00_01_10: BID = 1 << exponentShift_00_01_10

    if coefficient < maxSignificand_00_01_10 {
      guard exponent < maxExponent_00_01_10 else {
        Self.trapExponentOverflow(exponent: exponentArg, coefficient: coefficientArg)
      }

      let e = exponent << exponentShift_00_01_10
      return Self(canonical: sign | e | coefficient)
    }

    // Eliminate the case significand == 10^16 after rounding
    let overflowSignificand_00_01_10 = Self.maxDecimalDigits + 1

    if coefficient == overflowSignificand_00_01_10 {
      guard (exponent + 1) < maxExponent_00_01_10 else {
        Self.trapExponentOverflow(exponent: exponentArg, coefficient: coefficientArg)
      }

      let e = (exponent + 1) << Self.exponentShift_00_01_10
      let s = overflowSignificand_00_01_10 / 10
      return Self(canonical: sign | e | s)
    }

    // Decimal64 with high combination bits 11:
    // |+hheeeee|eeeeesss|ssssssss|ssssssss|ssssssss|ssssssss|ssssssss|ssssssss|
    // |        | 100Gsss|ssssssss|ssssssss|ssssssss|ssssssss|ssssssss|ssssssss|
    //
    // hh = 11
    // exponent = eee…
    // significand = 100G[12]sss…

    // Exponent was already checked for overflow
    let maxSignificand11 = Self.prefix100_11 | Self.significandMask_11

    if coefficient > maxSignificand11 {
      Self.trapSignificandOverflow(exponent: exponentArg, coefficient: coefficientArg)
    }

    // Add significand, without leading bits
    let e = exponent << exponentShift_11
    let s = coefficient & Self.significandMask_11
    return Self(canonical: sign | Self.combinationHighBits11Mask | e | s)
  }

  private static func checkExponentOverflow(
    biasedExponent: BID,
    coefficient: BID
  ) -> ExponentOverflow<BID> {
    var exponent = biasedExponent
    var coefficient = coefficient

    let unbiasedMaxExponent = Self._moveDecimalSeparatorRight(exponent: Self.maxUnbiasedExponent)
    let maxExponent = Self._addBias(exponent: unbiasedMaxExponent)

    if exponent > maxExponent {
      if exponent == maxExponent && coefficient == (Self.maxDecimalDigits + 1) {
        exponent += 1
        coefficient /= 10
      }

      if exponent > maxExponent {
        // Try to scale coefficient while decreasing exponent
        let coefficientAllDigits = (Self.maxDecimalDigits + 1) / 10

        while coefficient < coefficientAllDigits && exponent > maxExponent {
          exponent -= 1
          coefficient = (coefficient << 3) + (coefficient << 1)
        }

        if exponent > maxExponent {
          return .overflow
        }
      }
    }

    return .noOverflow(exponent: exponent, coefficient: coefficient)
  }

  private static func trapExponentOverflow(exponent: BID, coefficient: BID ) -> Never {
    preconditionFailure("Exponent overflow when creating \(Self.self) (\(coefficient) * 10^\(exponent)).")
  }

  private static func trapSignificandOverflow(exponent: BID, coefficient: BID) -> Never {
    preconditionFailure("Significand overflow when creating \(Self.self) (\(coefficient) * 10^\(exponent)).")
  }
}

// MARK: - Unpack

internal struct _Unpack<BID> {
  internal let isNegative: Bool
  internal let biasedExponent: BID
  internal let significand: BID
}

internal enum _UnpackResult<BID> {
  // For zero we are interested in exponent.
  case zero(_Unpack<BID>)
  case finite(_Unpack<BID>)
  case infinity(isNegative: Bool)
  case quietNaN(isNegative: Bool, payload: BID)
  case signalingNaN(isNegative: Bool, payload: BID)
}

extension DecimalMixin {

  internal typealias Unpack = _Unpack<BID>
  internal typealias UnpackResult = _UnpackResult<BID>

  /// Cbid: `unpack_BID{bitWidth}(*psign_x, *pexponent_x, *pcoefficient_x, x)`.
  internal func unpack() -> UnpackResult {
    let isNegative = self._isNegative

    if self._isInfinite {
      return .infinity(isNegative: isNegative)
    }

    if self._isNaN {
      let payload = self._nanPayload

      return self._isSet(Self.nanSignalingMask) ?
        .signalingNaN(isNegative: isNegative, payload: payload) :
        .quietNaN(isNegative: isNegative, payload: payload)
    }

    var biasedExponent: BID
    var significand: BID

    if self._isSet(Self.combinationHighBits11Mask) {
      biasedExponent = (self.bid >> Self.exponentShift_11) & Self.exponentMask
      significand = (self.bid & Self.significandMask_11) | Self.prefix100_11
    } else {
      biasedExponent = (self.bid >> Self.exponentShift_00_01_10) & Self.exponentMask
      significand = self.bid & Self.significandMask_00_01_10
    }

    // The maximum value of the binary-encoded significand 10 (3 × J + 1) −1
    // (or 10 (3 × J ) −1 when T is used as the payload of a NaN).
    // If the value exceeds the maximum, the significand c is non-canonical and
    // the value used for c is zero.
    //
    // IMPORTANT:
    // This check has nothing to do with 'greatestFiniteMagnitude'!
    // You may be non-canonical while having a low exponent (00_01_10 mode).
    if significand > Self.maxDecimalDigits {
      significand = 0
    }

    let u = Unpack(
      isNegative: isNegative,
      biasedExponent: biasedExponent,
      significand: significand
    )

    return significand == 0 ? .zero(u) : .finite(u)
  }
}
