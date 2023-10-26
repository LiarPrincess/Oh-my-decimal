import os
from io import TextIOWrapper
from dataclasses import dataclass
from collections.abc import Iterable
from common import GENERATED_HEADER


@dataclass
class _UIntType:
    "Unsigned Int."
    name: str
    word_count: int
    public: str

    @property
    def width(self):
        return 64 * self.word_count

    @property
    def div_helper_name(self):
        return f"UInt{self.div_helper_word_count * 64}"

    @property
    def div_helper_word_count(self):
        "Unsigned Int that is used during division."
        return self.word_count // 2 * 3


_U128 = _UIntType(name="UInt128", word_count=2, public="public")
_U256 = _UIntType(name="UInt256", word_count=4, public="internal")

_TYPES: list[_UIntType] = [_U128, _U256]


def generate(output_dir: str):
    for t in _TYPES:
        path = os.path.join(output_dir, f"{t.name}.swift")

        with open(path, "w") as ff:
            f = _File(ff)
            f.write(GENERATED_HEADER)
            f.write("// swiftlint:disable all\n")

            if t == _U128:
                f.write(
                    f"""\
// 'Decimal128.BitPattern = UInt128' is 'public'.
// But we do not want to export `UInt128` as a global name.
// Instead we will define 'UInt128' inside 'Decimal128' as 'Decimal128._UInt128'.

extension Decimal128 {{
  /// Internal storage.
  /// DO NOT use as a general purpose `UInt128`!
  /// This is only for `Decimal128`.
  public struct _UInt128: Sendable {{
    // Words from high bits (w0) to low bits (w1).
    // It is slower than `LLVM.UInt128`, but that would require `Builtins`.
    internal var w0: Word
    internal var w1: Word
  }}
}}

// Inside the module we want to use the normal name.
internal typealias UInt128 = Decimal128._UInt128

extension Decimal128._UInt128: Codable, FixedWidthInteger, UnsignedInteger, CustomStringConvertible {{\
"""
                )
            elif t == _U256:
                f.write(
                    f"""\
/// You know what this is, don't make me say it…
{t.public} struct {t.name}: Codable, FixedWidthInteger, UnsignedInteger, CustomStringConvertible {{\
"""
                )
            else:
                assert False, t.name

            f.write("\n")
            f.write("  internal typealias Word = UInt64")
            f.write_mark("Static properties")
            f.write("\n")
            f.write(f"  {t.public} static let bitWidth = {t.width}")

            f.write_mark("Properties")
            _write_properties(f, t)

            f.write_mark("Init")
            _write_inits(f, t)
            f.write_mark("Init - Int")
            _write_inits_int(f, t)
            f.write_mark("Init - Float")
            _write_inits_binary_floating_point(f, t)

            f.write_mark("Add")
            _write_add(f, t, t)
            f.write_mark("Sub")
            _write_sub(f, t, t)
            f.write_mark("Mul")
            _write_mul_for_division(f, t)
            _write_mul(f, t, t)
            f.write_mark("Div")
            _write_div(f, t)

            f.write_mark("Bit operations")
            _write_bit_operations(f, t)

            f.write_mark("Shifts")
            _write_shifts(f, t)

            f.write_mark("Equal, compare")
            _write_equal(f, t)
            _write_compare(f, t)

            f.write_mark("Words")
            _write_words(f, t)
            f.write("}")

            f.write_mark(f"Div helper - {t.div_helper_name}", indent=0)
            _write_div_helper_type(f, t)


class _File:
    def __init__(self, f: TextIOWrapper) -> None:
        self.f = f

    def write(self, s: str, *args: object, new_line: bool = True):
        if args:
            ss = s.format(*args)
            self.f.write(ss)
        else:
            self.f.write(s)

        if new_line and s != "\n":
            self.f.write("\n")

    def write_mark(self, s: str, indent: int = 2):
        self.f.write("\n")
        self.f.write(" " * indent)
        self.f.write("// MARK: - ")
        self.f.write(s)
        self.f.write("\n")

    def lines(self, pattern: str, *args: object):
        "Write each object in a new line."

        iterables = []
        static_args = []

        for a in args:
            if isinstance(a, Iterable) and not isinstance(a, str):
                iterables.append(a)
            else:
                static_args.append(a)

        for os in zip(*iterables):
            format_args = [*os, *static_args]
            s = pattern.format(*format_args)
            self.f.write(s)
            self.f.write("\n")

    def join(self, pattern: str, objects: Iterable, *, separator: str = ", "):
        "Write objects separated by 'separator'."

        for i, o in enumerate(objects):
            self.f.write("" if i == 0 else separator)
            self.f.write(pattern.format(o))


# ==================
# === Properties ===
# ==================


