import io
import os
import re
from dataclasses import dataclass
from common import (
    GENERATED_FILE_HEADER,
    DECIMAL_TYPES,
    DecimalType,
    IntType,
    IntToDecimal,
    Int32,
    Int64,
    UInt32,
    UInt64,
)


_INT_TYPES: list[IntType] = [Int32, Int64, UInt32, UInt64]


def generate(dir: str):
    class_name = "GeneratedToIntTests"
    file_path = os.path.join(dir, class_name + ".swift")

    with open(file_path, "w") as f:
        f.write(GENERATED_FILE_HEADER)
        f.write(
            f"""
import XCTest
@testable import Decimal

class {class_name}: XCTestCase, DecimalTests {{

  func test_double() {{
    var d = Double.nan
    // _ = Int32(d) // crash
    // _ = Int32(-d) // crash
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Double.signalingNaN
    // _ = Int32(d) // crash
    // _ = Int32(-d) // crash
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Double.infinity
    // _ = Int32(d) // crash
    // _ = Int32(-d) // crash
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))

    d = Double.zero
    XCTAssertEqual(Int32( d), 0)
    XCTAssertEqual(Int32(-d), 0)
    XCTAssertEqual(Int32(exactly:  d), 0)
    XCTAssertEqual(Int32(exactly: -d), 0)

    d = 5.0
    XCTAssertEqual(Int32( d),  5)
    XCTAssertEqual(Int32(-d), -5)
    XCTAssertEqual(Int32(exactly:  d),  5)
    XCTAssertEqual(Int32(exactly: -d), -5)

    d = 11.00
    XCTAssertEqual(Int32( d),  11)
    XCTAssertEqual(Int32(-d), -11)
    XCTAssertEqual(Int32(exactly:  d),  11)
    XCTAssertEqual(Int32(exactly: -d), -11)

    d = 11.13
    XCTAssertEqual(Int32( d),  11)
    XCTAssertEqual(Int32(-d), -11)
    XCTAssertNil(Int32(exactly:  d))
    XCTAssertNil(Int32(exactly: -d))
  }}
"""
        )

        for d in DECIMAL_TYPES:
            for i in _INT_TYPES:
                _write_decimal_tests(f, d, i)

        f.write("}\n")


HAS_NEGATIVE_NUMBER = re.compile(r"-\d")


