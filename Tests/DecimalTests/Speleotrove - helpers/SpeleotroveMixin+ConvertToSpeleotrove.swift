import XCTest
@testable import Decimal

// Sometimes Swift and Speleotrove have different semantic for a given operation.
// This code converts Swift result to Speleotrove result.
extension SpeleotroveMixin {

  // MARK: - Properties

  func toSpeleotrove_magnitude<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    result: T
  ) -> T {
    // Speleotrove: snan -> nan with the same sign + invalid operation
    // Swift: -snan -> snan
    if arg0.isSignalingNaN && result.sign == .plus && result.isSignalingNaN {
      return self.removeSignalingBit(arg0)
    }

    // Speleotrove: -nan -> -nan + invalid operation
    // Swift: -nan -> nan
    if arg0.sign == .minus && arg0.isQuietNaN && result.sign == .plus && result.isQuietNaN {
      return self.removeSignalingBit(arg0)
    }

    return result
  }

  // MARK: - Unary

  func toSpeleotrove_unaryPlus<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    result: T
  ) -> T {
    if result._isSignalingNaN {
      return self.removeSignalingBit(result)
    }

    // +(-0) -> +0
    if arg0.sign == .minus && arg0.isZero && result.sign == .minus && result.isZero {
      return result._magnitude
    }

    return result
  }

  func toSpeleotrove_unaryMinus<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    result: T
  ) -> T {
    if result.isNaN && arg0.sign != result.sign {
      if result.isSignalingNaN {
        return self.removeSignalingBit(arg0)
      }

      return arg0
    }

    // -(0) = 0
    if arg0.sign == .plus && arg0.isZero && result.sign == .minus && result.isZero {
      return result._magnitude
    }

    return result
  }

  // MARK: - Math

  func toSpeleotrove_add<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    // NaN(…) + SNaN(payload) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    return result
  }

  func toSpeleotrove_sub<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    // NaN(…) - SNaN(payload) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    return result
  }

  func toSpeleotrove_mul<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    // NaN(…) * SNaN(payload) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    return result
  }

  func toSpeleotrove_div<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    // NaN(…) / SNaN(payload) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    return result
  }

  func toSpeleotrove_rem<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T,
    status: inout DecimalStatus
  ) -> T {
    // NaN(…) % SNaN(payload) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    if result.isNaN {
      return result
    }

    if let r = self.toSpeleotrove_rem_whenQuotientIsNotRepresentable(
      arg0,
      arg1,
      status: &status
    ) {
      return r
    }

    return result
  }

  func toSpeleotrove_rem_whenQuotientIsNotRepresentable<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    status: inout DecimalStatus
  ) -> T? {
    // https://speleotrove.com/decimal/daops.html#refremain
    // https://speleotrove.com/decimal/daops.html#refremnear
    // This operation will fail under the same conditions as integer division
    // (that is, if integer division on the same two operands would fail, the
    // remainder cannot be calculated), except when the quotient is very close
    // to 10 raised to the power of the precision.[10]
    //
    // In plain words:
    // Swift: the remainder is always returned even if the result of the integer
    //        division (quotient) is not representable in a given format.
    // Speleotrove: if the result of the division (quotient) is not representable
    //        in a given format (overflow) then 'nan' is returned  with
    //        'invalidOperation' flag raised.
    let r = self.divideInt(arg0, by: arg1, rounding: .toNearestOrAwayFromZero)

    if r.isNaN {
      status.set(.isInvalidOperation)
      return T.nan
    }

    return nil
  }

  /// result = (arg0 * arg1) + arg2
  func toSpeleotrove_fma<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    _ arg2: T,
    result: T
  ) -> T {
    // NaN or NaNaN or NaNaNaN?
    var nanCount = 0

    if arg0.isNaN { nanCount += 1 }
    if arg1.isNaN { nanCount += 1 }
    if arg2.isNaN { nanCount += 1 }

    // Single NaN should be handled by the module.
    if nanCount >= 2 {
      if arg0.isSignalingNaN { return self.removeSignalingBit(arg0) }
      if arg1.isSignalingNaN { return self.removeSignalingBit(arg1) }
      if arg2.isSignalingNaN { return self.removeSignalingBit(arg2) }

      return arg0.isNaN ? arg0 : arg1
    }

    return result
  }

  // MARK: - Min, max

  func toSpeleotrove_min<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    // min(NaN(…), SNaN(payload)) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    // https://speleotrove.com/decimal/daops.html#refmin
    // Otherwise (they are numerically equal):
    // - if the operand signs differ the operand with sign 1 is chosen
    // - if the signs and exponents are equal the operands are identical so either can be chosen
    // - if the signs are both positive, the operand with the minimum exponent is chosen
    // - if the signs are both negative, the operand with the maximum exponent is chosen.

    // If equal and we returned 'lhs'.
    if arg0.isEqual(to: arg1) && result.isFinite && result.bid == arg0.bid {
      if arg0.bid == arg1.bid {
        return result
      }

      if arg0.sign != arg1.sign {
        return arg0.sign == .minus ? arg0 : arg1
      }

      let unpack0 = arg0._unpackFiniteOrZero()
      let unpack1 = arg1._unpackFiniteOrZero()

      if arg0.sign == .plus {
        return unpack0.exponent < unpack1.exponent ? arg0 : arg1
      }

      return unpack0.exponent > unpack1.exponent ? arg0 : arg1
    }

    return result
  }

  func toSpeleotrove_max<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    // max(NaN(…), SNaN(payload)) = NaN(payload)
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    // https://speleotrove.com/decimal/daops.html#refmax
    // Otherwise (they are numerically equal):
    // - if the operand signs differ the operand with sign 0 is chosen
    // - if the signs and exponents are equal the operands are identical so either can be chosen
    // - if the signs are both positive, the operand with the maximum exponent is chosen
    // - if the signs are both negative, the operand with the minimum exponent is chosen.

    // If equal and we returned 'lhs'.
    if arg0.isEqual(to: arg1) && result.isFinite && result.bid == arg0.bid {
      if arg0.bid == arg1.bid {
        return result
      }

      if arg0.sign != arg1.sign {
        return arg0.sign == .plus ? arg0 : arg1
      }

      let unpack0 = arg0._unpackFiniteOrZero()
      let unpack1 = arg1._unpackFiniteOrZero()

      if arg0.sign == .plus {
        return unpack0.exponent > unpack1.exponent ? arg0 : arg1
      }

      return unpack0.exponent < unpack1.exponent ? arg0 : arg1
    }

    return result
  }

  // MARK: - Quant

  func toSpeleotrove_quantize<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T {
    if let d = self.nan_op_snan_is_snan(arg0, arg1, result: result) {
      return d
    }

    return result
  }

  // MARK: - Helpers

  /// `NaN(…) + SNaN(payload) = NaN(payload)`
  ///
  /// Snake case for readability.
  private func nan_op_snan_is_snan<T: DecimalFloatingPoint & DecimalMixin>(
    _ arg0: T,
    _ arg1: T,
    result: T
  ) -> T? {
    if arg0.isQuietNaN && arg1.isSignalingNaN && result.bid == arg0.bid {
      let payload = arg1._unpackNaN()
      if payload.canonical != 0 {
        return self.removeSignalingBit(arg1)
      }
    }

    return nil
  }
}
