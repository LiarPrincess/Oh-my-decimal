// swiftlint:disable line_length

extension DecimalMixin {

  public func _hash(into hasher: inout Hasher) {
    if self._isNaN {
      // Tbh. it does not matter what we do here. 'Hash' is just a shortcut
      // before the real equality, and 'NaNs' are never be equal to anything.
      //
      // That said… there is a potential attack vector for certain dictionary
      // implementations where you pack them with NaN, and bring overall
      // performance to O(n).
      //
      // Anyway, things go into the dictionary, but nothing gets out!
      hasher.combine(self.bid)
      return
    }

    if self._isInfinite {
      // inf == inf
      // Regardless of the remaining 'significand' bits.
      let sign = self.bid & Self.signMask
      hasher.combine(sign | Self.infinityMask)
      return
    }

    let unpack = self._unpackFiniteOrZero()

    if unpack.significand.isZero {
      // 0 == 0
      // Regardless of the sign and exponent.
      // This will also handle non-canonical.
      let oneZeroToRuleThemAll_oneZeroToFindThem_oneZeroToBringThemAll_andInTheDarknessBindThem = Self._zero
      hasher.combine(oneZeroToRuleThemAll_oneZeroToFindThem_oneZeroToBringThemAll_andInTheDarknessBindThem.bid)
      return
    }

    let sign = unpack.sign.bid

    let (significand, exponent, _) = Self._quantizeToUseAllDecimalDigits(
      significand: unpack.significand,
      exponent: unpack.exponent
    )

    hasher.combine(sign | significand)
    hasher.combine(exponent)
  }
}
