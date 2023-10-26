extension DecimalMixin {

  // MARK: - From

  internal static func _init(decimalEncoding dpd: BID) -> Self {
    let sign = Sign(bid: dpd & Self.signMask)

    // Infinity stays the same
    if (dpd & Self.nanQuietMask) == Self.infinityMask {
      return Self(canonical: sign | Self.infinityMask)
    }

    Self.assertTrailingSignificandWidth_isMultipleOf10()
    let groupCount = Self.trailingSignificandWidth / 10 // 50 = 5 groups = 15 digits
    var significand: BID = 0
    var significandMultiplier: BID = 1

    for i in 0..<groupCount {
      let shift = i * 10
      let bits = (dpd >> shift) & 0b11_1111_1111
      let decoded = Tables.dpd(decode: bits)
      assert(decoded < 1000)

      significand += BID(decoded) * significandMultiplier
      significandMultiplier *= 1000
    }

    if (dpd & Self.nanQuietMask) == Self.nanQuietMask {
      // If the payload is not canonical, then oh well…
      let nan = dpd & Self.nanSignalingMask
      let payload = significand
      return Self(unchecked: sign | nan | payload)
    }

    // 5 highest combination bits
    let combination5 = dpd >> (Self.bitWidth - Self.signWidth - 5)
    let leadingSignificandDigit: BID
    var leadingExponentBits: BID

    if (combination5 & 0b11000) == 0b11000 {
      // i) When the most significant five bits of G are 110xx or 1110x:
      //    - leading significand digit d[0] is 8+G[4], a value 8 or 9
      //    - leading biased exponent bits are 2G[2] + G[3], a value 0, 1, or 2
      leadingSignificandDigit = 8 | (combination5 & 1)
      leadingExponentBits = (combination5 >> 1) & 0b11
    } else {
      // ii) When the most significant five bits of G are 0xxxx or 10xxx:
      //     - leading significand digit d[0] is 4G[2]+2G[3]+G[4],
      //       a value in the range 0 through 7
      //     - leading biased exponent bits are 2G[0]+G[1], a value 0, 1, or 2
      leadingSignificandDigit = combination5 & 0b111
      leadingExponentBits = (combination5 >> 3) & 0b11
    }

    significand += leadingSignificandDigit * significandMultiplier
    leadingExponentBits <<= Self.exponentWidth - 2

    let trailingExponentMask: BID = (1 << (Self.exponentWidth - 2)) - 1
    let trailingExponentBits = (dpd >> Self.trailingSignificandWidth) & trailingExponentMask

    return Self._packWithoutChecks(
      sign: sign,
      significand: significand,
      biasedExponent: leadingExponentBits | trailingExponentBits
    )
  }

  // MARK: - To

  internal func _toDenselyPackedDecimal() -> BID {
    var result: BID = self.bid & Self.signMask

    if self._isInfinite {
      return result | Self.infinityMask
    }

    var significand: BID
    var exponent: BID

    if self._isNaN {
      result |= self.bid & Self.nanSignalingMask
      let payload = self._unpackNaN()
      significand = payload.canonical
      exponent = 0
    } else {
      let unpack = self._unpackFiniteOrZero()
      significand = unpack.significand.canonical
      exponent = unpack.exponent.biased
    }

    Self.assertTrailingSignificandWidth_isMultipleOf10()
    let groupCount = Self.trailingSignificandWidth / 10 // 50 = 5 groups = 15 digits

    for i in 0..<groupCount {
      let (q, bits) = significand.quotientAndRemainder(dividingBy: 1000)
      let encoded = Tables.dpd(encode: bits)
      assert((encoded & ~0b11_1111_1111) == 0, "")

      let shift = i * 10
      result |= BID(encoded) << shift
      significand = q
    }

    let leadingExponentBits = (exponent >> (Self.exponentWidth - 2)) & 0b11
    let trailingExponentMask: BID = (1 << (Self.exponentWidth - 2)) - 1
    result |= (exponent & trailingExponentMask) << Self.trailingSignificandWidth

    // 5 highest combination bits
    let combination5: BID
    assert(significand <= 9)

    if significand >= 8 {
      // i) When the most significant five bits of G are 110xx or 1110x:
      //    - leading significand digit d[0] is 8+G[4], a value 8 or 9
      //    - leading biased exponent bits are 2G[2] + G[3], a value 0, 1, or 2
      combination5 = 0b11000 | (leadingExponentBits << 1) | (significand & 1)
    } else {
      // ii) When the most significant five bits of G are 0xxxx or 10xxx:
      //     - leading significand digit d[0] is 4G[2]+2G[3]+G[4],
      //       a value in the range 0 through 7
      //     - leading biased exponent bits are 2G[0]+G[1], a value 0, 1, or 2
      combination5 = (leadingExponentBits << 3) | significand
    }

    result |= combination5 << (Self.bitWidth - Self.signWidth - 5)
    return result
  }

  private static func assertTrailingSignificandWidth_isMultipleOf10() {
    assert(
      Self.trailingSignificandWidth.isMultiple(of: 10),
      "What monstrosity is this?"
    )
  }
}
