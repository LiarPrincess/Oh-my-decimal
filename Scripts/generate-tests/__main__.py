import os
import sys
import intel
import to_int_tests
import init_from_int_tests
import wide_uint_tests
import speleotrove_dectest


def main():
    if len(sys.argv) != 4:
        print(f"USAGE: python3 SCRIPT INTEL_TEST_DIR SPELEOTROVE_DIR OUTPUT_DIR")
        return

    intel_dir = sys.argv[1]
    speleotrove_dir = sys.argv[2]
    output_dir = sys.argv[3]

    generated_dir = os.path.join(output_dir, "Generated")
    _clean_dir(generated_dir)
    to_int_tests.generate(generated_dir)
    init_from_int_tests.generate(generated_dir)
    wide_uint_tests.generate(generated_dir)

    intel_marker_path = os.path.join(intel_dir, intel.MARKER_FILE)

    if os.path.exists(intel_marker_path):
        intel_output_dir = os.path.join(output_dir, "Intel - generated")
        _clean_dir(intel_output_dir)
        intel.generate(intel_dir, intel_output_dir)
    else:
        print(
            f"WARNING: Skipping Intel tests generation: {intel_marker_path} does not exist."
        )

    speleotrove_marker_path = os.path.join(
        speleotrove_dir, speleotrove_dectest.MARKER_FILE
    )

    if os.path.exists(speleotrove_marker_path):
        speleotrove_output_dir = os.path.join(output_dir, "Speleotrove - generated")
        _clean_dir(speleotrove_output_dir)
        speleotrove_dectest.generate(speleotrove_dir, speleotrove_output_dir)
    else:
        print(
            f"WARNING: Skipping Speleotrove tests generation: {speleotrove_marker_path} does not exist."
        )


def _clean_dir(dir: str):
    os.makedirs(dir, exist_ok=True)

    for name in os.listdir(dir):
        path = os.path.join(dir, name)
        os.unlink(path)

    readme_path = os.path.join(dir, "README.md")
    with open(readme_path, "w") as f:
        f.write(
            """\
All of the files in this directory were automatically generated.
See README in the repository root for details.
"""
        )


if __name__ == "__main__":
    main()
