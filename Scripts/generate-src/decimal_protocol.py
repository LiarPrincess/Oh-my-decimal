import os
import re
from io import TextIOWrapper
from dataclasses import dataclass
from common import GENERATED_HEADER, replace_rounding_in_template


def generate(output_dir: str):
    path = os.path.join(output_dir, f"DecimalFloatingPoint.swift")

    with open(path, "w") as f:
        f.write(GENERATED_HEADER)
        f.write(
            """\
// This code was generated based on the 'public' operations from 'Decimal64'.
// =============================================================================

/// It is a truth universally acknowledged, that `0.1 + 0.2` must be
/// `0.30000000000000004`.
///
/// …
///
/// This is a radix 10 (decimal) floating-point type from IEEE 754.
public protocol DecimalFloatingPoint: Comparable, Hashable,
                                      Sendable, Codable,
                                      ExpressibleByIntegerLiteral,
                                      CustomStringConvertible {
"""
        )

        # We will use this file to generate the protocol.
        decimal64_path = os.path.join(output_dir, "Decimal64.swift")
        _write_requirements(f, decimal64_path)

        f.write("}\n")
        f.write("\n")

        _write_extension(f)


# ====================
# === Requirements ===
# ====================


def _write_requirements(f: TextIOWrapper, decimal64_path: str):
    with open(decimal64_path, "r") as d64:
        swift_code = d64.read()
        declarations = _parse_public_declarations(swift_code)

    def write_doc(doc: str):
        doc = doc.strip()
        for l in doc.splitlines():
            f.write("  ")
            f.write(l)
            f.write("\n")

    def write_arg(arg: _Arg):
        if arg.label:
            f.write(arg.label)
            f.write(" ")

        f.write(arg.name)
        f.write(": ")
        f.write(arg.type)

    def write_args(args: list[_Arg]):
        args_len = len(args)

        if args_len == 1:
            write_arg(args[0])
        elif args_len > 1:
            for i, a in enumerate(args):
                f.write("\n    ")
                write_arg(a)
                if i != args_len - 1:
                    f.write(",")

    for d in declarations:
        if isinstance(d, _Struct):
            assert d.name == "Decimal64"

        elif isinstance(d, _Typealias):
            f.write("\n")
            write_doc(d.doc)

            if d.name == "Exponent":
                f.write(
                    "  associatedtype Exponent: SignedInteger & FixedWidthInteger\n"
                )
            elif d.name == "BitPattern":
                f.write(
                    "  associatedtype BitPattern: UnsignedInteger & FixedWidthInteger\n"
                )
            else:
                assert False, d.name

        elif isinstance(d, _Init):
            if len(d.args) > 0:
                a = d.args[0]

                # Conversion is specific to a given width.
                # There is nothing to generalize.
                is_decimal_conversion = a.name == "value" and a.type in (
                    "Decimal32",
                    "Decimal64",
                    "Decimal128",
                )

                if is_decimal_conversion or a.type == "Decoder":
                    continue

            f.write("\n")
            write_doc(d.doc)
            f.write("  ")
            f.write(d.name)

            f.write("(")
            write_args(d.args)
            if len(d.args) > 1:
                f.write("\n  ")
            f.write(")")

            f.write("\n")

        elif isinstance(d, _Property):
            f.write("\n")
            write_doc(d.doc)
            f.write("  ")

            if d.is_static:
                f.write("static ")

            f.write("var ")
            f.write(d.name)
            f.write(": ")
            f.write(d.type)
            f.write(" { get }\n")

        elif isinstance(d, _Func):
            if d.name in ("hash", "encode"):
                # This one is already in 'Hashable'
                continue

            f.write("\n")
            write_doc(d.doc)
            f.write("  ")

            if d.modifiers:
                f.write(d.modifiers)
                f.write(" ")

            f.write("func ")
            f.write(d.name)

            f.write("(")
            write_args(d.args)
            if len(d.args) > 1:
                f.write("\n  ")
            f.write(")")

            if d.return_type is not None:
                f.write(" -> ")
                f.write(d.return_type)

            f.write("\n")

        elif isinstance(d, _ConditionalCompilation):
            f.write("\n")
            f.write(d.line)
            f.write("\n")

        else:
            assert False, d


