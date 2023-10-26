extension DecimalFloatingPoint {

  /// Nerd! 🤓
  public static var is754version1985: Bool { return false }

  /// Nerd! 🤓
  public static var is754version2008: Bool { return true }

  /// The radix, or base of exponentiation, for a floating-point type.
  ///
  /// The magnitude of a floating-point value `x` of type `F` can be calculated
  /// by using the following formula, where `**` is exponentiation:
  ///
  ///     x.significand * (F.radix ** x.exponent)
  public static var radix: Int { 10 }

  /// The classification of this value.
  ///
  /// A value's `floatingPointClass` property describes its "class" as
  /// described by the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  public var floatingPointClass: FloatingPointClassification {
    // Taken from Swift sources.
    if isSignalingNaN { return .signalingNaN }
    if isNaN { return .quietNaN }
    if isInfinite { return sign == .minus ? .negativeInfinity : .positiveInfinity }
    if isNormal { return sign == .minus ? .negativeNormal : .positiveNormal }
    if isSubnormal { return sign == .minus ? .negativeSubnormal : .positiveSubnormal }
    return sign == .minus ? .negativeZero : .positiveZero
  }

  public var exponent: Exponent {
    var status = DecimalStatus()
    return self.exponent(status: &status)
  }

  /// Creates a decimal with a canonical value of 0.
  public init() {
    self = Self.zero
  }

  // overload: only rounding or no args
  public init(
    sign: FloatingPointSign,
    exponent: Exponent,
    significand: Self,
    rounding: DecimalFloatingPointRoundingRule = .{default_rounding_scaleb}
  ) {
    var status = DecimalStatus()
    self = Self(
      sign: sign,
      exponent: exponent,
      significand: significand,
      rounding: rounding,
      status: &status
    )
  }

  // overload: only status
  public init(
    sign: FloatingPointSign,
    exponent: Exponent,
    significand: Self,
    status: inout DecimalStatus
  ) {
    self = Self(
      sign: sign,
      exponent: exponent,
      significand: significand,
      rounding: .{default_rounding_scaleb},
      status: &status
    )
  }

  // MARK: - Init from String

  // overload: only rounding or no args
  public init?<S: StringProtocol>(
    _ description: S,
    rounding: DecimalFloatingPointRoundingRule = .{default_rounding_string_to_decimal}
  ) {
    var status = DecimalStatus()

    guard let result = Self(description, rounding: rounding, status: &status) else {
      return nil
    }

    self = result
  }

  // overload: only status
  public init?<S: StringProtocol>(
    _ description: S,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.{default_rounding_string_to_decimal}

    guard let result = Self(description, rounding: rounding, status: &status) else {
      return nil
    }

    self = result
  }

  public init?<S: StringProtocol>(exactly description: S) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven

    guard let result = Self(description, rounding: rounding, status: &status) else {
      return nil
    }

    if status.isInexact {
      return nil
    }

    self = result
  }

  // MARK: - Init from Int

  /// Creates a new value, rounded to the closest possible representation.
  ///
  /// - Parameter value: The integer to convert to a floating-point value.
  public init(_ value: Int) {
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.{default_rounding_int_to_decimal}
    self = Self(value, rounding: rounding, status: &status)
  }

  public init(integerLiteral value: Int) {
    self = Self(value)
  }

  // overload: only rounding or no args
  public init<Source: BinaryInteger>(
    _ value: Source,
    rounding: DecimalFloatingPointRoundingRule = .{default_rounding_int_to_decimal}
  ) {
    var status = DecimalStatus()
    self = Self(value, rounding: rounding, status: &status)
  }

  // overload: only status
  public init<Source: BinaryInteger>(
    _ value: Source,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.{default_rounding_int_to_decimal}
    self = Self(value, rounding: rounding, status: &status)
  }

  /// Creates a new value, if the given integer can be represented exactly.
  ///
  /// If the given integer cannot be represented exactly, the result is `nil`.
  ///
  /// - Parameter value: The integer to convert to a floating-point value.
  public init?<Source: BinaryInteger>(exactly source: Source) {
    // This method raises:
    // - isInexact -> fail
    // - isOverflowInexact -> fail
    // - isUnderflowInexact -> fail
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    self = Self(source, rounding: rounding, status: &status)

    if status.isInexact {
      return nil
    }

    // Any unexpected flags?
    status.clear(.isOverflowInexact | .isUnderflowInexact)
    assert(status.isEmpty)
  }

  // MARK: - Init from Float

