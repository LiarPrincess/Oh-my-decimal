import XCTest
@testable import Decimal

class InitFromDecimalTests: XCTestCase, DecimalTests {

  // Double(Float.signalingNaN) -> nan
  // We want sNaN.
  func test_snan() {
    func test<
      Src: DecimalFloatingPoint & DecimalMixin,
      Dst: DecimalFloatingPoint & DecimalMixin
    >(
      _ s: Src.Type,
      _ d: Dst.Type,
      create: (Src, inout DecimalStatus) -> Dst,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      for payload: Src.BitPattern in [0, 0x123] {
        var status = DecimalStatus()

        let expectedSrc = Src(nan: payload, signaling: false)
        var expected = create(expectedSrc, &status)
        expected = Dst(unchecked: expected.bid | Dst.nanSignalingMask)
        status.clearAll()

        let src = Src(nan: payload, signaling: true)

        let plus = create(+src, &status)
        self.assertEqual(plus, +expected, "+", file, line)
        self.assertStatusIsEmpty(status, "+", file, line)
        status.clearAll()

        let minus = create(-src, &status)
        self.assertEqual(minus, -expected, "-", file, line)
        self.assertStatusIsEmpty(status, "-", file, line)
        status.clearAll()
      }
    }

    test(Decimal32.self, Decimal64.self) { d, _ in .init(d) }
    test(Decimal32.self, Decimal128.self) { d, _ in .init(d) }
    test(Decimal64.self, Decimal128.self) { d, _ in .init(d) }
    test(Decimal64.self, Decimal32.self) { d, s in .init(d, status: &s) }
    test(Decimal128.self, Decimal32.self) { d, s in .init(d, status: &s) }
    test(Decimal128.self, Decimal64.self) { d, s in .init(d, status: &s) }
  }
}
