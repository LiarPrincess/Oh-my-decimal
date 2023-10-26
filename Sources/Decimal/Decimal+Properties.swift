extension DecimalMixin {

  // MARK: - Sign

  internal var _isNegative: Bool { self._isSet(Self.signMask) }
  internal var _isPositive: Bool { !self._isNegative }
  internal var _sign: Sign { Sign(bid: self.bid & Self.signMask) }

  internal var _floatingPointSign: FloatingPointSign {
    self._isNegative ? .minus : .plus
  }

  // MARK: - Finite

  internal var _isFinite: Bool {
    !self._isSet(Self.infinityMask)
  }

  internal var _isInfinite: Bool {
    (self.bid & Self.nanQuietMask) == Self.infinityMask
  }

  internal var _isInfiniteOrNaN: Bool {
    self._isSet(Self.infinityMask)
  }

  internal var _isZero: Bool {
    if self._isInfiniteOrNaN {
      return false
    }

    let unpack = self._unpackFiniteOrZero()
    return unpack.significand.isZero
  }

  // MARK: - NaN

  internal var _isNaN: Bool { self._isSet(Self.nanQuietMask) }
  internal var _isQuietNaN: Bool { (self.bid & Self.nanSignalingMask) == Self.nanQuietMask }
  internal var _isSignalingNaN: Bool { self._isSet(Self.nanSignalingMask) }

  // MARK: - Normal

  internal var _isNormal: Bool {
    // 2.1.38 normal number:
    // For a particular format, a finite non-zero floating-point number with
    // magnitude greater than or equal to a minimum b emin value, where b is the
    // radix.
    // Normal numbers can use the full precision available in a format.
    // In this standard, zero is neither normal nor subnormal.

    if self._isInfiniteOrNaN {
      return false
    }

    let unpack = self._unpackFiniteOrZero()
    let significand = unpack.significand

    if significand.isZero {
      return false
    }

    return self._isFiniteNormal(significand: significand)
  }

  internal var _isSubnormal: Bool {
    // The smallest positive normal floating-point number is b^emin and the
    // largest is b^emax×(b−b1−p). The non-zero floating-point numbers for
    // a format with magnitude less than b^emin are called subnormal because
    // their magnitudes lie between zero and the smallest normal magnitude.
    // They always have fewer than p significant digits.

    if self._isInfiniteOrNaN {
      return false
    }

    let unpack = self._unpackFiniteOrZero()
    let significand = unpack.significand

    if significand.isZero {
      return false
    }

    return !self._isFiniteNormal(significand: significand)
  }

  /// Is finite value normal?
  private func _isFiniteNormal(significand: Significand) -> Bool {
    assert(self._isFinite, "Checking isFiniteNormal on infinity or NaN?")

    let unpack = self._unpackFiniteOrZero()
    let exponent = unpack.exponent

    if exponent.biased >= Self.precisionInDigits {
      // Even if significand = 1 -> our exponent is enough to make it normal.
      return true
    }

    let digitCount = Self._getDecimalDigitCount(significand)
    return digitCount + exponent.signed > Self.emin
  }

  // MARK: - Canonical

  internal var _isCanonical: Bool {
    if self._isNaN {
      // A NaN is in its preferred (canonical) representation if the bits G6
      // through Gw + 4 are zero and the encoding of the payload is canonical.

      let significandMask: BID = (1 << Self.trailingSignificandWidth) - 1
      let combinationInvertedMask = Self.signMask | Self.nanSignalingMask | significandMask
      let combinationMask = ~combinationInvertedMask
      let hasCombinationBits0 = (self.bid & combinationMask) == 0

      let payload = self._unpackNaN()
      return hasCombinationBits0 && payload.isCanonical
    }

    if self._isInfinite {
      // The two canonical representations of infinity have bits G5 through
      // Gw +4 = 0, and T = 0. "nanQuietMask" ends at exactly G5.
      let valid = Self.signMask | Self.nanQuietMask
      let invalid = ~valid
      return (self.bid & invalid) == 0
    }

    let unpack = self._unpackFiniteOrZero()
    return unpack.significand.isCanonical
  }

  // MARK: - ULP

  internal var _ulp: Self {
    if !self._isFinite {
      return ._nan
    }

    let unpack = self._unpackFiniteOrZero()

    // 0 or non-canonical?
    if unpack.significand.isZero {
      return Self._leastNonzeroMagnitude
    }

    let digitCount = Self._getDecimalDigitCount(unpack.significand)
    let exponentDecrease = Swift.min(
      BID(Self.precisionInDigits - digitCount), // fill all significand digits
      unpack.exponent.biased // biased exponent can't go below 0
    )

    let significand: BID = 1
    let exponent = unpack.exponent.biased - exponentDecrease
    return Self(canonical: exponent << Self.exponentShift_00_01_10 | significand)
  }

  internal static var _ulpOfOne: Self {
    let one = Self._one
    return one._ulp
  }

  // MARK: - Magnitude

  internal var _magnitude: Self {
    // If the input is not canonical, then we will return non-canonical value.
    // Oh well…
    let bid = self.bid & (~Self.signMask)
    return Self(unchecked: bid)
  }
}
