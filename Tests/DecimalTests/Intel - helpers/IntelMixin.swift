@testable import Decimal

protocol IntelMixin {}

extension IntelMixin {

  /// Intel does not have tests for `truncatingRemainder`, just the standard
  /// `remainder`.
  ///
  /// Note that this is not the correct code! But it does not have to be.
  /// It just needs to be correct enough to make those tests usable.
  func remainderFromTruncatingRemainder<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    dividingBy rhs: T
  ) -> T {
    let remainder = lhs.truncatingRemainder(dividingBy: rhs)

    if remainder.isNaN || remainder.isInfinite {
      return remainder
    }

    // We can either 'rhs/2' or '2*remainder'.
    let rhsMag = rhs.magnitude
    let remainderMag = remainder.magnitude
    let remainder2Mag = remainderMag.multiplied(by: 2, rounding: .towardZero)

    // Exactly half?
    if remainder2Mag == rhsMag {
      return -remainder
    }

    // Below half?
    if remainder2Mag < rhsMag {
      return remainder
    }

    // Above half -> sub and reverse sign
    let sign = lhs._sign ^ T.signMask
    let sub = rhsMag.subtracting(remainderMag, rounding: .towardZero)
    return T(unchecked: sign | sub.bid)
  }
}
