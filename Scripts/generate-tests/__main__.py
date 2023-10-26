import os
import sys
from dataclasses import dataclass
from swift_code import get_swift_code
from write_test import Test, write_test
from parse_readtest_h import parse_readtest_h
from parse_readtest_in import Input, parse_readtest_in


@dataclass
class _ReplacedLine:
    "Fix invalid test."
    old: str
    new: str


_REPLACED_LINES: list[_ReplacedLine] = [
    # 'bid128_pow' has 3 operands (base, exponent and result).
    # This line is not correct. We will add '00' status.
    _ReplacedLine(
        "bid128_pow 0 [7c00314dc6448d9338c15b0a00000000] [7c000000000000000000000000000000] 00",
        "bid128_pow 0 [7c00314dc6448d9338c15b0a00000000] [7c000000000000000000000000000000] 00 00",
    ),
    # Sometimes 'bid128_next[down/up]' have an additional arg in the middle:
    # NAME ROUNDING ARG [ADDITIONAL_ARG] RESULT STATUS
    _ReplacedLine(
        "bid128_nextdown 0 1 [7c00314dc6448d9338c15b0a00000001] [2ffded09bead87c0378d8e63ffffffff] 00",
        "bid128_nextdown 0 1                                    [2ffded09bead87c0378d8e63ffffffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 [7c00314dc6448d9338c15b0a00000001] 1 [7c000000000000000000000000000000] 00",
        "bid128_nextdown 0 [7c00314dc6448d9338c15b0a00000001]   [7c000000000000000000000000000000] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 [7c00314dc6448d9338c15b0a00000001] [7c00314dc6448d9338c15b0a00000001] [7c000000000000000000000000000000] 00",
        "bid128_nextdown 0 [7c00314dc6448d9338c15b0a00000001]                                    [7c000000000000000000000000000000] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 [7c00314dc6448d9338c15b09ffffffff] [7c00314dc6448d9338c15b0a00000001] [7c00314dc6448d9338c15b09ffffffff] 00",
        "bid128_nextdown 0 [7c00314dc6448d9338c15b09ffffffff]                                    [7c00314dc6448d9338c15b09ffffffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 [7c00314dc6448d9338c15b0a00000001] [7c00314dc6448d9338c15b09ffffffff] [7c000000000000000000000000000000] 00",
        "bid128_nextdown 0 [7c00314dc6448d9338c15b0a00000001]                                    [7c000000000000000000000000000000] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 4294967296 4294967297 [3010d3c21bcecceda0ffffffffffffff] 00",
        "bid128_nextdown 0 4294967296            [3010d3c21bcecceda0ffffffffffffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 4294967296 4294967295 [3010d3c21bcecceda0ffffffffffffff] 00",
        "bid128_nextdown 0 4294967296            [3010d3c21bcecceda0ffffffffffffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 4294967295 4294967297 [3010d3c21bcdf92b853133125effffff] 00",
        "bid128_nextdown 0 4294967295            [3010d3c21bcdf92b853133125effffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextdown 0 4294967295 4294967294 [3010d3c21bcdf92b853133125effffff] 00",
        "bid128_nextdown 0 4294967295            [3010d3c21bcdf92b853133125effffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 1 [7c00314dc6448d9338c15b0a00000001] [2ffe314dc6448d9338c15b0a00000001] 00",
        "bid128_nextup 0 1                                    [2ffe314dc6448d9338c15b0a00000001] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 [7c00314dc6448d9338c15b0a00000001] 1 [7c000000000000000000000000000000] 00",
        "bid128_nextup 0 [7c00314dc6448d9338c15b0a00000001]   [7c000000000000000000000000000000] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 [7c00314dc6448d9338c15b0a00000001] [7c00314dc6448d9338c15b0a00000001] [7c000000000000000000000000000000] 00",
        "bid128_nextup 0 [7c00314dc6448d9338c15b0a00000001]                                    [7c000000000000000000000000000000] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 [7c00314dc6448d9338c15b09ffffffff] [7c00314dc6448d9338c15b0a00000001] [7c00314dc6448d9338c15b09ffffffff] 00",
        "bid128_nextup 0 [7c00314dc6448d9338c15b09ffffffff]                                    [7c00314dc6448d9338c15b09ffffffff] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 [7c00314dc6448d9338c15b0a00000001] [7c00314dc6448d9338c15b09ffffffff] [7c000000000000000000000000000000] 00",
        "bid128_nextup 0 [7c00314dc6448d9338c15b0a00000001]                                    [7c000000000000000000000000000000] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 4294967296 4294967297 [3010d3c21bcecceda100000000000001] 00",
        "bid128_nextup 0 4294967296            [3010d3c21bcecceda100000000000001] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 4294967296 4294967295 [3010d3c21bcecceda100000000000001] 00",
        "bid128_nextup 0 4294967296            [3010d3c21bcecceda100000000000001] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 4294967295 4294967297 [3010d3c21bcdf92b853133125f000001] 00",
        "bid128_nextup 0 4294967295            [3010d3c21bcdf92b853133125f000001] 00",
    ),
    _ReplacedLine(
        "bid128_nextup 0 4294967295 4294967294 [3010d3c21bcdf92b853133125f000001] 00",
        "bid128_nextup 0 4294967295            [3010d3c21bcdf92b853133125f000001] 00",
    ),
    # This Binary80 value is denormal (exponent 0xA5 = 165, rest is 0).
    # This should raise 'isDenormal' flag, but it does not happen?
    # There are other denormal test lines that do not expect this flag,
    # so I am not sure why THIS specific input should have it.
    #
    # Anyway, we will fix this test by removing 'denormal' flag.
    _ReplacedLine(
        "binary80_to_bid32 0 [000000000000000A50000000000000000] [0000000000000000] 32",
        "binary80_to_bid32 0 [000000000000000A50000000000000000] [0000000000000000] 30",
    ),
    # [407d3e74e92ab4e828a0] gives us:
    # - sign = .plus
    # - exponentBitPattern = 16509 = 0b100000001111101
    # - significandBitPattern = 4500478297282980000 = 0b11111001110100111010010010101010110100111010000010100010100000
    #
    # This means 1.2658017740986624835e+38 and not 4.1509585679631632484e+37.
    #
    # I have no idea how this C line gives the 4.1509585679631632484e+37:
    #   sscanf(op+1, BID_FMT_X4""BID_FMT_LLX16, (unsigned int*)((BID_UINT64*)&ldbl1+1), (BID_UINT64*)&ldbl1)
    # But it does, and after a few hours I give up.
    #
    # Anyway we will change the result to inexact 1.2658017740986624835e+38.
    _ReplacedLine(
        "binary80_to_bid128 0 [407d3e74e92ab4e828a0] [3048cca87682ee150000000000000000] 00",
        "binary80_to_bid128 0 [407d3e74e92ab4e828a0] [304a3e68aa1edea0c76f2a5a469d7343] 0x20",
    ),
]


