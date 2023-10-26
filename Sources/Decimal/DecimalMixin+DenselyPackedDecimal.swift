extension DecimalMixin {

  internal static func _initFromDenselyPackedDecimal(dpd: BID) -> Self {
    let bid = Self.fnFromDenselyPackedDecimal(dpd)
    return Self(unchecked: bid)
  }

  internal func _toDenselyPackedDecimal() -> BID {
    return Self.fnToDenselyPackedDecimal(self.bid)
  }
}
