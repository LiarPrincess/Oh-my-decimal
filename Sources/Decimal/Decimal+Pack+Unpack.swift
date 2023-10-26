extension DecimalMixin {

  // MARK: - Pack without checks

  internal static func _packWithoutChecks(
    sign: Sign,
    significand: BID,
    signedExponent: Int
  ) -> Self {
    let biased = Self._addBias(exponent: signedExponent)
    return Self._packWithoutChecks(
      sign: sign,
      significand: significand,
      biasedExponent: biased
    )
  }

  internal static func _packWithoutChecks(
    sign: Sign,
    significand: BID,
    exponent: Exponent
  ) -> Self {
    return Self._packWithoutChecks(
      sign: sign,
      significand: significand,
      biasedExponent: exponent.biased
    )
  }

  /// No overflow/underflow checking or checking for significand above
  /// `Self.maxDecimalDigits`.
  internal static func _packWithoutChecks(
    sign: Sign,
    significand: BID,
    biasedExponent: BID
  ) -> Self {
    assert(significand <= Self.maxDecimalDigits)
    let maxSignificand_00_01_10: BID = 1 << Self.exponentShift_00_01_10

    if significand < maxSignificand_00_01_10 {
      let e = biasedExponent << Self.exponentShift_00_01_10
      return Self(canonical: sign | e | significand)
    }

    // Add significand, without leading bits
    let e = biasedExponent << Self.exponentShift_11
    let s = significand & Self.significandMask_11
    return Self(canonical: sign | Self.combinationHighBits11Mask | e | s)
  }

  // MARK: - Pack

  /// Combine all of the arguments into a single `Decimal`.
  ///
  /// `roundingDigitCount` - number of trailing decimal digits in `significand`
  /// that are used for rounding. For example `significand = 12345` and
  /// `roundingDigitCount = 2` mean `result = 123`, and `45` is used for rounding.
  /// `signedExponent` is for the `result`, without the rounding digits.
  ///
  /// Works on both `BID` and `DoubleBID`.
  internal static func _pack<T: BinaryIntegerDecimal>(
    sign: Sign,
    significand: T,
    signedExponent: Int,
    roundingDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    Self._assertSignificandLessEqualMaxDecimalDigits(
      significand: significand,
      roundingDigitCount: roundingDigitCount
    )

/*
// TODO: [Pack] Avoid underflow by digits.
// Currently we use 'signedExponent < Self.minSignedExponent'.
// Is underflow possible for 'signedExponent < Self.emin'?
// Then the significand digits determine underflow or not.
// -----------------------------------------------------------------------------
// Underflow is when we are between 0 and 1 * 10^emin (for positive numbers).
//
// For this we need:
// - minSignedExponent <= exponent < emin
// - sufficient amount of digits in 'significand' to bring us above '1 * 10^emin'.
//
// 'digitCount' should be '>' or '>='?
// 'Decimal64.emin = -383' which means that min value is '1 * 10^-383':
// |value           |digitCount|minDigitCountTo…|underflow|
// |10E-385 = 1E-384|         2| -383 - -385 = 2|     True|
// |10E-384 = 1E-383|         2| -383 - -384 = 1|    False|
let digitCount = Tables.getDecimalDigitCount(significand) - roundingDigitCount
let minDigitCountToAvoidUnderflow = Swift.abs(Self.emin - signedExponent)

if signedExponent >= Self.minSignedExponent && digitCount > minDigitCountToAvoidUnderflow {
  // We successfully escaped the underflow.
  // Maybe just the 'digitCount > minDigitCountToAvoidUnderflow' is enough?
}
*/

    // If the exponent is equal to 'Self.minSignedExponent' then no underflow is
    // possible. Even if 'significand' is 1 then our magnitude is >= '1 * 10^emin'.
    // Rounding digits do not matter because they are away from zero.
    if signedExponent < Self.minSignedExponent {
      return Self._handlePotentialUnderflow(
        sign: sign,
        significand: significand,
        signedExponent: signedExponent,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        status: &status
      )
    }

    // If the exponent is equal to 'Self.maxSignedExponent' then no overflow
    // BEFORE rounding, because we know that 'significand' (without
    // 'roundingDigits') is <= 'Self.maxDecimalDigits'.
    // Case when we have 'infinity' AFTER rounding is handled by this method.
    if signedExponent > Self.maxSignedExponent {
      return Self._handlePotentialOverflow(
        sign: sign,
        significand: significand,
        signedExponent: signedExponent,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding,
        status: &status
      )
    }

    let roundingResult = Self._round(
      sign: sign,
      significand: significand,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding
    )

    let finalExponent: Int
    let finalSignificand: BID

    switch roundingResult.afterRounding {
    case .aboveMaxDecimalDigits:
      if signedExponent == Self.maxSignedExponent {
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      }

      // The new 'significand' is 'Self.maxDecimalDigits + 1', which is 10000….
      finalExponent = signedExponent + 1
      finalSignificand = (Self.maxDecimalDigits + 1) / 10

    case .value(let s):
      finalExponent = signedExponent
      finalSignificand = s
    }

    if roundingResult.isInexact {
      status.set(.isInexact)
    }

    return Self._packWithoutChecks(
      sign: sign,
      significand: finalSignificand,
      signedExponent: finalExponent
    )
  }

  /// Check if 'significand' without rounding digits is in valid range.
  internal static func _assertSignificandLessEqualMaxDecimalDigits<T: BinaryIntegerDecimal>(
    significand: T,
    roundingDigitCount: Int
  ) {
#if DEBUG
    let pow10: T = Tables.getPowerOf10(exponent: roundingDigitCount)
    let significand = significand / pow10
    assert(
      significand <= Self.maxDecimalDigits,
      "Forgot about some rounding digits?"
    )
#endif
  }

  /// Increase `exponent` while decreasing `significand` (potentially rounding).
  /// Or just make it (rounded) 0.
  private static func _handlePotentialUnderflow<T: BinaryIntegerDecimal>(
    sign: Sign,
    significand: T,
    signedExponent: Int,
    roundingDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // IEEE-754 -> 7.5 Underflow
    //
    // b) before rounding — when a non-zero result computed as though both the
    // exponent range and the precision were unbounded would lie strictly
    // between ±b^emin.
    //
    // (…)
    //
    // For decimal formats, tininess is detected before rounding — when
    // a non-zero result computed as though both the exponent range and the
    // precision were unbounded would lie strictly between ±b^emin.
    //
    // The default exception handling for underflow shall always deliver a
    // rounded result. The method for detecting tininess does not affect the
    // rounded result delivered, which might be zero, subnormal, or ±b^emin.
    //
    // In addition, under default exception handling for underflow, if the
    // rounded result is inexact — that is, it differs from what would have been
    // computed were both exponent range and precision unbounded — the underflow
    // flag shall be raised and the inexact (see 7.6) exception shall be signaled.
    //
    // If the rounded result is exact, no flag is raised and no inexact exception
    // is signaled. This is the only case in this standard of an exception signal
    // receiving default handling that does not raise the corresponding flag.
    // Such an underflow signal has no observable effect under default handling.
    //
    // === SIMPLIFIED ===
    // Result before rounding is not 0 and between ±b^emin -> underflow.
    // If the result is inexact (we have 'roundingDigits') -> inexact underflow.
    // If the result is exact (no 'roundingDigits') -> no status.
    assert(signedExponent < Self.minSignedExponent)

    // If both 'significand' and 'roundingDigits' are 0 -> exact 0 with minimum
    // exponent, no underflow.
    if significand == 0 {
      // Use the exponent that the user provided or biased '0' if it is too low.
      // Do NOT add bias before deciding which exponent to use ->
      // 'signedExponent' with bias may not be representable by 'BID' (below 0).
      let e = Swift.max(signedExponent, Self.minSignedExponent)
      let biased = Self._addBias(exponent: e)
      return Self(canonical: sign | biased << Self.exponentShift_00_01_10)
    }

    // How many 'significand' digits do we need to remove to get to exponent >= min?
    // This looks weird, but both operands are negative, so it does make sense.
    let removedDigitCount = Swift.abs(Self.minSignedExponent - signedExponent)

    // Situations like: 1E-999999999999…
    // Edge case: If 'removedDigitCount == Self.precisionInDigits' then we have
    // to use 'significand' for rounding -> we can't use this fast path.
    if removedDigitCount > Self.precisionInDigits {
      assert(significand != 0, "0 was already handled -> we removed 'some' digits.")
      status.set(.isUnderflowInexact)

      return Self._roundInfinitelySmallValue(
        sign: sign,
        preferredSignedExponentForZero: Self.minSignedExponent,
        rounding: rounding
      )
    }

    assert(1 <= removedDigitCount && removedDigitCount <= Self.precisionInDigits)

    // Remove digits, but remember that we have 'roundingDigits'!
    // We also need to 'hop over' them to get to real 'significand'.
    let roundingDigitCount = removedDigitCount + roundingDigitCount

    let roundingResult = Self._round(
      sign: sign,
      significand: significand,
      roundingDigitCount: roundingDigitCount,
      rounding: rounding
    )

    // If the rounded result is exact, no flag is raised and no inexact exception
    // is signaled. This is the only case in this standard of an exception signal
    // receiving default handling that does not raise the corresponding flag.
    // Such an underflow signal has no observable effect under default handling.
    if roundingResult.isInexact {
      status.set(.isUnderflowInexact)
    }

    switch roundingResult.afterRounding {
    case .aboveMaxDecimalDigits:
      // It is not possible for '+1' to go over 'Self.maxDecimalDigits' because:
      // - significand <= Self.maxDecimalDigits
      // - removedDigitCount > 1 which means we decreased the 'significand'
      preconditionFailure("[Pack-Underflow] Division increased the value?")
    case .value(let afterRounding):
      return Self(canonical: sign | afterRounding)
    }
  }

  /// Decrease 'exponent' by multiplying 'significand' by 10.
  /// In the worst case we will just nuke it into the (rounded) infinity.
  private static func _handlePotentialOverflow<T: BinaryIntegerDecimal>(
    sign: Sign,
    significand: T,
    signedExponent: Int,
    roundingDigitCount: Int,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // IEEE-754 -> 7.4 Overflow
    //
    // The overflow exception shall be signaled if and only if the destination
    // format’s largest finite number is exceeded in magnitude by what would have
    // been the rounded floating-point result (see 4) were the exponent range
    // unbounded. The default result shall be determined by the rounding
    // direction attribute and the sign of the intermediate result as follows:
    //
    // a) roundTiesToEven and roundTiesToAway carry all overflows to ∞ with the
    //    sign of the intermediate result.
    // b) roundTowardZero carries all overflows to the format’s largest finite
    //    number with the sign of the intermediate result.
    // c) roundTowardNegative carries positive overflows to the format’s largest
    //    finite number, and carries negative overflows to −∞.
    // d) roundTowardPositive carries negative overflows to the format’s most
    //    negative finite number, and carries positive overflows to +∞.
    //
    // In addition, under default exception handling for overflow, the overflow
    // flag shall be raised and the inexact exception shall be signaled.
    assert(signedExponent > Self.maxSignedExponent)

    // If both 'significand' and 'roundingDigits' are 0 -> exact 0 with maximum
    // exponent, no underflow.
    // Remember that if we have 'roundingDigits' then they may become a part of
    // 'significand' after multiplication which would change the value.
    if significand == 0 {
      // Exact 0 with max exponent.
      let exponent = Self._addBias(exponent: Self.maxSignedExponent)
      return Self(canonical: sign | exponent << Self.exponentShift_00_01_10)
    }

    // Add digits to 'significand' up to decrease the 'exponent'.
    var addedDigitCount = signedExponent - Self.maxSignedExponent

    // Situations like: 1E999999999999…
    if addedDigitCount >= Self.precisionInDigits {
      status.set(.isOverflowInexact)
      return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
    }

    let finalSignificand: BID

    if addedDigitCount == roundingDigitCount {
      // Nothing to do.
      // We will just include all 'roundingDigits' in 'significand'.

      if significand > Self.maxDecimalDigits {
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      }

      finalSignificand = BID(significand)
    } else if addedDigitCount > roundingDigitCount {
      // We need to add all of the 'roundingDigits' and then add some trailing '0'.
      addedDigitCount -= roundingDigitCount
      assert(addedDigitCount != 0)

      // We can't go over 'precision' digits.
      let digitCount = Tables.getDecimalDigitCount(significand)
      let availableDigitCount = Self.precisionInDigits - digitCount

      // 'significand' does not have enough space to perform multiplication.
      if addedDigitCount > availableDigitCount {
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      }

      assert(significand <= Self.maxDecimalDigits, "Forgot about some rounding digits?")

      let s = BID(significand)
      let pow10: BID = Tables.getPowerOf10(exponent: addedDigitCount)
      finalSignificand = s * pow10
    } else {
      // We include some of the 'roundingDigits' in significand and use the rest
      // for rounding.
      assert(addedDigitCount < roundingDigitCount)

      let digitCount = Tables.getDecimalDigitCount(significand)
      let roundingDigitCount = roundingDigitCount - addedDigitCount
      let newDigitCount = digitCount - roundingDigitCount

      // Adding 'rounding digits' to get the proper exponent made our significand
      // too big.
      if newDigitCount > Self.precisionInDigits {
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      }

      let roundingResult = Self._round(
        sign: sign,
        significand: significand,
        roundingDigitCount: roundingDigitCount,
        rounding: rounding
      )

      if roundingResult.isInexact {
        status.set(.isInexact)
      }

      switch roundingResult.afterRounding {
      case .aboveMaxDecimalDigits:
        status.set(.isOverflowInexact)
        return Self._roundInfinitelyBigValue(sign: sign, rounding: rounding)
      case .value(let s):
        finalSignificand = s
      }
    }

    // We successfully added all of the digits. There is no overflow!
    return Self._packWithoutChecks(
      sign: sign,
      significand: finalSignificand,
      signedExponent: Self.maxSignedExponent
    )
  }
}