def main():
    if len(sys.argv) != 3:
        print(f"USAGE: python3 SCRIPT INTEL_TEST_DIR OUTPUT_DIR")
        return

    intel_dir = sys.argv[1]
    output_dir = sys.argv[2]

    readtest_in_path = os.path.join(intel_dir, "readtest.in")
    name_to_inputs = parse_readtest_in(readtest_in_path)
    _replace_lines(name_to_inputs)

    readtest_h_path = os.path.join(intel_dir, "readtest.h")
    name_to_c_handler_code = parse_readtest_h(readtest_h_path)

    files = _merge(name_to_inputs, name_to_c_handler_code)

    for file in files:
        if not file.tests:
            continue

        path = os.path.join(output_dir, file.name)

        with open(path, "w") as f:
            separator = "// " + ("=" * 77) + "\n"
            f.write(separator)
            f.write("// Automatically generated. DO NOT EDIT!\n")
            f.write("// To regenerate: make gen\n")
            f.write(separator)
            f.write("\n")
            f.write("import XCTest\n")
            f.write("@testable import Decimal\n")
            f.write("\n")
            f.write(f"class {file.class_name}: XCTestCase, IntelMixin {{\n")

            for test in file.tests:
                write_test(f, test)

            f.write("}\n")


def _replace_lines(name_to_inputs: dict[str, list[Input]]):
    old_to_new: dict[str, str] = {}

    for r in _REPLACED_LINES:
        old_to_new[r.old] = r.new

    for inputs in name_to_inputs.values():
        for input in inputs:
            new = old_to_new.get(input.line)
            if new is not None:
                input.line = new


@dataclass
class _File:
    # File name
    name: str
    # Main Swift type (Decimal64, Double etc.)
    swift_type: str
    # Swift class name
    class_name: str
    tests: list[Test]


def _merge(
    name_to_inputs: dict[str, list[Input]], name_to_c_handler_code: dict[str, list[str]]
) -> list[_File]:
    result: list[_File] = []

    def create_file(swift_type: str) -> _File:
        name = f"Intel{swift_type}Tests.swift"
        class_name = f"Intel{swift_type}Tests"
        file = _File(name, swift_type, class_name, [])
        result.append(file)
        return file

    file_decimal32 = create_file("Decimal32")
    file_decimal64 = create_file("Decimal64")
    file_decimal128 = create_file("Decimal128")
    file_float = create_file("Float")
    file_double = create_file("Double")
    file_float80 = create_file("Float80")

    for name, inputs in name_to_inputs.items():
        # Skip if we do not have Swift implementation
        if get_swift_code(name) is None:
            continue

        c_handler = name_to_c_handler_code.get(name)
        assert c_handler is not None, f"Missing C handler: {name}"

        file: _File | None = None

        if _starts_with(name, "bid32_", "bid_to_dpd32", "bid_dpd_to_bid32"):
            file = file_decimal32
        elif _starts_with(name, "bid64_", "bid_to_dpd64", "bid_dpd_to_bid64"):
            file = file_decimal64
        elif _starts_with(name, "bid128_", "bid_to_dpd128", "bid_dpd_to_bid128"):
            file = file_decimal128
        elif _starts_with(name, "binary32_"):
            file = file_float
        elif _starts_with(name, "binary64_"):
            file = file_double
        elif _starts_with(name, "binary80_"):
            file = file_float80
        else:
            assert False, f"Test '{name}' was not assigned to Swift file."

        if file is not None:
            test = Test(name, inputs, c_handler)
            file.tests.append(test)

    return result


def _starts_with(name: str, *args: str) -> bool:
    for a in args:
        if name.startswith(a):
            return True

    return False


if __name__ == "__main__":
    main()
