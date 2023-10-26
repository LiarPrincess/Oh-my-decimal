import os
from io import TextIOWrapper
from dataclasses import dataclass
from common import GENERATED_HEADER

# Split big tables into multiple smaller ones if needed.
# (Because Swift compiler REALLY does not like big tables.)

# Above this size we will split into smaller units.
TABLE_SPLIT_THRESHOLD = 75
# How many rows are in a single unit?
SMALL_TABLE_SIZE = 50


@dataclass
class _AbstractTable:
    name: str
    # Type stored in the Array
    stored_swift_type: str
    # Type returned by the 'big table' function
    returned_swift_type: str
    lines: list[str]

    def to_swift_line(self, line: str):
        assert False, "'_AbstractTable.to_swift_line' should be overridden."


def generate(output_dir: str):
    tables = _read_tables()
    path = os.path.join(output_dir, f"BinaryFloatingPointTables.swift")

    with open(path, "w") as f:
        f.write(GENERATED_HEADER)

        f.write(
            """
// swiftlint:disable all

// TODO: [Swift bug] Compiling big tables require 15min+ and 20GB+ of ram
//       We have to split big tables into a multiple smaller ones.
//       Otherwise the compilation would take at least 15min and 20GB of ram.
//       'At least' because I never managed to compile it.

/// Tables of values for the various conversions:
///
/// - exponents: table of output exponents
/// - breakpoints: test values to decide between two possible exponents
/// - multipliers1/multipliers2: corresponding reciprocal multipliers
/// - coefflimits: used in exactness checks
internal enum BinaryFloatingPointTables {}
"""
        )

        for t in tables:
            _write_mark(f, t.name)

            if len(t.lines) < TABLE_SPLIT_THRESHOLD:
                _write_small_table(f, t)
            else:
                _write_big_table(f, t)


def _write_small_table(f: TextIOWrapper, table: _AbstractTable):
    f.write("extension BinaryFloatingPointTables {\n")
    f.write(f"  internal static let {table.name}: [{table.stored_swift_type}] = [\n")

    for line in table.lines:
        _write_line(f, table, line)

    f.write(f"  ]\n")
    f.write("}\n")


