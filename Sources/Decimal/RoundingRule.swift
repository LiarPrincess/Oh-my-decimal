/// IEEE-754: 4.3 Rounding-direction attributes
public enum DecimalFloatingPointRoundingRule: Equatable, CustomStringConvertible {

  /// The floating-point number nearest to the infinitely precise result shall
  /// be delivered; if the two nearest floating-point numbers bracketing an
  /// unrepresentable infinitely precise result are equally near, the one with
  /// an even least significant digit shall be delivered
  case toNearestOrEven
  /// The floating-point number nearest to the infinitely precise result shall
  /// be delivered; if the two nearest floating-point numbers bracketing an
  /// unrepresentable infinitely precise result are equally near, the one with
  /// larger magnitude shall be delivered.
  case toNearestOrAwayFromZero
  /// The result shall be the format’s floating-point number (possibly +∞)
  /// closest to and no less than the infinitely precise result
  case up
  /// The result shall be the format’s floating-point number (possibly −∞) closest
  /// to and no greater than the infinitely precise result
  case down
  /// The result shall be the format’s floating-point number closest to
  /// and no greater in magnitude than the infinitely precise result.
  case towardZero

  // Swift has 'FloatingPointRoundingRule.awayFromZero'; IEEE-754 2008 does not.

  public var description: String {
    switch self {
    case .toNearestOrEven: return "toNearestOrEven"
    case .toNearestOrAwayFromZero: return "toNearestOrAwayFromZero"
    case .up: return "up"
    case .down: return "down"
    case .towardZero: return "towardZero"
    }
  }
}
