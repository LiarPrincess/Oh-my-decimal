import os
from common import GENERATED_HEADER, DECIMAL_TYPES, INT_TYPES, Rounding


def generate(output_dir: str):
    path = os.path.join(output_dir, f"Int+Decimal.swift")

    with open(path, "w") as f:
        f.write(GENERATED_HEADER)

        f.write("\n")
        f.write("// swiftlint:disable line_length\n")
        f.write("\n")
        f.write("extension FixedWidthInteger {\n")

        for d in DECIMAL_TYPES:
            f.write(
                f"""
  // MARK: - {d.name}

  /// Creates an integer from the given floating-point value, rounding using the
  /// specified rounding mode.
  ///
  /// If `source` is outside the bounds of this type after rounding, a runtime
  /// error may occur.
  ///
  ///     let z = UInt(-21.5)
  ///     // Error: ...the result would be less than UInt.min
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  ///   `source` must be representable in this type after rounding.
  /// - Parameter rounding: A rounding rule to be used.
  public init(
    _ source: {d.name},
    rounding: DecimalFloatingPointRoundingRule = .{Rounding.decimal_to_int}
  ) {{
    precondition(
      source._isFinite,
      "{d.name} value cannot be converted to \\(Self.self) because it is either infinite or NaN"
    )

    // This method raises:
    // - isInexact - we don't care
    // - isInvalidOperation - unrepresentable value -> fail
    var status = DecimalStatus()
    self = source._toExactlyInt(rounding: rounding, status: &status)

    if status.isInvalidOperation {{
      // We will make a tiny assumption, but:
      // - this assumption is valid for every Swift.stdlib type
      // - it makes our code trivial
      if source._isNegative {{
        preconditionFailure("{d.name} value cannot be converted to \\(Self.self) because the result would be less than \\(Self.self).min")
      }}

      preconditionFailure("{d.name} value cannot be converted to \\(Self.self) because the result would be greater than \\(Self.self).max")
    }}
  }}

  /// Creates an integer from the given floating-point value, if it can be
  /// represented exactly.
  ///
  /// If the value passed as `source` is not representable exactly, the result
  /// is `nil`. In the following example, the constant `x` is successfully
  /// created from a value of `21.0`, while the attempt to initialize the
  /// constant `y` from `21.5` fails:
  ///
  ///     let x = Int(exactly: 21.0)
  ///     // x == Optional(21)
  ///     let y = Int(exactly: 21.5)
  ///     // y == nil
  ///
  /// - Parameter source: A floating-point value to convert to an integer.
  public init?(exactly source: {d.name}) {{
    guard source.isFinite else {{
      return nil
    }}

    // This method raises:
    // - isInexact - fail
    // - isInvalidOperation - unrepresentable value -> fail
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = DecimalStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    self = source._toExactlyInt(rounding: rounding, status: &status)

    if status.isInvalidOperation {{
      return nil
    }}

    if status.isInexact {{
      return nil
    }}
  }}
"""
            )

        f.write("}\n")
