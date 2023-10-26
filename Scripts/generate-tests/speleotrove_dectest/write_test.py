import os
from io import TextIOWrapper
from dataclasses import dataclass
from common import GENERATED_FILE_HEADER
from speleotrove_dectest.swift_code import (
    Swift,
    get_swift_code,
    ARG_TYPE_INT,
    ARG_TYPE_BOOL,
    ARG_TYPE_STRING,
    ARG_TYPE_TESTED_DECIMAL,
    ARG_TYPE_FLOATING_POINT_CLASS,
)
from speleotrove_dectest.parse_file import (
    SpeleotroveLine,
    SpeleotroveConfig,
    SPELEOTROVE_ROUNDING_CEILING,
    SPELEOTROVE_ROUNDING_DOWN,
    SPELEOTROVE_ROUNDING_FLOOR,
    SPELEOTROVE_ROUNDING_HALF_EVEN,
    SPELEOTROVE_ROUNDING_HALF_UP,
)


@dataclass
class SwiftLine(SpeleotroveLine):
    swift: Swift

    def __init__(self, line: SpeleotroveLine, swift: Swift):
        super().__init__(
            id=line.id,
            operation=line.operation,
            arg0=line.arg0,
            arg1=line.arg1,
            arg2=line.arg2,
            result=line.result,
            config=line.config,
            conditions=line.conditions,
        )
        self.swift = swift


@dataclass
class _Decimal:
    name: str
    bit_width: int
    precision: int
    min_exponent: int
    max_exponent: int

    def is_equal(self, config: SpeleotroveConfig) -> bool:
        "Is this decimal type is equal to config from file?"
        return (
            self.precision == config.precision
            and self.min_exponent == config.min_exponent
            and self.max_exponent == config.max_exponent
        )


_DECIMAL32 = _Decimal(
    "Decimal32",
    bit_width=32,
    precision=7,
    min_exponent=-95,
    max_exponent=96,
)
_DECIMAL64 = _Decimal(
    "Decimal64",
    bit_width=64,
    precision=16,
    min_exponent=-383,
    max_exponent=384,
)
_DECIMAL128 = _Decimal(
    "Decimal128",
    bit_width=128,
    precision=34,
    min_exponent=-6143,
    max_exponent=6144,
)


@dataclass
class _DecimalGroup:
    "All tests for a given decimal"
    decimal: _Decimal
    lines: list[SwiftLine]


@dataclass
class _OperationGroup:
    "All tests for a given operation grouped by decimal type"
    name: str
    decimal32: _DecimalGroup
    decimal64: _DecimalGroup
    decimal128: _DecimalGroup


def write_test(output_dir: str, class_name: str, lines: list[SwiftLine]):
    file_name = class_name + ".swift"
    path = os.path.join(output_dir, file_name)

    operations = _group_by_operation(lines)
    operations.sort(key=lambda o: o.name)

    with open(path, "w") as f:
        f.write(GENERATED_FILE_HEADER)
        f.write("\n")
        f.write("import XCTest\n")
        f.write("@testable import Decimal\n")
        f.write("\n")
        f.write(f"class {class_name}: XCTestCase, SpeleotroveMixin {{\n")

        for o in operations:
            if len(operations) != 1:
                f.write("\n")
                f.write("  // MARK: - ")
                f.write(o.name.title())
                f.write("\n")

            _write_test(f, o, o.decimal32)
            _write_test(f, o, o.decimal64)
            _write_test(f, o, o.decimal128)

        f.write("}\n")


def _group_by_operation(lines: list[SwiftLine]) -> list[_OperationGroup]:
    operation_lower_to_lines: dict[str, list[SwiftLine]] = dict()

    for l in lines:
        op = l.operation.lower()
        op_lines = operation_lower_to_lines.get(op)

        if op_lines is None:
            op_lines = []
            operation_lower_to_lines[op] = op_lines

        op_lines.append(l)

    result: list[_OperationGroup] = []

    for op_lower, lines in operation_lower_to_lines.items():
        g = _OperationGroup(
            op_lower,
            decimal32=_DecimalGroup(_DECIMAL32, []),
            decimal64=_DecimalGroup(_DECIMAL64, []),
            decimal128=_DecimalGroup(_DECIMAL128, []),
        )

        for l in lines:
            if _DECIMAL32.is_equal(l.config):
                g.decimal32.lines.append(l)
            elif _DECIMAL64.is_equal(l.config):
                g.decimal64.lines.append(l)
            elif _DECIMAL128.is_equal(l.config):
                g.decimal128.lines.append(l)
            else:
                assert False, "Config not assigned to decimal: " + str(l.config)

        result.append(g)

    return result