// MARK: - Unpack NaN

internal struct _NaNPayload<BID: BinaryIntegerDecimal> {
  internal let isCanonical: Bool
  internal let valueCanonicalOrNot: BID
  /// Value with applied non-canonical correction.
  internal var canonical: BID { self.isCanonical ? self.valueCanonicalOrNot : 0 }
}

extension DecimalMixin {

  internal typealias NaNPayload = _NaNPayload<BID>

  /// Get NaN payload with IEEE-754 max value check.
  ///
  /// The maximum value of the binary-encoded significand is the same as that of
  /// the corresponding decimal-encoded significand; that is, 10^(3×J + 1) −1
  /// (or 10^(3×J) −1 when T is used as the payload of a NaN).
  ///
  /// If the value exceeds the maximum, the significand c is non-canonical and
  /// the value used for c is zero.
  internal func _unpackNaN() -> NaNPayload {
    assert(self._isNaN, "Checking NaN payload without checking for NaN?")
    let bits = self.bid & Self.nanPayloadMask
    let isCanonical = bits <= Self.nanPayloadCanonicalMax
    return NaNPayload(isCanonical: isCanonical, valueCanonicalOrNot: bits)
  }
}

// MARK: - Unpack finite or zero

internal struct _Sign<BID: BinaryIntegerDecimal>: CustomStringConvertible {

