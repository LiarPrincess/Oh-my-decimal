// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================
// This code was generated based on the 'public' operations from 'Decimal64'.
// =============================================================================

/// It is a truth universally acknowledged, that `0.1 + 0.2` must be
/// `0.30000000000000004`.
///
/// …
///
/// This is a radix 10 (decimal) floating-point type from IEEE 754.
public protocol DecimalFloatingPoint: Comparable, Hashable,
                                      Sendable, Codable,
                                      ExpressibleByIntegerLiteral,
                                      CustomStringConvertible {

  /// A type that can represent any written exponent.
  associatedtype Exponent: SignedInteger & FixedWidthInteger

  /// A type that stores dem bits..
  associatedtype BitPattern: UnsignedInteger & FixedWidthInteger

  /// A quiet NaN ("not a number").
  ///
  /// A NaN compares not equal, not greater than, and not less than every
  /// value, including itself. Passing a NaN to an operation generally results
  /// in NaN.
  ///
  ///     let x = 1.21
  ///     // x > Decimal64.nan == false
  ///     // x < Decimal64.nan == false
  ///     // x == Decimal64.nan == false
  ///
  /// Because a NaN always compares not equal to itself, to test whether a
  /// floating-point value is NaN, use its `isNaN` property instead of the
  /// equal-to operator (`==`). In the following example, `y` is NaN.
  ///
  ///     let y = x + Decimal64.nan
  ///     print(y == Decimal64.nan)
  ///     // Prints "false"
  ///     print(y.isNaN)
  ///     // Prints "true"
  static var nan: Self { get }

  /// A signaling NaN ("not a number").
  ///
  /// The default IEEE 754 behavior of operations involving a signaling NaN is
  /// to raise the Invalid flag in the floating-point environment and return a
  /// quiet NaN.
  ///
  /// Other than these signaling operations, a signaling NaN behaves in the
  /// same manner as a quiet NaN.
  static var signalingNaN: Self { get }

  /// Positive infinity.
  ///
  /// Infinity compares greater than all finite numbers and equal to other
  /// infinite values.
  ///
  ///     let x = Decimal64.greatestFiniteMagnitude
  ///     let y = x * 2
  ///     // y == Decimal64.infinity
  ///     // y > x
  static var infinity: Self { get }

  /// The mathematical constant pi (π), approximately equal to 3.14159.
  ///
  /// When measuring an angle in radians, π is equivalent to a half-turn.
  ///
  /// This value is rounded toward zero to keep user computations with angles
  /// from inadvertently ending up in the wrong quadrant.
  ///
  ///     print(Decimal64.pi)
  ///     // Prints "+3141592653589793E-15"
  static var pi: Self { get }

  /// The zero value.
  ///
  /// Zero is the identity element for addition. For any value,
  /// `x + .zero == x` and `.zero + x == x`.
  static var zero: Self { get }

  /// The greatest finite number representable by this type.
  ///
  /// This value compares greater than or equal to all finite numbers, but less
  /// than `infinity`.
  ///
  /// This value corresponds to type-specific C macros such as `FLT_MAX` and
  /// `DBL_MAX`. The naming of those macros is slightly misleading, because
  /// `infinity` is greater than this value.
  static var greatestFiniteMagnitude: Self { get }

  /// The least positive normal number.
  ///
  /// This value compares less than or equal to all positive normal numbers.
  /// There may be smaller positive numbers, but they are *subnormal*, meaning
  /// that they are represented with less precision than normal numbers.
  ///
  /// This value corresponds to type-specific C macros such as `FLT_MIN` and
  /// `DBL_MIN`. The naming of those macros is slightly misleading, because
  /// subnormals, zeros, and negative numbers are smaller than this value.
  static var leastNormalMagnitude: Self { get }

  /// The least positive number.
  ///
  /// This value compares less than or equal to all positive numbers, but
  /// greater than zero. If the type supports subnormal values,
  /// `leastNonzeroMagnitude` is smaller than `leastNormalMagnitude`;
  /// otherwise they are equal.
  static var leastNonzeroMagnitude: Self { get }

  /// A Boolean value indicating whether the instance is equal to zero.
  ///
  /// The `isZero` property of a value `x` is `true` when `x` represents either
  /// `-0.0` or `+0.0`. `x.isZero` is equivalent to the following comparison:
  /// `x == 0.0`.
  ///
  ///     let x = -0.0
  ///     x.isZero        // true
  ///     x == 0.0        // true
  var isZero: Bool { get }

  /// A Boolean value indicating whether this instance is finite.
  ///
  /// All values other than NaN and infinity are considered finite, whether
  /// normal or subnormal.  For NaN, both `isFinite` and `isInfinite` are false.
  var isFinite: Bool { get }

  /// A Boolean value indicating whether the instance is infinite.
  ///
  /// For NaN, both `isFinite` and `isInfinite` are false.
  var isInfinite: Bool { get }

  /// A Boolean value indicating whether the instance's representation is in
  /// its canonical form.
  ///
  /// The [IEEE 754 specification][spec] defines a *canonical*, or preferred,
  /// encoding of a floating-point value.
  ///
  /// Decimal floating-point types admit a large number of non-canonical
  /// encodings. Consult the IEEE 754 standard for additional details.
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  var isCanonical: Bool { get }

  /// A Boolean value indicating whether this instance is normal.
  ///
  /// A *normal* value is a finite number that uses the full precision
  /// available to values of a type. Zero is neither a normal nor a subnormal
  /// number.
  var isNormal: Bool { get }

  /// A Boolean value indicating whether the instance is subnormal.
  ///
  /// A *subnormal* value is a nonzero number that has a lesser magnitude than
  /// the smallest normal number. Subnormal values don't use the full
  /// precision available to values of a type.
  ///
  /// Zero is neither a normal nor a subnormal number. Subnormal numbers are
  /// often called *denormal* or *denormalized*---these are different names
  /// for the same concept.
  var isSubnormal: Bool { get }

  /// A Boolean value indicating whether the instance is NaN ("not a number").
  ///
  /// Because NaN is not equal to any value, including NaN, use this property
  /// instead of the equal-to operator (`==`) or not-equal-to operator (`!=`)
  /// to test whether a value is or is not NaN. For example:
  ///
  ///     let x = Decimal64()
  ///     let y = x * .infinity
  ///     // y is a NaN
  ///
  ///     // Comparing with the equal-to operator never returns 'true'
  ///     print(x == Decimal64.nan)
  ///     // Prints "false"
  ///     print(y == Decimal64.nan)
  ///     // Prints "false"
  ///
  ///     // Test with the 'isNaN' property instead
  ///     print(x.isNaN)
  ///     // Prints "false"
  ///     print(y.isNaN)
  ///     // Prints "true"
  ///
  /// This property is `true` for both quiet and signaling NaNs.
  var isNaN: Bool { get }

  /// A Boolean value indicating whether the instance is a signaling NaN.
  ///
  /// Signaling NaNs typically raise the Invalid flag when used in general
  /// computing operations.
  var isSignalingNaN: Bool { get }

  /// The sign of the floating-point value.
  ///
  /// The `sign` property is `.minus` if the value's signbit is set, and
  /// `.plus` otherwise. For example:
  ///
  ///     let x = Decimal64(-33)
  ///     // x.sign == .minus
  ///
  /// Don't use this property to check whether a floating point value is
  /// negative. For a value `x`, the comparison `x.sign == .minus` is not
  /// necessarily the same as `x < 0`. In particular, `x.sign == .minus` if
  /// `x` is -0, and while `x < 0` is always `false` if `x` is NaN, `x.sign`
  /// could be either `.plus` or `.minus`.
  var sign: FloatingPointSign { get }

  /// IEEE-754: 5.5.2 Decimal re-encoding operations.
  /// Binary integer decimal.
  var binaryEncoding: BitPattern { get }

  /// IEEE-754: 5.5.2 Decimal re-encoding operations.
  /// Densely packed decimal.
  var decimalEncoding: BitPattern { get }

  /// The exponent of the floating-point value.
  ///
  /// The *exponent* of a floating-point value is the integer part of the
  /// logarithm of the value's magnitude. For a value `x` of a floating-point
  /// type `F`, the magnitude can be calculated as the following, where `**`
  /// is exponentiation:
  ///
  ///     x.significand * (F.radix ** x.exponent)
  ///
  /// In the next example, `y` has a value of `33.33333333333333`.
  /// Exponent is equal to `floor(log10(y)) = floor(1.5228787) = 1`
  /// and significand is `3.333333333333333` (always between [1, 10)).
  ///
  ///     let y: Decimal64 = 100 / 3 // +3333333333333333E-14 = 33.33333333333333
  ///     // y.significand == +3333333333333333E-15 // 3.333333333333333
  ///     // y.exponent == 1
  ///     // Decimal64.radix == 10
  ///
  /// The `exponent` property has the following edge cases:
  ///
  /// - If `x` is zero, then `x.exponent` is `Int.min`.
  /// - If `x` is +/-infinity or NaN, then `x.exponent` is `Int.max`
  ///
  /// This property implements the `logB` operation defined by the [IEEE 754
  /// specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  func exponent(status: inout DecimalStatus) -> Exponent

  /// The significand of the floating-point value.
  ///
  /// The magnitude of a floating-point value `x` of type `F` can be calculated
  /// by using the following formula, where `**` is exponentiation:
  ///
  ///     x.significand * (F.radix ** x.exponent)
  ///
  /// In the next example, `y` has a value of `33.33333333333333`.
  /// Exponent is equal to `floor(log10(y)) = floor(1.5228787) = 1`
  /// and significand is `3.333333333333333`.
  ///
  ///     let y: Decimal64 = 100 / 3 // +3333333333333333E-14 = 33.33333333333333
  ///     // y.significand == +3333333333333333E-15 // 3.333333333333333
  ///     // y.exponent == 1
  ///     // Decimal64.radix == 10
  ///
  /// If a type's radix is 10, then for finite nonzero numbers, the significand
  /// is in the range `1.0 ..< 10.0`. For other values of `x`, `x.significand`
  /// is defined as follows:
  ///
  /// - If `x` is zero, then `x.significand` is 0.0.
  /// - If `x` is infinite, then `x.significand` is infinity.
  /// - If `x` is NaN, then `x.significand` is NaN.
  /// - Note: The significand is frequently also called the *mantissa*, but
  ///   significand is the preferred terminology in the [IEEE 754
  ///   specification][spec], to allay confusion with the use of mantissa for
  ///   the fractional part of a logarithm.
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  var significand: Self { get }

  /// The magnitude of this value.
  ///
  /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
  /// You can use the `magnitude` property in operations that are simpler to
  /// implement in terms of unsigned values, such as printing the value of an
  /// integer, which is just printing a '-' character in front of an absolute
  /// value.
  ///
  ///     let x = -200
  ///     // x.magnitude == 200
  ///
  /// The global `abs(_:)` function provides more familiar syntax when you need
  /// to find an absolute value. In addition, because `abs(_:)` always returns
  /// a value of the same type, even in a generic context, using the function
  /// instead of the `magnitude` property is encouraged.
  var magnitude: Self { get }

  /// A textual representation of this instance.
  ///
  /// Calling this property directly is discouraged. Instead, convert an
  /// instance of any type to a string by using the `String(describing:)`
  /// initializer. This initializer works with any type, and uses the custom
  /// `description` property for types that conform to
  /// `CustomStringConvertible`:
  ///
  ///     struct Point: CustomStringConvertible {
  ///         let x: Int, y: Int
  ///
  ///         var description: String {
  ///             return "(\(x), \(y))"
  ///         }
  ///     }
  ///
  ///     let p = Point(x: 21, y: 30)
  ///     let s = String(describing: p)
  ///     print(s)
  ///     // Prints "(21, 30)"
  ///
  /// The conversion of `p` to a string in the assignment to `s` uses the
  /// `Point` type's `description` property.
  var description: String { get }

  /// Creates a NaN ("not a number") value with the specified payload.
  ///
  /// NaN values compare not equal to every value, including themselves. Most
  /// operations with a NaN operand produce a NaN result. Don't use the
  /// equal-to operator (`==`) to test whether a value is NaN. Instead, use
  /// the value's `isNaN` property.
  ///
  ///     let x = Decimal64(nan: 0, signaling: false)
  ///     print(x == .nan)
  ///     // Prints "false"
  ///     print(x.isNaN)
  ///     // Prints "true"
  ///
  /// - Parameters:
  ///   - payload: The payload to use for the new NaN value.
  ///   - signaling: Pass `true` to create a signaling NaN or `false` to create
  ///     a quiet NaN.
  init(
    nan payload: BitPattern,
    signaling: Bool
  )

  /// IEEE-754: 5.5.2 Decimal re-encoding operations.
  /// Binary integer decimal.
  init(binaryEncoding: BitPattern)

  /// IEEE-754: 5.5.2 Decimal re-encoding operations.
  /// Densely packed decimal.
  init(decimalEncoding: BitPattern)

  /// Creates a new floating-point value using the sign of one value and the
  /// magnitude of another.
  ///
  /// The following example uses this initializer to create a new `Decimal64`
  /// instance with the sign of `a` and the magnitude of `b`:
  ///
  ///     let a = Decimal64(-21)
  ///     let b = Decimal64(305)
  ///     let c = Decimal64(signOf: a, magnitudeOf: b)
  ///     print(c)
  ///     // Prints "-305E+0"
  ///
  /// This initializer implements the IEEE 754 `copysign` operation.
  ///
  /// - Parameters:
  ///   - signOf: A value from which to use the sign. The result of the
  ///     initializer has the same sign as `signOf`.
  ///   - magnitudeOf: A value from which to use the magnitude. The result of
  ///     the initializer has the same magnitude as `magnitudeOf`.
  init(
    signOf s: Self,
    magnitudeOf m: Self
  )

  /// Creates a new value from the given sign, exponent, and significand.
  ///
  /// This initializer is equivalent to the following calculation, where `**`
  /// is exponentiation, computed as if by a single, correctly rounded,
  /// floating-point operation:
  ///
  ///     let sign: FloatingPointSign = .plus
  ///     let exponent = -2
  ///     let significand = Decimal64(5)
  ///     let y = (sign == .minus ? -1 : 1) * significand * 10 ** exponent
  ///     // y == +5E-2
  ///
  /// As with any basic operation, if this value is outside the representable
  /// range of the type, overflow or underflow occurs, and zero, a subnormal
  /// value, or infinity may result. In addition, there are two other edge
  /// cases:
  ///
  /// - If the value you pass to `significand` is zero or infinite, the result
  ///   is zero or infinite, regardless of the value of `exponent`.
  /// - If the value you pass to `significand` is NaN, the result is NaN.
  ///
  /// For any floating-point value `x` of type `F`, the result of the following
  /// is equal to `x`, with the distinction that the result is canonicalized
  /// if `x` is in a noncanonical encoding:
  ///
  ///     let x0 = F(sign: x.sign, exponent: x.exponent, significand: x.significand)
  ///
  /// Please note that the returned `0` may be of a different cohort (different
  /// exponent) than `x0` (for `0.exponent` returns `Int.min`).
  ///
  /// This initializer implements the `scaleB` operation defined by the [IEEE
  /// 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - sign: The sign to use for the new value.
  ///   - exponent: The new value's exponent.
  ///   - significand: The new value's significand.
  init(
    sign: FloatingPointSign,
    exponent: Exponent,
    significand: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  )

  /// Creates a new value from the given `String`, rounded using the specified
  /// rounding rule.
  ///
  /// - Parameters:
  ///   - description: String to convert to a floating-point value.
  init?<S: StringProtocol>(
    _ description: S,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  )

  /// Creates a new value, rounded using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - value: The integer to convert to a floating-point value.
  init<Source: BinaryInteger>(
    _ value: Source,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  )

  /// Creates a new instance from the given value, rounded using the specified
  /// rounding rule.
  ///
  /// - Parameters:
  ///   - value: A floating-point value to be converted.
  init(
    _ value: Float,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  )

  /// Creates a new instance from the given value, rounded using the specified
  /// rounding rule.
  ///
  /// - Parameters:
  ///   - value: A floating-point value to be converted.
  init(
    _ value: Double,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  )

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

  /// Creates a new instance from the given value, rounded using the specified
  /// rounding rule.
  ///
  /// - Parameters:
  ///   - value: A floating-point value to be converted.
  init(
    _ value: Float80,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  )

#endif

  /// Replaces this value with its additive inverse.
  ///
  /// The result is always exact. This example uses the `negate()` method to
  /// negate the value of the variable `x`:
  ///
  ///     var x = 21.5
  ///     x.negate()
  ///     // x == -21.5
  mutating func negate()

  /// Adds two values and produces their sum, rounding using the specified
  /// rounding rule.
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
  func adding(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// Subtracts one value from another and produces their difference, rounding
  /// using the specified rounding rule.
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
  func subtracting(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// Multiplies two values and produces their product, rounding using the
  /// specified rounding rule.
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
  func multiplied(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the quotient of dividing the first value by the second, rounding
  /// using the specified rounding rule.
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
  func divided(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the remainder of this value divided by the given value.
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
  ///     let x = 8.625
  ///     print(x / 0.75)
  ///     // Prints "11.5"
  ///
  ///     let q = (x / 0.75).rounded(.toNearestOrEven)
  ///     // q == 12.0
  ///     let r = x.remainder(dividingBy: 0.75)
  ///     // r == -0.375
  ///
  ///     let x1 = 0.75 * q + r
  ///     // x1 == 8.625
  ///
  /// If this value and `other` are finite numbers, the remainder is in the
  /// closed range `-abs(other / 2)...abs(other / 2)`. The
  /// `remainder(dividingBy:)` method is always exact. This method implements
  /// the remainder operation defined by the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameter other: The value to use when dividing this value.
  /// - Returns: The remainder of this value divided by `other`.
  func remainder(
    dividingBy other: Self,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the remainder of this value divided by the given value using
  /// truncating division.
  ///
  /// Performing truncating division with floating-point values results in a
  /// truncated integer quotient and a remainder. For values `x` and `y` and
  /// their truncated integer quotient `q`, the remainder `r` satisfies
  /// `x == y * q + r`.
  ///
  /// The following example calculates the truncating remainder of dividing
  /// 8.625 by 0.75:
  ///
  ///     let x = 8.625
  ///     print(x / 0.75)
  ///     // Prints "11.5"
  ///
  ///     let q = (x / 0.75).rounded(.towardZero)
  ///     // q == 11.0
  ///     let r = x.truncatingRemainder(dividingBy: 0.75)
  ///     // r == 0.375
  ///
  ///     let x1 = 0.75 * q + r
  ///     // x1 == 8.625
  ///
  /// If this value and `other` are both finite numbers, the truncating
  /// remainder has the same sign as this value and is strictly smaller in
  /// magnitude than `other`. The `truncatingRemainder(dividingBy:)` method
  /// is always exact.
  ///
  /// - Parameter other: The value to use when dividing this value.
  /// - Returns: The remainder of this value divided by `other` using
  ///   truncating division.
  func truncatingRemainder(
    dividingBy other: Self,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the square root of the value, rounding using the specified rounding
  /// rule.
  ///
  /// The following example declares a function that calculates the length of
  /// the hypotenuse of a right triangle given its two perpendicular sides.
  ///
  ///     func hypotenuse(_ a: Decimal64, _ b: Decimal64) -> Decimal64 {
  ///         return (a * a + b * b).squareRoot()
  ///     }
  ///
  ///     let (dx, dy) = (3.0, 4.0)
  ///     let distance = hypotenuse(dx, dy)
  ///     // distance == 5.0
  ///
  /// - Returns: The square root of the value.
  func squareRoot(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the result of adding the product of the two given values to this
  /// value, computed without intermediate rounding.
  ///
  /// This method is equivalent to the C `fma` function and implements the
  /// `fusedMultiplyAdd` operation defined by the [IEEE 754
  /// specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - lhs: One of the values to multiply before adding to this value.
  ///   - rhs: The other value to multiply.
  /// - Returns: The product of `lhs` and `rhs`, added to this value.
  func addingProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// Returns a Boolean value indicating whether this instance is equal to the
  /// given value.
  ///
  /// This method serves as the basis for the equal-to operator (`==`) for
  /// floating-point values. When comparing two values with this method, `-0`
  /// is equal to `+0`. NaN is not equal to any value, including itself. For
  /// example:
  ///
  ///     let x = 15.0
  ///     x.isEqual(to: 15.0)
  ///     // true
  ///     x.isEqual(to: .nan)
  ///     // false
  ///     Decimal64.nan.isEqual(to: .nan)
  ///     // false
  ///
  /// The `isEqual(to:)` method implements the equality predicate defined by
  /// the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameter other: The value to compare with this value.
  /// - Returns: `true` if `other` has the same value as this instance;
  ///   otherwise, `false`. If either this value or `other` is NaN, the result
  ///   of this method is `false`.
  func isEqual(
    to other: Self,
    status: inout DecimalStatus
  ) -> Bool

  /// Returns a Boolean value indicating whether this instance is less than the
  /// given value.
  ///
  /// This method serves as the basis for the less-than operator (`<`) for
  /// floating-point values. Some special cases apply:
  ///
  /// - Because NaN compares not less than nor greater than any value, this
  ///   method returns `false` when called on NaN or when NaN is passed as
  ///   `other`.
  /// - `-infinity` compares less than all values except for itself and NaN.
  /// - Every value except for NaN and `+infinity` compares less than
  ///   `+infinity`.
  ///
  ///     let x = 15.0
  ///     x.isLess(than: 20.0)
  ///     // true
  ///     x.isLess(than: .nan)
  ///     // false
  ///     Decimal64.nan.isLess(than: x)
  ///     // false
  ///
  /// The `isLess(than:)` method implements the less-than predicate defined by
  /// the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameter other: The value to compare with this value.
  /// - Returns: `true` if this value is less than `other`; otherwise, `false`.
  ///   If either this value or `other` is NaN, the result of this method is
  ///   `false`.
  func isLess(
    than other: Self,
    status: inout DecimalStatus
  ) -> Bool

  /// Returns a Boolean value indicating whether this instance is less than or
  /// equal to the given value.
  ///
  /// This method serves as the basis for the less-than-or-equal-to operator
  /// (`<=`) for floating-point values. Some special cases apply:
  ///
  /// - Because NaN is incomparable with any value, this method returns `false`
  ///   when called on NaN or when NaN is passed as `other`.
  /// - `-infinity` compares less than or equal to all values except NaN.
  /// - Every value except NaN compares less than or equal to `+infinity`.
  ///
  ///     let x = 15.0
  ///     x.isLessThanOrEqualTo(20.0)
  ///     // true
  ///     x.isLessThanOrEqualTo(.nan)
  ///     // false
  ///     Decimal64.nan.isLessThanOrEqualTo(x)
  ///     // false
  ///
  /// The `isLessThanOrEqualTo(_:)` method implements the less-than-or-equal
  /// predicate defined by the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameter other: The value to compare with this value.
  /// - Returns: `true` if `other` is greater than this value; otherwise,
  ///   `false`. If either this value or `other` is NaN, the result of this
  ///   method is `false`.
  func isLessThanOrEqualTo(
    _ other: Self,
    status: inout DecimalStatus
  ) -> Bool

  /// Returns a Boolean value indicating whether this instance should precede
  /// or tie positions with the given value in an ascending sort.
  ///
  /// This relation is a refinement of the less-than-or-equal-to operator
  /// (`<=`) that provides a total order on all values of the type, including
  /// signed zeros and NaNs.
  ///
  /// The following example uses `isTotallyOrdered(belowOrEqualTo:)` to sort an
  /// array of floating-point values, including some that are NaN:
  ///
  ///     var numbers = [2.5, 21.25, 3.0, .nan, -9.5]
  ///     numbers.sort { !$1.isTotallyOrdered(belowOrEqualTo: $0) }
  ///     print(numbers)
  ///     // Prints "[-9.5, 2.5, 3.0, 21.25, nan]"
  ///
  /// The `isTotallyOrdered(belowOrEqualTo:)` method implements the total order
  /// relation as defined by the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameter other: A floating-point value to compare to this value.
  /// - Returns: `true` if this value is ordered below or the same as `other`
  ///   in a total ordering of the floating-point type; otherwise, `false`.
  func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool

  /// Returns the lesser of the two given values.
  ///
  /// This method returns the minimum of two values, preserving order and
  /// eliminating NaN when possible. For two values `x` and `y`, the result of
  /// `minimum(x, y)` is `x` if `x <= y`, `y` if `y < x`, or whichever of `x`
  /// or `y` is a number if the other is a quiet NaN. If both `x` and `y` are
  /// NaN, or either `x` or `y` is a signaling NaN, the result is NaN.
  ///
  ///     Decimal64.minimum(10, -25)
  ///     // -25
  ///     Decimal64.minimum(10, .nan)
  ///     // 10
  ///     Decimal64.minimum(.nan, -25)
  ///     // -25
  ///     Decimal64.minimum(.nan, .nan)
  ///     // nan
  ///
  /// The `minimum` method implements the `minNum` operation defined by the
  /// [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - x: A floating-point value.
  ///   - y: Another floating-point value.
  /// - Returns: The minimum of `x` and `y`, or whichever is a number if the
  ///   other is NaN.
  static func minimum(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the greater of the two given values.
  ///
  /// This method returns the maximum of two values, preserving order and
  /// eliminating NaN when possible. For two values `x` and `y`, the result of
  /// `maximum(x, y)` is `x` if `x > y`, `y` if `x <= y`, or whichever of `x`
  /// or `y` is a number if the other is a quiet NaN. If both `x` and `y` are
  /// NaN, or either `x` or `y` is a signaling NaN, the result is NaN.
  ///
  ///     Decimal64.maximum(10, -25)
  ///     // 10
  ///     Decimal64.maximum(10, .nan)
  ///     // 10
  ///     Decimal64.maximum(.nan, -25)
  ///     // -25
  ///     Decimal64.maximum(.nan, .nan)
  ///     // nan
  ///
  /// The `maximum` method implements the `maxNum` operation defined by the
  /// [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - x: A floating-point value.
  ///   - y: Another floating-point value.
  /// - Returns: The greater of `x` and `y`, or whichever is a number if the
  ///   other is NaN.
  static func maximum(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the value with lesser magnitude.
  ///
  /// This method returns the value with lesser magnitude of the two given
  /// values, preserving order and eliminating NaN when possible. For two
  /// values `x` and `y`, the result of `minimumMagnitude(x, y)` is `x` if
  /// `x.magnitude <= y.magnitude`, `y` if `y.magnitude < x.magnitude`, or
  /// whichever of `x` or `y` is a number if the other is a quiet NaN. If both
  /// `x` and `y` are NaN, or either `x` or `y` is a signaling NaN, the result
  /// is NaN.
  ///
  ///     Decimal64.minimumMagnitude(10, -25)
  ///     // 10
  ///     Decimal64.minimumMagnitude(10, .nan)
  ///     // 10
  ///     Decimal64.minimumMagnitude(.nan, -25)
  ///     // -25
  ///     Decimal64.minimumMagnitude(.nan, .nan)
  ///     // nan
  ///
  /// The `minimumMagnitude` method implements the `minNumMag` operation
  /// defined by the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - x: A floating-point value.
  ///   - y: Another floating-point value.
  /// - Returns: Whichever of `x` or `y` has lesser magnitude, or whichever is
  ///   a number if the other is NaN.
  static func minimumMagnitude(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self

  /// Returns the value with greater magnitude.
  ///
  /// This method returns the value with greater magnitude of the two given
  /// values, preserving order and eliminating NaN when possible. For two
  /// values `x` and `y`, the result of `maximumMagnitude(x, y)` is `x` if
  /// `x.magnitude > y.magnitude`, `y` if `x.magnitude <= y.magnitude`, or
  /// whichever of `x` or `y` is a number if the other is a quiet NaN. If both
  /// `x` and `y` are NaN, or either `x` or `y` is a signaling NaN, the result
  /// is NaN.
  ///
  ///     Decimal64.maximumMagnitude(10, -25)
  ///     // -25
  ///     Decimal64.maximumMagnitude(10, .nan)
  ///     // 10
  ///     Decimal64.maximumMagnitude(.nan, -25)
  ///     // -25
  ///     Decimal64.maximumMagnitude(.nan, .nan)
  ///     // nan
  ///
  /// The `maximumMagnitude` method implements the `maxNumMag` operation
  /// defined by the [IEEE 754 specification][spec].
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  ///
  /// - Parameters:
  ///   - x: A floating-point value.
  ///   - y: Another floating-point value.
  /// - Returns: Whichever of `x` or `y` has greater magnitude, or whichever is
  ///   a number if the other is NaN.
  static func maximumMagnitude(
    _ x: Self,
    _ y: Self,
    status: inout DecimalStatus
  ) -> Self

  /// The unit in the last place of this value.
  ///
  /// This is the unit of the least significant digit in this value's
  /// significand. For most numbers `x`, this is the difference between `x`
  /// and the next greater (in magnitude) representable number. There are some
  /// edge cases to be aware of:
  ///
  /// - If `x` is not a finite number, then `x.ulp` is NaN.
  /// - If `x` is very small in magnitude, then `x.ulp` may be a subnormal
  ///   number. If a type does not support subnormals, `x.ulp` may be rounded
  ///   to zero.
  /// - `greatestFiniteMagnitude.ulp` is a finite number, even though the next
  ///   greater representable value is `infinity`.
  ///
  /// See also the `ulpOfOne` static property.
  var ulp: Self { get }

  /// The unit in the last place of 1.0.
  ///
  /// The positive difference between 1.0 and the next greater representable
  /// number. `ulpOfOne` corresponds to the value represented by the C macros
  /// `FLT_EPSILON`, `DBL_EPSILON`, etc, and is sometimes called *epsilon* or
  /// *machine epsilon*. Swift deliberately avoids using the term "epsilon"
  /// because:
  ///
  /// - Historically "epsilon" has been used to refer to several different
  ///   concepts in different languages, leading to confusion and bugs.
  ///
  /// - The name "epsilon" suggests that this quantity is a good tolerance to
  ///   choose for approximate comparisons, but it is almost always unsuitable
  ///   for that purpose.
  ///
  /// See also the `ulp` member property.
  static var ulpOfOne: Self { get }

  /// The least representable value that compares greater than this value.
  ///
  /// For any finite value `x`, `x.nextUp` is greater than `x`. For `nan` or
  /// `infinity`, `x.nextUp` is `x` itself. The following special cases also
  /// apply:
  ///
  /// - If `x` is `-infinity`, then `x.nextUp` is `-greatestFiniteMagnitude`.
  /// - If `x` is `-leastNonzeroMagnitude`, then `x.nextUp` is `-0.0`.
  /// - If `x` is zero, then `x.nextUp` is `leastNonzeroMagnitude`.
  /// - If `x` is `greatestFiniteMagnitude`, then `x.nextUp` is `infinity`.
  func nextUp(status: inout DecimalStatus) -> Self

  /// The greatest representable value that compares less than this value.
  ///
  /// For any finite value `x`, `x.nextDown` is less than `x`. For `nan` or
  /// `-infinity`, `x.nextDown` is `x` itself. The following special cases
  /// also apply:
  ///
  /// - If `x` is `infinity`, then `x.nextDown` is `greatestFiniteMagnitude`.
  /// - If `x` is `leastNonzeroMagnitude`, then `x.nextDown` is `0.0`.
  /// - If `x` is zero, then `x.nextDown` is `-leastNonzeroMagnitude`.
  /// - If `x` is `-greatestFiniteMagnitude`, then `x.nextDown` is `-infinity`.
  func nextDown(status: inout DecimalStatus) -> Self

  /// The floating-point value with the same sign and exponent as this value,
  /// but with a significand of 1.0.
  ///
  /// A *quantum* is a set of decimal floating-point values that all have the
  /// same sign and exponent. The `quantum` property is a member of the same
  /// decade as this value, but with a unit significand.
  ///
  /// In this example, `x` has a value of `33.33333333333333` which is stored as
  /// `3333333333333333E-14 = 3333333333333333 * 10 ** -14`.
  /// Therefore, `x.quantum` is equal to `+1E-14`.
  ///
  ///     let x = 100 / 3 // +3333333333333333E-14
  ///     let y = x.quantum // +1E-14
  ///
  /// IEEE-754: Definition 2.1.44 quantum
  ///
  /// The quantum of a finite floating-point representation is the value of a unit
  /// in the last position of its significand. This is equal to the radix raised
  /// to the exponent q, which is used when the significand is regarded as an integer.
  var quantum: Self { get }

  /// IEEE-754: `sourceFormat quantize(source, source)`.
  ///
  /// For finite decimal operands x and y of the same format, `quantize(x, y)`
  /// is a floating-point number in the same format that has, if possible,
  /// the same numerical value as x and the same quantum as y.
  ///
  /// If the exponent is being increased, rounding according to the applicable
  /// rounding-direction attribute might occur: the result is a different
  /// floating-point representation and the inexact exception is signaled
  /// if the result does not have the same numerical value as x.
  ///
  /// If the exponent is being decreased and the significand of the result would
  /// have more than p digits, the invalid operation exception is signaled
  /// and the result is NaN.
  ///
  /// If one or both operands are NaN, the rules in 6.2 are followed.
  ///
  /// Otherwise if only one operand is infinite then the invalid operation
  /// exception is signaled and the result is NaN.
  ///
  /// If both operands are infinite then the result is canonical ∞ with the
  /// sign of x.
  ///
  /// `quantize` does not signal underflow or overflow.
  /// The preferred exponent is Q(y).
  func quantized(
    to other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self

  /// IEEE-754: `boolean sameQuantum(source, source)`
  ///
  /// For numerical decimal operands x and y of the same format, sameQuantum(x, y)
  /// is true if the exponents of x and y are the same, that is, Q(x) = Q(y),
  /// and false otherwise.
  ///
  /// `sameQuantum(NaN, NaN)` and `sameQuantum(inf, inf)` are true; if exactly one
  /// operand is infinite or exactly one operand is NaN, sameQuantum is false.
  ///
  /// `sameQuantum` signals no exception.
  func sameQuantum(as other: Self) -> Bool

  /// Returns this value rounded to an integral value using the specified
  /// rounding rule.
  ///
  /// The following example rounds a value using four different rounding rules:
  ///
  ///     let x = 6.5
  ///
  ///     // Equivalent to the C 'round' function:
  ///     print(x.rounded(.toNearestOrAwayFromZero))
  ///     // Prints "7.0"
  ///
  ///     // Equivalent to the C 'trunc' function:
  ///     print(x.rounded(.towardZero))
  ///     // Prints "6.0"
  ///
  ///     // Equivalent to the C 'ceil' function:
  ///     print(x.rounded(.up))
  ///     // Prints "7.0"
  ///
  ///     // Equivalent to the C 'floor' function:
  ///     print(x.rounded(.down))
  ///     // Prints "6.0"
  ///
  /// For more information about the available rounding rules, see the
  /// `DecimalFloatingPointRoundingRule` enumeration. To round a value using the
  /// default "schoolbook rounding", you can use the shorter `rounded()`
  /// method instead.
  ///
  ///     print(x.rounded())
  ///     // Prints "7.0"
  ///
  /// - Parameter rule: The rounding rule to use.
  /// - Returns: The integral value found by rounding using `rule`.
  func rounded(
    _ rule: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self
}

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
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
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
      rounding: .toNearestOrEven,
      status: &status
    )
  }

  // MARK: - Init from String

  // overload: only rounding or no args
  public init?<S: StringProtocol>(
    _ description: S,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
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
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven

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
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)
  }

  public init(integerLiteral value: Int) {
    self = Self(value)
  }

  // overload: only rounding or no args
  public init<Source: BinaryInteger>(
    _ value: Source,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self(value, rounding: rounding, status: &status)
  }

  // overload: only status
  public init<Source: BinaryInteger>(
    _ value: Source,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
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

  // overload: only rounding or no args
  public init(
    _ value: Float,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self(value, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ value: Float,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter value: A floating-point value to be converted.
  public init?(
    exactly value: Float,
    status: inout DecimalStatus
  ) {
    // Separate status to avoid polluting 'status' argument with 'isInexact'.
    // 'rounding' should not matter because any rounding means 'inexact'.
    var s = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &s)

    if s.isSet(.isInexact) {
      return nil
    }

    if s.isBinaryFloatingPointSubnormal {
      status.set(.isBinaryFloatingPointSubnormal)
    }
  }

  // overload: no status
  public init?(exactly value: Float) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  // overload: only rounding or no args
  public init(
    _ value: Double,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self(value, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ value: Double,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter value: A floating-point value to be converted.
  public init?(
    exactly value: Double,
    status: inout DecimalStatus
  ) {
    // Separate status to avoid polluting 'status' argument with 'isInexact'.
    // 'rounding' should not matter because any rounding means 'inexact'.
    var s = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &s)

    if s.isSet(.isInexact) {
      return nil
    }

    if s.isBinaryFloatingPointSubnormal {
      status.set(.isBinaryFloatingPointSubnormal)
    }
  }

  // overload: no status
  public init?(exactly value: Double) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

  // overload: only rounding or no args
  public init(
    _ value: Float80,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self(value, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ value: Float80,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter value: A floating-point value to be converted.
  public init?(
    exactly value: Float80,
    status: inout DecimalStatus
  ) {
    // Separate status to avoid polluting 'status' argument with 'isInexact'.
    // 'rounding' should not matter because any rounding means 'inexact'.
    var s = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &s)

    if s.isSet(.isInexact) {
      return nil
    }

    if s.isBinaryFloatingPointSubnormal {
      status.set(.isBinaryFloatingPointSubnormal)
    }
  }

  // overload: no status
  public init?(exactly value: Float80) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
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
    return lhs.adding(rhs, rounding: .toNearestOrEven)
  }

  /// Adds two values and stores the result in the left-hand-side variable,
  /// rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
  public static func += (lhs: inout Self, rhs: Self) {
    lhs = lhs.adding(rhs, rounding: .toNearestOrEven)
  }

  /// Adds two values and stores the result in the left-hand-side variable,
  /// rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The first value to add.
  ///   - rhs: The second value to add.
  public mutating func add(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.adding(other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func add(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = self.adding(other, rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func add(
    _ other: Self,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.adding(other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func adding(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) -> Self {
    var status = DecimalStatus()
    return self.adding(other, rounding: rounding, status: &status)
  }

  // overload: only status
  public func adding(
    _ other: Self,
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    return self.adding(other, rounding: rounding, status: &status)
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
    return lhs.subtracting(rhs, rounding: .toNearestOrEven)
  }

  /// Subtracts the second value from the first and stores the difference in
  /// the left-hand-side variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
  public static func -= (lhs: inout Self, rhs: Self) {
    lhs = lhs.subtracting(rhs, rounding: .toNearestOrEven)
  }

  /// Subtracts the second value from the first and stores the difference in
  /// the left-hand-side variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: A numeric value.
  ///   - rhs: The value to subtract from `lhs`.
  public mutating func subtract(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.subtracting(other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func subtract(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = self.subtracting(other, rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func subtract(
    _ other: Self,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.subtracting(other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func subtracting(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) -> Self {
    var status = DecimalStatus()
    return self.subtracting(other, rounding: rounding, status: &status)
  }

  // overload: only status
  public func subtracting(
    _ other: Self,
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    return self.subtracting(other, rounding: rounding, status: &status)
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
    return lhs.multiplied(by: rhs, rounding: .toNearestOrEven)
  }

  /// Multiplies two values and stores the result in the left-hand-side
  /// variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs = lhs.multiplied(by: rhs, rounding: .toNearestOrEven)
  }

  /// Multiplies two values and stores the result in the left-hand-side
  /// variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The first value to multiply.
  ///   - rhs: The second value to multiply.
  public mutating func multiply(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.multiplied(by: other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func multiply(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = self.multiplied(by: other, rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func multiply(
    by other: Self,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.multiplied(by: other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func multiplied(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) -> Self {
    var status = DecimalStatus()
    return self.multiplied(by: other, rounding: rounding, status: &status)
  }

  // overload: only status
  public func multiplied(
    by other: Self,
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    return self.multiplied(by: other, rounding: rounding, status: &status)
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
    return lhs.divided(by: rhs, rounding: .toNearestOrEven)
  }

  /// Divides the first value by the second and stores the quotient in the
  /// left-hand-side variable, rounding to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs.divided(by: rhs, rounding: .toNearestOrEven)
  }

  /// Divides the first value by the second and stores the quotient in the
  /// left-hand-side variable, rounding using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value to divide `lhs` by.
  public mutating func divide(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.divided(by: other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func divide(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = self.divided(by: other, rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func divide(
    by other: Self,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.divided(by: other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func divided(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) -> Self {
    var status = DecimalStatus()
    return self.divided(by: other, rounding: rounding, status: &status)
  }

  // overload: only status
  public func divided(
    by other: Self,
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    return self.divided(by: other, rounding: rounding, status: &status)
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
  public mutating func formSquareRoot(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.squareRoot(rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func formSquareRoot(
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = self.squareRoot(rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func formSquareRoot(
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.squareRoot(rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func squareRoot(
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) -> Self {
    var status = DecimalStatus()
    return self.squareRoot(rounding: rounding, status: &status)
  }

  // overload: only status
  public func squareRoot(
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    return self.squareRoot(rounding: rounding, status: &status)
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
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func addProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
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
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.addingProduct(lhs, rhs, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func addingProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
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
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
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

  public mutating func quantize(
    to other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.quantized(to: other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public mutating func quantize(
    to other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = self.quantized(to: other, rounding: rounding, status: &status)
  }

  // overload: only status
  public mutating func quantize(
    to other: Self,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = self.quantized(to: other, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public func quantized(
    to other: Self,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) -> Self {
    var status = DecimalStatus()
    return self.quantized(to: other, rounding: rounding, status: &status)
  }

  // overload: only status
  public func quantized(
    to other: Self,
    status: inout DecimalStatus
  ) -> Self {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    return self.quantized(to: other, rounding: rounding, status: &status)
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
    _ rule: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = self.rounded(rule, status: &status)
  }

  // overload: only rounding or no args
  public mutating func round(
    _ rule: DecimalFloatingPointRoundingRule = .toNearestOrAwayFromZero
  ) {
    var status = DecimalStatus()
    self = self.rounded(rule, status: &status)
  }

  // overload: only status
  public mutating func round(
    status: inout DecimalStatus
  ) {
    let rule = DecimalFloatingPointRoundingRule.toNearestOrAwayFromZero
    self = self.rounded(rule, status: &status)
  }

  // overload: only rounding or no args
  public func rounded(
    _ rule: DecimalFloatingPointRoundingRule = .toNearestOrAwayFromZero
  ) -> Self {
    var status = DecimalStatus()
    return self.rounded(rule, status: &status)
  }

  // overload: only status
  public func rounded(
    status: inout DecimalStatus
  ) -> Self {
    let rule = DecimalFloatingPointRoundingRule.toNearestOrAwayFromZero
    return self.rounded(rule, status: &status)
  }
}
