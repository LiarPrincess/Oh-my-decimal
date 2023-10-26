from dataclasses import dataclass
from intel.parse_readtest_h import Operand

# ============
# === File ===
# ============


@dataclass
class InputLine:
    number: int
    value: str


@dataclass
class InputTest:
    name: str
    lines: list[InputLine]


def parse_readtest_in(path: str) -> list[InputTest]:
    "Returns mapping: intel_test_name -> list of inputs."

    test_name_to_lines: dict[str, list[InputLine]] = dict()

    with open(path, "r") as f:
        for n, line in enumerate(f):
            line = line.strip()

            if not line or line.startswith("--"):  # -- comment
                continue

            name_end_index = line.find(" ")
            assert name_end_index != -1, "Unable to find name in: " + line

            name = line[:name_end_index]
            lines = test_name_to_lines.get(name)

            if lines is None:
                lines = []
                test_name_to_lines[name] = lines

            l = InputLine(n + 1, line)
            lines.append(l)

    result: list[InputTest] = []

    for name, lines in test_name_to_lines.items():
        t = InputTest(name, lines)
        result.append(t)

    return result


# ============
# === Line ===
# ============


@dataclass
class Argument:
    value: str
    operand: Operand

    @property
    def swift_type(self) -> str:
        return self.operand.swift_type

    @property
    def swift_parsing_function(self) -> str:
        return self.operand.swift_parsing_function


@dataclass
class Arguments:
    rounding: str
    args: list[Argument]
    status: str

    ulp: str | None
    str_prefix: str | None
    long_int_size: str | None
    underflow_before_only: bool


# Rename: parse_input_line
def parse_input(
    test_name: str, input_line: InputLine, operands: list[Operand]
) -> Arguments:
    # Every line is: NAME ROUNDING ARG1 ARG2 ARG3 STATUS
    line = input_line.value
    while "  " in line:
        line = line.replace("  ", " ")

    split = line.split(" ")
    rounding = split[1]
    args: list[Argument] = []

    for i, op in enumerate(operands):
        s = split[2 + i]
        args.append(Argument(s, op))

    status_index = 2 + len(operands)
    status = split[status_index]

    ulp: str | None = None
    str_prefix: str | None = None
    long_int_size: str | None = None
    underflow_before_only = False

    index = status_index + 1
    while index < len(split):
        s = split[index]

        if s == "underflow_before_only" or s == "undefrlow_before_only":
            underflow_before_only = True
        elif s.startswith("ulp="):
            ulp = s[4:]
        elif s.startswith("str_prefix="):
            str_prefix = s[11:]
        elif s.startswith("longintsize="):
            long_int_size = s[12:]
        elif s.startswith("--"):
            # Comment until the end of the line.
            break
        else:
            assert False, "Unknown line suffix: " + s

        index += 1

    return Arguments(
        rounding, args, status, ulp, str_prefix, long_int_size, underflow_before_only
    )
