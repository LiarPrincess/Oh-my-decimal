import os
from io import TextIOWrapper
from common import (
    Rounding,
    DecimalType,
    GENERATED_HEADER,
    DECIMAL_TYPES,
    replace_rounding_in_template,
)


def generate_decimals(output_dir: str):
    dir = os.path.dirname(__file__)
    template_file = os.path.join(dir, "DECIMAL_TEMPLATE.swift")

    with open(template_file, "r") as f:
        template = f.read()

    for d in DECIMAL_TYPES:
        path = os.path.join(output_dir, f"{d.name}.swift")

        with open(path, "w") as f:
            f.write(GENERATED_HEADER)
            f.write("\n")
            t = _specialize(template, d)
            f.write(t)


def _specialize(template: str, d: DecimalType) -> str:
    t = replace_rounding_in_template(template)
    t = t.replace("{name}", d.name)
    t = t.replace("{bit_width}", str(d.bit_width))
    t = t.replace("{bid_type}", str(d.bid_type))
    t = t.replace("{combination_width}", str(d.combination_width))
    t = t.replace("{exponent_bias}", str(d.exponent_bias))
    t = t.replace("{max_unbiased_exponent}", str(d.max_unbiased_exponent))
    t = t.replace("{trailing_significand_width}", str(d.trailing_significand_width))
    t = t.replace("{precision_in_digits}", str(d.precision_in_digits))
    t = t.replace("{max_decimal_digits}", d.max_decimal_digits)
    t = t.replace("{pi_decimal_digits}", d.pi_decimal_digits)

    decimal_conversion = ""

    for source in DECIMAL_TYPES:
        if d.bit_width > source.bit_width:
            decimal_conversion += create_from_smaller(source)
        elif d.bit_width < source.bit_width:
            decimal_conversion += create_from_bigger(source)

    decimal_conversion = decimal_conversion.strip("\n")
    t = t.replace("{decimal_conversion}", decimal_conversion)

    return t


def create_from_smaller(source: DecimalType):
    return f"""
  /// Creates a new instance from the given value.
  ///
  /// - Parameters:
  ///   - value: A floating-point value to be converted.
  public init(_ value: Decimal{source.bit_width}) {{
    var status = ExceptionStatus()
    self = Self._fromDecimal{source.bit_width}(value, status: &status)
  }}
"""


def create_from_bigger(source: DecimalType):
    return f"""
  /// Creates a new instance from the given value, rounded using the specified
  /// rounding rule.
  ///
  /// - Parameters:
  ///   - value: A floating-point value to be converted.
  public init(
    _ value: Decimal{source.bit_width},
    rounding: DecimalFloatingPointRoundingRule = .{Rounding.decimal_to_decimal}
  ) {{
    var status = ExceptionStatus()
    self = Self._fromDecimal{source.bit_width}(value, rounding: rounding, status: &status)
  }}

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter value: A floating-point value to be converted.
  public init?(exactly value: Decimal{source.bit_width}) {{
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.{Rounding.decimal_to_decimal}
    self = Self._fromDecimal{source.bit_width}(value, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {{
      return nil
    }}
  }}
"""
