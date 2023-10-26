extension DecimalMixin {

  // MARK: - Create

  internal static func _fromFloat(
    _ value: Float,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return Self._fromFloatingPoint(
      Self.fnFromFloat,
      value,
      rounding: rounding,
      status: &status
    )
  }

  internal static func _fromDouble(
    _ value: Double,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return Self._fromFloatingPoint(
      Self.fnFromDouble,
      value,
      rounding: rounding,
      status: &status
    )
  }

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

  internal static func _fromFloat80(
    _ value: Float80,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return Self._fromFloatingPoint(
      Self.fnFromFloat80,
      value,
      rounding: rounding,
      status: &status
    )
  }

#endif

  private static func _fromFloatingPoint<T: FloatingPoint>(
    _ fn: (T, IDEC_round, IDEC_flagsPtr) -> BID,
    _ value: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let bid = fn(value, rounding.value, &status.value)
    return Self(unchecked: bid)
  }

  // MARK: - Convert to

  internal func _toFloat(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Float {
    return Self.fnToFloat(self.bid, rounding.value, &status.value)
  }

  internal func _toDouble(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Double {
    return Self.fnToDouble(self.bid, rounding.value, &status.value)
  }

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)

  internal func _toFloat80(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Float80 {
    return Self.fnToFloat80(self.bid, rounding.value, &status.value)
  }

#endif
}
