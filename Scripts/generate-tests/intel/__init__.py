import os
from dataclasses import dataclass
from common import GENERATED_FILE_HEADER
from intel.swift_code import get_swift_code
from intel.write_test import Test, write_test
from intel.fix_tests import fix_invalid_tests
from intel.parse_readtest_h import IntelTestCode, parse_readtest_h
from intel.parse_readtest_in import InputTest, parse_readtest_in

# File used to check if Intel files are present.
MARKER_FILE = "readtest.in"


def generate(intel_dir: str, output_dir: str):
    readtest_in_path = os.path.join(intel_dir, "readtest.in")
    tests = parse_readtest_in(readtest_in_path)
    fix_invalid_tests(tests)

    readtest_h_path = os.path.join(intel_dir, "readtest.h")
    c_code = parse_readtest_h(readtest_h_path)

    files = _merge(tests, c_code)

    for file in files:
        if not file.tests:
            continue

        file_name = file.name + ".swift"
        path = os.path.join(output_dir, file_name)

        with open(path, "w") as f:
            f.write(GENERATED_FILE_HEADER)
            f.write("\n")
            f.write("import XCTest\n")
            f.write("@testable import Decimal\n")
            f.write("\n")
            f.write(f"class {file.name}: XCTestCase, IntelMixin {{\n")

            for test in file.tests:
                write_test(f, test)

            f.write("}\n")


@dataclass
class _TestFile:
    name: str
    tests: list[Test]


def _merge(tests: list[InputTest], c_code: list[IntelTestCode]) -> list[_TestFile]:
    class_name_to_file: dict[str, _TestFile] = {}
    test_name_to_c_code: dict[str, list[str]] = {}

    for h in c_code:
        name = h.test_name
        assert name not in test_name_to_c_code, f"Duplicate: " + name
        test_name_to_c_code[name] = h.lines

    for test in tests:
        test_name = test.name

        # Skip if we do not have Swift implementation
        if get_swift_code(test_name) is None:
            continue

        code = test_name_to_c_code.get(test_name)
        assert code is not None, f"Missing C code: {test_name}"

        class_name = _get_swift_class_name(test_name)
        file = class_name_to_file.get(class_name)

        if file is None:
            file = _TestFile(class_name, [])
            class_name_to_file[class_name] = file

        test = Test(test_name, test.lines, code)
        file.tests.append(test)

    result: list[_TestFile] = []

    for file in list(class_name_to_file.values()):
        file.tests = sorted(file.tests, key=_by_bit_width)
        result.append(file)

    return result


def _get_swift_class_name(test_name: str) -> str:
    if _ends_with(
        test_name,
        "_isCanonical",
        "_isFinite",
        "_isInf",
        "_isNaN",
        "_isNormal",
        "_isSignaling",
        "_isSigned",
        "_isSubnormal",
        "_isZero",
        "_abs",
        "_class",
    ):
        return "IntelPropertyTests"

    if _ends_with(test_name, "_negate"):
        return "IntelUnaryTests"

    if _ends_with(test_name, "_add"):
        return "IntelAddTests"

    if _ends_with(test_name, "_sub"):
        return "IntelSubTests"

    if _ends_with(test_name, "_div"):
        return "IntelDivTests"

    if _ends_with(test_name, "_rem"):
        return "IntelRemTests"

    if _ends_with(test_name, "_mul"):
        return "IntelMulTests"

    if _ends_with(test_name, "_fma"):
        return "IntelFusedMultiplyAddTests"

    if _ends_with(test_name, "_sqrt"):
        return "IntelSquareRootTests"

    if _ends_with(test_name, "_to_string"):
        return "IntelToStringTests"

    if _ends_with(test_name, "_from_string"):
        return "IntelFromStringTests"

    if _contains(test_name, "_to_int", "_to_uint"):
        return "IntelToIntTests"

    if _contains(test_name, "_from_int", "_from_uint"):
        return "IntelFromIntTests"

    if _ends_with(test_name, "_to_binary32", "_to_binary64", "_to_binary80"):
        return "IntelToBinaryFloatingPointTests"

    if _starts_with(test_name, "binary32_to_", "binary64_to_", "binary80_to_"):
        return "IntelFromBinaryFloatingPointTests"

    if _ends_with(test_name, "_to_dpd128", "_to_dpd32", "_to_dpd64"):
        return "IntelToDenselyPackedDecimalTests"

    if _starts_with(test_name, "bid_dpd_to_"):
        return "IntelFromDenselyPackedDecimalTests"

    if _ends_with(test_name, "_to_bid32", "_to_bid64", "_to_bid128"):
        return "IntelFromDecimalTests"

    if _ends_with(test_name, "_nextdown", "_nextup"):
        return "IntelNextTests"

    if _ends_with(test_name, "quiet_equal", "quiet_not_equal"):
        return "IntelEqualTests"

    if _ends_with(
        test_name,
        "quiet_greater",
        "quiet_greater_equal",
        "quiet_greater_unordered",
        "quiet_not_greater",
        "quiet_less",
        "quiet_less_equal",
        "quiet_less_unordered",
        "quiet_not_less",
    ):
        return "IntelCompareTests"

    if _ends_with(test_name, "_maxnum", "_maxnum_mag", "_minnum", "_minnum_mag"):
        return "IntelMinMaxNumberTests"

    if _ends_with(test_name, "_totalOrder", "_totalOrderMag"):
        return "IntelTotalOrderTests"

    if _ends_with(test_name, "_scalbln", "_scalbn", "_frexp", "_ilogb"):
        return "IntelLogScaleTests"

    if _ends_with(test_name, "_quantum", "_sameQuantum", "_quantize"):
        return "IntelQuantumTests"

    if _contains(test_name, "_round_integral_"):
        return "IntelRoundTests"

    if _ends_with(
        test_name,
        "_copy",  # Does nothing
        "_copySign",  # Decimal{bit_width}(signOf: arg1, magnitudeOf: arg0)
        "_inf",  # Decimal{bit_width}.infinity
        "_nan",  # Decimal{bit_width}(nan: payload, signaling: false)
        "_radix",  # Decimal{bit_width}.radix
    ):
        return "IntelOtherTests"

    assert False, f"Test '{test_name}' was not assigned to Swift file."


def _starts_with(name: str, *args: str) -> bool:
    for a in args:
        if name.startswith(a):
            return True

    return False


def _ends_with(name: str, *args: str) -> bool:
    for a in args:
        if name.endswith(a):
            return True

    return False


def _contains(name: str, *args: str) -> bool:
    for a in args:
        if a in name:
            return True

    return False


def _by_bit_width(t: Test) -> str:
    "Sorting function."
    return t.name.replace("bid32", "bid032").replace("bid64", "bid064")
