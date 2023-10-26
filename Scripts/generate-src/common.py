from dataclasses import dataclass

GENERATED_HEADER = """\
// =============================================================================
// Automatically generated. DO NOT EDIT!
// To regenerate: make gen
// =============================================================================
"""

# ===============
# === Decimal ===
# ===============


@dataclass
class DecimalType:
    """
    See 'DecimalMixin' for the meaning of those fields.
    Mostly from IEEE-754: Table 3.6 — Decimal interchange format parameters 0
    """

    name: str
    bit_width: int
    bid_type: str
    # w +5, combination field width in bits
    combination_width: int
    # bias, E − q
    exponent_bias: int
    # emax
    max_unbiased_exponent: int
    # t, trailing significand field width in bits
    trailing_significand_width: int
    # p, precision in digits
    precision_in_digits: int
    max_decimal_digits: str
    pi_decimal_digits: str


DECIMAL_TYPES = [
    DecimalType(
        name="Decimal32",
        bit_width=32,
        bid_type="UInt32",
        combination_width=11,
        exponent_bias=101,
        max_unbiased_exponent=96,
        trailing_significand_width=20,
        precision_in_digits=7,
        max_decimal_digits="9_999_999",
        pi_decimal_digits="3_141_592",
    ),
    DecimalType(
        name="Decimal64",
        bit_width=64,
        bid_type="UInt64",
        combination_width=13,
        exponent_bias=398,
        max_unbiased_exponent=384,
        trailing_significand_width=50,
        precision_in_digits=16,
        max_decimal_digits="9_999_999_999_999_999",
        pi_decimal_digits="3_141_592_653_589_793",
    ),
    DecimalType(
        name="Decimal128",
        bit_width=128,
        bid_type="BID_UINT128",
        combination_width=17,
        exponent_bias=6176,
        max_unbiased_exponent=6144,
        trailing_significand_width=110,
        precision_in_digits=34,
        max_decimal_digits='BID("9999999999999999999999999999999999")! // 9_999_999_999_999_999_999_999_999_999_999_999',
        pi_decimal_digits='BID("3141592653589793238462643383279502")! // 3_141_592_653_589_793_238_462_643_383_279_502',
    ),
]


# ===========
# === Int ===
# ===========


@dataclass
class IntType:
    "Int, UInt"
    name: str
    int64_type: str


@dataclass
class IntWidthType:
    "Int64, UInt64 etc."
    name: str
    intel_name: str


AnyIntType = IntType | IntWidthType

INT_TYPES: list[AnyIntType] = [
    IntType("Int", "Int64"),
    IntType("UInt", "UInt64"),
    IntWidthType("Int8", "int8"),
    IntWidthType("UInt8", "uint8"),
    IntWidthType("Int16", "int16"),
    IntWidthType("UInt16", "uint16"),
    IntWidthType("Int32", "int32"),
    IntWidthType("UInt32", "uint32"),
    IntWidthType("Int64", "int64"),
    IntWidthType("UInt64", "uint64"),
]


# =============================
# === Binary floating point ===
# =============================


@dataclass
class BinaryFloatingPointType:
    "Float, Double, Float80"
    name: str


BINARY_FLOATING_POINT_TYPES: list[BinaryFloatingPointType] = [
    BinaryFloatingPointType("Float"),
    BinaryFloatingPointType("Double"),
    BinaryFloatingPointType("Float80"),
]


# ================
# === Rounding ===
# ================


class Rounding:
    "Default rounding direction."

    # From Swift stdlib -> FloatingPointParsing.swift:
    #
    # /// A decimal or hexadecimal string is converted to a `Double`
    # /// instance using the IEEE 754 roundTiesToEven (default) rounding
    # /// attribute.
    string_to_decimal = "toNearestOrEven"

    # From Swift stdlib -> Integers.swift:
    #
    # public protocol BinaryInteger {
    #   /// Creates an integer from the given floating-point value, rounding toward
    #   /// zero.
    #   ///
    #   /// Any fractional part of the value passed as `source` is removed, rounding
    #   /// the value toward zero.
    #   ///
    #   ///     let x = Int(21.5)
    #   ///     // x == 21
    #   ///     let y = Int(-21.5)
    #   ///     // y == -21
    #   init<T: BinaryFloatingPoint>(_ source: T)
    decimal_to_int = "towardZero"
    # From Swift stdlib -> FloatingPoint.swift:
    #
    # public protocol BinaryFloatingPoint {
    #   /// Creates a new value, rounded to the closest possible representation.
    #   ///
    #   /// If two representable values are equally close, the result is the value
    #   /// with more trailing zeros in its significand bit pattern.
    #   public init<Source: BinaryInteger>(_ value: Source)
    #
    # NOTE: This is not an exact match for the Swift rule.
    int_to_decimal = "toNearestOrEven"

    # From Swift stdlib -> FloatingPoint.swift (BinaryFloatingPoint -> BinaryFloatingPoint):
    #
    # extension BinaryFloatingPoint {
    #   static func _convert<Source: BinaryFloatingPoint>(
    #     from source: Source
    #   ) -> (value: Self, exact: Bool) {
    #     (…)
    #     // If two representable values are equally close, we return the value with
    #     // more trailing zeros in its significand bit pattern.
    #
    # NOTE: This is not an exact match for the Swift rule.
    decimal_to_binary_floating_point = "toNearestOrEven"
    binary_to_decimal_floating_point = "toNearestOrEven"

    decimal_to_decimal = "toNearestOrEven"

    # Bankers rounding. Obviously…
    math = "toNearestOrEven"
    # This one is hard to chose.
    quantize = "toNearestOrEven"
    # IEEE-754 scaleB operation
    scaleb = "toNearestOrEven"
    # From Swift stdlib -> FloatingPoint.swift:
    #
    # extension FloatingPoint {
    #   @_transparent
    #   public mutating func round() {
    #     round(.toNearestOrAwayFromZero)
    #   }
    round = "toNearestOrAwayFromZero"


_ROUNDING_REPLACEMENTS: dict[str, str] = {
    "{default_rounding_string_to_decimal}": Rounding.string_to_decimal,
    "{default_rounding_decimal_to_int}": Rounding.decimal_to_int,
    "{default_rounding_int_to_decimal}": Rounding.int_to_decimal,
    "{default_rounding_decimal_to_binary_floating_point}": Rounding.decimal_to_binary_floating_point,
    "{default_rounding_binary_to_decimal_floating_point}": Rounding.binary_to_decimal_floating_point,
    "{default_rounding_decimal_to_decimal}": Rounding.decimal_to_decimal,
    "{default_rounding_math}": Rounding.math,
    "{default_rounding_scaleb}": Rounding.scaleb,
    "{default_rounding_quantize}": Rounding.quantize,
    "{default_rounding_round}": Rounding.round,
}


def replace_rounding_in_template(template: str) -> str:
    for key, value in _ROUNDING_REPLACEMENTS.items():
        template = template.replace(key, "." + value)

    return template
