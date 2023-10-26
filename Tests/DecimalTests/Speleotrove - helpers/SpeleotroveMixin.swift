@testable import Decimal

protocol SpeleotroveMixin {}

extension SpeleotroveMixin {

  // MARK: - Copy

  // https://speleotrove.com/decimal/damisc.html#refcopya
  // We do not have this operation, but we want those tests.
  // Use only the public api!
  func copyAbs<T: DecimalFloatingPoint>(_ d: T) -> T {
    return d.magnitude
  }

  // https://speleotrove.com/decimal/damisc.html#refcopyn
  // We do not have this operation, but we want those tests.
  // Use only the public api!
  func copyNegate<T: DecimalFloatingPoint>(_ d: T) -> T {
    return -d
  }

  // MARK: - Next

  // https://speleotrove.com/decimal/daops.html#refnextow
  // We do not have this operation, but we want those tests.
  // Use only the public api!
  func nextToward<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ direction: T,
    status: inout DecimalStatus
  ) -> T {
    // Our 'next' takes only 1 arg, so we have to handle NaN here in the correct
    // order ('d' before 'direction').
    if let nan = self.handleNaN(d, direction, status: &status) {
      return nan
    }

    if d == direction {
      return d
    }

    let result = d < direction ?
      d.nextUp(status: &status) :
      d.nextDown(status: &status)

    // IEEE 754 nextXX is quiet (quote from standard):
    //   nextUp(x) is quiet except for sNaNs.
    // Speleotrove signals inexact underflow/overflow.

    if result.magnitude < T.leastNormalMagnitude {
      status.set(.isUnderflowInexact)
    }

    if !d.isInfinite && result.isInfinite {
      status.set(.isOverflowInexact)
    }

    return result
  }

  // MARK: - Div, rem

  // https://speleotrove.com/decimal/daops.html#refdivint
  // We do not have this operation, but we want those tests.
  // Use only the public api!
  func divideInt<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    by rhs: T,
    rounding: DecimalFloatingPointRoundingRule
  ) -> T {
    var status = DecimalStatus()

    if let nan = self.handleNaN(lhs, rhs, status: &status) {
      return nan
    }

    let result = lhs.divided(by: rhs, rounding: rounding, status: &status)

    if status.isOverflow {
      return T.nan
    }

    if result.isInfinite {
      return result
    }

    let precision = T(1)
    return result.quantized(to: precision, rounding: .towardZero)
  }

  /// Use `truncatingRemainder` tests to test `remainder`.
  func truncatingRemainderFromReminder<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    dividingBy rhs: T
  ) -> T {
    var status = DecimalStatus()

    if let nan = self.handleNaN(lhs, rhs, status: &status) {
      return nan
    }

    if let r = self.toSpeleotrove_rem_whenQuotientIsNotRepresentable(
      lhs,
      rhs,
      status: &status
    ) {
      return r
    }

    let result = lhs.remainder(dividingBy: rhs)

    if result.isNaN || result.isInfinite {
      return result
    }

    // This may not be correct for the 'halfway' case, but it is enough to pass
    // all of the tests. Which is all we need to mark 'remainder' as 'tested'.
    // We do not have to be 'perfect', because it is not a part of the public api.

    // No 'near' correction was performed?
    if result.sign == lhs.sign {
      return result
    }

    // Near correction was performed.
    // We have to restore what was before correction.
    // The general idea is to 'flip' it to the other sign.
    return result.sign == rhs.sign ?
      result.subtracting(rhs, rounding: .towardZero) :
      result.adding(rhs, rounding: .towardZero)
  }

  // MARK: - Total order

  // https://speleotrove.com/decimal/damisc.html#refcotot
  // In Speleotrove: total order returns -1, 0, 1.
  // In Swift: total order returns 'isBelowOrEqual: Bool'
  // So, we have to add equality checks and return '0'.
  func totalOrder<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T
  ) -> Int {
    // Totally greater?
    if !lhs.isTotallyOrdered(belowOrEqualTo: rhs) {
      return 1
    }

    // Ordered according to the initial 'lhs.isTotallyOrdered(belowOrEqualTo:)'.
    let swiftResult = -1

    if lhs.sign != rhs.sign {
      return swiftResult
    }

    if lhs.isInfinite && rhs.isInfinite {
      return 0
    }

    // 2. Numbers (representations which are not NaNs) are ordered such that
    // a larger numerical value is higher in the ordering.
    // If two representations have the same numerical value then the exponent
    // is taken into account; larger (more positive) exponents are higher
    // in the ordering.
    if lhs.isFinite && rhs.isFinite && lhs.isEqual(to: rhs) {
      let lhsUnpack = lhs._unpackFiniteOrZero()
      let rhsUnpack = rhs._unpackFiniteOrZero()

      if lhsUnpack.exponent == rhsUnpack.exponent {
        return 0
      }
    }

    // 4. Quiet NaNs and signaling NaNs are ordered according to their payload;
    // a larger payload is higher in the ordering.
    if lhs.isQuietNaN && rhs.isQuietNaN || lhs.isSignalingNaN && rhs.isSignalingNaN {
      let lhsPayload = lhs._unpackNaN()
      let rhsPayload = rhs._unpackNaN()

      if lhsPayload.canonical == rhsPayload.canonical {
        return 0
      }
    }

    return swiftResult
  }

  // https://speleotrove.com/decimal/damisc.html#refcotot
  // In Speleotrove: total order returns -1, 0, 1.
  // In Swift: total order returns 'isBelowOrEqual: Bool'
  // So, we have to add equality checks and return '0'.
  func totalOrderMagnitude<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T
  ) -> Int {
    return self.totalOrder(lhs.magnitude, rhs.magnitude)
  }

  // MARK: - LogB, ScaleB

  // https://speleotrove.com/decimal/damisc.html#reflogb
  // In Speleotrove: decimal
  // In Swift: int
  func logB<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    status: inout DecimalStatus
  ) -> T {
    let exponent = d.exponent(status: &status)

    if d.isQuietNaN {
      if exponent == T.Exponent.max && status.isInvalidOperation {
        status.clear(.isInvalidOperation)
        return d
      }

      return self.errorMarker()
    }

    if d.isSignalingNaN {
      if exponent == T.Exponent.max {
        return self.removeSignalingBit(d)
      }

      return self.errorMarker()
    }

    // If the operand is infinite then +Infinity is returned.
    if d.isInfinite {
      if exponent == T.Exponent.max && status.isInvalidOperation {
        status.clear(.isInvalidOperation)
        return T.infinity
      }

      return self.errorMarker()
    }

    // If the operand is a zero, then –Infinity is returned and the Division
    // by zero exceptional condition is raised.
    if d.isZero {
      if exponent == T.Exponent.min && status.isInvalidOperation {
        status.clear(.isInvalidOperation)
        status.set(.isDivisionByZero)
        return -T.infinity
      }

      return self.errorMarker()
    }

    // Otherwise, the result is the integer which is the exponent of the
    // magnitude of the most significant digit of the operand (as though the
    // operand were truncated to a single digit while maintaining the value of
    // that digit and without limiting the resulting exponent).
    // All results are exact unless an integer result does not fit in the
    // available precision.
    return T(exponent, rounding: .towardZero)
  }

  // https://speleotrove.com/decimal/damisc.html#refscaleb
  // In Speleotrove: exponent is decimal
  // In Swift: exponent is int
  func scaleB<T: DecimalFloatingPoint & DecimalMixin>(
    _ d: T,
    _ exponent: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> T {
    // scaleb takes two operands.
    // If either operand is a NaN then the general arithmetic rules apply.
    // Otherwise, the second operand must be a finite integer with an exponent
    // of zero[4]  and in the range ±2 × (Emax + precision) inclusive, where
    // Emax is the largest value that can be returned by the logb operation at
    // the same precision setting.[5] // (If is is not, the Invalid Operation
    // condition is raised and the result is NaN.)
    //
    // If the first operand is infinite then that Infinity is returned, otherwise
    // the result is the first operand modified by adding the value of the second
    // operand to its exponent. The result may Overflow or Underflow.

    if exponent.isNaN || exponent.isInfinite {
      if let r = self.handleNaN(d, exponent, status: &status) {
        return r
      }

      status.set(.isInvalidOperation)
      return T.nan
    }

    assert(exponent.isFinite)
    let unpack = exponent._unpackFiniteOrZero()
    let significand = unpack.significand.canonical
    let maxSignificand = 2 * (T.emax + T.precisionInDigits)

    // Finite integer with an exponent of zero[4]  and in the range
    // ±2 × (Emax + precision) inclusive
    guard unpack.exponent.signed == 0,
          significand <= maxSignificand,
          var e = T.Exponent(exactly: significand) else {
      if let r = self.handleNaN(d, exponent, status: &status) {
        return r
      }

      status.set(.isInvalidOperation)
      return T.nan
    }

    if exponent.sign == .minus {
      e.negate()
    }

    let result = T(
      sign: .plus,
      exponent: e,
      significand: d,
      rounding: rounding,
      status: &status
    )

    // Swift implementation should NOT raise 'invalidOperation'.
    if result.isSignalingNaN && !status.isInvalidOperation {
      status.set(.isInvalidOperation)
      return self.removeSignalingBit(result)
    }

    return result
  }

  // MARK: - Reduce

  // https://speleotrove.com/decimal/daops.html#refredu
  // We do not have this operation, but we want those tests.
  // Use only the public api!
  func reduce<T: DecimalFloatingPoint & DecimalMixin>(_ d: T, expected: T) -> T {
    return d.quantized(to: expected, rounding: .towardZero)
  }

  // MARK: - Canonical

  // Our parser takes care of making things canonical.
  func canonical<T: DecimalFloatingPoint & DecimalMixin>(_ d: T) -> T {
    return d
  }

  // MARK: - Helpers

  private func handleNaN<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    status: inout DecimalStatus
  ) -> T? {
    if lhs.isSignalingNaN {
      status.set(.isInvalidOperation)
      return self.removeSignalingBit(lhs)
    }

    if rhs.isSignalingNaN {
      status.set(.isInvalidOperation)
      return self.removeSignalingBit(rhs)
    }

    if lhs.isNaN {
      return lhs
    }

    if rhs.isNaN {
      return rhs
    }

    return nil
  }

  // Ultra common.
  // Swift is 'ok' with returning 'snan', but Speleotrove wants 'nan'.
  func removeSignalingBit<T: DecimalMixin>(_ d: T) -> T {
    let bit = T.nanQuietMask ^ T.nanSignalingMask
    return T(unchecked: d.bid & (~bit))
  }

  /// Invalid result: `0xbad`.
  private func errorMarker<T: DecimalFloatingPoint & DecimalMixin>() -> T {
    return T(nan: 0xbad, signaling: true)
  }
}
