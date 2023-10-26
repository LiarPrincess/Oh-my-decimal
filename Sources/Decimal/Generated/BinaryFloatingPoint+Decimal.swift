// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================

// MARK: - Float

extension Float {

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal32,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal32,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal32,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal32) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal64,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
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
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal128,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal128) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }
}

// MARK: - Double

extension Double {

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal32,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal32,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal32,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal32) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal64,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
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
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal128,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal128) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }
}

// MARK: - Float80

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

extension Float80 {

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal32,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal32,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal32,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal32) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal64,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal64,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
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
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only rounding or no args
  public init(
    _ source: Decimal128,
    rounding: DecimalFloatingPointRoundingRule = .toNearestOrEven
  ) {
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  // overload: only status
  public init(
    _ source: Decimal128,
    status: inout DecimalStatus
  ) {
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: Decimal128) {
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {
      return nil
    }
  }
}

#endif