  internal static var plus: Self { Self(bid: 0) }
  internal static var minus: Self { Self(bid: 1 << (BID.bitWidth - 1)) }

  internal let bid: BID

  internal var isPlus: Bool { self.bid == 0 }
  internal var isMinus: Bool { self.bid != 0 }
  internal var description: String { self.isPlus ? "+" : "-" }

  internal static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.bid == rhs.bid
  }

  internal static func != (lhs: Self, rhs: Self) -> Bool {
    return lhs.bid != rhs.bid
  }

  internal static func | (lhs: Self, rhs: BID) -> BID {
    return lhs.bid | rhs
  }

  internal static func ^ (lhs: Self, rhs: Self) -> Self {
    return Self(bid: lhs.bid ^ rhs.bid)
  }

  internal static func ^ (lhs: Self, rhs: BID) -> BID {
    return lhs.bid ^ rhs
  }

  internal init(bid: BID) {
#if DEBUG
    let signMask: BID = 1 << (BID.bitWidth - 1)
    let restMask = ~signMask
    assert((bid & restMask) == 0)
#endif

    self.bid = bid
  }
}

internal struct _Significand<BID: BinaryIntegerDecimal> {
  internal let isCanonical: Bool
  internal let valueCanonicalOrNot: BID

  /// Value with applied non-canonical correction.
  internal var canonical: BID { self.isCanonical ? self.valueCanonicalOrNot : 0 }
  /// Is zero or non-canonical.
  internal var isZero: Bool { self.canonical == 0 }
}

