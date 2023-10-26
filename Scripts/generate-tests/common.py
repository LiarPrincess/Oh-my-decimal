from dataclasses import dataclass

GENERATED_FILE_HEADER = """\
// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================
"""


@dataclass
class DecimalType:
    name: str
    # k, storage width in bits
    bit_width: int
    # p, precision in digits
    precision: int


Decimal32 = DecimalType(name="Decimal32", bit_width=32, precision=7)
Decimal64 = DecimalType(name="Decimal64", bit_width=64, precision=16)
Decimal128 = DecimalType(name="Decimal128", bit_width=128, precision=34)

DECIMAL_TYPES = [Decimal32, Decimal64, Decimal128]


@dataclass
class IntType:
    name: str
    min: int
    max: int

    @property
    def is_signed(self) -> bool:
        return self.min < 0

    @property
    def is_unsigned(self) -> bool:
        return self.min == 0


Int32 = IntType("Int32", min=-2147483648, max=2147483647)
Int64 = IntType("Int64", min=-9223372036854775808, max=9223372036854775807)
UInt32 = IntType("UInt32", min=0, max=4294967295)
UInt64 = IntType("UInt64", min=0, max=18446744073709551615)


class IntToDecimal:
    def __init__(self, d: DecimalType, n: int) -> None:
        n = abs(n)
        count = digit_count(n)

        if d.precision < count:
            self.decimal_exponent = count - d.precision
            pow10 = pow(10, self.decimal_exponent)
            self.decimal_significand = n // pow10
            self.int = self.decimal_significand * pow10
        else:
            self.int = n
            self.decimal_significand = n
            self.decimal_exponent = 0


def digit_count(i: int) -> int:
    assert i >= 0
    return len(str(i))