@dataclass
class _Struct:
    doc: str
    name: str


@dataclass
class _Typealias:
    doc: str
    name: str


@dataclass
class _Property:
    doc: str
    is_static: bool
    keyword: str
    name: str
    type: str


@dataclass
class _Arg:
    label: str | None
    name: str
    type: str
    default_value: str | None


@dataclass
class _Init:
    doc: str
    name: str
    args: list[_Arg]


@dataclass
class _Func:
    doc: str
    modifiers: str
    name: str
    args: list[_Arg]
    return_type: str | None


@dataclass
class _ConditionalCompilation:
    line: str


_Declaration = (
    _Struct | _Typealias | _Init | _Property | _Func | _ConditionalCompilation
)


def _parse_public_declarations(swift_code: str) -> list[_Declaration]:
    result: list[_Declaration] = []

    lines = swift_code.splitlines()
    line_index = 0
    line_index_end = len(lines)
    doc_lines: list[str] = []

    def get_doc() -> str:
        result = "\n".join(doc_lines)
        doc_lines.clear()
        return result

    def get_function_declaration_lines(initial_index: int) -> list[str]:
        index = initial_index
        result: list[str] = []

        while index != line_index_end:
            line = lines[index]
            result.append(line)
            index += 1

            if "{" in line:
                break

        return result

    while line_index != line_index_end:
        line = lines[line_index].strip()
        current_line_index = line_index
        line_index += 1

        if line.startswith("///"):
            doc_lines.append(line)
            continue

        if line.startswith("#"):
            result.append(_ConditionalCompilation(line))
            doc_lines.clear()
            continue

        if not line.startswith("public"):
            doc_lines.clear()
            continue

        line = line.replace("public", "", 1).strip()

        if _starts_with(line, "struct"):
            r = re.search("struct\\s+(\\w+)", line)
            if r is None:
                assert False, line

            doc = get_doc()
            name = r.group(1)
            result.append(_Struct(doc, name))
            continue

        if _starts_with(line, "typealias"):
            r = re.search("typealias\\s+(\\w+)\\s+=", line)
            if r is None:
                assert False, line

            doc = get_doc()
            name = r.group(1)
            result.append(_Typealias(doc, name))
            continue

        if _starts_with(line, "init"):
            fn_lines = get_function_declaration_lines(current_line_index)
            fn = _parse_func(fn_lines)

            doc = get_doc()
            result.append(_Init(doc, fn.name, fn.args))
            continue

        if _starts_with(line, "let", "var", "static let", "static var"):
            doc = get_doc()

            r = re.search("(static)?\\s*(var|let)\\s+(\\w+)\\s*[=:]\\s*(\\w+)", line)
            if r is None:
                assert False, line

            is_static = r.group(1) is not None
            keyword = r.group(2)
            name = r.group(3)

            type = r.group(4)
            type = "Int" if name == "radix" else type

            result.append(_Property(doc, is_static, keyword, name, type))
            continue

        if _starts_with(
            line, "func", "mutating func", "static func", "static prefix func"
        ):
            fn_lines = get_function_declaration_lines(current_line_index)
            fn = _parse_func(fn_lines)
            fn.doc = get_doc()
            result.append(fn)
            continue

        assert False, "Unknown public declaration: " + line

    return result


def _starts_with(s: str, *args: str) -> bool:
    for a in args:
        if s.startswith(a):
            return True

    return False


