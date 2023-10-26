extension DecimalMixin {

  internal func _quantize(
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnQuantize, other: other, rounding: rounding, status: &status)
  }

  internal func _sameQuantum(other: Self) -> Bool {
    return self._test(Self.fnSameQuantum, other: other)
  }

  internal func _quantum(status: inout ExceptionStatus) -> Self {
    // if self._isInfinite {
    //   return Self(canonical: Self.infinityMask)
    // }

    // if self._isNaN {
    //   return Self(canonical: Self.nanQuietMask)
    // }

    // let is11 = self._isSet(Self.combinationHighBits11Mask)
    // let exponentShift = is11 ? Self.exponentShift_11 : Self.exponentShift_00_01_10
    // let exponent = self.bid & (Self.exponentMask << exponentShift)
    // let significand: BID = 1
    // return Self(canonical: exponent | significand)

    // Swift stdlib:
    //   public var binade: Double {
    //     guard _fastPath(isFinite) else { return .nan }
    // #if !arch(arm)
    //     if _slowPath(isSubnormal) {
    //       let bitPattern_ =
    //         (self * 0x1p52).bitPattern
    //           & (-Double.infinity).bitPattern
    //       return Double(bitPattern: bitPattern_) * 0x1p-52
    //     }
    // #endif
    //     return Double(bitPattern: bitPattern & (-Double.infinity).bitPattern)
    //   }

    return self._convert(Self.fnQuantum, status: &status)
  }
}
