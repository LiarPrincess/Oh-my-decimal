extension DecimalMixin {

  // MARK: - From smaller

  /// `Smaller = D.bitWidth < Self.bitWidth`
  internal static func _init<D: DecimalMixin>(smaller d: D) -> Self {
    assert(D.bitWidth < Self.bitWidth)

    let shift = Self.bitWidth - D.bitWidth
    let bid = BID(truncatingIfNeeded: d.bid)
    let sign = (bid << shift) & Self.signMask

    if d._isNaN {
      let nan = d._isSignalingNaN ? Self.nanSignalingMask : Self.nanQuietMask
      let unpack = d._unpackNaN()
      let payloadScale = Self.precisionInDigits - D.precisionInDigits
      let payloadScalePow10: BID = Tables.getPowerOf10(exponent: payloadScale)
      let payload = BID(truncatingIfNeeded: unpack.canonical) * payloadScalePow10
      return Self(canonical: sign | nan | payload)
    }

    if d._isInfinite {
      return Self(canonical: sign | Self.infinityMask)
    }

    let unpack = d._unpackFiniteOrZero()
    let exponent = BID(truncatingIfNeeded: unpack.exponent.biased)
     + BID(truncatingIfNeeded: Self.exponentBias)
     - BID(truncatingIfNeeded: D.exponentBias)
    let significand = BID(truncatingIfNeeded: unpack.significand.canonical)

    return Self._packWithoutChecks(
      sign: Sign(bid: sign),
      significand: significand,
      biasedExponent: exponent
    )
  }

  // MARK: - From bigger

  /// `Bigger = D.bitWidth > Self.bitWidth`
  internal static func _init<D: DecimalMixin>(
    bigger d: D,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    assert(D.bitWidth > Self.bitWidth)

    let shift = D.bitWidth - Self.bitWidth
    let sign = BID(truncatingIfNeeded: d.bid >> shift) & Self.signMask

    if d._isNaN {
      let nan = d._isSignalingNaN ? Self.nanSignalingMask : Self.nanQuietMask
      let unpack = d._unpackNaN()
      let scale = D.precisionInDigits - Self.precisionInDigits
      let pow10: D.BID = Tables.getPowerOf10(exponent: scale)
      let payload = BID(truncatingIfNeeded: unpack.canonical / pow10)
      return Self(canonical: sign | nan | payload)
    }

    if d._isInfinite {
      return Self(canonical: sign | Self.infinityMask)
    }

    let unpack = d._unpackFiniteOrZero()
    var signedExponent = unpack.exponent.signed
    let significand = unpack.significand.canonical

    // Exact without rounding digits?
    // No truncation because 'D.bitWidth > Self.bitWidth', so 'Self.maxDecimalDigits'
    // will trivially fit.
    let maxDecimalDigits = D.BID(truncatingIfNeeded: Self.maxDecimalDigits)

    if significand <= maxDecimalDigits {
      let s = BID(truncatingIfNeeded: significand)
      return Self._pack(
        sign: Sign(bid: sign),
        significand: s,
        signedExponent: signedExponent,
        roundingDigitCount: 0,
        rounding: rounding,
        status: &status
      )
    }

    let digitCount = D._getDecimalDigitCount(significand)
    let roundingDigitCount = digitCount - Self.precisionInDigits
    signedExponent += roundingDigitCount
    assert(roundingDigitCount > 0)

    // This tiny little function allows us to initialize 'Decimal32' directly
    // from 'Decimal128' without writing the whole 'QuadBID' thingie.
    // And yes… sometimes I am amazed how brilliant I am. 🐭✨
    return Self._pack(
      sign: Sign(bid: sign),
      significand: significand,
      signedExponent: signedExponent,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding,
      status: &status
    )
  }
}
