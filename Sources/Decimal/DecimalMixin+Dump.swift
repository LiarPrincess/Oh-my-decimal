extension DecimalMixin {
#if DEBUG

  internal static func dumpEncoding() {
    let sign = "+"
    let highBits = "hh"

    var combination = sign
    for n in 0..<self.combinationWidth {
      combination.append(String(n % 10))
    }

    let combinationPadding = String(repeating: " ", count: Self.bitWidth - combination.count)
    let combinationLastIndex = Self.combinationWidth - 1
    let combinationComment = "combination bits G[0]…G[\(combinationLastIndex)]"
    Self.dumpInOctets(combination + combinationPadding, combinationComment)

    // -2 for high bits
    let exponent_00_01_10 = String(repeating: "e", count: Self.exponentWidth - highBits.count)
    let significand_00_01_10 = String(repeating: "s", count: Self.exponentShift_00_01_10)
    let comment_00_01_10 = "hh=00,01,10 exponent=hheee… significand=0sss…"
    Self.dumpInOctets(sign + highBits + exponent_00_01_10 + significand_00_01_10, comment_00_01_10)

    let exponent_11 = String(repeating: "e", count: Self.exponentWidth)
    let significand_11 = String(repeating: "s", count: Self.exponentShift_11)
    let comment_11 = "hh=11       exponent=eee…   significand=100G[\(combinationLastIndex)]sss…"
    Self.dumpInOctets(sign + highBits + exponent_11 + significand_11, comment_11)
  }

  internal static func dump(_ n: BID, _ comment: String = "") {
    let s = String(n, radix: 2)
    Self.dumpInOctets(s, comment)
  }

  internal func dump(_ comment: String = "") {
    Self.dump(self.bid, comment)
  }

  private static func dumpInOctets(_ s: String, _ comment: String) {
    assert(
      Self.bitWidth >= s.count,
      "Dump string too long: \(s) (count: \(s.count), max: \(Self.bitWidth))."
    )

    let padding = String(repeating: " ", count: Self.bitWidth - s.count)
    let full = padding + s

    var printed = "|"
    printed.reserveCapacity(Self.bitWidth + Self.bitWidth / 4 + 1 + comment.count)

    for (index, c) in full.enumerated() {
      printed.append(c)

      if (index + 1).isMultiple(of: 8) {
        printed.append("|")
      }
    }

    if !comment.isEmpty {
      printed.append(comment)
    }

    print(printed)
  }

#endif
}
