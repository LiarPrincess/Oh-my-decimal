extension DecimalMixin {

  internal func _round(
    _ rule: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    let fn: (BID, IDEC_flagsPtr?) -> BID

    switch rule {
    case .toNearestOrEven: fn = Self.fnRoundToNearestOrEven
    case .toNearestOrAwayFromZero: fn = Self.fnRoundToNearestOrAwayFromZero
    case .up: fn = Self.fnRoundUp
    case .down: fn = Self.fnRoundDown
    case .towardZero: fn = Self.fnRoundTowardZero
    }

    let bid = fn(self.bid, &status.value)
    return Self(canonical: bid)
  }
}
