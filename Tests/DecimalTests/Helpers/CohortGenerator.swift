@testable import Decimal

/// Same value different cohort.
struct CohortGenerator<T: DecimalMixin> {

  private let d: T
  private let unpack: T.FiniteUnpack

  private var sign: T.Sign { self.unpack.sign }
  private var signedExponent: Int { self.unpack.exponent.signed }
  private var biasedExponent: T.BID { self.unpack.exponent.biased }
  private var significand: T.BID { self.unpack.significand.canonical }

  init(finiteOrZero d: T) {
    assert(d._isFinite)
    self.d = d
    self.unpack = d._unpackFiniteOrZero()
  }

  func incrementExponent(allowInexact: Bool) -> T? {
    if self.signedExponent == T.maxSignedExponent {
      return nil
    }

    let signedExponent = self.signedExponent + 1
    let (significand, r) = self.significand.quotientAndRemainder(dividingBy: 10)
    let isInexact = r != 0

    if isInexact && !allowInexact {
      return nil
    }

    return T._packWithoutChecks(
      sign: self.sign,
      significand: significand,
      signedExponent: signedExponent
    )
  }

  func decrementExponent() -> T? {
    if self.biasedExponent == 0 {
      return nil
    }

    let biasedExponent = self.biasedExponent - 1
    let significand = self.significand * 10

    if significand > T.maxDecimalDigits {
      return nil
    }

    return T._packWithoutChecks(
      sign: self.sign,
      significand: significand,
      biasedExponent: biasedExponent
    )
  }
}
