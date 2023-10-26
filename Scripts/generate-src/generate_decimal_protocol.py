import os
import re
from dataclasses import dataclass
from common import GENERATED_HEADER, replace_rounding_in_template


def generate_decimal_protocol(output_dir: str):
    # We will use this file to generate the protocol.
    decimal_path = os.path.join(output_dir, "Decimal64.swift")

    with open(decimal_path, "r") as f:
        swift_code = f.read()
        decimal_declarations = _parse_public_declarations(swift_code)

    dir = os.path.dirname(__file__)
    extension_file = os.path.join(dir, "PROTOCOL_EXTENSION.swift")

    with open(extension_file, "r") as f:
        extension_code = f.read()

    path = os.path.join(output_dir, f"DecimalFloatingPoint.swift")

    with open(path, "w") as f:
        f.write(GENERATED_HEADER)
        f.write(
            """
// swiftlint:disable operator_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length

// This code was automatically generated based on 'public' operations from Decimal64.
//
// Missing from IEEE-754:
// - convertFromHexCharacter
// - convertToHexCharacter
// - compareQuiet
//   - Ordered
//   - Unordered
// - compareSignaling
//   - Equal
//   - NotEqual
//   - Greater
//   - GreaterEqual
//   - GreaterUnordered
//   - NotGreater
//   - Less
//   - LessEqual
//   - LessUnordered
//   - NotLess
//
// Missing from Swift.FloatingPoint:
// - func truncatingRemainder(dividingBy other: Self) -> Self
// - mutating func formTruncatingRemainder(dividingBy other: Self)
//
// Missing from Swift.BinaryFloatingPoint (for symmetry):
// - associatedtype RawExponent: UnsignedInteger
// - static var exponentBitCount: Int { get }
// - static var significandBitCount: Int { get }
// - var exponentBitPattern: RawExponent { get }
// - var significandBitPattern: RawSignificand { get }
// - var significandWidth: Int { get }
// - init(sign: FloatingPointSign, exponentBitPattern: RawExponent, significandBitPattern: RawSignificand)
//
// Other missing Swift things:
// - random - apart from a few specific input ranges it would not do what user wants:
//     - simple random between 0 and 10**10 would be skewed towards smaller
//       numbers because there are more of them.
//     - if we generated truly random value and then rounded then bigger
//       numbers would be more common (they have bigger ulp).
// - Strideable - really quickly it would break the Sterbenz lemma: y/2 < x < 2y.
//     What is the distance between greatestFiniteMagnitude and leastNormalMagnitude?
// - ExpressibleByFloatLiteral - Swift converts to Float80/Double and then converts
//     to a number. That basically translates to a random number generator.

/// A radix-10 (decimal) floating-point type from IEEE-754.
public protocol DecimalFloatingPoint: Codable,
                                      Equatable, Comparable, Hashable,
                                      ExpressibleByIntegerLiteral,
                                      CustomStringConvertible {
"""
        )

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

        for d in decimal_declarations:
            if isinstance(d, _Struct):
                assert d.name == "Decimal64"

            elif isinstance(d, _Typealias):
                f.write("\n")
                write_doc(d.doc)

                if d.name == "Exponent":
                    f.write("  associatedtype Exponent: FixedWidthInteger\n")
                elif d.name == "RawSignificand":
                    f.write("  associatedtype RawSignificand: FixedWidthInteger\n")
                else:
                    assert False, d.name

            elif isinstance(d, _Init):
                # Conversion is specific to a given width.
                # There is nothing to generalize.
                is_decimal_conversion = False
                if len(d.args) > 0:
                    a = d.args[0]
                    is_decimal_conversion = a.name == "value" and a.type in (
                        "Decimal32",
                        "Decimal64",
                        "Decimal128",
                    )

                if is_decimal_conversion:
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

        f.write("}\n")

        extension_code = replace_rounding_in_template(extension_code)
        f.write(extension_code)


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
