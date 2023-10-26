import io
import os
import re
from dataclasses import dataclass
from common import (
    GENERATED_FILE_HEADER,
    DECIMAL_TYPES,
    DecimalType,
    Decimal32,
    Decimal64,
    Decimal128,
    IntType,
    Int32,
    Int64,
    UInt32,
    UInt64,
    IntToDecimal,
    digit_count,
)

_INT_TYPES: list[IntType] = [Int32, Int64, UInt32, UInt64]


def generate(dir: str):
    class_name = "GeneratedInitFromIntTests"
    file_path = os.path.join(dir, class_name + ".swift")

    with open(file_path, "w") as f:
        f.write(GENERATED_FILE_HEADER)
        f.write(
            f"""
import XCTest
@testable import Decimal

class {class_name}: XCTestCase, DecimalTests {{

  func test_double() {{
    var i = Int64.zero
    var expected = Float.zero
    XCTAssertEqual(Float(i), expected)
    XCTAssertEqual(Float(exactly: i), expected)

    i = 5
    expected = Float("5")!
    XCTAssertEqual(Float( i),  expected)
    XCTAssertEqual(Float(-i), -expected)
    XCTAssertEqual(Float(exactly:  i),  expected)
    XCTAssertEqual(Float(exactly: -i), -expected)

    i = 42
    expected = Float("42")!
    XCTAssertEqual(Float( i),  expected)
    XCTAssertEqual(Float(-i), -expected)
    XCTAssertEqual(Float(exactly:  i),  expected)
    XCTAssertEqual(Float(exactly: -i), -expected)

    i = .max
    // Float( i) - no easy algorithm to find the exact result
    XCTAssertNil(Float(exactly:  i))
    XCTAssertNil(Float(exactly: -i))

    // i = .min
    // We can't test '-i', as it overflows.
    // Float( i) - no easy algorithm to find the exact result
    XCTAssertNil(Float(exactly: i))
  }}
"""
        )

        for d in DECIMAL_TYPES:
            for i in _INT_TYPES:
                _write_decimal_tests(f, d, i)

        f.write(
            """
  // MARK: - Helpers

  private func run<D: DecimalFloatingPoint & DecimalMixin, I: FixedWidthInteger>(
    _ i: I,
    rounding: DecimalFloatingPointRoundingRule,
    expected: D,
    _ expectedStatus: DecimalStatus,
    _ message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    var status = DecimalStatus()
    let result = D(i, rounding: rounding, status: &status)

    self.assertEqual(result, expected, message, file, line)
    self.assertStatus(status, expectedStatus, message, file, line)
  }

  private func runExact<D: DecimalFloatingPoint & DecimalMixin, I: FixedWidthInteger>(
    _ i: I,
    expected: D?,
    _ message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    let result = D(exactly: i)

    switch (result, expected) {
    case let (.some(l), .some(r)):
      self.assertEqual(l, r, message, file, line)

    case let (.some(l), .none):
      XCTFail("Got: \\(l) " + message, file: file, line: line)

    case (.none, .some):
      XCTFail("Got nil. " + message, file: file, line: line)

    case (.none, .none):
      // Both 'nil' -> equal
      break
    }
  }

  private func runExactNil<D: DecimalFloatingPoint & DecimalMixin, I: FixedWidthInteger>(
    _ i: I,
    _ d: D.Type,
    _ message: String = "",
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) {
    let result = D(exactly: i)
    XCTAssertNil(result, message, file: file, line: line)
  }
"""
        )

        f.write("}\n")