# https://speleotrove.com/decimal/damodel.html
_SPELEOTROVE_ROUNDING_TO_SWIFT_ROUNDING: dict[str, str] = {
    # (Round toward 0; truncate.) The discarded digits are ignored;
    # the result is unchanged.
    SPELEOTROVE_ROUNDING_DOWN: "towardZero",
    # (Round toward +¥.) If all of the discarded digits are zero or if the sign
    # is 1 the result is unchanged. Otherwise, the result coefficient should be
    # incremented by 1 (rounded up).
    SPELEOTROVE_ROUNDING_CEILING: "up",
    # (Round toward –¥.) If all of the discarded digits are zero or if the sign
    # is 0 the result is unchanged. Otherwise, the sign is 1 and the result
    # coefficient should be incremented by 1.
    SPELEOTROVE_ROUNDING_FLOOR: "down",
    # If the discarded digits represent greater than half (0.5) the value of a
    # one in the next left position then the result coefficient should be
    # incremented by 1 (rounded up). If they represent less than half, then the
    # result coefficient is not adjusted (that is, the discarded digits are ignored).
    #
    # Otherwise (they represent exactly half) the result coefficient is unaltered
    # if its rightmost digit is even, or incremented by 1 (rounded up) if its
    # rightmost digit is odd (to make an even digit).
    SPELEOTROVE_ROUNDING_HALF_EVEN: "toNearestOrEven",
    # If the discarded digits represent greater than or equal to half (0.5) of
    # the value of a one in the next left position then the result coefficient
    # should be incremented by 1 (rounded up).
    # Otherwise the discarded digits are ignored.
    SPELEOTROVE_ROUNDING_HALF_UP: "toNearestOrAwayFromZero",
    # --------------------
    # (Round away from 0.) If all of the discarded digits are zero the result is
    # unchanged.
    # Otherwise, the result coefficient should be incremented by 1 (rounded up).
    # SPELEOTROVE_ROUNDING_UP: "",
    # --------------------
    # If the discarded digits represent greater than half (0.5) of the value of
    # a one in the next left position then the result coefficient should be
    # incremented by 1 (rounded up). Otherwise (the discarded digits are 0.5 or
    # less) the discarded digits are ignored.
    # SPELEOTROVE_ROUNDING_HALF_DOWN: "",
    # --------------------
    # (Round zero or five away from 0.) The same as round-up, except that rounding
    # up only occurs if the digit to be rounded up is 0 or 5, and after overflow
    # the result is the same as for round-down.[10]
    # SPELEOTROVE_ROUNDING_05UP: "",
}


_ARG_INDEX_EXPECTED = -1


@dataclass
class _ArgType:
    def write_call_arg(self, f: TextIOWrapper, arg: str):
        assert False, "ArgType.write_call_arg should be overriden."

    def write_helper_arg(self, f: TextIOWrapper, index: int):
        assert False, "ArgType.write_helper_arg should be overriden."

    def write_helper_parse(self, f: TextIOWrapper, index: int):
        assert False, "ArgType.write_helper_parse should be overriden."

    def _helper_arg_name(self, index: int) -> str:
        return "expected" if index == _ARG_INDEX_EXPECTED else f"arg{index}"


