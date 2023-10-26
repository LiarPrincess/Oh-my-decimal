import os
from io import TextIOWrapper
from common import (
    DecimalType,
    IntType,
    AnyIntType,
    GENERATED_HEADER,
    DECIMAL_TYPES,
    INT_TYPES,
    Rounding,
)


def generate_int_extensions(output_dir: str):
    for d in DECIMAL_TYPES:
        path = os.path.join(output_dir, f"Int+{d.name}.swift")

        with open(path, "w") as f:
            f.write(GENERATED_HEADER)
            f.write("\n")
            f.write("import Cbid\n")
            f.write("\n")
            f.write("// swiftlint:disable line_length\n")
            f.write("// swiftlint:disable file_length\n")

            for i in INT_TYPES:
                _write(f, d, i)


def _write(f: TextIOWrapper, d: DecimalType, i: AnyIntType):
    if isinstance(i, IntType):
        init_fn = i.int64_type
        cast_result = f"Self(result) // Range checks guarantee no trap"
        int_precondition = f"""
    precondition(
      {i.name}.bitWidth == 32 || {i.name}.bitWidth == 64,
      "{d.name} value cannot be converted to \\({i.name}.bitWidth) bit {i.name} (expected 32 or 64 bit)."
    )
"""
    else:
        init_fn = "Self"
        cast_result = "result"
        int_precondition = ""

    # ===========
    # === Int ===
    # ===========

    f.write(
        f"""
// MARK: - {i.name}

// If min/max are exactly representable -> no rounding is needed.
// Not exactly representable -> away from zero -> outside of range.
private let min{i.name} = {d.name}({i.name}.min, rounding: .towardZero)
private let max{i.name} = {d.name}({i.name}.max, rounding: .towardZero)

extension {i.name} {{

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
      source.isFinite,
      "{d.name} value cannot be converted to {i.name} because it is either infinite or NaN"
    )
    precondition(
      source >= min{i.name},
      "{d.name} value cannot be converted to {i.name} because the result would be less than {i.name}.min"
    )
    precondition(
      source <= max{i.name},
      "{d.name} value cannot be converted to {i.name} because the result would be greater than {i.name}.max"
    )
{int_precondition}
    var status = ExceptionStatus()
    let result = {init_fn}(source, rounding: rounding, status: &status)
    self = {cast_result}
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
    guard source.isFinite else {{ return nil }}
    guard source >= min{i.name} else {{ return nil }}
    guard source <= max{i.name} else {{ return nil }}
{int_precondition}
    // 'rounding' should not matter because any rounding means 'inexact'.
    var status = ExceptionStatus()
    let rounding = DecimalFloatingPointRoundingRule.towardZero
    let result = {init_fn}(exactly: source, rounding: rounding, status: &status)

    if status.isSet(.isInexact) {{
      return nil
    }}

    self = {cast_result}
  }}
"""
    )

    if not isinstance(i, IntType):
        f.write(
            f"""
  /// Method for Intel tests.
  internal init(
    _ source: {d.name},
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {{
    switch rounding {{
    case .toNearestOrEven:         self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_rnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_rninta, status: &status)
    case .up:         self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_ceil,  status: &status)
    case .down:       self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_floor, status: &status)
    case .towardZero: self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_int,   status: &status)
    }}
  }}

  /// Method for Intel tests.
  /// If result is not 'exactly' then it will set 'status.isInexact'.
  internal init(
    exactly source: {d.name},
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) {{
    switch rounding {{
    case .toNearestOrEven:         self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_xrnint,  status: &status)
    case .toNearestOrAwayFromZero: self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_xrninta, status: &status)
    case .up:         self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_xceil,  status: &status)
    case .down:       self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_xfloor, status: &status)
    case .towardZero: self = source._toInt(__bid{d.bit_width}_to_{i.intel_name}_xint,   status: &status)
    }}
  }}
"""
        )

    f.write("}\n")