def _write_decimal_tests(f: io.TextIOWrapper, d: DecimalType, i: IntType):
    min = IntToDecimal(d, i.min)
    max = IntToDecimal(d, i.max)

    f.write("\n")
    f.write(f"  // MARK: - {d.name} -> {i.name}\n")

    # Handle negative numbers for unsigned types.
    is_signed = i.is_signed
    is_unsigned = i.is_unsigned

    def write_handling_unsigned(s: str, *, is_exactly: bool):
        for line in s.splitlines():
            # Because of 'exponent' we need to allow negative numbers in 'pack'.
            has_negative = HAS_NEGATIVE_NUMBER.search(line)
            is_pack = "_packWithoutChecks" in line
            is_unsigned_negative = is_unsigned and has_negative and not is_pack

            if is_unsigned_negative:
                if is_exactly:
                    f.write(f"    XCTAssertNil({i.name}(exactly: -d))")
                    f.write("\n")
            else:
                f.write(line)
                f.write("\n")

    # ============
    # === Cast ===
    # ============

    s = f"""
  func test_{d.name}_to_{i.name}() {{
    // {d.name}.nan will crash
    // {d.name}.signalingNaN will crash
    // {d.name}.infinity will crash
    var d = {d.name}.zero

    // Exact checks - independent of rounding
    for r in Self.roundingRules {{
      d = {d.name}.zero
      XCTAssertEqual({i.name}( d, rounding: r), 0, r.description)
      XCTAssertEqual({i.name}(-d, rounding: r), 0, r.description)

      // Exponent = 0
      d = 5
      XCTAssertEqual({i.name}( d, rounding: r),  5, r.description)
      XCTAssertEqual({i.name}(-d, rounding: r), -5, r.description)

      // Positive exponent
      d = {d.name}._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
      XCTAssertEqual({i.name}( d, rounding: r),  171900, r.description)
      XCTAssertEqual({i.name}(-d, rounding: r), -171900, r.description)

      // Negative exponent, decimal digits = 0
      d = {d.name}._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
      XCTAssertEqual({i.name}( d, rounding: r),  11, r.description)
      XCTAssertEqual({i.name}(-d, rounding: r), -11, r.description)
    }}

    // Negative exponent, decimal digits below half
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1142, signedExponent: -2)
    XCTAssertEqual({i.name}( d, rounding: .up), 12)
    XCTAssertEqual({i.name}( d, rounding: .down), 11)
    XCTAssertEqual({i.name}( d, rounding: .towardZero), 11)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrEven), 11)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrAwayFromZero), 11)
    XCTAssertEqual({i.name}(-d, rounding: .up), -11)
    XCTAssertEqual({i.name}(-d, rounding: .down), -12)
    XCTAssertEqual({i.name}(-d, rounding: .towardZero), -11)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrEven), -11)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrAwayFromZero), -11)

    // Negative exponent, decimal digits half odd
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1150, signedExponent: -2)
    XCTAssertEqual({i.name}( d, rounding: .up), 12)
    XCTAssertEqual({i.name}( d, rounding: .down), 11)
    XCTAssertEqual({i.name}( d, rounding: .towardZero), 11)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual({i.name}(-d, rounding: .up), -11)
    XCTAssertEqual({i.name}(-d, rounding: .down), -12)
    XCTAssertEqual({i.name}(-d, rounding: .towardZero), -11)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrAwayFromZero), -12)
    // Negative exponent, decimal digits half even
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1050, signedExponent: -2)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrEven), 10)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrEven), -10)

    // Negative exponent, decimal digits above half
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1151, signedExponent: -2)
    XCTAssertEqual({i.name}( d, rounding: .up), 12)
    XCTAssertEqual({i.name}( d, rounding: .down), 11)
    XCTAssertEqual({i.name}( d, rounding: .towardZero), 11)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrEven), 12)
    XCTAssertEqual({i.name}( d, rounding: .toNearestOrAwayFromZero), 12)
    XCTAssertEqual({i.name}(-d, rounding: .up), -11)
    XCTAssertEqual({i.name}(-d, rounding: .down), -12)
    XCTAssertEqual({i.name}(-d, rounding: .towardZero), -11)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrEven), -12)
    XCTAssertEqual({i.name}(-d, rounding: .toNearestOrAwayFromZero), -12)

    // {i.name}.max
    // We have to parse because the value may not be representable by int literal.
    if let d: {d.name} = self.parseExact("{max.decimal_significand}E{max.decimal_exponent}", #file, #line) {{
      XCTAssertEqual({i.name}( d),  {max.int})
      XCTAssertEqual({i.name}(-d), -{max.int})
    }}
"""

    write_handling_unsigned(s, is_exactly=False)

    if is_signed:
        f.write(
            f"""
    // {i.name}.min
    // We have to parse because the value may not be representable by int literal.
    if let d: {d.name} = self.parseExact("{min.decimal_significand}E{min.decimal_exponent}", #file, #line) {{
      XCTAssertEqual({i.name}(-d), -{min.int})
    }}
"""
        )

    f.write("  }\n")

    # =============
    # === Exact ===
    # =============

    s = f"""
  func test_{d.name}_to_{i.name}_exactly() {{
    var d = {d.name}.nan
    XCTAssertNil({i.name}(exactly:  d))
    XCTAssertNil({i.name}(exactly: -d))

    d = {d.name}.signalingNaN
    XCTAssertNil({i.name}(exactly:  d))
    XCTAssertNil({i.name}(exactly: -d))

    d = {d.name}.infinity
    XCTAssertNil({i.name}(exactly:  d))
    XCTAssertNil({i.name}(exactly: -d))

    d = {d.name}.zero
    XCTAssertEqual({i.name}(exactly:  d), 0)
    XCTAssertEqual({i.name}(exactly: -d), 0)

    // Exponent = 0
    d = 5
    XCTAssertEqual({i.name}(exactly:  d),  5)
    XCTAssertEqual({i.name}(exactly: -d), -5)

    // Positive exponent
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1719, signedExponent: 2)
    XCTAssertEqual({i.name}(exactly:  d),  171900)
    XCTAssertEqual({i.name}(exactly: -d), -171900)

    // Negative exponent, decimal digits = 0
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1100, signedExponent: -2)
    XCTAssertEqual({i.name}(exactly:  d),  11)
    XCTAssertEqual({i.name}(exactly: -d), -11)

    // Negative exponent, decimal digits != 0
    d = {d.name}._packWithoutChecks(sign: .plus, significand: 1317, signedExponent: -2)
    XCTAssertNil({i.name}(exactly:  d))
    XCTAssertNil({i.name}(exactly: -d))

    // {i.name}.max
    if let d: {d.name} = self.parseExact("{max.decimal_significand}E{max.decimal_exponent}", #file, #line) {{
      XCTAssertEqual({i.name}(exactly:  d),  {max.int})
      XCTAssertEqual({i.name}(exactly: -d), -{max.int})
    }}
"""

    write_handling_unsigned(s, is_exactly=True)

    if is_signed:
        f.write(
            f"""
    // {i.name}.min
    // We have to parse because '-{i.name}.min' may not be representable.
    if let d: {d.name} = self.parseExact("{min.decimal_significand}E{min.decimal_exponent}", #file, #line) {{
      XCTAssertEqual({i.name}(exactly: -d), -{min.int})
    }}
"""
        )

    f.write("  }\n")