internal struct _Exponent<BID: BinaryIntegerDecimal>: Equatable, Comparable {
  internal let biased: BID
  /// Unbiased. Human centric value.
  /// We can't name it `unbiased` because that is way too similar to `biased`.
  internal let signed: Int

  internal static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.biased == rhs.biased
  }

  internal static func < (lhs: Self, rhs: Self) -> Bool {
    return lhs.biased < rhs.biased
  }
}

internal struct _FiniteUnpack<BID: BinaryIntegerDecimal> {
  internal var sign: _Sign<BID>
  internal let exponent: _Exponent<BID>
  internal let significand: _Significand<BID>
}

extension DecimalMixin {

  internal typealias Sign = _Sign<BID>
  /// Exponent patronum!
  internal typealias Exponent = _Exponent<BID>
  internal typealias Significand = _Significand<BID>
  internal typealias FiniteUnpack = _FiniteUnpack<BID>

  /// Technically `zero` is also finite, but we want to make it explicit.
  internal func _unpackFiniteOrZero() -> FiniteUnpack {
    assert(self._isFinite, "Unpack finite on infinity or NaN?")

    let sign = self._sign
    let exponentShift: Int
    let significandBID: BID

    if self._isSet(Self.combinationHighBits11Mask) {
      exponentShift = Self.exponentShift_11
      significandBID = (self.bid & Self.significandMask_11) | Self.prefix100_11
    } else {
      exponentShift = Self.exponentShift_00_01_10
      significandBID = self.bid & Self.significandMask_00_01_10
    }

    // The maximum value of the binary-encoded significand 10 (3 × J + 1) −1
    // (or 10 (3 × J ) −1 when T is used as the payload of a NaN).
    // If the value exceeds the maximum, the significand c is non-canonical and
    // the value used for c is zero.
    //
    // IMPORTANT:
    // This check has nothing to do with 'greatestFiniteMagnitude'!
    // You may be non-canonical while having a low exponent (00_01_10 mode).
    let isCanonical = significandBID <= Self.maxDecimalDigits
    let significand = Significand(
      isCanonical: isCanonical,
      valueCanonicalOrNot: significandBID
    )

    let biased = (self.bid >> exponentShift) & Self.exponentMask
    let signed = Self._removeBias(biasedExponent: biased)
    let exponent = Exponent(biased: biased, signed: signed)

    return FiniteUnpack(sign: sign, exponent: exponent, significand: significand)
  }
}
