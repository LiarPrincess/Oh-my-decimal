import XCTest
@testable import Decimal

// Well… actually… hash and equatable
class HashableTests: XCTestCase, DecimalTests {

  /// Once you get in, you can't get out!
  /// - No Mr. Bond, I expect you to die!
  /// <Kefka laugh>
  func test_nan() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let nans = [
        T.nan,
        -T.nan,
        T(nan: 0x123, signaling: false),
        -T(nan: 0x123, signaling: false),
        T.signalingNaN,
        -T.signalingNaN,
        T(nan: 0x123, signaling: true),
        -T(nan: 0x123, signaling: true),
      ]

      var dict = [T: Int]()

      // Insert
      for (index, d) in nans.enumerated() {
        dict[d] = index
      }

      // Retrieval
      for d in nans {
        let int = dict[d]
        let intString = String(describing: int)
        XCTAssertNil(int, "dict[\(d)] = \(intString)", file: file, line: line)
      }

      // Removal
      let countBefore = dict.count

      for d in nans {
        dict[d] = nil
      }

      XCTAssertEqual(dict.count, countBefore, "dict.count", file: file, line: line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_infinity() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      var dict = [T: Int]()

      // Insert
      dict[ T.infinity] = 1
      dict[-T.infinity] = 2
      XCTAssertEqual(dict.count, 2, "insert: count", file: file, line: line)

      // Retrieval
      XCTAssertEqual(dict[ T.infinity], 1, "get: dict[inf]", file: file, line: line)
      XCTAssertEqual(dict[-T.infinity], 2, "get: dict[inf]", file: file, line: line)

      // Removal
      dict[ T.infinity] = nil
      XCTAssertNil(dict[ T.infinity], "remove +: dict[inf]", file: file, line: line)
      XCTAssertEqual(dict[-T.infinity], 2, "remove +: dict[inf]", file: file, line: line)
      XCTAssertEqual(dict.count, 1, "remove +: count", file: file, line: line)

      dict[-T.infinity] = nil
      XCTAssertNil(dict[ T.infinity], "remove -: dict[inf]", file: file, line: line)
      XCTAssertNil(dict[-T.infinity], "remove -: dict[inf]", file: file, line: line)
      XCTAssertEqual(dict.count, 0, "remove -: count", file: file, line: line)
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_zero() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let plusZeros = [
        T.zero,
        T._packWithoutChecks(sign: .plus, significand: 0, signedExponent: 0),
        T._packWithoutChecks(sign: .plus, significand: 0, signedExponent:  42),
        T._packWithoutChecks(sign: .plus, significand: 0, signedExponent: -42),
        T._packWithoutChecks(sign: .plus, significand: 0, signedExponent: T.minSignedExponent),
        T._packWithoutChecks(sign: .plus, significand: 0, signedExponent: T.maxSignedExponent),
      ]

      var zeros = [T]()

      for d in plusZeros {
        zeros.append( d)
        zeros.append(-d)
      }

      // Raw hash
      let expectedHash = self.hash(T.zero)

      for d in zeros {
        let hash = self.hash(d)
        XCTAssertEqual(hash, expectedHash, "hash(\(d)) == hash(0)", file: file, line: line)
      }

      var dict = [T: Int]()
      self.insertRandom(into: &dict, count: 5, seed: 123456, butNot: T.zero)
      let expectedCount = dict.count + 1

      for (index, d) in zeros.enumerated() {
        dict[d] = index
        XCTAssertEqual(dict[d], index, "dict[\(d)]", file: file, line: line)
        XCTAssertEqual(dict.count, expectedCount, "dict[\(d)].count", file: file, line: line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_cohorts() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      var dict = [T: Int]()
      let decimals: [T] = self.generateDecimals(approximateCount: 50)

      for (index, d) in decimals.enumerated() {
        let cohorts = CohortGenerator(finiteOrZero: d)

        dict[d] = index
        XCTAssertEqual(dict[d], index, "before: \(d)", file: file, line: line)

        if let inc = cohorts.incrementExponent(allowInexact: false) {
          XCTAssertEqual(dict[inc], index, "inc: \(d)", file: file, line: line)
          dict[inc] = nil
          XCTAssertNil(dict[inc], "inc.remove: \(d)", file: file, line: line)
          dict[inc] = index
        }

        if let dec = cohorts.decrementExponent() {
          XCTAssertEqual(dict[dec], index, "dec: \(d)", file: file, line: line)
          dict[dec] = nil
          XCTAssertNil(dict[dec], "dec.remove: \(d)", file: file, line: line)
          dict[dec] = index
        }

        XCTAssertEqual(dict[d], index, "after: \(d)", file: file, line: line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  func test_dict() {
    func test<T: DecimalFloatingPoint & DecimalMixin>(
      _ t: T.Type,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      var dict = [T: Int]()
      let (all, unique) = self.generateHashableDecimals(T.self)

      // Insert
      for (index, d) in all.enumerated() {
        dict[d] = index
        XCTAssertEqual(dict[d], index, "insert: \(d)", file: file, line: line)
      }

      XCTAssertEqual(dict.count, unique.count, "insert: count", file: file, line: line)

      // Remove
      for d in unique {
        dict[d] = nil
      }

      XCTAssertEqual(dict.count, 0, "remove: count", file: file, line: line)

      for d in all {
        XCTAssertNil(dict[d], "remove: \(d)", file: file, line: line)
      }
    }

    test(Decimal32.self)
    test(Decimal64.self)
    test(Decimal128.self)
  }

  // MARK: - Helpers

  private func hash<T: DecimalFloatingPoint & DecimalMixin>(_ d: T) -> Int {
    var hasher = Hasher()
    d.hash(into: &hasher)
    return hasher.finalize()
  }

  private func insertRandom<T: DecimalFloatingPoint & DecimalMixin>(
    into dict: inout [T: Int],
    count: Int,
    seed: RandomDecimalGenerator<T>.Seed,
    butNot: T? = nil
  ) {
    let decimals: [T] = self.generateDecimals(approximateCount: count, seed: seed)

    for (index, d) in decimals.enumerated() {
      if let b = butNot, b == d {
        continue
      }

      dict[d] = 500 + index
    }
  }

  private func generateHashableDecimals<T: DecimalFloatingPoint & DecimalMixin>(
    _ t: T.Type
  ) -> (all: [T], unique: [T]) {
    var all: [T] = self.generateDecimals(approximateCount: 25)
    all.append( T.zero)
    all.append(-T.zero)
    all.append( T.infinity)
    all.append(-T.infinity)

    // We can't use 'Set' because 'Hashable' was not yet proven to work correctly…
    var unique = [T]()

    for d in all where !unique.contains(d) {
      unique.append(d)
    }

    return (all, unique)
  }
}
