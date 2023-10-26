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


def generate_binary_floating_point_extensions(output_dir: str):
    for d in DECIMAL_TYPES:
        path = os.path.join(output_dir, f"BinaryFloatingPoint+{d.name}.swift")

        with open(path, "w") as f:
            f.write(GENERATED_HEADER)

            for i in BINARY_FLOATING_POINT_TYPES:
                _write(f, d, i)


def _write(f: TextIOWrapper, d: DecimalType, b: BinaryFloatingPointType):
    is_float80 = b.name == "Float80"
    if is_float80:
        f.write("\n#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)\n")

    f.write(
        f"""
extension {b.name} {{

  /// Creates a new instance from the given value, rounding using the specified
  /// rounding mode.
  ///
  /// - Parameter source: A floating-point value to be converted.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: {d.name},
    rounding: DecimalFloatingPointRoundingRule = .{Rounding.decimal_to_binary_floating_point}
  ) {{
    var status = ExceptionStatus()
    self = source._to{b.name}(rounding: rounding, status: &status)
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
    let rounding = DecimalFloatingPointRoundingRule.{Rounding.decimal_to_binary_floating_point}

    var status = ExceptionStatus()
    self = source._to{b.name}(rounding: rounding, status: &status)

    if status.isSet(.isInexact) {{
      return nil
    }}
  }}
}}
"""
    )

    if is_float80:
        f.write("\n#endif\n")