def _write_properties(f: _File, t: _UIntType):
    f.write("\n")

    # =============
    # === words ===
    # =============

    # 'UInt128' properties are stored in 'Decimal128._UInt128'.
    if t != _U128:
        f.write(f"  // Words from high bits (w0) to low bits (w{t.word_count-1}).")
        f.lines("  internal var w{0}: Word", range(t.word_count))
        f.write("\n")

    f.write(f"  {t.public} var words: Words {{ Words(self) }}")

    # ==============
    # === isZero ===
    # ==============

    f.write("\n")
    f.write("  internal var isZero: Bool {")
    f.write("    return ", new_line=False)
    f.join("self.w{0} == 0", range(t.word_count), separator=" && ")
    f.write("\n")
    f.write("  }")

    # ================
    # === bitCount ===
    # ================

    f.write("\n")
    f.write(f"  {t.public} var leadingZeroBitCount: Int {{")
    f.lines(
        "    if self.w{0} != 0 {{ return {0} * Word.bitWidth + self.w{0}.leadingZeroBitCount }}",
        range(t.word_count - 1),
    )
    f.write(
        "    return {0} * Word.bitWidth + self.w{0}.leadingZeroBitCount",
        t.word_count - 1,
    )
    f.write("  }")

    f.write("\n")
    f.write(f"  {t.public} var trailingZeroBitCount: Int {{")
    f.lines(
        "    if self.w{0} != 0 {{ return {1} * Word.bitWidth + self.w{0}.trailingZeroBitCount }}",
        reversed(range(1, t.word_count)),
        range(0, t.word_count),
    )
    f.write(
        f"    return {t.word_count - 1} * Word.bitWidth + self.w0.trailingZeroBitCount"
    )
    f.write("  }")

    f.write("\n")
    f.write(f"  {t.public} var nonzeroBitCount: Int {{")
    f.write("    return ", new_line=False)
    f.join("self.w{0}.nonzeroBitCount", range(t.word_count), separator=" + ")
    f.write("\n")
    f.write("  }")

    # ===================
    # === byteSwapped ===
    # ===================

    f.write("\n")
    f.write(f"  {t.public} var byteSwapped: Self {{")
    f.lines("    let w{0} = self.w{0}.byteSwapped", range(t.word_count))
    f.write("    return Self(", new_line=False)
    f.join("w{0}", range(t.word_count))
    f.write(")")
    f.write("  }")

    # ===================
    # === description ===
    # ===================

    f.write(
        f"""
  {t.public} var description: String {{
    let _0: UInt8 = 48
    var n = self
    var result = ""

    while !n.isZero {{
      let (q, r) = n.quotientAndRemainder(dividingBy: 10 as Word)
      n = q

      let ascii = _0 + UInt8(r)
      let scalar = UnicodeScalar(ascii)
      let char = Character(scalar)
      result.append(char)
    }}

    return result.isEmpty ? "0" : String(result.reversed())
  }}\
"""
    )


# ============
# === Init ===
# ============


def _write_inits(f: _File, t: _UIntType):
    f.write("\n")
    f.write(f"  {t.public} init() {{")
    f.lines("    self.w{0} = 0", range(t.word_count))
    f.write("  }")

    # =============
    # === Words ===
    # =============

    f.write("\n")
    f.write("  internal init(", new_line=False)
    f.join("_ w{0}: Word", range(t.word_count))
    f.write(") {")
    f.lines("    self.w{0} = w{0}", range(t.word_count))
    f.write("  }")


def _write_inits_int(f: _File, t: _UIntType):
    # =====================
    # === BinaryInteger ===
    # =====================

    f.write(
        f"""
  {t.public} init<T: BinaryInteger>(_ source: T) {{
    guard let result = Self(exactly: source) else {{
      preconditionFailure("Value is outside the representable range")
    }}

    self = result
  }}

  {t.public} init?<T: BinaryInteger>(exactly source: T) {{
    if source < (0 as T) {{
      return nil
    }}

    if let low = Word(exactly: source.magnitude) {{\
"""
    )

    f.lines("      self.w{0} = 0", range(t.word_count - 1))
    f.write(f"      self.w{t.word_count - 1} = low")
    f.write("    } else {")
    f.write("      var s = source")
    f.write("      let mask = T(Word.max)")

    for i in reversed(range(t.word_count)):
        f.write("")
        f.write(f"      self.w{i} = Word(s & mask)")
        f.write(f"      s >>= Word.bitWidth")

    f.write("")
    f.write("      if s != (0 as T) {")
    f.write("        return nil")
    f.write("      }")
    f.write("    }")
    f.write("  }")

    # ======================
    # === integerLiteral ===
    # ======================

    f.write(
        f"""
  {t.public} init(integerLiteral value: IntegerLiteralType) {{
    self = Self(value)
  }}\
"""
    )

    # ======================
    # === truncatingBits ===
    # ======================

    f.write("\n")
    f.write(f"  {t.public} init(_truncatingBits bits: UInt) {{")
    f.lines(
        "    self.w{0} = Word(_truncatingBits: bits >> ({1} * Word.bitWidth))",
        range(t.word_count),
        reversed(range(t.word_count)),
    )
    f.write("  }")


def _write_inits_binary_floating_point(f: _File, t: _UIntType):
    f.write(
        f"""
  {t.public} init<T: BinaryFloatingPoint>(_ source: T) {{
    preconditionFailure("{t.name}(BinaryFloatingPoint) not implemented.")
  }}

  {t.public} init?<T: BinaryFloatingPoint>(exactly source: T) {{
    preconditionFailure("{t.name}(exactly: BinaryFloatingPoint) not implemented.")
  }}\
"""
    )


# ================
# === Add, sub ===
# ================


