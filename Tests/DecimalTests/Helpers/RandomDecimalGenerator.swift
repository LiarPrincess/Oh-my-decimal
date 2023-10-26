@testable import Decimal

/// The quality of the produced decimals is not that great.
/// This is not an issue, we just want some decimals, we do not care about their values.
struct RandomDecimalGenerator<T: DecimalMixin> {

  typealias Seed = UInt64

  private var xorshift: Xorshift

  init(seed: Seed?) {
    self.xorshift = Xorshift(seed: seed ?? 123456)
  }

  private typealias BID = T.BID

  /// There is `1/10` chance that the significand will have
  /// `significandDigitCount-1` digits.
  mutating func next(significandDigitCount: Int) -> T {
    let bid = self.nextBid()

    let pow10: BID = Tables.getPowerOf10(exponent: significandDigitCount)
    let significand = bid % pow10

    // This will skew distribution toward smaller exponents. Whatever…
    let exponentBits = (bid >> T.trailingSignificandWidth) & T.exponentMask
    let maxBiasedExponent = BID(T.maxSignedExponent + T.exponentBias)
    let biasedExponent = exponentBits % maxBiasedExponent

    let sign = T.Sign(bid: bid & T.signMask)

    return T._packWithoutChecks(
      sign: sign,
      significand: significand,
      biasedExponent: biasedExponent
    )
  }

  /// Generate NaN with payload.
  mutating func nextNaN() -> T {
    let bid = self.nextBid()
    let sign = bid & T.signMask
    let payload = bid % T.nanPayloadCanonicalMax
    return T(unchecked: sign | T.nanQuietMask | payload)
  }

  private mutating func nextBid() -> T.BID {
    return self.xorshift.next(BID.self)
  }
}

/// No guarantee about the distribution (especially uniform distribution).
/// https://en.wikipedia.org/wiki/Xorshift
private struct Xorshift {

  fileprivate typealias State = UInt64

  private var state: State

  fileprivate init(seed: State) {
    self.state = seed
  }

  fileprivate mutating func next<T: UnsignedInteger & FixedWidthInteger>(_ t: T.Type) -> T {
    if T.bitWidth <= State.bitWidth {
      let n = self.next()
      return T(truncatingIfNeeded: n)
    }

    if T.bitWidth <= 2 * State.bitWidth {
      let high = self.next()
      let low = self.next()

      let h = T(truncatingIfNeeded: high) << State.bitWidth
      let l = T(truncatingIfNeeded: low)
      return h | l
    }

    preconditionFailure("Xorshift can produce values up to \(2 * State.bitWidth) bit.")
  }

  fileprivate mutating func next() -> State {
    self.state ^= self.state << 13
    self.state ^= self.state >> 7
    self.state ^= self.state << 17
    return self.state
  }
}
