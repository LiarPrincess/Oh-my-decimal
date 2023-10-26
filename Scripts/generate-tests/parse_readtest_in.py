from dataclasses import dataclass
from parse_readtest_h import Operand

# ============
# === File ===
# ============


@dataclass
class Input:
    line_number: int
    line: str


def parse_readtest_in(path: str) -> dict[str, list[Input]]:
    "Returns mapping: intel_test_name -> list of inputs."

    name_to_inputs: dict[str, list[Input]] = dict()

    with open(path, "r") as f:
        for n, line in enumerate(f):
            line = line.strip()

            if not line or line.startswith("--"):  # -- comment
                continue

            split = line.split(" ")
            assert len(split) > 0, line

            name = split[0]
            inputs = name_to_inputs.get(name)

            if inputs is None:
                inputs = []
                name_to_inputs[name] = inputs

            inputs.append(Input(n + 1, line))

    return name_to_inputs


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


def parse_input(test_name: str, input: Input, operands: list[Operand]) -> Arguments:
    # Every line is: NAME ROUNDING ARG1 ARG2 ARG3 STATUS
    line = input.line
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