def _write_add(f: _File, t: _UIntType, rhs: _UIntType):
    _write_add_sub(f, t, rhs, "add")


def _write_sub(f: _File, t: _UIntType, rhs: _UIntType):
    _write_add_sub(f, t, rhs, "sub")


def _write_add_sub(f: _File, t: _UIntType, rhs: _UIntType, operation: str):
    if operation == "add":
        op = "+"
        fn = "addingReportingOverflow"
        carry = "carry"
    elif operation == "sub":
        op = "-"
        fn = "subtractingReportingOverflow"
        carry = "borrow"
    else:
        assert False, operation

    rhs_name = "Self" if t.word_count == rhs.word_count else rhs.name

    # =================
    # === Operators ===
    # =================

    f.write(
        f"""
  {t.public} static func {op} (lhs: Self, rhs: {rhs_name}) -> Self {{
    let (result, overflow) = lhs.{fn}(rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }}

  {t.public} static func {op}= (lhs: inout Self, rhs: {rhs_name}) {{
    let (result, overflow) = lhs.{fn}(rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }}\
"""
    )

    # =========================
    # === ReportingOverflow ===
    # =========================

    f.write("\n")
    f.write(
        f"  {t.public} func {fn}(_ rhs: {rhs_name}) -> (partialValue: Self, overflow: Bool) {{"
    )

    i = t.word_count - 1
    rhs_last_word = "rhs" if rhs.word_count == 1 else f"rhs.w{rhs.word_count-1}"
    f.write(f"    let w{i} = self.w{i}.{fn}({rhs_last_word})")
    f.write(f"    let {carry}{i}: Word = w{i}.overflow ? 1 : 0")

    word_count_diff = t.word_count - rhs.word_count

    for word_index in reversed(range(rhs.word_count - 1)):
        i = word_count_diff + word_index
        f.write(
            f"""
    let partial{i} = self.w{i}.{fn}(rhs.w{i - word_count_diff})
    let w{i} = partial{i}.partialValue.{fn}({carry}{i+1})
    let {carry}{i}: Word = (partial{i}.overflow ? 1 : 0) + (w{i}.overflow ? 1 : 0)\
"""
        )

    for i in reversed(range(word_count_diff)):
        f.write(
            f"""
    let w{i} = self.w{i}.{fn}({carry}{i+1})
    let {carry}{i}: Word = w{i}.overflow ? 1 : 0\
"""
        )

    f.write("\n")
    f.write(f"    let result = Self(", new_line=False)
    f.join("w{0}.partialValue", range(t.word_count))
    f.write(")")
    f.write(f"    let overflow = {carry}0 != 0")
    f.write("    return (result, overflow)")
    f.write("  }")


# ===========
# === Mul ===
# ===========


def _write_mul_for_division(f: _File, t: _UIntType):
    word_count = t.word_count // 2
    div_rhs = _UIntType(
        name=f"UInt{word_count * 64}",
        word_count=word_count,
        public="",
    )

    _write_mul(f, t, div_rhs, "internal")


def _write_mul(f: _File, t: _UIntType, rhs: _UIntType, public: str = ""):
    public = public or t.public
    rhs_name = "Self" if t.word_count == rhs.word_count else rhs.name

    # =================
    # === Operators ===
    # =================

    f.write(
        f"""
  {public} static func * (lhs: Self, rhs: {rhs_name}) -> Self {{
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    return result
  }}

  {public} static func *= (_ lhs: inout Self, _ rhs: {rhs_name}) {{
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!overflow, "arithmetic overflow")
    lhs = result
  }}\
"""
    )

    # ===================================
    # === multipliedReportingOverflow ===
    # ===================================

    word_count_diff = t.word_count - rhs.word_count
    columns = _create_multiplication_columns(t, rhs)

    # Last 't.word_count' columns are for result,
    # everything else is for overflow checks.
    mul_columns = columns[-t.word_count :]
    overflow_columns = columns[: -t.word_count]

    f.write("\n")
    f.write(
        f"  {public} func multipliedReportingOverflow(by rhs: {rhs_name}) -> (partialValue: Self, overflow: Bool) {{"
    )

    _write_multiplications(f, mul_columns, rhs)

    for column in reversed(mul_columns):
        _write_multiplication_column_sum(f, columns, column)

    f.write("\n")

    f.write(f"    let overflow: Bool = carry{t.word_count} != 0")

    lowest_overflow_column = overflow_columns[-1]
    f.write(f"      // Check 'high' in column {lowest_overflow_column.index}")
    for coord in lowest_overflow_column.high:
        f.write(f"      || (mul{coord.lhs}{coord.rhs}.high != 0)")

    f.write(f"      // Check not preformed multiplications")
    written_coordinate_id: set[int] = set()

    for column in reversed(overflow_columns):
        for coord in column.low:
            coord_id = id(coord)
            if coord_id in written_coordinate_id:
                continue

            written_coordinate_id.add(coord_id)

            l = f"self.w{coord.lhs}"
            r = "rhs" if rhs.word_count == 1 else f"rhs.w{coord.rhs_in_initial_width}"
            f.write(f"      || ({l} != 0 && {r} != 0)")

    f.write("\n")

    f.write("    let result = Self(", new_line=False)
    f.join("w{0}", range(t.word_count, 2 * t.word_count))
    f.write(")")

    f.write("    return (result, overflow)")
    f.write("  }")

    # ===========================
    # === multipliedFullWidth ===
    # ===========================

    f.write("\n")
    f.write(
        f"  {public} func multipliedFullWidth(by rhs: {rhs_name}) -> (high: {rhs_name}, low: Self) {{"
    )

    _write_multiplications(f, columns, rhs)

    for column in reversed(columns):
        _write_multiplication_column_sum(f, columns, column)

    f.write("\n")
    f.write(f"    assert(carry{word_count_diff} == 0)")
    f.write(f"    let high = {rhs_name}(", new_line=False)
    f.join("w{0}", range(word_count_diff, t.word_count))
    f.write(")")

    f.write("    let low = Self(", new_line=False)
    f.join("w{0}", range(t.word_count, 2 * t.word_count))
    f.write(")")

    f.write("    return (high, low)")
    f.write("  }")


