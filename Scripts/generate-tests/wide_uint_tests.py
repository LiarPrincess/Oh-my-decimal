import io
import os
import random
from dataclasses import dataclass
from common import GENERATED_FILE_HEADER

# 2^64−1 - upper bound is included in 'random'
_WORD_UPPER_BOUND = 18446744073709551615
# Divide by this to obtain 'words'
_WORD_MUL = _WORD_UPPER_BOUND + 1
# Max number characters on Word hexadecimal representation.
_WORD_HEX_CHAR_COUNT = len(hex(_WORD_UPPER_BOUND))


@dataclass
class _UIntType:
    name: str
    word_count: int
    max: int

    def __init__(self, name: str, word_count: int):
        self.name = name
        self.word_count = word_count

        self.max = 1
        for _ in range(word_count):
            self.max *= _WORD_MUL


_INT_TYPES = [
    _UIntType(name="UInt128", word_count=2),
    _UIntType(name="UInt256", word_count=4),
]


def generate(dir: str):
    # Fix seed, so that we generate the same tests every time
    random.seed(123456)

    for t in _INT_TYPES:
        name = "Generated" + t.name + "Tests"
        path = os.path.join(dir, name + ".swift")

        with open(path, "w") as f:
            f.write(GENERATED_FILE_HEADER)
            f.write(
                f"""
import XCTest
@testable import Decimal

class {name}: XCTestCase {{

  typealias Word = {t.name}.Word
"""
            )

            _write_add(f, t)
            _write_sub(f, t)
            _write_mul(f, t)
            _write_div(f, t)
            _write_create_function(f, t)
            f.write("}\n")


def _write_add(f: io.TextIOWrapper, t: _UIntType):
    _write_add_sub(
        f,
        t,
        "Add",
        lambda a, b: a + b,
        "addingReportingOverflow",
        "+",
    )


def _write_sub(f: io.TextIOWrapper, t: _UIntType):
    _write_add_sub(
        f,
        t,
        "Sub",
        lambda a, b: a - b,
        "subtractingReportingOverflow",
        "-",
    )


def _write_add_sub(
    f: io.TextIOWrapper,
    t: _UIntType,
    name: str,
    python_fn,
    swift_reporting_overflow: str,
    swift_op: str,
):
    name_lower = name.lower()
    _write_mark(f, name)

    for lhs_word_count, rhs_word_count in _get_binary_word_counts(t):
        f.write("\n")
        f.write(f"  func test_{name_lower}_{lhs_word_count}_by_{rhs_word_count}() {{\n")

        for _ in range(50):
            lhs = _Number.random(lhs_word_count)
            rhs = _Number.random(rhs_word_count)
            expected = python_fn(lhs.n, rhs.n)
            has_overflow = expected < 0 or expected > t.max
            expected = _Number.from_int(expected % t.max)

            f.write(f"    self.{name_lower}(")
            f.write(lhs.word_array)
            f.write(f", ")
            f.write(rhs.word_array)
            f.write(f", ")
            f.write("true" if has_overflow else "false")
            f.write(f", ")
            f.write(expected.word_array)
            f.write(f")\n")

        f.write("  }\n")

    f.write(
        f"""
  private func {name_lower}(
    _ lhsWords: [Word],
    _ rhsWords: [Word],
    _ expectedOverflow: Bool,
    _ expectedWords: [Word],
    file: StaticString = #file,
    line: UInt = #line
  ) {{
    let lhs = self.create(lhsWords)
    let rhs = self.create(rhsWords)
    let expected = self.create(expectedWords)

    let (result, overflow) = lhs.{swift_reporting_overflow}(rhs)
    XCTAssertEqual(result, expected, "reportingOverflow.result", file: file, line: line)
    XCTAssertEqual(overflow, expectedOverflow, "reportingOverflow.overflow", file: file, line: line)

    if !overflow {{
      let result2 = lhs {swift_op} rhs
      XCTAssertEqual(result2, expected, "{swift_op}", file: file, line: line)
    }}
  }}
"""
    )


