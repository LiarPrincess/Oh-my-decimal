from io import TextIOWrapper
from dataclasses import dataclass


# ============
# === File ===
# ============


@dataclass
class _Test:
    name: str
    # C code inside
    code: list[str]


class _LineReader:
    def __init__(self, f: TextIOWrapper) -> None:
        self.line_number = -1
        self.__line_start = 0
        self.__f = f

    def read_line(self) -> str | None:
        self.line_number += 1
        self.__line_start = self.__f.tell()
        line = self.__f.readline()
        return None if line == "" else line.rstrip()

    def push_back_line(self):
        self.__f.seek(self.__line_start)


def _parse_test(reader: _LineReader) -> _Test | None:
    while True:
        line = reader.read_line()
        line_number = reader.line_number

        is_conditional = line == "#if __ENABLE_BINARY80__" or line == "#endif"
        if not is_conditional:
            break

    if line is None:
        return None

    assert _is_test_start(
        line
    ), f"Expected '{line}' (line {line_number}) to start a new test."

    name_split = line.split('"')
    assert len(name_split) == 3

    name = name_split[1]
    code: list[str] = list()
    line = reader.read_line()

    while line is not None:
        is_test_end = line == "}"
        if is_test_end:
            break

        code.append(line)
        line = reader.read_line()

    return _Test(name, code)


def _is_test_start(line: str) -> bool:
    return _starts_with(line, "if(strcmp(func,")


def parse_readtest_h(path: str) -> dict[str, list[str]]:
    "Returns mapping: intel_test_name -> handler C code."

    result: dict[str, list[str]] = dict()

    with open(path, "r") as f:
        reader = _LineReader(f)
        line = ""

        # Skip header
        while line is not None and not _is_test_start(line):
            line = reader.read_line()

        assert line is not None, "Skipping pash header skipped the whole file."

        # Put back the initial test line
        reader.push_back_line()

        while True:
            test = _parse_test(reader)
            if test is None:
                break
            else:
                name = test.name

                if name in result:
                    # 'bidXX_fmod' functions have duplicates.
                    if name.endswith("_fmod"):
                        pass
                    else:
                        assert False, f"Duplicate {name}."

                result[name] = test.code

    return result


# ==============
# === C code ===
# ==============


@dataclass
class Operand:
    name: str
    swift_type: str
    swift_parsing_function: str


_OPERANDS = (
    # BID encoding
    Operand("OP_DEC32", "Decimal32", "parseDecimal32"),
    Operand("OP_DEC64", "Decimal64", "parseDecimal64"),
    Operand("OP_DEC128", "Decimal128", "parseDecimal128"),
    # DPD encoding
    Operand("OP_DPD32", "UInt32", "parseDenselyPackedDecimal32"),
    Operand("OP_DPD64", "UInt64", "parseDenselyPackedDecimal64"),
    Operand("OP_DPD128", "UInt128", "parseDenselyPackedDecimal128"),
    # Binary floating point
    Operand("OP_BIN32", "Float", "parseFloat"),
    Operand("OP_BIN64", "Double", "parseDouble"),
    Operand("OP_BIN80", "Float80", "parseFloat80"),
    # Operand("OP_BIN128", "", ""),
    # Int
    Operand("OP_INT8", "Int8", "parseInt8"),
    Operand("OP_INT16", "Int16", "parseInt16"),
    Operand("OP_INT32", "Int32", "parseInt32"),
    Operand("OP_INT64", "Int64", "parseInt64"),
    # UInt
    Operand("OP_BID_UINT8", "UInt8", "parseUInt8"),
    Operand("OP_BID_UINT16", "UInt16", "parseUInt16"),
    Operand("OP_BID_UINT32", "UInt32", "parseUInt32"),
    Operand("OP_BID_UINT64", "UInt64", "parseUInt64"),
    # Other
    # Operand("OP_NONE", "", ""),
    # Operand("OP_STRING", "", ""),
    Operand("OP_LINT", "Int", "parseInt"),
)


@dataclass
class Compare:
    name: str
    swift_enum_value: str


# expected_status != *pfpsf
# check64 (R64, Q64) // return a == b ? 0 : 1
# i1 != i2
# Qi64 != qi64
# R64_1 != B64
COMPARE_FUZZY_STATUS = Compare("CMP_FUZZYSTATUS", "fuzzyStatus")
# check64 (R64, Q64)
# BIDECIMAL_CALL2_NORND (bid64_quiet_not_equal, Q64, R64);
# expected_status != *pfpsf
COMPARE_EQUAL_STATUS = Compare("CMP_EQUALSTATUS", "equalStatus")
# check64_rel(R64, Q64)
# (expected_status&trans_flags_mask) != (*pfpsf&trans_flags_mask)
COMPARE_RELATIVE_ERROR = Compare("CMP_RELATIVEERR", "relativeError")

# Not used
# COMPARE_EXACT = Compare("CMP_EXACT", "exact")
# COMPARE_EXACT_STATUS = Compare("CMP_EXACTSTATUS", "exactStatus")
# COMPARE_FUZZY = Compare("CMP_FUZZY", "fuzzy")
# COMPARE_EQUAL = Compare("CMP_EQUAL", "equal")
# COMPARE_NONE = Compare("CMP_NONE", "none")


