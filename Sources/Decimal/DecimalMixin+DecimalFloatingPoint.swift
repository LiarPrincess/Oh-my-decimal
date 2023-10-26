import Cbid

extension Decimal64 {

  internal static func _fromDecimal32(
    _ value: Decimal32,
    status: inout ExceptionStatus
  ) -> Self {
    let result = __bid32_to_bid64(value.bid, &status.value)
    return Self(unchecked: result)
  }

  internal static func _fromDecimal128(
    _ value: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let result = __bid128_to_bid64(value.bid, rounding.value, &status.value)
    return Self(unchecked: result)
  }
}

extension Decimal32 {

  internal static func _fromDecimal64(
    _ value: Decimal64,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let result = __bid64_to_bid32(value.bid, rounding.value, &status.value)
    return Self(unchecked: result)
  }

  internal static func _fromDecimal128(
    _ value: Decimal128,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let result = __bid128_to_bid32(value.bid, rounding.value, &status.value)
    return Self(unchecked: result)
  }
}

extension Decimal128 {

  internal static func _fromDecimal32(
    _ value: Decimal32,
    status: inout ExceptionStatus
  ) -> Self {
    let result = __bid32_to_bid128(value.bid, &status.value)
    return Self(unchecked: result)
  }

  internal static func _fromDecimal64(
    _ value: Decimal64,
    status: inout ExceptionStatus
  ) -> Self {
    let result = __bid64_to_bid128(value.bid, &status.value)
    return Self(unchecked: result)
  }
}
