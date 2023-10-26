import os
from speleotrove_dectest.fix_tests import fix_invalid_tests
from speleotrove_dectest.swift_code import get_swift_code
from speleotrove_dectest.write_test import SwiftLine, write_test
from speleotrove_dectest.parse_file import (
    SpeleotroveLine,
    parse_container_file,
    parse_file,
)

# File used to check if Speleotrove files are present.
MARKER_FILE = "decDouble.decTest"

_CONTAINER_FILES = (
    "decSingle.decTest",
    "decDouble.decTest",
    "decQuad.decTest",
)

_IGNORED_FILES = (
    # We do not have toSci/toEng operations
    "dsBase.decTest",
    "ddBase.decTest",
    "dqBase.decTest",
    # Bit twiddling
    "ddAnd.decTest",
    "dqAnd.decTest",
    "ddInvert.decTest",
    "dqInvert.decTest",
    "ddOr.decTest",
    "dqOr.decTest",
    "ddXor.decTest",
    "dqXor.decTest",
    "ddShift.decTest",
    "dqShift.decTest",
    "ddRotate.decTest",
    "dqRotate.decTest",
)


def generate(speleotrove_dir: str, output_dir: str):
    all_lines: list[SpeleotroveLine] = []

    for container_name in _CONTAINER_FILES:
        container_path = os.path.join(speleotrove_dir, container_name)

        for file_name in parse_container_file(container_path):
            file_name = file_name + ".decTest"

            if file_name not in _IGNORED_FILES:
                file_path = os.path.join(speleotrove_dir, file_name)
                lines = parse_file(file_path)

                fix_invalid_tests(file_name, lines)
                all_lines.extend(lines)

    class_name_to_lines = _group_by_file(all_lines)

    for class_name, lines in class_name_to_lines.items():
        write_test(output_dir, class_name, lines)


def _group_by_file(lines: list[SpeleotroveLine]) -> dict[str, list[SwiftLine]]:
    class_name_to_lines: dict[str, list[SwiftLine]] = dict()

    for speleotrove_line in lines:
        operation = speleotrove_line.operation

        swift = get_swift_code(operation)
        class_name = swift.class_name

        class_lines = class_name_to_lines.get(class_name)

        if class_lines is None:
            class_lines = []
            class_name_to_lines[class_name] = class_lines

        line = SwiftLine(speleotrove_line, swift)
        class_lines.append(line)

    return class_name_to_lines
