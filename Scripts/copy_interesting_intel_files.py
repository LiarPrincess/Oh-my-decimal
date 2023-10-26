"""
Select interesting files from Intel library and link them in separate dir.
"""

import os
import sys
import pathlib

# Interesting files
# Format: INPUT_FILE [OUTPUT_PATH]
FILES = """
bid_functions.h
bid_internal.h
bid_conf.h
bid_div_macros.h

bid_from_int.c
bid_dpd.c
bid_decimal_data.c bid_decimal_data_TABLES.c
bid_convert_data.c bid_convert_data_TABLES2.c
bid128.c bid128_bid_nr_digits.c
bid_binarydecimal.c

bid{bit_width}_noncomp.c bid{bit_width}_noncomp_PROPERTIES.c

bid{bit_width}_next.c next/

bid{bit_width}_compare.c compare/
bid{bit_width}_minmax.c compare/

bid{bit_width}_logb.c logb/
bid{bit_width}_logbd.c logb/
bid{bit_width}_scalb.c logb/
bid{bit_width}_scalbl.c logb/
bid{bit_width}_frexp.c logb/

bid_round.c round/
bid{bit_width}_round_integral.c round/

bid{bit_width}_add.c op/
bid{bit_width}_mul.c op/
bid{bit_width}_div.c op/
bid{bit_width}_rem.c op/

bid{bit_width}_fma.c op_special/
bid{bit_width}_pow.c op_special/
bid{bit_width}_sqrt.c op_special/

bid{bit_width}_string.c string/

bid{bit_width}_quantumd.c quantum/

TESTS/readtest.c
TESTS/readtest.h
TESTS/readtest.in
TESTS/test_bid_conf.h
TESTS/test_bid_functions.h
"""


def main():
    if len(sys.argv) != 3:
        print(f"USAGE: python3 SCRIPT INTEL_TEST_DIR OUTPUT_DIR")
        return

    source_dir = os.path.abspath(sys.argv[1])
    output_dir = os.path.abspath(sys.argv[2])
    common = os.path.commonprefix([source_dir, output_dir])

    for line in FILES.splitlines():
        line = line.strip()

        if not line or line.startswith("#"):
            continue

        split = line.split(" ")

        if len(split) == 1:
            source_name = line
            link_name = line
        elif len(split) == 2:
            source_name = split[0]
            is_link_dir = split[1].endswith("/")
            link_name = split[1] + split[0] if is_link_dir else split[1]
        else:
            assert False, line

        source_inner_dir = "" if source_name.startswith("TESTS/") else "LIBRARY/src"
        source_path = os.path.join(source_dir, source_inner_dir, source_name)
        link_path = os.path.join(output_dir, link_name)

        for width in ("32", "64", "128"):
            s = source_path.replace("{bit_width}", width)
            l = link_path.replace("{bit_width}", width)

            print(l.replace(common, ""), "->", s.replace(common, ""))

            try:
                link_dir = os.path.dirname(l)
                pathlib.Path(link_dir).mkdir(parents=True, exist_ok=True)
            except IOError:
                pass

            try:
                os.remove(l)
            except IOError:
                pass

            pathlib.Path(l).symlink_to(s)

            # No variable -> link just once
            if "{bit_width}" not in source_path:
                break


if __name__ == "__main__":
    main()
