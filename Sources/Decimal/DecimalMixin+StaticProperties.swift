extension DecimalMixin {

  // MARK: - Zero, one

  internal static var _zero: Self {
    return Self._createCanonicalSmall(significand: 0)
  }

  internal static var _one: Self {
    return Self._createCanonicalSmall(significand: 1)
  }

  /// Create value with exponent = 0.
  private static func _createCanonicalSmall(significand: BID) -> Self {
    // Exponent = 0 -> encoded as bias.
    //
    // Note that 'bias' always starts with '01' which will become combination
    // high bits. In this case exponent is stored continuously after sign.
    //
    //           |exponent width|bias|bias binary      |bias binary width
    // Decimal32 |             8| 101|        0110 0101| 8
    // Decimal64 |            10| 398|     01 1000 1110|10
    // Decimal128|            14|6176|01 1000 0010 0000|14
    let exponent = BID(Self.exponentBias)
    let shift = Self.bitWidth - Self.signWidth - Self.exponentWidth
    return Self(canonical: exponent << shift | significand)
  }

  // MARK: - NaN, infinity

  internal static var _nan:          Self { Self(canonical: Self.nanQuietMask) }
  internal static var _signalingNaN: Self { Self(canonical: Self.nanSignalingMask) }
  internal static var _infinity:     Self { Self(canonical: Self.infinityMask) }

  // MARK: - Greatest/least magnitude

  /// Hard-coded `Self.infinity.nextDown`.
  internal static var _greatestFiniteMagnitude: Self {
    // Largest value is  9.99… * 10^emax.
    // We want it in the 9999… * 10^(emax-p+1) form.
    // We could also hard-code the values, but this should optimize nicely.

    let highBits: BID
    let exponentShift: Int
    let significandBits: BID

    if Self.bitWidth == 128 {
      // highBits = 0b10 provided by exponent.
      highBits = 0
      exponentShift = Self.exponentShift_00_01_10
      significandBits = Self.maxDecimalDigits
    } else {
      highBits = Self.combinationHighBits11Mask
      exponentShift = Self.exponentShift_11
      significandBits = Self.maxDecimalDigits & Self.significandMask_11
    }

    let exponent = Self._moveDecimalSeparatorRight(exponent: Self.maxUnbiasedExponent)
    let biasedExponent = Self._addBias(exponent: exponent)
    let exponentBits = biasedExponent << exponentShift

    return Self(canonical: highBits | exponentBits | significandBits)
  }

  internal static var _leastNormalMagnitude: Self {
    // Smallest normalized value is 1.00...×10^Emin.
    // Sign:        0 - positive
    // Exponent:    0 -> 0 - Self.exponentBias
    // Significand: 100000…
    let bid = (Self.maxDecimalDigits + 1) / 10
    return Self(canonical: bid)
  }

  /// Hard-coded `Self.zero.nextUp`.
  /// `1*10^(-Self.exponentBias)`.
  internal static var _leastNonzeroMagnitude: Self {
    // Smallest non-zero value is 1×10^(2−p−Emax).
    // Sign:        0 - positive
    // Exponent:    0 -> 0 - Self.exponentBias
    // Significand: 1
    return Self(canonical: 1)
  }

  // MARK: - Pie

  internal static var _pi: Self {
    let exponent = -Self.precisionInDigits + 1
    let biasedExponent = Self._addBias(exponent: exponent)
    let exponentBits = biasedExponent << Self.exponentShift_00_01_10

    let significandBits = Self.piDecimalDigits
    return Self(canonical: exponentBits | significandBits)
  }
}