{init_from_float}
{init_from_double}
{init_from_float80}

  // MARK: - Unary

  /// Returns the given number unchanged.
  ///
  /// You can use the unary plus operator (`+`) to provide symmetry in your
  /// code for positive numbers when also using the unary minus operator.
  ///
  ///     let x = -21
  ///     let y = +21
  ///     // x == -21
  ///     // y == 21
  ///
  /// - Returns: The given argument without any changes.
  public static prefix func + (n: Self) -> Self {
    return n
  }

  /// Calculates the additive inverse of a value.
  ///
  /// The unary minus operator (prefix `-`) calculates the negation of its
  /// operand. The result is always exact.
  ///
  ///     let x = 21.5
  ///     let y = -x
  ///     // y == -21.5
  ///
  /// - Parameter operand: The value to negate.
  public static prefix func - (n: Self) -> Self {
    var copy = n
    copy.negate()
    return copy
  }

  // MARK: - Add

  /// Adds two values and produces their sum, rounding to a representable
  /// value.
  ///
  /// The addition operator (`+`) calculates the sum of its two arguments. For
  /// example:
  ///
  ///     let x = 1.5
  ///     let y = x + 2.25
  ///     // y == 3.75
  ///
  /// The `+` operator implements the addition operation defined by the
  /// [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
  public static func + (lhs: Self, rhs: Self) -> Self {
    return lhs.adding(rhs, rounding: .{default_rounding_math})
  }

  /// Adds two values and stores the result in the left-hand-side variable,
  /// rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
  public static func += (lhs: inout Self, rhs: Self) {
    lhs = lhs.adding(rhs, rounding: .{default_rounding_math})
  }

  /// Adds two values and stores the result in the left-hand-side variable,
  /// rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
{binary_overloads_add}

  // MARK: - Sub

  /// Subtracts one value from another and produces their difference, rounded
  /// to a representable value.
  ///
  /// The subtraction operator (`-`) calculates the difference of its two
  /// arguments. For example:
  ///
  ///     let x = 7.5
  ///     let y = x - 2.25
  ///     // y == 5.25
  ///
  /// The `-` operator implements the subtraction operation defined by the
  /// [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
  public static func - (lhs: Self, rhs: Self) -> Self {
    return lhs.subtracting(rhs, rounding: .{default_rounding_math})
  }

  /// Subtracts the second value from the first and stores the difference in
  /// the left-hand-side variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
  public static func -= (lhs: inout Self, rhs: Self) {
    lhs = lhs.subtracting(rhs, rounding: .{default_rounding_math})
  }

  /// Subtracts the second value from the first and stores the difference in
  /// the left-hand-side variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
{binary_overloads_sub}

  // MARK: - Mul

  /// Multiplies two values and produces their product, rounding to a
  /// representable value.
  ///
  /// The multiplication operator (`*`) calculates the product of its two
  /// arguments. For example:
  ///
  ///     let x = 7.5
  ///     let y = x * 2.25
  ///     // y == 16.875
  ///
  /// The `*` operator implements the multiplication operation defined by the
  /// [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
  public static func * (lhs: Self, rhs: Self) -> Self {
    return lhs.multiplied(by: rhs, rounding: .{default_rounding_math})
  }

  /// Multiplies two values and stores the result in the left-hand-side
  /// variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs = lhs.multiplied(by: rhs, rounding: .{default_rounding_math})
  }

  /// Multiplies two values and stores the result in the left-hand-side
  /// variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
{binary_overloads_mul}

  // MARK: - Div

  /// Returns the quotient of dividing the first value by the second, rounding
  /// to a representable value.
  ///
  /// The division operator (`/`) calculates the quotient of the division if
  /// `rhs` is nonzero. If `rhs` is zero, the result of the division is
  /// infinity, with the sign of the result matching the sign of `lhs`.
  ///
  ///     let x = 16.875
  ///     let y = x / 2.25
  ///     // y == 7.5
  ///
  ///     let z = x / 0
  ///     // z.isInfinite == true
  ///
  /// The `/` operator implements the division operation defined by the [IEEE
  /// 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
  public static func / (lhs: Self, rhs: Self) -> Self {
    return lhs.divided(by: rhs, rounding: .{default_rounding_math})
  }

  /// Divides the first value by the second and stores the quotient in the
  /// left-hand-side variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs.divided(by: rhs, rounding: .{default_rounding_math})
  }

  /// Divides the first value by the second and stores the quotient in the
  /// left-hand-side variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
{binary_overloads_div}

  // MARK: - Remainder

  /// Replaces this value with the remainder of itself divided by the given
  /// value.
  ///
  /// For two finite values `x` and `y`, the remainder `r` of dividing `x` by
  /// `y` satisfies `x == y * q + r`, where `q` is the integer nearest to
  /// `x / y`. If `x / y` is exactly halfway between two integers, `q` is
  /// chosen to be even. Note that `q` is *not* `x / y` computed in
  /// floating-point arithmetic, and that `q` may not be representable in any
  /// available integer type.
  ///
  /// The following example calculates the remainder of dividing 8.625 by 0.75:
  ///
  ///     var x = 8.625
  ///     print(x / 0.75)
  ///     // Prints "11.5"
  ///
  ///     let q = (x / 0.75).rounded(.toNearestOrEven)
  ///     // q == 12.0
  ///     x.formRemainder(dividingBy: 0.75)
  ///     // x == -0.375
  ///
  ///     let x1 = 0.75 * q + x
  ///     // x1 == 8.625
  ///
  /// If this value and `other` are finite numbers, the remainder is in the
  /// closed range `-abs(other / 2)...abs(other / 2)`. The
  /// `formRemainder(dividingBy:)` method is always exact.
  ///
  /// - Parameter other: The value to use when dividing this value.
  public mutating func formRemainder(
    dividingBy other: Self,
    status: inout DecimalStatus
  ) {
    self = self.remainder(dividingBy: other, status: &status)
  }

  public mutating func formRemainder(dividingBy other: Self) {
    var status = DecimalStatus()
    self = self.remainder(dividingBy: other, status: &status)
  }

  public func remainder(dividingBy other: Self) -> Self {
    var status = DecimalStatus()
    return self.remainder(dividingBy: other, status: &status)
  }

  /// Replaces this value with the remainder of itself divided by the given
  /// value using truncating division.
  ///
  /// Performing truncating division with floating-point values results in a
  /// truncated integer quotient and a remainder. For values `x` and `y` and
  /// their truncated integer quotient `q`, the remainder `r` satisfies
  /// `x == y * q + r`.
  ///
  /// The following example calculates the truncating remainder of dividing
  /// 8.625 by 0.75:
  ///
  ///     var x = 8.625
  ///     print(x / 0.75)
  ///     // Prints "11.5"
  ///
  ///     let q = (x / 0.75).rounded(.towardZero)
  ///     // q == 11.0
  ///     x.formTruncatingRemainder(dividingBy: 0.75)
  ///     // x == 0.375
  ///
  ///     let x1 = 0.75 * q + x
  ///     // x1 == 8.625
  ///
  /// If this value and `other` are both finite numbers, the truncating
  /// remainder has the same sign as this value and is strictly smaller in
  /// magnitude than `other`. The `formTruncatingRemainder(dividingBy:)`
  /// method is always exact.
  ///
  /// - Parameter other: The value to use when dividing this value.
  public mutating func formTruncatingRemainder(
    dividingBy other: Self,
    status: inout DecimalStatus
  ) {
    self = self.truncatingRemainder(dividingBy: other, status: &status)
  }

  public mutating func formTruncatingRemainder(dividingBy other: Self) {
    var status = DecimalStatus()
    self = self.truncatingRemainder(dividingBy: other, status: &status)
  }

  public func truncatingRemainder(dividingBy other: Self) -> Self {
    var status = DecimalStatus()
    return self.truncatingRemainder(dividingBy: other, status: &status)
  }

  // MARK: - Square root

  /// Replaces this value with its square root, rounding using the specified
  /// rounding rule.
{unary_overloads_square_root}

  // MARK: - Adding product

  /// Adds the product of the two given values to this value in place, computed
  /// without intermediate rounding.
  ///
  /// - Parameters:
  ///   - lhs: One of the values to multiply before adding to this value.
  ///   - rhs: The other value to multiply.
  public mutating func addProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func addProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule = .{default_rounding_math}
  ) {
    var status = DecimalStatus()
    self = self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func addProduct(
    _ lhs: Self,
    _ rhs: Self,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.{default_rounding_math}
    self = self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func addingProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule = .{default_rounding_math}
  ) -> Self {
    var status = DecimalStatus()
    return self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // overload: only status
  public func addingProduct(
    _ lhs: Self,
    _ rhs: Self,
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.{default_rounding_math}
    return self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // MARK: - Equal, compare

  public func isEqual(to other: Self) -> Bool {
    var status = DecimalStatus()
    return self.isEqual(to: other, status: &status)
  }

  public func isLess(than other: Self) -> Bool {
    var status = DecimalStatus()
    return self.isLess(than: other, status: &status)
  }

  public func isLessThanOrEqualTo(_ other: Self) -> Bool {
    var status = DecimalStatus()
    return self.isLessThanOrEqualTo(other, status: &status)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.isEqual(to: rhs)
  }

  public static func < (lhs: Self, rhs: Self) -> Bool {
    return lhs.isLess(than: rhs)
  }

  public static func <= (lhs: Self, rhs: Self) -> Bool {
    return lhs.isLessThanOrEqualTo(rhs)
  }

  public static func > (lhs: Self, rhs: Self) -> Bool {
    return rhs.isLess(than: lhs)
  }

  public static func >= (lhs: Self, rhs: Self) -> Bool {
    return rhs.isLessThanOrEqualTo(lhs)
  }

  // MARK: - Total order

  public func isMagnitudeTotallyOrdered(belowOrEqualTo other: Self) -> Bool {
    let s = self.magnitude
    let o = other.magnitude
    return s.isTotallyOrdered(belowOrEqualTo: o)
  }

  // MARK: - Minimum/maximum

  public static func minimum(_ x: Self, _ y: Self) -> Self {
    var status = DecimalStatus()
    return Self.minimum(x, y, status: &status)
  }

  public static func maximum(_ x: Self, _ y: Self) -> Self {
    var status = DecimalStatus()
    return Self.maximum(x, y, status: &status)
  }

  public static func minimumMagnitude(_ x: Self, _ y: Self) -> Self {
    var status = DecimalStatus()
    return Self.minimumMagnitude(x, y, status: &status)
  }

  public static func maximumMagnitude(_ x: Self, _ y: Self) -> Self {
    var status = DecimalStatus()
    return Self.maximumMagnitude(x, y, status: &status)
  }

  // MARK: - Next

  public var nextUp: Self {
    var status = DecimalStatus()
    return self.nextUp(status: &status)
  }

  public var nextDown: Self {
    var status = DecimalStatus()
    return self.nextDown(status: &status)
  }

  // MARK: - Quantize

{binary_overloads_quantize}

  // MARK: - Round

  /// Rounds the value to an integral value using the specified rounding rule.
  ///
  /// The following example rounds a value using four different rounding rules:
  ///
  ///     // Equivalent to the C 'round' function:
  ///     var w = 6.5
  ///     w.round(.toNearestOrAwayFromZero)
  ///     // w == 7.0
  ///
  ///     // Equivalent to the C 'trunc' function:
  ///     var x = 6.5
  ///     x.round(.towardZero)
  ///     // x == 6.0
  ///
  ///     // Equivalent to the C 'ceil' function:
  ///     var y = 6.5
  ///     y.round(.up)
  ///     // y == 7.0
  ///
  ///     // Equivalent to the C 'floor' function:
  ///     var z = 6.5
  ///     z.round(.down)
  ///     // z == 6.0
  ///
  /// For more information about the available rounding rules, see the
  /// `DecimalFloatingPointRoundingRule` enumeration. To round a value using the
  /// default "schoolbook rounding", you can use the shorter `round()` method
  /// instead.
  ///
  ///     var w1 = 6.5
  ///     w1.round()
  ///     // w1 == 7.0
  ///
  /// - Parameter rule: The rounding rule to use.
{unary_overloads_round}
}
