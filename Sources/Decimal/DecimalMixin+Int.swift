import Cbid

// MARK: - From Int

extension Decimal32 {
  internal static func _fromInt<T: BinaryInteger>(
    _ value: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return Self._fromInt(
      value: value,
      fromInt64: __bid32_from_int64,
      fromUInt64: __bid32_from_uint64,
      rounding: rounding,
      status: &status
    )
  }
}

extension Decimal64 {
  internal static func _fromInt<T: BinaryInteger>(
    _ value: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return Self._fromInt(
      value: value,
      fromInt64: __bid64_from_int64,
      fromUInt64: __bid64_from_uint64,
      rounding: rounding,
      status: &status
    )
  }
}

extension Decimal128 {
  internal static func _fromInt<T: BinaryInteger>(
    _ value: T,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return Self._fromInt(
      value: value,
      fromInt64: { value, _, _ in __bid128_from_int64(value) },
      fromUInt64: { value, _, _ in __bid128_from_uint64(value) },
      rounding: rounding,
      status: &status
    )
  }
}

extension DecimalMixin {

  /// Will set 'isInexact' flat on status if needed.
  fileprivate static func _fromInt<T: BinaryInteger>(
    value: T,
    fromInt64: (BID_SINT64, IDEC_round, IDEC_flagsPtr?) -> BID,
    fromUInt64: (BID_UINT64, IDEC_round, IDEC_flagsPtr?) -> BID,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    // TODO: Int: unsignedFn(value.magnitude) -> if value < 0 { result.negate() }
    // Intel tests will fail if we:
    // 1. unsignedFn(value.magnitude)
    // 2. if value < 0 { result.negate() }
    //
    // So we will have a separate path for signed and unsigned numbers.
    precondition(
      value.bitWidth <= 64,
      "\(Self.self) does not support integers over 64 bits."
    )

    var bid: Self.BID?

    if T.isSigned {
      if let i64 = Int64(exactly: value) {
        bid = fromInt64(i64, rounding.value, &status.value)
      }
    } else {
      if let u64 = UInt64(exactly: value) {
        bid = fromUInt64(u64, rounding.value, &status.value)
      }
    }

    guard let bid = bid else {
      preconditionFailure("Unable to create \(Self.self) from \(value) (\(T.self)): argument out of range.")
    }

    return Self(unchecked: bid)
  }

  // MARK: - Convert to

  internal func _toInt<T: FixedWidthInteger>(
    _ fn: (BID, IDEC_flagsPtr) -> T,
    status: inout ExceptionStatus
  ) -> T {
    return fn(self.bid, &status.value)
  }
}