def _write_big_table(f: TextIOWrapper, table: _AbstractTable):
    table_count = (len(table.lines) // SMALL_TABLE_SIZE) + 1
    is_returning_table_value = table.stored_swift_type == table.returned_swift_type

    f.write(
        f"""\
extension BinaryFloatingPointTables {{
  internal static func {table.name}(_ index: Int) -> {table.returned_swift_type} {{
    // We have to split this table into a multiple smaller ones.
    // Otherwise the compilation would take at least 15min and 20GB of ram.
    // 'At least' because I never managed to compile it.
    let (q, r) = index.quotientAndRemainder(dividingBy: {SMALL_TABLE_SIZE})
"""
    )

    if not is_returning_table_value:
        f.write(f"    let result: {table.stored_swift_type}\n")

    f.write("\n")
    f.write("    switch q {\n")

    for n in range(table_count):
        f.write(f"    case {n}: ")

        if is_returning_table_value:
            f.write(f"return ")
        else:
            f.write(f"result = ")

        f.write(f"{table.name}_{n}[r]\n")

    f.write('    default: preconditionFailure("Index out of range")\n')
    f.write("    }\n")

    if not is_returning_table_value:
        f.write("\n")
        f.write(f"    return {table.returned_swift_type}(truncatingIfNeeded: result)\n")

    f.write("  }\n")
    f.write("}\n")

    for n in range(table_count):
        f.write(f"\n")
        f.write(f"private let {table.name}_{n}: [{table.stored_swift_type}] = [\n")

        start = n * SMALL_TABLE_SIZE
        end = start + SMALL_TABLE_SIZE
        lines = table.lines[start:end]

        for line in lines:
            _write_line(f, table, line)

        f.write(f"]\n")


def _write_line(f: TextIOWrapper, table: _AbstractTable, line: str):
    # Split value and comment
    split = line.split("//")

    l = split[0].strip()
    l = table.to_swift_line(l)
    f.write(l)
    f.write(",")

    if len(split) == 2:
        comment = split[1].strip()
        f.write(" // ")
        f.write(comment)

    f.write("\n")


def _write_mark(f: TextIOWrapper, s: str):
    f.write("\n")
    f.write("// MARK: - ")
    f.write(s)
    f.write("\n")
    f.write("\n")


# ===================
# === Read tables ===
# ===================


class _Int16Table(_AbstractTable):
    def __init__(self, name: str, lines: list[str]) -> None:
        super().__init__(name, "Int16", "Int", lines)

    def to_swift_line(self, line: str):
        return line.replace(",", "")


class _Int32Table(_AbstractTable):
    def __init__(self, name: str, lines: list[str]) -> None:
        super().__init__(name, "Int32", "Int", lines)

    def to_swift_line(self, line: str):
        return line.replace(",", "")


class _UInt128Table(_AbstractTable):
    def __init__(self, name: str, lines: list[str]) -> None:
        super().__init__(name, "UInt128", "UInt128", lines)

    def to_swift_line(self, line: str):
        w1, w0 = _parse_wide_int(line)
        return f"UInt128({w0}, {w1})"


class _UInt256Table(_AbstractTable):
    def __init__(self, name: str, lines: list[str]) -> None:
        super().__init__(name, "UInt256", "UInt256", lines)

    def to_swift_line(self, line: str):
        w3, w2, w1, w0 = _parse_wide_int(line)
        return f"UInt256({w0}, {w1}, {w2}, {w3})"


def _parse_wide_int(line: str) -> list[str]:
    # {{2815461535676025517ull, 98607613ull}},
    # {{11435047252012674334ull, 201452880473063984ull, 4951948911778577462ull, 2037035976334486086ull}},

    assert line.startswith("{{"), line
    assert line.endswith("}},") or line.endswith("}}"), line
    l = line.replace("{", "").replace("}", "").replace("ull", "")

    if l.endswith(","):
        l = l[:-1]

    result: list[str] = []

    for s in l.split(","):
        s = s.strip()
        result.append(s)

    return result


def _read_tables() -> list[_AbstractTable]:
    dir = os.path.dirname(__file__)
    path = os.path.join(dir, "binary_floating_point_tables.txt")
    result: list[_AbstractTable] = []

    with open(path, "r") as f:
        while True:
            t = _read_table(f)

            if t is not None:
                result.append(t)
            else:
                break

    return result


def _read_table(f: TextIOWrapper) -> _AbstractTable | None:
    def read_line():
        line = ""

        # Skip empty
        while not line:
            pos_before = f.tell()
            line = f.readline().strip()
            pos_after = f.tell()

            # EOF?
            if pos_after == pos_before:
                return ""

        return line

    line = read_line()

    if line == "":
        return None

    comment_lines: list[str] = []

    while line.startswith("//"):
        comment_lines.append(line)
        line = read_line()

    # static const BID_UINT128 bid_power_five[] = {
    assert line.startswith("static const"), line
    line = line.replace("static const", "").replace("[]", "")
    split = line.split()
    assert len(split) == 4, "Invalid 1st line. Move the 1st value to next line."

    name = split[1]
    c_type = split[0]

    line = read_line()
    lines: list[str] = []

    while line and line != "};":
        # Sometimes UInt256 is split into 2 lines.
        if c_type == "BID_UINT256" and not (
            line.endswith("}},") or line.endswith("}}")
        ):
            line2 = read_line()
            assert line2.endswith("}},") or line2.endswith("}}"), line2
            line = line + " " + line2

        lines.append(line)
        line = read_line()

    assert line == "};", line

    # This table does not fit in Int16.
    if name == "bid_exponents_binary80":
        return _Int32Table(name, lines)

    if c_type == "int":
        return _Int16Table(name, lines)

    if c_type == "BID_UINT128":
        return _UInt128Table(name, lines)

    if c_type == "BID_UINT256":
        return _UInt256Table(name, lines)

    assert False, "Unknown C type: " + c_type
