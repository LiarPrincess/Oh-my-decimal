import os
from io import TextIOWrapper
from common import (
    DecimalType,
    BinaryFloatingPointType,
    GENERATED_HEADER,
    DECIMAL_TYPES,
    BINARY_FLOATING_POINT_TYPES,
    Rounding,
)


def generate(output_dir: str):
    path = os.path.join(output_dir, f"BinaryFloatingPoint+Decimal.swift")

    with open(path, "w") as f:
        f.write(GENERATED_HEADER)

        for b in BINARY_FLOATING_POINT_TYPES:
            is_float80 = b.name == "Float80"

            f.write("\n")
            f.write(f"// MARK: - {b.name}\n")

            if is_float80:
                f.write("\n")
                f.write(
                    "#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)\n"
                )

            f.write("\n")
            f.write(f"extension {b.name} {{\n")

            for d in DECIMAL_TYPES:
                f.write(
                    f"""
  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: {d.name},
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) {{
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }}

  // overload: only rounding or no args
  public init(
    _ source: {d.name},
    rounding: DecimalFloatingPointRoundingRule = .{Rounding.decimal_to_binary_floating_point}
  ) {{
    var status = DecimalStatus()
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }}

  // overload: only status
  public init(
    _ source: {d.name},
    status: inout DecimalStatus
  ) {{
    let rounding = DecimalFloatingPointRoundingRule.{Rounding.decimal_to_binary_floating_point}
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)
  }}

  /// Creates a new instance from the given value, if it can be represented
  /// exactly.
  ///
  /// If the given floating-point value cannot be represented exactly, the
  /// result is `nil`. A value that is NaN ("not a number") cannot be
  /// represented exactly if its payload cannot be encoded exactly.
  ///
  /// - Parameter source: A floating-point value to be converted.
  public init?(exactly source: {d.name}) {{
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.{Rounding.decimal_to_binary_floating_point}
    self = Self._initFromDecimal(source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {{
      return nil
    }}
  }}
"""
                )

            f.write("}\n")

            if is_float80:
                f.write("\n#endif\n")