@dataclass
class _MulCoordinate:
    """
    lhs - word index in self;
    rhs_in_initial_width - word index in rhs;
    rhs - word index as if rhs had the same width as lhs (all words in front are 0);
    """

    lhs: int
    rhs: int
    rhs_in_initial_width: int

    def __repr__(self) -> str:
        return f"({self.lhs}, {self.rhs})"


@dataclass
class _MulColumn:
    """
    Summation column for multiplication.
    high - high word from this coordinate;
    low  - low  word from this coordinate;
    """

    index: int
    high: list[_MulCoordinate]
    high_coordinate_sum: int
    low: list[_MulCoordinate]
    low_coordinate_sum: int


def _create_multiplication_columns(
    lhs: _UIntType,
    rhs: _UIntType,
) -> list[_MulColumn]:
    result: list[_MulColumn] = []

    for index in range(2 * lhs.word_count):
        column = _MulColumn(index, [], 0, [], 0)
        result.append(column)

    #                   |      0       1
    #                   |      0       1
    #         ----------+---------------
    #                   | 11.high 11.low
    #           10.high | 10.low
    #           01.high | 01.low
    #   00.high 00.low  |
    #   0       1       | 2       3   <- column (result word)
    #   0       1       | 2       -   <- coordinate sum for high
    #   -       0       | 1       2   <- coordinate sum for low

    word_count_diff = lhs.word_count - rhs.word_count
    assert word_count_diff >= 0

    for lhs_i in range(lhs.word_count):
        for rhs_in_initial_width in range(rhs.word_count):
            rhs_i = word_count_diff + rhs_in_initial_width
            coordinate = _MulCoordinate(lhs_i, rhs_i, rhs_in_initial_width)
            coordinate_sum = lhs_i + rhs_i

            column_high = result[coordinate_sum]
            column_high.high.append(coordinate)
            column_high.high_coordinate_sum = coordinate_sum

            column_low = result[coordinate_sum + 1]
            column_low.low.append(coordinate)
            column_low.low_coordinate_sum = coordinate_sum

    # Remove prefix columns without any sum
    while result:
        has_coordinates = result[0].high or result[0].low
        if has_coordinates:
            break

        result.pop(0)

    return result


def _write_multiplications(f: _File, columns: list[_MulColumn], rhs: _UIntType):
    coordinates: list[_MulCoordinate] = []

    for c in columns:
        coordinates.extend(c.low)

    coordinates.sort(key=lambda c: (c.lhs, c.rhs))

    for c in coordinates:
        r = "rhs" if rhs.word_count == 1 else f"rhs.w{c.rhs_in_initial_width}"
        f.write(
            f"    let mul{c.lhs}{c.rhs} = self.w{c.lhs}.multipliedFullWidth(by: {r})"
        )


def _write_multiplication_column_sum(
    f: _File, columns: list[_MulColumn], c: _MulColumn
):
    f.write("\n")
    f.write(f"    // Column {c.index}")

    if id(c) == id(columns[-1]):
        assert not c.high
        assert len(c.low) == 1

        coord = c.low[0]
        f.write(f"    let w{c.index} = mul{coord.lhs}{coord.rhs}.low")
        f.write(f"    let carry{c.index}: Word = 0")
        return

    f.write(f"    let (carry{c.index}, w{c.index}) = sum(")
    f.write(f"      carry{c.index + 1},")

    high = map(lambda coord: f"mul{coord.lhs}{coord.rhs}.high", c.high)
    low = map(lambda coord: f"mul{coord.lhs}{coord.rhs}.low", c.low)

    f.write(f"      ", new_line=False)
    f.join("{0}", high)
    if c.low:
        f.write(",", new_line=False)
    f.write(f" // previous column (sum={c.high_coordinate_sum})")

    if c.low:
        f.write(f"      ", new_line=False)
        f.join("{0}", low)
        f.write(f" // this column (sum={c.low_coordinate_sum})")

    f.write(f"    )")


# ===========
# === Div ===
# ===========


