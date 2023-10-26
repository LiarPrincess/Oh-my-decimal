import sys
from generate_decimals import generate_decimals
from generate_int import generate_int_extensions
from generate_decimal_protocol import generate_decimal_protocol
from generate_binary_floating_point import generate_binary_floating_point_extensions


def main():
    if len(sys.argv) != 2:
        print(f"USAGE: python3 SCRIPT OUTPUT_DIR")
        return

    output_dir = sys.argv[1]
    generate_decimals(output_dir)
    generate_decimal_protocol(output_dir)
    generate_int_extensions(output_dir)
    generate_binary_floating_point_extensions(output_dir)


if __name__ == "__main__":
    main()
