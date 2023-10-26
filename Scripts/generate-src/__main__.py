import sys
import decimals
import int_extensions
import wide_uint_types
import decimal_protocol
import binary_floating_point_extensions
import binary_floating_point_tables


def main():
    if len(sys.argv) != 2:
        print(f"USAGE: python3 SCRIPT OUTPUT_DIR")
        return

    output_dir = sys.argv[1]

    # Decimals have to be before protocol, because the protocol is based on Decimal64.
    decimals.generate(output_dir)
    decimal_protocol.generate(output_dir)

    int_extensions.generate(output_dir)
    wide_uint_types.generate(output_dir)

    binary_floating_point_extensions.generate(output_dir)
    binary_floating_point_tables.generate(output_dir)


if __name__ == "__main__":
    main()
