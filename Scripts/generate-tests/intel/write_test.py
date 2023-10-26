from io import TextIOWrapper
from dataclasses import dataclass
from intel.swift_code import get_swift_code
from intel.parse_readtest_in import InputLine, parse_input
from intel.parse_readtest_h import parse_c_handler_code


@dataclass
class Test:
    # Intel name
    name: str
    # Lines from 'readtest.in'.
    inputs: list[InputLine]
    # Intel code from 'readtest.h'.
    c_handler_code: list[str]


def write_test(f: TextIOWrapper, test: Test):
    name = test.name
    swift_code = get_swift_code(name)

    if swift_code is None:
        return

    handler = parse_c_handler_code(name, test.c_handler_code)
    operands = handler.operands
    has_rounding = handler.has_rounding
    has_status = handler.has_status

    has_ulp = False
    has_str_prefix = False
    has_long_int_size = False
    has_underflow_before_only = False

    f.write(f"\n")
    f.write(f"  func test_{name}() {{\n")

    for input in test.inputs:
        i = parse_input(name, input, operands)

        f.write(f"    self.{name}(")
        f.write(f'"{i.rounding}"')

        for a in i.args:
            f.write(f', "{a.value}"')

        f.write(f', "{i.status}"')

        if i.ulp is not None:
            has_ulp = True
            f.write(f', ulp: "{i.ulp}"')

        if i.str_prefix is not None:
            has_str_prefix = True
            f.write(f', strPrefix: "{i.str_prefix}"')

        if i.long_int_size is not None:
            has_long_int_size = True
            f.write(f', longIntSize: "{i.status}"')

        if i.underflow_before_only:
            has_underflow_before_only = True
            f.write(f", underflowBeforeOnly: true")

        f.write(")\n")

    f.write("  }\n")

    # ========================
    # === Helper arguments ===
    # ========================

    @dataclass
    class Arg:
        argument: str
        binding: str | None
        is_last: bool = False

    args: list[Arg] = []

    def add_arg(argument: str, binding: str = ""):
        "binding: name[: Type] = parsing method"

        if binding:
            split = binding.split("=")
            name = split[0].strip()
            parse = split[1].strip()
            type = ""

            name_split = name.split(":")
            if len(name_split) == 2:
                name = name_split[0].strip()
                type = ": " + name_split[1].strip()

            bind = f"guard let {name}{type} = {parse}(_{name}, file, line) else {{ return }}"
            args.append(Arg(argument, bind))
        else:
            args.append(Arg(argument, None))

    add_arg(
        "_ _rounding: String", "rounding = self.parseRounding" if has_rounding else ""
    )

    has_float80 = False

    for i, arg in enumerate(operands):
        is_first = i == 0
        is_last = i == len(operands) - 1
        n = "expected" if is_last else f"arg{i}"

        # In 'bidXX_from_string' argument is OP_DEC64, we want 'String'.
        if is_first and test.name.endswith("_from_string"):
            add_arg(f"_ {n}: String")

        # In 'bidXX_to_string' result is OP_DEC64, we want 'String'.
        elif is_last and test.name.endswith("_to_string"):
            add_arg(f"_ {n}: String")

        # In 'bid_dpd_to_bidXX' we want 1st arg as Int
        elif is_first and test.name == "bid_dpd_to_bid32":
            add_arg(f"_ _{n}: String", f"{n} = self.parseDenselyPackedDecimal32")
        elif is_first and test.name == "bid_dpd_to_bid64":
            add_arg(f"_ _{n}: String", f"{n} = self.parseDenselyPackedDecimal64")
        elif is_first and test.name == "bid_dpd_to_bid128":
            add_arg(f"_ _{n}: String", f"{n} = self.parseDenselyPackedDecimal128")
        else:
            add_arg(f"_ _{n}: String", f"{n} = self.{arg.swift_parsing_function}")

        has_float80 = has_float80 or arg.swift_type == "Float80"

    add_arg(
        "_ _expectedStatus: String",
        "expectedStatus = self.parseStatus" if has_status else "",
    )

    if has_ulp:
        add_arg(
            f"ulp _ulp: String? = nil",
            f"ulp = self.parseUlp",
        )

    if has_str_prefix:
        add_arg(
            "strPrefix _strPrefix: String? = nil", "strPrefix = self.parseStrPrefix"
        )

    if has_long_int_size:
        add_arg(
            "longIntSize _longIntSize: String? = nil",
            "longIntSize = self.parseLongIntSize",
        )

    if has_underflow_before_only:
        add_arg("underflowBeforeOnly: Bool = false")

    add_arg("file: StaticString = #file")
    add_arg("line: UInt = #line")
    args[-1].is_last = True

    # =========================
    # === Helper definition ===
    # =========================

    f.write(f"\n")
    f.write(f"  private func {name}(\n")

    for a in args:
        f.write("    ")
        f.write(a.argument)
        f.write("" if a.is_last else ",")
        f.write("\n")

    f.write("  ) {\n")

    if has_float80:
        f.write("#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)\n\n")

    for a in args:
        if a.binding is not None:
            f.write("    ")
            f.write(a.binding)
            f.write("\n")

    f.write("\n")

    if has_status:
        f.write(f"    var status = DecimalStatus()\n")

    compare = handler.compare
    swift_compare = "." + compare.swift_enum_value
    swift_code = swift_code.replace("{compare_enum_value}", swift_compare).rstrip()

    f.write(swift_code)
    f.write("\n")

    if has_status:
        f.write(
            f"    self.assertStatus(status, expectedStatus, .{compare.swift_enum_value}, file, line)\n"
        )

    if has_float80:
        f.write("\n#endif\n")

    f.write("  }\n")
