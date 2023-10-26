// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

extension Float {

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = ExceptionStatus()
    self = source._toFloat(rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal64) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven

    var status = ExceptionStatus()
    self = source._toFloat(rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }
}

extension Double {

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = ExceptionStatus()
    self = source._toDouble(rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal64) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven

    var status = ExceptionStatus()
    self = source._toDouble(rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }
}

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

extension Float80 {

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = ExceptionStatus()
    self = source._toFloat80(rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal64) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven

    var status = ExceptionStatus()
    self = source._toFloat80(rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }
}

#endif