def _write_div(f: _File, t: _UIntType):
    # =================
    # === Operators ===
    # =================

    f.write(
        f"""
  {t.public} static func / (lhs: Self, rhs: Self) -> Self {{
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "Division by zero")
    return result
  }}

  {t.public} static func /= (lhs: inout Self, rhs: Self) {{
    let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
    precondition(!overflow, "Division by zero")
    lhs = result
  }}

  {t.public} func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {{
    if rhs == Self.zero {{
      return (self, true)
    }}

    let qr = self.quotientAndRemainder(dividingBy: rhs)
    return (qr.quotient, false)
  }}

  {t.public} static func % (lhs: Self, rhs: Self) -> Self {{
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "Division by zero in remainder operation")
    return result
  }}

  {t.public} static func %= (lhs: inout Self, rhs: Self) {{
    let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
    precondition(!overflow, "Division by zero in remainder operation")
    lhs = result
  }}

  {t.public} func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {{
    if rhs == Self.zero {{
      return (self, true)
    }}

    let qr = self.quotientAndRemainder(dividingBy: rhs)
    return (qr.remainder, false)
  }}\
"""
    )

    # ====================================
    # === quotientAndRemainder by Word ===
    # ====================================

    f.write(
        """
  internal func quotientAndRemainder(dividingBy rhs: Word) -> (quotient: Self, remainder: Word) {
    let div0 = self.w0.quotientAndRemainder(dividingBy: rhs)\
"""
    )

    for i in range(1, t.word_count):
        f.write(
            f"""
    let div{i} = div{i-1}.remainder == 0 ?
      self.w{i}.quotientAndRemainder(dividingBy: rhs) :
      rhs.dividingFullWidth((div{i-1}.remainder, self.w{i}))\
"""
        )

    f.write("\n")
    f.write("    let quotient = Self(", new_line=False)
    f.join("div{0}.quotient", range(t.word_count))
    f.write(")")
    f.write(f"    return (quotient, div{t.word_count-1}.remainder)")
    f.write("  }")

    # =======================================
    # === quotientAndRemainder by UInt128 ===
    # =======================================

    if t == _U256:
        f.write(
            f"""
  internal func quotientAndRemainder(dividingBy rhs: UInt128) -> (quotient: Self, remainder: UInt128) {{
    // rhs == Word?
    if rhs.w0 == 0 {{
      let (q, r) = self.quotientAndRemainder(dividingBy: rhs.w1)
      let remainder = UInt128(0, r)
      return (q, remainder)
    }}

    // self == UInt128?
    if self.w0 == 0 && self.w1 == 0 {{
      let w2w3 = UInt128(self.w2, self.w3)
      let (q, r) = w2w3.quotientAndRemainder(dividingBy: rhs)
      let quotient = Self(0, 0, q.w0, q.w1)
      return (quotient, r)
    }}

    let w0w1 = UInt128(self.w0, self.w1)
    let div0 = w0w1.quotientAndRemainder(dividingBy: rhs)

    let w2w3 = UInt128(self.w2, self.w3)
    let div1 = div0.remainder == 0 ?
      w2w3.quotientAndRemainder(dividingBy: rhs) :
      rhs.dividingFullWidth((div0.remainder, w2w3))

    let quotient = Self(div0.quotient.w0, div0.quotient.w1, div1.quotient.w0, div1.quotient.w1)
    let remainder = UInt128(div1.remainder.w0, div1.remainder.w1)
    return (quotient, remainder)
  }}\
"""
        )

    # ====================================
    # === quotientAndRemainder by Self ===
    # ====================================

    f.write(
        f"""
  {t.public} func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {{
    precondition(rhs != 0, "Division by zero")

    if self == rhs {{
      return (1, 0)
    }}

    if self < rhs {{
      return (0, self)
    }}\
"""
    )

    # === Check if rhs has n-words ===

    fast_word_count = t.word_count // 2

    s = "" if fast_word_count == 1 else "s"
    f.write("\n")
    f.write(f"    // Rhs {fast_word_count} word{s}?")

    f.write("    if ", new_line=False)
    f.join("rhs.w{0} == 0", range(t.word_count - fast_word_count), separator=" && ")
    f.write(" {")

    rhs_width = fast_word_count * 64
    f.write(f"      let rhsShort = UInt{rhs_width}(", new_line=False)
    f.join("rhs.w{0}", range(t.word_count - fast_word_count, t.word_count))
    f.write(")")

    f.write("      let (q, r) = self.quotientAndRemainder(dividingBy: rhsShort)")

    f.write("      let remainder = Self(", new_line=False)
    f.join("0", range(t.word_count - fast_word_count))
    f.write(", ", new_line=False)
    if fast_word_count == 1:
        f.write("r", new_line=False)
    else:
        f.join("r.w{0}", range(fast_word_count))
    f.write(")")

    f.write("      return (q, remainder)")
    f.write("    }")

    # === Shifting edge case ===
    f.write(
        """
    // Edge case for the bit shifting below.
    if self.leadingZeroBitCount == rhs.leadingZeroBitCount {
      // Quotient is 1 and remainder is the difference:
      // - lhs > rhs
      // - both operands have non-0 high bits
      // - both have the same high power of 2, so quotient has to be 1\
"""
    )

    f.write("      let quotient = Self(", new_line=False)
    f.join("0", range(t.word_count - 1))
    f.write(", 1)")
    f.write("      let remainder = self - rhs")
    f.write("      return (quotient, remainder)")
    f.write("    }")

    # === Shifting ===

    f.write(
        """
    // At this point we know that:
    // - lhs > rhs
    // - lhs it has 'more' bits
    // - both lhs and rhs have upper half filled -> full width division
    //
    // What follows is:
    // - "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler
    // - "The Art of Computer Programming vol 2" by Knuth -> 4.3.1 - Algorithm D
    let shift = rhs.leadingZeroBitCount
    let rhsShifted = rhs &<< shift

    let lhsHigh = (self &>> (Self.bitWidth &- shift))
    let lhsLow = self &<< shift

    let (q, r) = Self.divide3by2(
      lhsHigh.low, lhsLow.high, lhsLow.low,
      by: rhsShifted
    )

    let quotient = Self(high: 0, low: q)
    let remainder = r &>> shift
    return (quotient, remainder)
  }\
"""
    )

    # ==================
    # === divide3by2 ===
    # ==================

    half = f"UInt{t.width // 2}"
    three_halfs = f"UInt{t.width + t.width // 2}"

    f.write(
        f"""
  /// "Algorithm 2. (D3n/2n)" by Christoph Burnikel and Joachim Ziegler
  private static func divide3by2(
    _ a1: {half}, _ a2: {half}, _ a3: {half},
    by b: Self
  ) -> (quotient: {half}, remainder: Self) {{
    // Let A and B be nonnegative integers, and let A<βn*B and β2n/2 <= B < β2n.
    // Algorithm D3n/2n computes the quotient Q = [A/B] with remainder R = A-Q*B.
    // 1. Split A into three parts A = [A1;A2;A3] with Ai < βn.
    // 2. Split B into two   parts B = [B1;B2] with Bi < βn.
    // 3. Distinguish the cases A1 < B1 or A1 >= B1 .
    //   (a) If A1<B1, compute Q̂ = floor([A1;A2]/B1) with remainder R1 using
    //                 algorithm D2n/1n.
    //   (b) If A1>=B1, set Q̂ = βn-1
    //                  set R1 = [A1;A2] - [B1;0] + [0;B1] (=[A1,A2] - Q̂B1).
    // 4. Compute D = Q̂*B2 using Karatsuba multiplication.
    // 5. Compute R̂ = R1*βn + A4 - D.
    // 6. As long as R̂ < 0, repeat // Same as R1*βn + A4 < D.
    //   (a) R̂ = R̂ + B
    //   (b) Q̂ = Q̂ - 1
    // 7. Return Q̂, R̂
    //
    // (…)
    //
    // We conclude that the body of the loop in step 6 of algorithm D3n/2n is
    // processed at most twice.

    assert(b.leadingZeroBitCount == 0)
    let b1 = b.high

    // We do not need R1.
    // We will calculate 'R̂' differently, see details below.
    var qHat = a1 < b1 ?
      b1.dividingFullWidth((a1, a2)).quotient :
      {half}.max

    // The method in the paper gives incorrect reminder?
    // They want 'D = Q̂*B2'.
    // We will use 'D = Q̂*B' and compare with original value 'A'.
    let d = b.multipliedFullWidth(by: qHat)
    let D = {three_halfs}(d.high, d.low)
    // This is basically the original value of 'A'
    // We will do the '-D' part later.
    var rHat = {three_halfs}(a1, a2, a3)
    let bWide = {three_halfs}(0, b)

    // Statement about the double iteration holds true even if 'D = Q̂*B'
    // (and not 'D = Q̂*B1'), because the iteration count depends on the quotient
    // approximation and not on the exact value of 'D'.
    while rHat < D {{
      rHat += bWide
      qHat &-= 1
    }}

    rHat -= D
    assert(rHat.w0 == 0)
    let r = Self(high: rHat.w1, low: rHat.w2)
    return (qHat, r)
  }}\
"""
    )

    # =========================
    # === dividingFullWidth ===
    # =========================

    if t == _U128:
        f.write(
            """
  public func dividingFullWidth(
    _ lhs: (high: Self, low: Self)
  ) -> (quotient: Self, remainder: Self) {
    let rhs = self
    precondition(rhs != 0, "Division by zero")
    precondition(rhs >= lhs.high, "Division results in an overflow")

    // lhs = UInt128?
    if lhs.high == 0 {
      return lhs.low.quotientAndRemainder(dividingBy: rhs)
    }

    let lhs = UInt256(high: lhs.high, low: lhs.low)

    // rhs = Word?
    if rhs.high == 0 {
      // School method: abcd / r
      let r = rhs.low
      let a = lhs.w0 % r

      let b = a == 0 ?
        lhs.w1 % r :
        r.dividingFullWidth((a, lhs.w1)).remainder

      let (x, c) = b == 0 ?
        lhs.w2.quotientAndRemainder(dividingBy: r) :
        r.dividingFullWidth((b, lhs.w2))

      let (y, d) = c == 0 ?
        lhs.w3.quotientAndRemainder(dividingBy: r) :
        r.dividingFullWidth((c, lhs.w3))

      let quotient = Self(high: x, low: y)
      let remainder = Self(high: 0, low: d)
      return (quotient, remainder)
    }

    // Left shift both rhs and lhs, then divide and right shift the remainder.
    // Similar to Knuth Algorithm D.
    let shift = rhs.leadingZeroBitCount
    let lhsShifted = lhs &<< shift
    let rhsShifted = rhs &<< shift

    if lhsShifted.w0 == 0 && Self(high: lhsShifted.w1, low: lhsShifted.w2) < rhsShifted {
      let (q, r) = Self.divide3by2(
        lhsShifted.w1, lhsShifted.w2, lhsShifted.w3,
        by: rhsShifted
      )

      let quotient = Self(high: 0, low: q)
      let remainder = r &>> shift
      return (quotient, remainder)
    }

    let (q1, r1) = Self.divide3by2(
      lhsShifted.w0, lhsShifted.w1, lhsShifted.w2,
      by: rhsShifted
    )

    let (q2, r2) = Self.divide3by2(
      r1.high, r1.low, lhsShifted.w3,
      by: rhsShifted
    )

    let quotient = Self(q1, q2)
    let remainder = r2 &>> shift
    return (quotient, remainder)
  }\
"""
        )
    else:
        f.write(
            f"""
  {t.public} func dividingFullWidth(_ dividend: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {{
    fatalError("{t.name} dividingFullWidth is not implemented.")
  }}\
"""
        )


