extension DecimalMixin {

  internal static func _init(payload: BID, signaling: Bool) -> Self {
    precondition(
      (payload & ~Self.nanPayloadMask) == 0,
      "NaN payload is not encodable."
    )

    let nan = signaling ? Self.nanSignalingMask : Self.nanQuietMask
    let significand = payload & Self.nanPayloadMask

    // If payload is not canonical, then we will not be canonical.
    return Self(unchecked: nan | significand)
  }

  internal static func _init(signOf: Self, magnitudeOf: Self) -> Self {
    // If the 'magnitudeOf' is not canonical then the output will not be canonical.
    let bid = (signOf.bid & Self.signMask) | (magnitudeOf.bid & ~Self.signMask)
    return Self(unchecked: bid)
  }
}
