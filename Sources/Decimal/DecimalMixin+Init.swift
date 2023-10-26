extension DecimalMixin {

  internal static func _initNaN(payload: BID, signaling: Bool) -> Self {
    precondition(
      (payload & ~Self.nanPayloadMask) == 0,
      "NaN payload is not encodable."
    )

    let nan = signaling ? Self.nanSignalingMask : Self.nanQuietMask
    let significand = payload & Self.nanPayloadMask
    return Self(canonical: nan | significand)
  }

  internal static func _initByCopyingSign(signOf: Self, magnitudeOf: Self) -> Self {
    // If the 'magnitudeOf' was not canonical then the output will not be canonical.
    let bid = (signOf.bid & Self.signMask) | (magnitudeOf.bid & ~Self.signMask)
    return Self(unchecked: bid)
  }
}
