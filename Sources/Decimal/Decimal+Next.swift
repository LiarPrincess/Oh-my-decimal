extension DecimalMixin {

  // MARK: - Up

  internal func _nextUp(status: inout DecimalStatus) -> Self {
    // When x is NaN, then the result is according to 6.2.
    if self._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, status: &status)
    }

    // nextUp(+∞) is +∞
    // nextUp(−∞) is the finite negative number largest in magnitude
    if self._isInfinite {
      return self._isNegative ? Self._minusGreatestFiniteMagnitude : Self._infinity
    }

    // Edge cases
    if self.bid == Self._minusLeastNonzeroMagnitude.bid {
      // The preferred exponent is the least possible: -0 * 10^emin
      return Self(canonical: Self.signMask)
    }

    if self.bid == Self._greatestFiniteMagnitude.bid {
      return Self._infinity
    }

    let unpack = self._unpackFiniteOrZero()

    // nextUp(±0) is the positive number of least magnitude in x’s format.
    if unpack.significand.isZero {
      return Self._leastNonzeroMagnitude
    }

    // Increase significand (multiply by 10) while decreasing exponent (-= 1).
    // This will allow us to just += 1 the significand later. It will also
    // satisfy 'The preferred exponent is the least possible' from IEEE-754.
    var (significand, exponent, _) = Self._quantizeToUseAllDecimalDigits(
      significand: unpack.significand,
      exponent: unpack.exponent
    )

    if unpack.sign.isPlus {
      significand += 1

      // +1 put us in the non-canonical territory.
      if significand == (Self.maxDecimalDigits + 1) {
        significand /= 10
        exponent += 1
      }
    } else {
      significand -= 1

      // Special case for things like:
      //   (-1E-238).nextUp
      // = (-1000000000000000E-253).nextUp
      // =   -999999999999999E-253
      // =  -9999999999999999E-254
      if significand == Self.maxDecimalDigits / 10 && exponent != Self.minSignedExponent {
        significand = Self.maxDecimalDigits
        exponent -= 1
      }
    }

    return Self._packWithoutChecks(
      sign: unpack.sign,
      significand: significand,
      signedExponent: exponent
    )
  }

  // MARK: - Down

  internal func _nextDown(status: inout DecimalStatus) -> Self {
    // From IEEE-754:  nextDown(x) is −nextUp(−x).

    var d = self
    d._negate()

    var up = d._nextUp(status: &status)
    up._negate()

    return up
  }
}