@dataclass
class CHandler:
    operands: list[Operand]
    has_rounding: bool
    has_status: bool
    compare: Compare


def parse_c_handler_code(test_name: str, code: list[str]) -> CHandler:
    get_test: str | None = None
    call: str | None = None
    check_results: str | None = None
    error_prefix = f"Unable to parse c handler for {test_name}: "

    for line in code:
        line = line.strip()

        if line in ("{", "}", "*pfpsf = fpsf_0; save_binary_status();", "fpsf_0 = 0;"):
            pass
        elif line.startswith("GETTEST"):
            get_test = line
        elif line.startswith("BIDECIMAL_CALL"):
            call = line
        elif line.startswith("check_results"):
            check_results = line
        elif test_name.endswith("_nan"):
            # We will allow different lines in 'bidXX_nan' tests.
            pass
        else:
            assert False, error_prefix + f"invalid line pattern: '{line}'."

    assert get_test is not None, error_prefix + "missing 'get_test' line."
    assert call is not None, error_prefix + "missing 'call' line."
    assert check_results is not None, error_prefix + "missing 'check_results' line."

    # ================
    # === Operands ===
    # ================

    assert _starts_with(get_test, "GETTEST1(", "GETTEST2(", "GETTEST3("), (
        error_prefix + "unknown test GETTER: " + get_test
    )

    operands: list[Operand] = []
    operands_str = _get_string_between_brackets(get_test)

    for operand_name in operands_str.split(","):
        operand: Operand | None = None
        operand_name = operand_name.strip()

        for o in _OPERANDS:
            if o.name == operand_name:
                operand = o
                break

        assert operand is not None, (
            error_prefix + "unimplemented OPERAND: " + operand_name
        )
        operands.append(operand)

    # GETTEST 1st argument is the result followed by arguments.
    # In file the result is last.
    # We will follow the file order.
    #
    # File reading:
    #  sscanf (line, "%s %d %s %s %x",       funcstr, &rnd_mode, op1,           res, &expected_status)
    #  sscanf (line, "%s %d %s %s %s %x",    funcstr, &rnd_mode, op1, op2,      res, &expected_status)
    #  sscanf (line, "%s %d %s %s %s %s %x", funcstr, &rnd_mode, op1, op2, op3, res, &expected_status)
    #
    # Get test:
    #  GETTEST1(res,op1)         op1type = (op1);                                   restype = (res); get_test();
    #  GETTEST2(res,op1,op2)     op1type = (op1); op2type = (op2);                  restype = (res); get_test();
    #  GETTEST3(res,op1,op2,op3) op1type = (op1); op2type = (op2); op3type = (op3); restype = (res); get_test();
    result_operand = operands.pop(0)
    operands.append(result_operand)

    # ============
    # === Call ===
    # ============

    has_rounding = True
    has_status = True

    # Longer names have to be 1st!
    if _starts_with(call, "BIDECIMAL_CALLV_EMPTY("):
        pass
    elif _starts_with(call, "BIDECIMAL_CALL1_NORND(", "BIDECIMAL_CALL2_NORND("):
        has_rounding = False
    elif _starts_with(
        call, "BIDECIMAL_CALL1_NORND_NOSTAT(", "BIDECIMAL_CALL2_NORND_NOSTAT("
    ):
        has_status = False
        has_rounding = False
    elif _starts_with(call, "BIDECIMAL_CALL1_NORND_RESREF("):
        has_rounding = False
    elif _starts_with(call, "BIDECIMAL_CALL2_NORND_NOFLAGS_NOMASK_NOINFO_ARG2REF("):
        # 'frexp' has rounding
        has_rounding = test_name.endswith("_frexp")
    elif _starts_with(call, "BIDECIMAL_CALL1_NORND_NOFLAGS_NOMASK_NOINFO_ARGREF("):
        has_status = False
        has_rounding = False
    elif _starts_with(call, "BIDECIMAL_CALL1_RESARG("):
        pass
    elif _starts_with(call, "BIDECIMAL_CALL1(", "BIDECIMAL_CALL2(", "BIDECIMAL_CALL3("):
        pass
    else:
        assert False, error_prefix + "unknown CALL function: " + call

    # ==============
    # === Assert ===
    # ==============

    compare_str = _get_string_between_brackets(check_results)

    if compare_str == COMPARE_FUZZY_STATUS.name:
        compare = COMPARE_FUZZY_STATUS
    elif compare_str == COMPARE_EQUAL_STATUS.name:
        compare = COMPARE_EQUAL_STATUS
    elif compare_str == COMPARE_RELATIVE_ERROR.name:
        compare = COMPARE_RELATIVE_ERROR
    else:
        assert False, error_prefix + "unknown COMPARE: " + compare_str

    return CHandler(operands, has_rounding, has_status, compare)


def _get_string_between_brackets(s: str) -> str:
    "Get text between brackets"
    left_index = s.index("(")
    right_index = s.index(")")
    return s[left_index + 1 : right_index]


def _starts_with(s: str, *args: str) -> bool:
    s = s.replace(" ", "")

    for p in args:
        if s.startswith(p):
            return True

    return False
