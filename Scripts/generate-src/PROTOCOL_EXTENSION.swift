extension DecimalFloatingPoint {

  /// The radix, or base of exponentiation, for a floating-point type.
  ///
  /// The magnitude of a floating-point value `x` of type `F` can be calculated
  /// by using the following formula, where `**` is exponentiation:
  ///
  ///     x.significand * (F.radix ** x.exponent)
  public static var radix: Int { 10 }

  /// Creates a decimal with a canonical value of 0.
  public init() {
    self = Self.zero
  }

  public init(sign: FloatingPointSign, exponent: Exponent, significand: Self) {
    self = Self(
      sign: sign,
      exponent: exponent,
      significand: significand,
      rounding: {default_rounding_scaleb}
    )
  }

  public init?(_ description: String) {
    guard let r = Self(description, rounding: {default_rounding_string_to_decimal}) else {
      return nil
    }

    self = r
  }

  // MARK: - Init from Int

  /// Creates a new value, rounded to the closest possible representation.
  ///
  /// - Parameter value: The integer to convert to a floating-point value.
  public init(_ value: Int) {
    self = Self(value, rounding: {default_rounding_int_to_decimal})
  }

  public init<Source: BinaryInteger>(_ value: Source) {
    self = Self(value, rounding: {default_rounding_int_to_decimal})
  }

  // MARK: - Init from Float

  public init(_ value: Float) {
    self = Self(value, rounding: {default_rounding_binary_to_decimal_floating_point})
  }

  public init(_ value: Double) {
    self = Self(value, rounding: {default_rounding_binary_to_decimal_floating_point})
  }

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

  /// Creates a new instance from the given value, rounding using the
  /// specified rounding mode.
  ///
  /// - Parameters:
  ///   - value: A floating-point value to be converted.
  ///   - rounding: A rounding rule to be used.
  public init(_ value: Float80) {
    self = Self(value, rounding: {default_rounding_binary_to_decimal_floating_point})
  }

#endif

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
    return lhs.adding(rhs, rounding: {default_rounding_math})
  }

  /// Adds two values and stores the result in the left-hand-side variable,
  /// rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
  public static func += (lhs: inout Self, rhs: Self) {
    lhs = lhs.adding(rhs, rounding: {default_rounding_math})
  }

  /// Adds two values and stores the result in the left-hand-side variable,
  /// rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
  public mutating func add(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule = {default_rounding_math}
  ) {
    self = self.adding(other, rounding: rounding)
  }

  public func adding(_ other: Self) -> Self {
    return self.adding(other, rounding: {default_rounding_math})
  }

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
    return lhs.subtracting(rhs, rounding: {default_rounding_math})
  }

  /// Subtracts the second value from the first and stores the difference in
  /// the left-hand-side variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
  public static func -= (lhs: inout Self, rhs: Self) {
    lhs = lhs.subtracting(rhs, rounding: {default_rounding_math})
  }

  /// Subtracts the second value from the first and stores the difference in
  /// the left-hand-side variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
  public mutating func subtract(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule = {default_rounding_math}
  ) {
    self = self.subtracting(other, rounding: rounding)
  }

  public func subtracting(_ other: Self) -> Self {
    return self.subtracting(other, rounding: {default_rounding_math})
  }

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
    return lhs.multiplied(by: rhs, rounding: {default_rounding_math})
  }

  /// Multiplies two values and stores the result in the left-hand-side
  /// variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs = lhs.multiplied(by: rhs, rounding: {default_rounding_math})
  }

  /// Multiplies two values and stores the result in the left-hand-side
  /// variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
  public mutating func multiply(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule = {default_rounding_math}
  ) {
    self = self.multiplied(by: other, rounding: rounding)
  }

  public func multiplied(by other: Self) -> Self {
    return self.multiplied(by: other, rounding: {default_rounding_math})
  }

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
    return lhs.divided(by: rhs, rounding: {default_rounding_math})
  }

  /// Divides the first value by the second and stores the quotient in the
  /// left-hand-side variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs.divided(by: rhs, rounding: {default_rounding_math})
  }

  /// Divides the first value by the second and stores the quotient in the
  /// left-hand-side variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
  public mutating func divide(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule = {default_rounding_math}
  ) {
    self = self.divided(by: other, rounding: rounding)
  }

  public func divided(by other: Self) -> Self {
    return self.divided(by: other, rounding: {default_rounding_math})
  }

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
  public mutating func formRemainder(dividingBy other: Self) {
    self = self.remainder(dividingBy: other)
  }

  // MARK: - Pow

  public func pow(exponent: Self) -> Self {
    return self.pow(exponent: exponent, rounding: {default_rounding_math})
  }

  /// Replaces this value with value raised to the exponent.
  public mutating func formPow(exponent: Self) {
    self = self.pow(exponent: exponent, rounding: {default_rounding_math})
  }

  // MARK: - Square root

  /// Replaces this value with its square root, rounding using the specified
  /// rounding rule.
  public mutating func formSquareRoot(
    rounding: DecimalFloatingPointRoundingRule = {default_rounding_math}
  ) {
    self = squareRoot(rounding: rounding)
  }

  public func squareRoot() -> Self {
    return self.squareRoot(rounding: {default_rounding_math})
  }

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
    rounding: DecimalFloatingPointRoundingRule = {default_rounding_math}
  ) {
    self = self.addingProduct(lhs, rhs, rounding: rounding)
  }

  public func addingProduct(_ lhs: Self,_ rhs: Self) -> Self {
    return self.addingProduct(lhs, rhs, rounding: {default_rounding_math})
  }

  // MARK: - Quantize

  public func quantize(other: Self) -> Self {
    return self.quantize(to: other, rounding: {default_rounding_quantize})
  }

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
  public mutating func round(
    _ rule: DecimalFloatingPointRoundingRule = {default_rounding_round}
  ) {
    self = self.rounded(rule)
  }

  public func rounded() -> Self {
    return self.rounded({default_rounding_round})
  }
}