def _parse_func(lines: list[str]) -> _Func:
    line = ""

    for l in lines:
        line += " "
        line += l.strip()

    line = line.replace("public", "").strip()
    while "  " in line:
        line = line.replace("  ", " ")

    pattern_name = "([^\\(]+)"  # not '('
    pattern_args = "([^\\)]*)"  # not ')'
    pattern_return_type = "([^{]*)"  # not '{}'
    pattern = f"{pattern_name}\\({pattern_args}\\)\\s*{pattern_return_type}"

    r = re.search(pattern, line)
    if r is None:
        assert False, line

    name_group = r.group(1).replace("func ", "", 1)
    modifiers = ""

    for m in ("mutating ", "static ", "prefix "):
        if m in name_group:
            modifiers += m
            name_group = name_group.replace(m, "", 1)

    modifiers = modifiers.strip()
    name = name_group.strip()

    args: list[_Arg] = []
    args_str = r.group(2).strip()

    if args_str:
        for s in args_str.split(","):
            split = s.split(":")

            label_name = split[0].strip()
            label_name_split = label_name.split(" ")

            if len(label_name_split) == 1:
                label = None
                n = label_name_split[0].strip()
            else:
                label = label_name_split[0].strip()
                n = label_name_split[1].strip()

            type_default = split[1].strip()
            type_default_split = type_default.split("=")
            type = type_default_split[0].strip()

            default = (
                None if len(type_default_split) == 1 else type_default_split[1].strip()
            )

            args.append(_Arg(label, n, type, default))

    return_type: str | None = r.group(3).replace("->", "").strip()
    if not return_type:
        return_type = None

    return _Func("", modifiers, name, args, return_type)


# =================
# === Extension ===
# =================


def _write_extension(f: TextIOWrapper):
    dir = os.path.dirname(__file__)
    extension_file = os.path.join(dir, "DECIMAL_PROTOCOL_EXTENSION.swift")

    with open(extension_file, "r") as ext:
        code = ext.read()

    code = _replace_float_overload(
        code,
        marker="{init_from_float}",
        type_name="Float",
    )

    code = _replace_float_overload(
        code,
        marker="{init_from_double}",
        type_name="Double",
    )

    code = _replace_float_overload(
        code,
        marker="{init_from_float80}",
        type_name="Float80",
    )

    code = _replace_binary_overloads(
        code,
        marker="{binary_overloads_add}",
        fn_name="adding",
        fn_name_mutating="add",
    )

    code = _replace_binary_overloads(
        code,
        marker="{binary_overloads_sub}",
        fn_name="subtracting",
        fn_name_mutating="subtract",
    )

    code = _replace_binary_overloads(
        code,
        marker="{binary_overloads_mul}",
        fn_name="multiplied",
        fn_name_mutating="multiply",
        first_arg_label="by",
    )

    code = _replace_binary_overloads(
        code,
        marker="{binary_overloads_div}",
        fn_name="divided",
        fn_name_mutating="divide",
        first_arg_label="by",
    )

    code = _replace_binary_overloads(
        code,
        marker="{binary_overloads_quantize}",
        fn_name="quantized",
        fn_name_mutating="quantize",
        first_arg_label="to",
    )

    code = _replace_unary_overloads(
        code,
        marker="{unary_overloads_square_root}",
        fn_name="squareRoot",
        fn_name_mutating="formSquareRoot",
        rounding_arg_label="",
        rounding_arg_name="rounding",
        default_rounding="{default_rounding_math}",
    )

    code = _replace_unary_overloads(
        code,
        marker="{unary_overloads_round}",
        fn_name="rounded",
        fn_name_mutating="round",
        rounding_arg_label="_",
        rounding_arg_name="rule",
        default_rounding="{default_rounding_round}",
    )

    code = replace_rounding_in_template(code)
    f.write(code)


def _replace_float_overload(code: str, marker: str, type_name: str) -> str:
    new_code = f"""\
  // overload: only rounding or no args
  public init(
    _ value: {type_name},
    rounding: DecimalFloatingPointRoundingRule = .{{default_rounding_binary_to_decimal_floating_point}}
  ) {{
    var status = DecimalStatus()
    self = Self(value, rounding: rounding, status: &status)
  }}

  // overload: only status
  public init(
    _ value: {type_name},
    status: inout DecimalStatus
  ) {{
    let rounding = DecimalFloatingPointRoundingRule.{{default_rounding_binary_to_decimal_floating_point}}
    self = Self(value, rounding: rounding, status: &status)
  }}

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter value: A floating-point value to be converted.
  public init?(
    exactly value: {type_name},
    status: inout DecimalStatus
  ) {{
    // Separate status to avoid polluting 'status' argument with 'isInexact'.
    // 'rounding' should not matter because any rounding means 'inexact'.
    var s = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.toNearestOrEven
    self = Self(value, rounding: rounding, status: &s)

    if s.isSet(.isInexact) {{
      return nil
    }}

    if s.isBinaryFloatingPointSubnormal {{
      status.set(.isBinaryFloatingPointSubnormal)
    }}
  }}

  // overload: no status
  public init?(exactly value: {type_name}) {{
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.{{default_rounding_binary_to_decimal_floating_point}}
    self = Self(value, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {{
      return nil
    }}
  }}
"""

    if type_name == "Float80":
        new_code = (
            "#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)\n\n"
            + new_code
            + "\n#endif"
        )

    return code.replace(marker, new_code)