# ======================
# === Bit operations ===
# ======================


def _write_bit_operations(f: _File, t: _UIntType):
    # ==============
    # === Invert ===
    # ==============

    f.write("\n")
    f.write(f"  {t.public} static prefix func ~ (n: Self) -> Self {{")
    f.lines("    let w{0} = ~n.w{0}", range(t.word_count))
    f.write("    return Self(", new_line=False)
    f.join("w{0}", range(t.word_count))
    f.write(")")
    f.write("  }")

    # ====================
    # === And, or, xor ===
    # ====================

    bit_operators = (
        ("and", "&"),
        ("or", "|"),
        ("xor", "^"),
    )

    for name, op in bit_operators:
        f.write(f"\n")
        f.write(f"  {t.public} static func {op}= (lhs: inout Self, rhs: Self) {{")
        f.lines(
            "    lhs.w{0} {1}= rhs.w{0}",
            range(t.word_count),
            op,
        )
        f.write("  }")


# ==============
# === Shifts ===
# ==============


def _write_shifts(f: _File, t: _UIntType):
    f.write("\n")
    s = _LeftShiftWriter(f, t)
    s.write()

    f.write("\n")
    s = _RightShiftWriter(f, t)
    s.write()

    f.write(
        """
  /// Calculates the result of shifting a value’s binary representation the
  /// specified number of digits in direction, MASKING THE SHIFT AMOUNT TO
  /// THE TYPE’S BIT WIDTH, and stores the result in the left-hand-side variable.
  private static func applyShiftMask(_ n: Self) -> Word {\
"""
    )

    if t.word_count % 2 == 0:
        i = t.word_count - 1
        f.write(f"    let mask = Word(truncatingIfNeeded: Self.bitWidth &- 1)")
        f.write(f"    return n.w{i} & mask")
    else:
        f.write(
            """\
    let wordWidth = Word(truncatingIfNeeded: Self.bitWidth)
    let qr = n.quotientAndRemainder(dividingBy: wordWidth)
    return qr.remainder\
"""
        )

    f.write("  }")


