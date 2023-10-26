// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

import Cbid

// swiftlint:disable line_length
// swiftlint:disable file_length

// MARK: - Int

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minInt = Decimal128(Int.min, rounding: .towardZero)
private let maxInt = Decimal128(Int.max, rounding: .towardZero)

extension Int {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to Int because it is either infinite or NaN"
    )
    precondition(
      source >= minInt,
      "Decimal128 value cannot be converted to Int because the result would be less than Int.min"
    )
    precondition(
      source <= maxInt,
      "Decimal128 value cannot be converted to Int because the result would be greater than Int.max"
    )

    precondition(
      Int.bitWidth == 32 || Int.bitWidth == 64,
      "Decimal128 value cannot be converted to \(Int.bitWidth) bit Int (expected 32 or 64 bit)."
    )

    var status = ExceptionStatus()
    let result = Int64(source, rounding: rounding, status: &status)
    self = Self(result) // Range checks guarantee no trap
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minInt else { return nil }
    guard source <= maxInt else { return nil }

    precondition(
      Int.bitWidth == 32 || Int.bitWidth == 64,
      "Decimal128 value cannot be converted to \(Int.bitWidth) bit Int (expected 32 or 64 bit)."
    )

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Int64(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = Self(result) // Range checks guarantee no trap
  }
}

// MARK: - UInt

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minUInt = Decimal128(UInt.min, rounding: .towardZero)
private let maxUInt = Decimal128(UInt.max, rounding: .towardZero)

extension UInt {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to UInt because it is either infinite or NaN"
    )
    precondition(
      source >= minUInt,
      "Decimal128 value cannot be converted to UInt because the result would be less than UInt.min"
    )
    precondition(
      source <= maxUInt,
      "Decimal128 value cannot be converted to UInt because the result would be greater than UInt.max"
    )

    precondition(
      UInt.bitWidth == 32 || UInt.bitWidth == 64,
      "Decimal128 value cannot be converted to \(UInt.bitWidth) bit UInt (expected 32 or 64 bit)."
    )

    var status = ExceptionStatus()
    let result = UInt64(source, rounding: rounding, status: &status)
    self = Self(result) // Range checks guarantee no trap
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minUInt else { return nil }
    guard source <= maxUInt else { return nil }

    precondition(
      UInt.bitWidth == 32 || UInt.bitWidth == 64,
      "Decimal128 value cannot be converted to \(UInt.bitWidth) bit UInt (expected 32 or 64 bit)."
    )

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = UInt64(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = Self(result) // Range checks guarantee no trap
  }
}

// MARK: - Int8

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minInt8 = Decimal128(Int8.min, rounding: .towardZero)
private let maxInt8 = Decimal128(Int8.max, rounding: .towardZero)

extension Int8 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to Int8 because it is either infinite or NaN"
    )
    precondition(
      source >= minInt8,
      "Decimal128 value cannot be converted to Int8 because the result would be less than Int8.min"
    )
    precondition(
      source <= maxInt8,
      "Decimal128 value cannot be converted to Int8 because the result would be greater than Int8.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minInt8 else { return nil }
    guard source <= maxInt8 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int8_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int8_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int8_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int8_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int8_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int8_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int8_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int8_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int8_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int8_xint,   status: &status)
    }
  }
}

// MARK: - UInt8

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minUInt8 = Decimal128(UInt8.min, rounding: .towardZero)
private let maxUInt8 = Decimal128(UInt8.max, rounding: .towardZero)

extension UInt8 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to UInt8 because it is either infinite or NaN"
    )
    precondition(
      source >= minUInt8,
      "Decimal128 value cannot be converted to UInt8 because the result would be less than UInt8.min"
    )
    precondition(
      source <= maxUInt8,
      "Decimal128 value cannot be converted to UInt8 because the result would be greater than UInt8.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minUInt8 else { return nil }
    guard source <= maxUInt8 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint8_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint8_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint8_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint8_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint8_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint8_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint8_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint8_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint8_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint8_xint,   status: &status)
    }
  }
}

// MARK: - Int16

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minInt16 = Decimal128(Int16.min, rounding: .towardZero)
private let maxInt16 = Decimal128(Int16.max, rounding: .towardZero)

extension Int16 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to Int16 because it is either infinite or NaN"
    )
    precondition(
      source >= minInt16,
      "Decimal128 value cannot be converted to Int16 because the result would be less than Int16.min"
    )
    precondition(
      source <= maxInt16,
      "Decimal128 value cannot be converted to Int16 because the result would be greater than Int16.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minInt16 else { return nil }
    guard source <= maxInt16 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int16_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int16_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int16_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int16_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int16_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int16_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int16_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int16_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int16_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int16_xint,   status: &status)
    }
  }
}