def _write_decimal_tests(f: io.TextIOWrapper, d: DecimalType, i: IntType):
    min = IntToDecimal(d, i.min)
    max = IntToDecimal(d, i.max)
    max_digit_count = digit_count(i.max)
    can_represent_max_exactly = d.precision >= max_digit_count

    f.write("\n")
    f.write(f"  // MARK: - {d.name} from {i.name}\n")

    # Handle negative numbers for unsigned types.
    is_signed = i.is_signed
    is_unsigned = i.is_unsigned

    def write_handling_unsigned(s: str, *, is_exactly: bool):
        for line in s.splitlines():
            has_negative = False

            for marker in (
                "self.run(-i,",
                "self.runExact(-i",
                "self.runExactNil(-i,",
                "_packWithoutChecks(sign: .minus",  # Otherwise unused variable
            ):
                has_negative = has_negative or marker in line

            is_unsigned_negative = is_unsigned and has_negative

            if not is_unsigned_negative:
                f.write(line)
                f.write("\n")

    # ============
    # === Cast ===
    # ============

    max_cast_status = "DecimalStatus()" if can_represent_max_exactly else ".isInexact"

    s = f"""
  func test_{d.name}_from_{i.name}() {{
    var i = {i.name}.zero
    var expected = {d.name}.zero

    for r in Self.roundingRules {{
      i = .zero
      expected = .zero
      self.run(i, rounding: r, expected: expected, DecimalStatus(), r.description)

      i = 5
      expected = {d.name}._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)

      i = 42
      expected = {d.name}._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }}

    // We have to parse because the value may not be representable by int literal.
    if let e: {d.name} = self.parseExact("{max.decimal_significand}E{max.decimal_exponent}", #file, #line) {{
      i = .max
      self.run( i, rounding: .towardZero, expected:  e, {max_cast_status})
      self.run(-i, rounding: .towardZero, expected: -e, {max_cast_status})
    }}
"""

    write_handling_unsigned(s, is_exactly=False)

    if is_signed:
        f.write(
            f"""
    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: {d.name} = self.parseExact("{min.decimal_significand}E{min.decimal_exponent}", #file, #line) {{
      i = .min
      self.run(i, rounding: .towardZero, expected: -e, {max_cast_status})
    }}
"""
        )

    f.write("  }\n")

    if not can_represent_max_exactly:
        if d == Decimal32:
            noRounding = "1234567"
            rounded = "1234568"
        elif d == Decimal64:
            noRounding = "1234567890123455"
            rounded = "1234567890123456"
        else:
            assert False, d.name

        s = f"""
  func test_{d.name}_from_{i.name}_rounding() {{
    var i = {i.name}.zero
    var expected = {d.name}.zero

    for r in Self.roundingRules {{
      // More digits than precision, but all = 0
      i = {noRounding}_00
      expected = {d.name}._packWithoutChecks(sign: .plus, significand: {noRounding}, signedExponent: 2)
      self.run( i, rounding: r, expected:  expected, DecimalStatus(), r.description)
      self.run(-i, rounding: r, expected: -expected, DecimalStatus(), r.description)
    }}

    // More digits than precision, with rounding
    let  noRounding = {d.name}._packWithoutChecks(sign: .plus,  significand: {noRounding}, signedExponent: 2)
    let  rounded    = {d.name}._packWithoutChecks(sign: .plus,  significand: {rounded}, signedExponent: 2)
    let _noRounding = {d.name}._packWithoutChecks(sign: .minus, significand: {noRounding}, signedExponent: 2)
    let _rounded    = {d.name}._packWithoutChecks(sign: .minus, significand: {rounded}, signedExponent: 2)

    // Below half
    i = {noRounding}_42
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  noRounding, .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _noRounding, .isInexact)

    // Half - odd
    i = {noRounding}_50
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
    // Half - even, we will reuse 'rounded' as it is even
    i = {rounded}_50
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)

    // Above half
    i = {noRounding}_51
    self.run( i, rounding: .up,                      expected:  rounded,    .isInexact)
    self.run( i, rounding: .down,                    expected:  noRounding, .isInexact)
    self.run( i, rounding: .towardZero,              expected:  noRounding, .isInexact)
    self.run( i, rounding: .toNearestOrEven,         expected:  rounded,    .isInexact)
    self.run( i, rounding: .toNearestOrAwayFromZero, expected:  rounded,    .isInexact)
    self.run(-i, rounding: .up,                      expected: _noRounding, .isInexact)
    self.run(-i, rounding: .down,                    expected: _rounded,    .isInexact)
    self.run(-i, rounding: .towardZero,              expected: _noRounding, .isInexact)
    self.run(-i, rounding: .toNearestOrEven,         expected: _rounded,    .isInexact)
    self.run(-i, rounding: .toNearestOrAwayFromZero, expected: _rounded,    .isInexact)
  }}
"""
        write_handling_unsigned(s, is_exactly=False)

    # =============
    # === Exact ===
    # =============

    max_cast_status = "DecimalStatus()" if can_represent_max_exactly else ".isInexact"

    s = f"""
  func test_{d.name}_from_{i.name}_exactly() {{
    var i = {i.name}.zero
    var expected = {d.name}.zero
    self.runExact(i, expected: expected)

    i = 5
    expected = {d.name}._packWithoutChecks(sign: .plus, significand: 5, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = 42
    expected = {d.name}._packWithoutChecks(sign: .plus, significand: 42, signedExponent: 0)
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)
"""

    if can_represent_max_exactly:
        s += f"""
    // We have to parse because the value may not be representable by int literal.
    if let e: {d.name} = self.parseExact("{max.decimal_significand}E{max.decimal_exponent}", #file, #line) {{
      i = .max
      self.runExact( i, expected:  e)
      self.runExact(-i, expected: -e)
    }}
"""
        if is_signed:
            s += f"""
    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    if let e: {d.name} = self.parseExact("{min.decimal_significand}E{min.decimal_exponent}", #file, #line) {{
      i = .min
      self.runExact(i, expected: -e)
    }}
"""

    else:
        base = "1" * d.precision
        trailing_zero_count = max_digit_count - d.precision
        assert trailing_zero_count > 0
        trailing_zero = "0" * trailing_zero_count

        s += f"""
    // If we have a lot of trailing '0' then we are always representable.
    i = {base}{trailing_zero}
    expected = {d.name}._packWithoutChecks(sign: .plus, significand: {base}, signedExponent: {trailing_zero_count})
    self.runExact( i, expected:  expected)
    self.runExact(-i, expected: -expected)

    i = .max
    expected = {d.name}._packWithoutChecks(sign: .plus, significand: {max.decimal_significand}, signedExponent: {max.decimal_exponent})
    self.runExactNil( i, {d.name}.self)
    self.runExactNil(-i, {d.name}.self)
"""

        if is_signed:
            s += f"""
    // For min we can't test '-i', as it overflows.
    // We have to parse because the value may not be representable by int literal.
    i = .min
    self.runExactNil( i, {d.name}.self)
"""

    write_handling_unsigned(s, is_exactly=True)

    f.write("  }\n")
