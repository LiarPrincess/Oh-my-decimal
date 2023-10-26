extension DecimalMixin {

  // MARK: - Zero, one

  internal static var _zero: Self {
    return Self._initWithExponent0(significand: 0)
  }

  internal static var _one: Self {
    return Self._initWithExponent0(significand: 1)
  }

  /// Create value with signed exponent = 0.
  private static func _initWithExponent0(significand: BID) -> Self {
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
    let shift = Self.exponentShift_00_01_10
    return Self(canonical: exponent << shift | significand)
  }

  // MARK: - NaN, infinity

  internal static var _nan:          Self { Self(canonical: Self.nanQuietMask) }
  internal static var _signalingNaN: Self { Self(canonical: Self.nanSignalingMask) }
  internal static var _infinity:     Self { Self(canonical: Self.infinityMask) }

  // MARK: - Greatest/least magnitude

  /// Hard-coded `Self.infinity.nextDown`.
  ///
  /// The largest positive normal floating-point number is b^Emax ×(b − b^[1− p]).
  internal static var _greatestFiniteMagnitude: Self {
    // Largest value is  9.99… * 10^emax.
    // We want it in the 9999… * 10^(emax-p+1) form.
    // We could also hard-code the values, but this should optimize nicely.
    return Self._packWithoutChecks(
      sign: .plus,
      significand: Self.maxDecimalDigits,
      signedExponent: Self.maxSignedExponent
    )
  }

  /// The smallest positive normal floating-point number is `b^Emin`.
  internal static var _leastNormalMagnitude: Self {
    // Smallest normalized value is 1 * 10^Emin.
    // Sign:        0 - positive
    // Exponent:    0 -> 0 - Self.exponentBias
    // Significand: 100000…
    let bid = Self._leastNormalMagnitudeSignificand
    return Self(canonical: bid)

    // Same value in different cohort:
    // let exponent = Self._addBias(exponent: Self.emin)
    // let significand: Self.BID = 1
    // return Self(canonical: exponent << Self.exponentShift_00_01_10 | significand)
  }

  /// The smallest positive normal floating-point number is `b^Emin`.
  ///
  /// This is also the underflow cutoff:
  ///   b) before rounding — when a non-zero result computed as though both the
  ///      exponent range and the precision were unbounded would lie strictly
  ///      between ± b emin.
  internal static var _leastNormalMagnitudeSignificand: BID {
    return (Self.maxDecimalDigits + 1) / 10
  }

  /// Hard-coded `Self.zero.nextUp`.
  ///
  /// Every finite floating-point number is an integral multiple of the smallest
  /// subnormal magnitude: `b^Emin × b^(1−p) = b^(Emin + 1 - p)`.
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

  // MARK: - Minus

  /// `-Self._zero`
  internal static var _minusZero: Self {
    Self(canonical: Self.signMask | Self._zero.bid)
  }

  /// `-Self._one`
  internal static var _minusOne: Self {
    Self(canonical: Self.signMask | Self._one.bid)
  }

  /// `-Self._greatestFiniteMagnitude`
  internal static var _minusGreatestFiniteMagnitude: Self {
    Self(canonical: Self.signMask | Self._greatestFiniteMagnitude.bid)
  }

  /// `-Self._leastNonzeroMagnitude`
  internal static var _minusLeastNonzeroMagnitude: Self {
    Self(canonical: Self.signMask | Self._leastNonzeroMagnitude.bid)
  }
}