def _write_mul(f: io.TextIOWrapper, t: _UIntType):
    name = "Mul"
    name_lower = name.lower()
    _write_mark(f, name)

    for lhs_word_count, rhs_word_count in _get_binary_word_counts(t):
        f.write("\n")
        f.write(f"  func test_{name_lower}_{lhs_word_count}_by_{rhs_word_count}() {{\n")

        for _ in range(100):
            lhs = _Number.random(lhs_word_count)
            rhs = _Number.random(rhs_word_count)
            expected = lhs.n * rhs.n
            expected_high = _Number.from_int(expected // t.max)
            expected_low = _Number.from_int(expected % t.max)

            f.write(f"    self.{name_lower}(")
            f.write(lhs.word_array)
            f.write(f", ")
            f.write(rhs.word_array)
            f.write(f", ")
            f.write(expected_high.word_array)
            f.write(f", ")
            f.write(expected_low.word_array)
            f.write(f")\n")

        f.write("  }\n")

    half_type = f"UInt{t.word_count // 2 * 64}"
    f.write(
        f"""
  private func {name_lower}(
    _ lhsWords: [Word],
    _ rhsWords: [Word],
    _ expectedHighWords: [Word],
    _ expectedLowWords: [Word],
    file: StaticString = #file,
    line: UInt = #line
  ) {{
    let lhs = self.create(lhsWords)
    let rhs = self.create(rhsWords)
    let expectedHigh = self.create(expectedHighWords)
    let expectedLow = self.create(expectedLowWords)

    let (high, low) = lhs.multipliedFullWidth(by: rhs)
    XCTAssertEqual(high, expectedHigh, "fullWidth.high", file: file, line: line)
    XCTAssertEqual(low, expectedLow, "fullWidth.low", file: file, line: line)

    let expectedOverflow = expectedHigh != 0
    let (low1, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    XCTAssertEqual(low1, expectedLow, "reportingOverflow.low", file: file, line: line)
    XCTAssertEqual(overflow, expectedOverflow, "reportingOverflow.overflow", file: file, line: line)

    if !expectedOverflow {{
      let low2 = lhs * rhs
      XCTAssertEqual(low2, expectedLow, "*", file: file, line: line)
    }}

    if rhsWords.count == {t.word_count // 2} {{
      let rhsSmall = rhs.low

      let (highSmall, lowSmall) = lhs.multipliedFullWidth(by: rhsSmall)
      XCTAssertEqual(highSmall, expectedHigh.low, "fullWidth({half_type}).high", file: file, line: line)
      XCTAssertEqual(lowSmall, expectedLow, "fullWidth({half_type}).low", file: file, line: line)

      let (lowOvSmall, overflowSmall) = lhs.multipliedReportingOverflow(by: rhsSmall)
      XCTAssertEqual(lowOvSmall, expectedLow, "reportingOverflow({half_type}).low", file: file, line: line)
      XCTAssertEqual(overflowSmall, expectedOverflow, "reportingOverflow({half_type}).overflow", file: file, line: line)

      if !expectedOverflow {{
        let lowStarSmall = lhs * rhsSmall
        XCTAssertEqual(lowStarSmall, expectedLow, "{half_type}.*", file: file, line: line)
      }}
    }}
  }}
"""
    )


def _write_div(f: io.TextIOWrapper, t: _UIntType):
    name = "Div"
    name_lower = name.lower()
    _write_mark(f, name)

    for lhs_word_count, rhs_word_count in _get_binary_word_counts(t):
        f.write("\n")
        f.write(f"  func test_{name_lower}_{lhs_word_count}_by_{rhs_word_count}() {{\n")

        for _ in range(100):
            lhs = _Number.random(lhs_word_count)
            rhs = _Number.random(rhs_word_count)
            expected_q = _Number.from_int(lhs.n // rhs.n)
            expected_r = _Number.from_int(lhs.n % rhs.n)

            f.write(f"    self.{name_lower}(")
            f.write(lhs.word_array)
            f.write(f", ")
            f.write(rhs.word_array)
            f.write(f", ")
            f.write(expected_q.word_array)
            f.write(f", ")
            f.write(expected_r.word_array)
            f.write(f")\n")

        f.write("  }\n")

    f.write(
        f"""
  private func {name_lower}(
    _ lhsWords: [Word],
    _ rhsWords: [Word],
    _ quotientWords: [Word],
    _ remainderWords: [Word],
    file: StaticString = #file,
    line: UInt = #line
  ) {{
    let lhs = self.create(lhsWords)
    let rhs = self.create(rhsWords)
    let quotient = self.create(quotientWords)
    let remainder = self.create(remainderWords)

    let qr = lhs.quotientAndRemainder(dividingBy: rhs)
    XCTAssertEqual(qr.quotient, quotient, "quotientAndRemainder.quotient", file: file, line: line)
    XCTAssertEqual(qr.remainder, remainder, "quotientAndRemainder.remainder", file: file, line: line)

    let q = lhs / rhs
    XCTAssertEqual(q, quotient, "/", file: file, line: line)

    let r = lhs % rhs
    XCTAssertEqual(r, remainder, "%", file: file, line: line)
  }}
"""
    )


@dataclass
class _Number:
    n: int
    words: list[int]

    @property
    def word_array(self) -> str:
        result = "["

        for index, w in enumerate(self.words):
            if index != 0:
                result += ", "

            s = hex(w)
            result += s.rjust(_WORD_HEX_CHAR_COUNT)

        result += "]"
        return result

    @staticmethod
    def from_int(n: int) -> "_Number":
        words: list[int] = []

        if n == 0:
            words.append(0)
        else:
            nn = n
            while nn != 0:
                words.append(nn % _WORD_MUL)
                nn = nn // _WORD_MUL

            words.reverse()

        return _Number(n, words)

    @staticmethod
    def random(word_count: int) -> "_Number":
        n = 0
        words: list[int] = []

        for _ in range(word_count):
            word = random.randint(0, _WORD_UPPER_BOUND)
            n = n * _WORD_MUL + word
            words.append(word)

        return _Number(n, words)


def _get_binary_word_counts(t: _UIntType):
    for lhs_word_count in range(1, t.word_count + 1):
        for rhs_word_count in range(1, t.word_count + 1):
            yield (lhs_word_count, rhs_word_count)


def _write_create_function(f: io.TextIOWrapper, t: _UIntType):
    _write_mark(f, "Create")
    f.write("\n")
    f.write(f"  private func create(_ words: [Word]) -> {t.name} {{\n")
    f.write(f"    switch words.count {{\n")

    for n in range(t.word_count):
        n += 1
        f.write(f"    case {n}: return {t.name}(")
        is_first = True

        for _ in range(t.word_count - n):
            if not is_first:
                f.write(", ")

            f.write("0")
            is_first = False

        for i in range(n):
            if not is_first:
                f.write(", ")

            f.write(f"words[{i}]")
            is_first = False

        f.write(f")\n")

    f.write(f'    default: fatalError("Unknown {t.name} input: \\(words)")\n')
    f.write("    }\n")
    f.write("  }\n")


def _write_mark(f: io.TextIOWrapper, s: str):
    f.write("\n")
    f.write("  // MARK: - ")
    f.write(s)
    f.write("\n")
