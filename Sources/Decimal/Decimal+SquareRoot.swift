extension Int {
  fileprivate var isOdd: Bool {
    return (self & 1) == 1
  }
}

extension DecimalMixin {

  internal func _squareRoot(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self {
    // formatOf-squareRoot(source1)
    // The operation squareRoot(x) computes √x.
    // It has a positive sign for all operands ≥ 0, except that squareRoot(−0)
    // shall be −0.
    // The preferred exponent is floor(Q(x)/2).
    //
    // 6.1 Infinity arithmetic
    // Operations on infinite operands are usually exact and therefore signal no
    // exceptions, including, among others:
    // ― squareRoot(+∞)
    //
    // 6.3 The sign bit
    // Except that squareRoot(−0) shall be −0, every numeric squareRoot result
    // shall have a positive sign.
    //
    // 7.2 Invalid operation
    // For operations producing results in floating-point format, the default
    // result of an operation that signals the invalid operation exception shall
    // be a quiet NaN that should provide some diagnostic information (see 6.2).
    //
    // These operations are:
    // g) squareRoot if the operand is less than zero

    if self._isNaN {
      return Self._nanResult_viaIEEE754_section62(self, status: &status)
    }

    if self._isInfinite {
      if self._isNegative {
        status.set(.isInvalidOperation)
        return Self._nan
      }

      return Self._infinity
    }

    let unpack = self._unpackFiniteOrZero()

    if unpack.significand.canonical == 0 {
      let exponent = Self._sqrtBiasedHalf(exponent: unpack.exponent)
      return Self(canonical: unpack.sign | exponent << Self.exponentShift_00_01_10)
    }

    if unpack.sign.isMinus {
      status.set(.isInvalidOperation)
      return Self._nan
    }

    if let exact = Self._sqrtExact(unpack: unpack) {
      return exact
    }

    status.set(.isInexact)

    // Scale to 'DoubleBID'.
    // '-1' to fit the '+1' from the odd exponent.
    let unpackDigitCount = Self._getDecimalDigitCount(unpack.significand)
    var scale = 2 * Self.precisionInDigits - unpackDigitCount - 1
    let scaledSignedExponent = unpack.exponent.signed - scale
    // Multiply by an additional '10' if we have 'odd' exponent.
    // Note that this is based on 'scaledExponent', not on 'unpack.exponent'.
    scale += scaledSignedExponent.isOdd ? 1 : 0

    let pow10: DoubleBID = Tables.getPowerOf10(exponent: scale)
    let scaledSignificand = pow10 * unpack.significand.canonical

    // root = ⌊√scaledSignificand⌋
    // Only 'low' matter because √(2*precision digits) = precision digits.
    let rootDoubleBID = scaledSignificand.squareRoot()
    assert(rootDoubleBID.high == 0 && rootDoubleBID.low <= Self.maxDecimalDigits)
    var root = rootDoubleBID.low

    // Exponent/2 will escape us from underflow/overflow range.
    // So, we can just round it here.
    let isRoundingUp: Bool

    switch rounding {
    case .up:
      // Our integer square root rounds toward '0'.
      // We are not 'exact', so we know that we have some digits after.
      isRoundingUp = true

    case .down,
         .towardZero:
      // Positive number -> toward zero -> truncate -> no change.
      isRoundingUp = false

    case .toNearestOrEven,
         .toNearestOrAwayFromZero:
      // We will never be exactly 'halfway', so 'OrEven/OrAwayFromZero' can
      // share the code. The thing below is not exactly 'halfway', but it serves
      // the same purpose.
      let halfway = root + root + 1
      let halfwaySquare = Self._mulSignificands(halfway, halfway)
      let scaledSignificand4 = scaledSignificand << 2 // multiply by 4

      // Not '>=' because we are inexact!
      isRoundingUp = scaledSignificand4 > halfwaySquare
    }

    var biasedExponent = BID((scaledSignedExponent + 2 * Self.exponentBias) >> 1)

    if isRoundingUp {
      root += 1

      // Make it canonical if needed.
      if root == Self.maxDecimalDigits + 1 {
        root /= 10
        biasedExponent += 1
      }
    }

    return Self._packWithoutChecks(
      sign: .plus,
      significand: root,
      biasedExponent: biasedExponent
    )
  }

  private static func _sqrtExact(unpack: FiniteUnpack) -> Self? {
    var significand = unpack.significand.canonical
    let exponent = unpack.exponent

    if exponent.signed.isOdd {
      significand *= 10
    }

    let root = significand.squareRoot()

    if root * root == significand {
      let e = Self._sqrtBiasedHalf(exponent: exponent)
      return Self._packWithoutChecks(
        sign: .plus,
        significand: root,
        biasedExponent: e
      )
    }

    return nil
  }

  private static func _sqrtBiasedHalf(exponent: Exponent) -> BID {
    // - '+ exponentBias' - because after spit we will need 2 biases
    // - '>> 1' - the same as divide by 2
    return (exponent.biased + BID(Self.exponentBias)) >> 1
  }
}