def _write_test(f: TextIOWrapper, operation: _OperationGroup, group: _DecimalGroup):
    decimal = group.decimal
    lines: list[SwiftLine] = []
    swift: Swift | None = None

    for l in group.lines:
        # We do not support references.
        if l.arg0 == "#" or l.arg1 == "#" or l.arg2 == "#":
            continue

        if l.config.rounding not in _SPELEOTROVE_ROUNDING_TO_SWIFT_ROUNDING:
            continue

        if swift is None:
            swift = l.swift
        else:
            assert id(swift) == id(l.swift)

        lines.append(l)

    if not lines:
        if group.lines:
            f.write(f"\n")
            f.write(
                f"  // There are some lines for {decimal.name}, but none of them is supported.\n"
            )

        return

    assert swift is not None

    lines.sort(key=lambda l: l.id)
    fn_name = operation.name + str(decimal.bit_width)

    # =================
    # === Arg types ===
    # =================

    arg0_type = _get_arg_type(swift.arg0_type, decimal)
    arg1_type = _get_arg_type_optional(swift.arg1_type, decimal)
    arg2_type = _get_arg_type_optional(swift.arg2_type, decimal)
    result_type = _get_arg_type(swift.result_type, decimal)

    # ============
    # === Test ===
    # ============

    f.write(f"\n")
    f.write(f"  func test_{operation.name}{decimal.bit_width}() {{\n")

    for l in lines:
        f.write(f"    /* {l.id} */ self.{fn_name}(")

        arg0_type.write_call_arg(f, l.arg0)

        if arg1_type is None:
            assert l.arg1 is None, f"Unexpected arg1: {l.operation} -> {l.id}"
        else:
            assert l.arg1 is not None, f"Missing arg1: {l.operation} -> {l.id}"
            f.write(", ")
            arg1_type.write_call_arg(f, l.arg1)

        if arg2_type is None:
            assert l.arg2 is None, f"Unexpected arg2: {l.operation} -> {l.id}"
        else:
            assert l.arg2 is not None, f"Missing arg2: {l.operation} -> {l.id}"
            f.write(", ")
            arg2_type.write_call_arg(f, l.arg2)

        f.write(", ")
        result_type.write_call_arg(f, l.result)

        f.write(", .")
        rounding = _SPELEOTROVE_ROUNDING_TO_SWIFT_ROUNDING[l.config.rounding]
        f.write(rounding)

        status: list[str] = []

        if l.conditions.is_ieee_invalid_operation:
            status.append(".isInvalidOperation")
        if l.conditions.is_ieee_inexact:
            status.append(".isInexact")
        if l.conditions.is_ieee_overflow:
            status.append(".isOverflow")
        if l.conditions.is_ieee_underflow:
            status.append(".isUnderflow")
        if l.conditions.is_ieee_division_by_zero:
            status.append(".isDivisionByZero")

        if status:
            f.write(", ")
            f.write(" | ".join(status))

        f.write(")\n")

    f.write("  }\n")

    # ==============
    # === Helper ===
    # ==============

    swift_code = get_swift_code(operation.name)
    arg_types = [arg0_type]

    if arg1_type is not None:
        arg_types.append(arg1_type)

        if arg2_type is not None:
            arg_types.append(arg2_type)

    f.write("\n")
    f.write(f"  private func {fn_name}(\n")

    for i, a in enumerate(arg_types):
        a.write_helper_arg(f, i)

    result_type.write_helper_arg(f, _ARG_INDEX_EXPECTED)

    f.write("    _ rounding: DecimalFloatingPointRoundingRule,\n")
    f.write("    _ _expectedStatus: DecimalStatus? = nil,\n")
    f.write("    file: StaticString = #file,\n")
    f.write("    line: UInt = #line\n")
    f.write("  ) {\n")

    for i, a in enumerate(arg_types):
        a.write_helper_parse(f, i)

    result_type.write_helper_parse(f, _ARG_INDEX_EXPECTED)

    if swift_code.has_status:
        f.write("    let expectedStatus = _expectedStatus ?? DecimalStatus()\n")

    f.write("\n")

    if swift_code.has_status:
        f.write("    var status = DecimalStatus()\n")

    code = swift_code.code
    if code.startswith("\n"):
        code = code[1:]

    code = code.replace("{decimal_name}", decimal.name)

    f.write(code)
    f.write("  }\n")


def _get_arg_type(s: str, tested_decimal: _Decimal) -> _ArgType:
    if s == ARG_TYPE_INT:
        return _IntArgType()

    if s == ARG_TYPE_BOOL:
        return _BoolArgType()

    if s == ARG_TYPE_STRING:
        return _StringArgType()

    if s == ARG_TYPE_TESTED_DECIMAL:
        return _DecimalArgType(tested_decimal)

    if s == ARG_TYPE_FLOATING_POINT_CLASS:
        return _FloatingPointClassArgType()

    assert False, "Unknown arg type: " + s