// MARK: - UInt16

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minUInt16 = Decimal128(UInt16.min, rounding: .towardZero)
private let maxUInt16 = Decimal128(UInt16.max, rounding: .towardZero)

extension UInt16 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to UInt16 because it is either infinite or NaN"
    )
    precondition(
      source >= minUInt16,
      "Decimal128 value cannot be converted to UInt16 because the result would be less than UInt16.min"
    )
    precondition(
      source <= maxUInt16,
      "Decimal128 value cannot be converted to UInt16 because the result would be greater than UInt16.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minUInt16 else { return nil }
    guard source <= maxUInt16 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint16_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint16_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint16_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint16_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint16_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint16_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint16_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint16_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint16_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint16_xint,   status: &status)
    }
  }
}

// MARK: - Int32

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minInt32 = Decimal128(Int32.min, rounding: .towardZero)
private let maxInt32 = Decimal128(Int32.max, rounding: .towardZero)

extension Int32 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to Int32 because it is either infinite or NaN"
    )
    precondition(
      source >= minInt32,
      "Decimal128 value cannot be converted to Int32 because the result would be less than Int32.min"
    )
    precondition(
      source <= maxInt32,
      "Decimal128 value cannot be converted to Int32 because the result would be greater than Int32.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minInt32 else { return nil }
    guard source <= maxInt32 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int32_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int32_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int32_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int32_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int32_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int32_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int32_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int32_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int32_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int32_xint,   status: &status)
    }
  }
}

// MARK: - UInt32

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minUInt32 = Decimal128(UInt32.min, rounding: .towardZero)
private let maxUInt32 = Decimal128(UInt32.max, rounding: .towardZero)

extension UInt32 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to UInt32 because it is either infinite or NaN"
    )
    precondition(
      source >= minUInt32,
      "Decimal128 value cannot be converted to UInt32 because the result would be less than UInt32.min"
    )
    precondition(
      source <= maxUInt32,
      "Decimal128 value cannot be converted to UInt32 because the result would be greater than UInt32.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minUInt32 else { return nil }
    guard source <= maxUInt32 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint32_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint32_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint32_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint32_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint32_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint32_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint32_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint32_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint32_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint32_xint,   status: &status)
    }
  }
}

// MARK: - Int64

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minInt64 = Decimal128(Int64.min, rounding: .towardZero)
private let maxInt64 = Decimal128(Int64.max, rounding: .towardZero)

extension Int64 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to Int64 because it is either infinite or NaN"
    )
    precondition(
      source >= minInt64,
      "Decimal128 value cannot be converted to Int64 because the result would be less than Int64.min"
    )
    precondition(
      source <= maxInt64,
      "Decimal128 value cannot be converted to Int64 because the result would be greater than Int64.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minInt64 else { return nil }
    guard source <= maxInt64 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int64_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int64_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int64_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int64_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int64_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_int64_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_int64_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_int64_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_int64_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_int64_xint,   status: &status)
    }
  }
}

// MARK: - UInt64

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let minUInt64 = Decimal128(UInt64.min, rounding: .towardZero)
private let maxUInt64 = Decimal128(UInt64.max, rounding: .towardZero)

extension UInt64 {

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .towardZero
  ) {
    precondition(
      source.isFinite,
      "Decimal128 value cannot be converted to UInt64 because it is either infinite or NaN"
    )
    precondition(
      source >= minUInt64,
      "Decimal128 value cannot be converted to UInt64 because the result would be less than UInt64.min"
    )
    precondition(
      source <= maxUInt64,
      "Decimal128 value cannot be converted to UInt64 because the result would be greater than UInt64.max"
    )

    var status = ExceptionStatus()
    let result = Self(source, rounding: rounding, status: &status)
    self = result
  }

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: Decimal128) {
    guard source.isFinite else { return nil }
    guard source >= minUInt64 else { return nil }
    guard source <= maxUInt64 else { return nil }

    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = Self(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }

    self = result
  }

  /// Method for Intel tests.
  internal init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint64_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint64_rninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint64_ceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint64_floor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint64_int,   status: &status)
    }
  }

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {
    switch rounding {
    case .toNearestOrEven:         self = source._toInt(__bid128_to_uint64_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid128_to_uint64_xrninta, status: &status)
    case .up:         self = source._toInt(__bid128_to_uint64_xceil,  status: &status)
    case .down:       self = source._toInt(__bid128_to_uint64_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid128_to_uint64_xint,   status: &status)
    }
  }
}