class _ShiftWriter:
    def __init__(self, f: _File, t: _UIntType, op: str) -> None:
        self.f = f
        self.t = t
        self.op = op

    def write(self):
        f = self.f
        t = self.t

        f.write(f"  {t.public} static func &{self.op}= (lhs: inout Self, rhs: Self) {{")
        f.write(f"    let rhs = Self.applyShiftMask(rhs)")
        f.write(f"    let word = Word(Word.bitWidth)")
        f.write("\n")

        f.write("    if rhs == 0 {")
        f.write("      // Nothing to do here.")

        for word_count in range(1, t.word_count + 1):
            is_last = word_count == t.word_count

            f.write(f"    }} else if rhs < {word_count} &* word {{")
            self._write_rhs_less_than_word(word_count, is_last)

            f.write(f"    }} else if rhs == {word_count} &* word {{")
            self._write_rhs_equal_word(word_count)

            if is_last:
                f.write(f"    }}")

        f.write("  }")

    def _write_rhs_less_than_word(self, word_count: int, is_last: bool):
        assert False, "Abstract _ShiftWriter._write_rhs_less_than_word"

    def _write_rhs_equal_word(self, word_count: int):
        assert False, "Abstract _ShiftWriter._write_rhs_equal_word"


class _LeftShiftWriter(_ShiftWriter):
    def __init__(self, f: _File, t: _UIntType) -> None:
        super().__init__(f, t, "<<")

    def _write_rhs_less_than_word(self, word_count: int, is_last: bool):
        f = self.f
        t = self.t

        f.write(f"      let left = rhs &- ({word_count-1} &* word)")
        if not is_last:
            f.write(f"      let right = word &- left")

        for i in range(t.word_count):
            left_i = i + word_count - 1
            right_i = left_i + 1

            if 0 <= left_i < t.word_count:
                f.write(f"      lhs.w{i} = lhs.w{left_i} &<< left")

            if 0 <= right_i < t.word_count:
                f.write(f"      lhs.w{i} |= lhs.w{right_i} &>> right")

            if left_i >= t.word_count and right_i >= t.word_count:
                f.write(f"      lhs.w{i} = 0")

    def _write_rhs_equal_word(self, word_count: int):
        f = self.f
        t = self.t

        for i in range(t.word_count):
            source_i = i + word_count

            if 0 <= source_i < t.word_count:
                f.write(f"      lhs.w{i} = lhs.w{source_i}")
            else:
                f.write(f"      lhs.w{i} = 0")