def _get_arg_type_optional(s: str | None, tested_decimal: _Decimal) -> _ArgType | None:
    if s is None:
        return None

    return _get_arg_type(s, tested_decimal)


def _encode_decimal_payload(arg: str) -> str:
    arg_lower = arg.lower()

    for p in ("nan", "+nan", "-nan", "snan", "+snan", "-snan"):
        if arg_lower.startswith(p):
            p_len = len(p)
            nan = arg[:p_len]
            payload_str = arg[p_len:]

            if payload_str != "":
                payload_int = int(payload_str)
                payload_hex = hex(payload_int)
                arg = nan + "(" + payload_hex + ")"

            break

    return arg


@dataclass
class _DecimalArgType(_ArgType):
    decimal: _Decimal

    def write_call_arg(self, f: TextIOWrapper, arg: str):
        # https://speleotrove.com/decimal/dtfile.html#syntax
        arg = arg.replace("'", "")
        arg = _encode_decimal_payload(arg)
        f.write('"')
        f.write(arg)
        f.write('"')

    def write_helper_arg(self, f: TextIOWrapper, index: int):
        name = self._helper_arg_name(index)
        f.write(f"    _ _{name}: String,\n")

    def write_helper_parse(self, f: TextIOWrapper, index: int):
        name = self._helper_arg_name(index)
        f.write(
            f"    guard let {name} = self.parse{self.decimal.name}(_{name}, file, line) else {{ return }}\n"
        )


class _IntArgType(_ArgType):
    def write_call_arg(self, f: TextIOWrapper, arg: str):
        f.write(arg)

    def write_helper_arg(self, f: TextIOWrapper, index: int):
        name = self._helper_arg_name(index)
        f.write(f"    _ {name}: Int,\n")

    def write_helper_parse(self, f: TextIOWrapper, index: int):
        pass


class _BoolArgType(_ArgType):
    def write_call_arg(self, f: TextIOWrapper, arg: str):
        assert arg in "01", arg
        f.write("false" if arg == "0" else "true")

    def write_helper_arg(self, f: TextIOWrapper, index: int):
        name = self._helper_arg_name(index)
        f.write(f"    _ {name}: Bool,\n")

    def write_helper_parse(self, f: TextIOWrapper, index: int):
        pass


class _StringArgType(_ArgType):
    def write_call_arg(self, f: TextIOWrapper, arg: str):
        # Compare uses 'str', but in some rare cases they also use nan.
        arg = _encode_decimal_payload(arg)
        f.write('"')
        f.write(arg)
        f.write('"')

    def write_helper_arg(self, f: TextIOWrapper, index: int):
        name = self._helper_arg_name(index)
        f.write(f"    _ {name}: String,\n")

    def write_helper_parse(self, f: TextIOWrapper, index: int):
        pass


_SPELEOTROVE_CLASS_TO_SWIFT_CLASS: dict[str, str] = {
    "+zero": "positiveZero",
    "+subnormal": "positiveSubnormal",
    "+normal": "positiveNormal",
    "+infinity": "positiveInfinity",
    "-zero": "negativeZero",
    "-subnormal": "negativeSubnormal",
    "-normal": "negativeNormal",
    "-infinity": "negativeInfinity",
    "nan": "quietNaN",
    "snan": "signalingNaN",
}


class _FloatingPointClassArgType(_ArgType):
    def write_call_arg(self, f: TextIOWrapper, arg: str):
        arg = arg.lower()
        swift_class = _SPELEOTROVE_CLASS_TO_SWIFT_CLASS.get(arg)
        assert swift_class is not None, "Unknown class: " + arg

        f.write(".")
        f.write(swift_class)

    def write_helper_arg(self, f: TextIOWrapper, index: int):
        name = self._helper_arg_name(index)
        f.write(f"    _ {name}: FloatingPointClassification,\n")

    def write_helper_parse(self, f: TextIOWrapper, index: int):
        pass