def _replace_binary_overloads(
    code: str,
    marker: str,
    fn_name: str,
    fn_name_mutating: str,
    first_arg_label: str = "",
):
    arg_label = first_arg_label or "_"
    call_label = first_arg_label + ": " if first_arg_label else ""

    return code.replace(
        marker,
        f"""\
  public mutating func {fn_name_mutating}(
    {arg_label} other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {{
    self = self.{fn_name}({call_label}other, rounding: rounding, status: &status)
  }}

  // overload: only rounding or no args
  public mutating func {fn_name_mutating}(
    {arg_label} other: Self,
    rounding: DecimalFloatingPointRoundingRule = .{{default_rounding_math}}
  ) {{
    var status = DecimalStatus()
    self = self.{fn_name}({call_label}other, rounding: rounding, status: &status)
  }}

  // overload: only status
  public mutating func {fn_name_mutating}(
    {arg_label} other: Self,
    status: inout DecimalStatus
  ) {{
    let rounding = DecimalFloatingPointRoundingRule.{{default_rounding_math}}
    self = self.{fn_name}({call_label}other, rounding: rounding, status: &status)
  }}

  // overload: only rounding or no args
  public func {fn_name}(
    {arg_label} other: Self,
    rounding: DecimalFloatingPointRoundingRule = .{{default_rounding_math}}
  ) -> Self {{
    var status = DecimalStatus()
    return self.{fn_name}({call_label}other, rounding: rounding, status: &status)
  }}

  // overload: only status
  public func {fn_name}(
    {arg_label} other: Self,
    status: inout DecimalStatus
  ) -> Self {{
    let rounding = DecimalFloatingPointRoundingRule.{{default_rounding_math}}
    return self.{fn_name}({call_label}other, rounding: rounding, status: &status)
  }}\
""",
    )


def _replace_unary_overloads(
    code: str,
    marker: str,
    fn_name: str,
    fn_name_mutating: str,
    rounding_arg_label: str,
    rounding_arg_name: str,
    default_rounding: str,
):
    arg_label = rounding_arg_label + " " if rounding_arg_label else ""
    call_label = "" if rounding_arg_label == "_" else rounding_arg_name + ": "

    return code.replace(
        marker,
        f"""\
  public mutating func {fn_name_mutating}(
    {arg_label}{rounding_arg_name}: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {{
    self = self.{fn_name}({call_label}{rounding_arg_name}, status: &status)
  }}

  // overload: only rounding or no args
  public mutating func {fn_name_mutating}(
    {arg_label}{rounding_arg_name}: DecimalFloatingPointRoundingRule = .{default_rounding}
  ) {{
    var status = DecimalStatus()
    self = self.{fn_name}({call_label}{rounding_arg_name}, status: &status)
  }}

  // overload: only status
  public mutating func {fn_name_mutating}(
    status: inout DecimalStatus
  ) {{
    let {rounding_arg_name} = DecimalFloatingPointRoundingRule.{default_rounding}
    self = self.{fn_name}({call_label}{rounding_arg_name}, status: &status)
  }}

  // overload: only rounding or no args
  public func {fn_name}(
    {arg_label}{rounding_arg_name}: DecimalFloatingPointRoundingRule = .{default_rounding}
  ) -> Self {{
    var status = DecimalStatus()
    return self.{fn_name}({call_label}{rounding_arg_name}, status: &status)
  }}

  // overload: only status
  public func {fn_name}(
    status: inout DecimalStatus
  ) -> Self {{
    let {rounding_arg_name} = DecimalFloatingPointRoundingRule.{default_rounding}
    return self.{fn_name}({call_label}{rounding_arg_name}, status: &status)
  }}\
""",
    )