class _RightShiftWriter(_ShiftWriter):
    def __init__(self, f: _File, t: _UIntType) -> None:
        super().__init__(f, t, ">>")

    def _write_rhs_less_than_word(self, word_count: int, is_last: bool):
        f = self.f
        t = self.t

        f.write(f"      let right = rhs &- ({word_count-1} &* word)")
        if not is_last:
            f.write(f"      let left = word &- right")

        for i in reversed(range(t.word_count)):
            right_i = i - word_count + 1
            left_i = right_i - 1

            if 0 <= right_i <= t.word_count:
                f.write(f"      lhs.w{i} = lhs.w{right_i} &>> right")

            if 0 <= left_i <= t.word_count:
                f.write(f"      lhs.w{i} |= lhs.w{left_i} &<< left")

            if left_i < 0 and right_i < 0:
                f.write(f"      lhs.w{i} = 0")

    def _write_rhs_equal_word(self, word_count: int):
        f = self.f
        t = self.t

        for i in reversed(range(t.word_count)):
            source_i = i - word_count

            if 0 <= source_i < t.word_count:
                f.write(f"      lhs.w{i} = lhs.w{source_i}")
            else:
                f.write(f"      lhs.w{i} = 0")


# ======================
# === Equal, compare ===
# ======================


def _write_equal(f: _File, t: _UIntType):
    f.write("\n")
    f.write(f"  {t.public} static func == (lhs: Self, rhs: Self) -> Bool {{")
    f.write("    return ", new_line=False)
    f.join("lhs.w{0} == rhs.w{0}", range(t.word_count), separator=" && ")
    f.write("\n")
    f.write("  }")


def _write_compare(f: _File, t: _UIntType):
    f.write("\n")
    f.write(f"  {t.public} static func < (lhs: Self, rhs: Self) -> Bool {{")

    i = 0
    f.write(f"    if lhs.w{i} < rhs.w{i} {{ return true }}")

    for i in range(1, t.word_count):
        f.write("\n")
        f.write(f"    if lhs.w{i-1} != rhs.w{i-1} {{ return false }}")

        if i != t.word_count - 1:
            f.write(f"    if lhs.w{i} < rhs.w{i} {{ return true }}")
        else:
            f.write(f"    return lhs.w{i} < rhs.w{i}")

    f.write("  }")


# =============
# === Words ===
# =============


def _write_words(f: _File, t: _UIntType):
    f.write(
        f"""
  {t.public} struct Words: RandomAccessCollection {{
    {t.public} typealias Element = UInt
    {t.public} typealias Index = Int

    {t.public} var count: Int {{ {t.name}.bitWidth / UInt.bitWidth }}
    {t.public} var startIndex: Index {{ 0 }}
    {t.public} var endIndex: Index {{ count }}

    internal var value: {t.name}

    fileprivate init(_ value: {t.name}) {{
      self.value = value
    }}

    {t.public} subscript(position: Index) -> UInt {{
      precondition(
        0 <= position && position < self.endIndex,
        "Word index out of range"
      )

      let shift = position * UInt.bitWidth
      let shifted = self.value &>> shift
      return UInt(truncatingIfNeeded: shifted.w{t.word_count - 1})
    }}

    {t.public} func index(after i: Index) -> Index {{ i + 1 }}
    {t.public} func index(before i: Index) -> Index {{ i - 1 }}
  }}\
"""
    )


# ==================
# === Div helper ===
# ==================


def _write_div_helper_type(f: _File, t: _UIntType):
    f.write("\n")
    f.write("/// Unsigned Int that is used during division.")
    f.write(f"private struct {t.div_helper_name} {{")

    f.write("\n")
    f.write(f"  fileprivate typealias Word = UInt{t.div_helper_word_count // 3 * 64}")

    f.write("\n")
    f.write("  fileprivate let w0: Word")
    f.write("  fileprivate let w1: Word")
    f.write("  fileprivate let w2: Word")

    f.write("\n")
    f.write(f"  fileprivate init(_ w0: Word, _ wide: {t.name}) {{")
    f.write("    self.w0 = w0")
    f.write("    self.w1 = Word(", new_line=False)
    f.join("wide.w{0}", range(t.word_count // 2))
    f.write(")")
    f.write("    self.w2 = Word(", new_line=False)
    f.join("wide.w{0}", range(t.word_count // 2, t.word_count))
    f.write(")")
    f.write("  }")

    f.write(
        f"""
  fileprivate init(_ w0: Word, _ w1: Word, _ w2: Word) {{
    self.w0 = w0
    self.w1 = w1
    self.w2 = w2
  }}\
"""
    )

    fake_uint = _UIntType(
        name=t.div_helper_name,
        word_count=3,
        public="fileprivate",
    )

    _write_add(f, fake_uint, fake_uint)
    _write_sub(f, fake_uint, fake_uint)
    _write_compare(f, fake_uint)
    f.write("}")
