from dataclasses import dataclass

_TEST_NAME_TO_SWIFT_CODE: dict[str, str] = dict()
_NOT_IMPLEMENTED_TEST_NAMES: set[str] = set()


def get_swift_code(test_name: str) -> str | None:
    _fill_dict()

    result = _TEST_NAME_TO_SWIFT_CODE.get(test_name)
    if result is not None:
        return result

    assert (
        test_name in _NOT_IMPLEMENTED_TEST_NAMES
    ), f"Unknown test function: {test_name}."

    return None


def _fill_dict():
    if _TEST_NAME_TO_SWIFT_CODE:
        return

    _TEST_NAME_TO_SWIFT_CODE["A"] = "B"

    test_name: str | None = None
    test_code: list[str] = []

    for line in _get_lines(_DEFINITIONS):
        line_strip = line.strip()

        if line_strip.startswith("#"):
            continue

        if line_strip == "" or line.startswith(" "):
            test_code.append(line)
        else:
            _add_test(test_name, test_code)
            test_name = line
            test_code = []

    # Add last test
    _add_test(test_name, test_code)


@dataclass
class _Replacement:
    old: str
    # If 'dict' -> all of the entries will be added as replacements.
    values: list[str | dict[str, str]]


# {compare_enum_value} will be replaced later based on 'readtest.h'.
_REPLACEMENTS: list[_Replacement] = [
    _Replacement("{bit_width}", ["32", "64", "128"]),
    _Replacement("{binary_width}", ["32", "64", "80"]),
    _Replacement(
        "{int.intel}",
        [
            {"{int.intel}": "int8", "{int.swift}": "Int8"},
            {"{int.intel}": "uint8", "{int.swift}": "UInt8"},
            {"{int.intel}": "int16", "{int.swift}": "Int16"},
            {"{int.intel}": "uint16", "{int.swift}": "UInt16"},
            {"{int.intel}": "int32", "{int.swift}": "Int32"},
            {"{int.intel}": "uint32", "{int.swift}": "UInt32"},
            {"{int.intel}": "int64", "{int.swift}": "Int64"},
            {"{int.intel}": "uint64", "{int.swift}": "UInt64"},
        ],
    ),
    _Replacement(
        "{binary_floating_point.intel}",
        [
            {
                "{binary_floating_point.intel}": "binary32",
                "{binary_floating_point.swift}": "Float",
            },
            {
                "{binary_floating_point.intel}": "binary64",
                "{binary_floating_point.swift}": "Double",
            },
            {
                "{binary_floating_point.intel}": "binary80",
                "{binary_floating_point.swift}": "Float80",
            },
        ],
    ),
]


def _add_test(name_template: str | None, code_lines: list[str]):
    if name_template is None:
        return

    code_template = "\n".join(code_lines)

    # Select replacements to use.
    # We have a lot of replacements, so nesting 'for' loops is too slow.
    # By default replace Python '{{' with '{'.
    replacements: list[dict[str, str]] = [
        {
            "{{": "{",
            "}}": "}",
        }
    ]

    for r in _REPLACEMENTS:
        if r.old in name_template or r.old in code_template:
            new_replacements: list[dict[str, str]] = []

            for new in r.values:
                for old_to_new in replacements:
                    copy = old_to_new.copy()

                    if isinstance(new, str):
                        copy[r.old] = new
                    else:
                        copy.update(new)

                    new_replacements.append(copy)

            replacements = new_replacements

    for r in replacements:
        name = name_template
        code = code_template

        for old, new in r.items():
            name = name.replace(old, new)
            code = code.replace(old, new)

        name = name.strip()
        has_implementation = code.strip()

        if has_implementation:
            _TEST_NAME_TO_SWIFT_CODE[name] = code
        else:
            _NOT_IMPLEMENTED_TEST_NAMES.add(name)


def _get_lines(s: str):
    index = 0

    while index < len(s):
        line_end_index = s.find("\n", index)
        line = s[index:line_end_index]
        index = line_end_index + 1
        yield line


_DEFINITIONS = """

bid{bit_width}_class
    let result = arg0.floatingPointClass
    self.assertFloatingPointClass(result, expected, file, line)

bid{bit_width}_radix
    // Dummy use for 'arg0', so that the compiler does not complain.
    _ = arg0

    let result = Decimal{bit_width}.radix
    self.assertInt(result, Int(expected), file, line)

bid{bit_width}_nan
    let payload = arg0.bid & Decimal{bit_width}.nanPayloadMask
    let result = Decimal{bit_width}(nan: payload, signaling: false)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_inf
    // Dummy use for 'arg0, rounding, status', so that the compiler does not complain.
    _ = (arg0, rounding)
    // Dummy assign 'status', so that the compiler does not complain.
    status = ExceptionStatus()

    let result = Decimal{bit_width}.infinity
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_copy
    let result = arg0
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_copySign
    let result = Decimal{bit_width}(signOf: arg1, magnitudeOf: arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# ==================
# === Predicates ===
# ==================

bid{bit_width}_isZero
    let result = arg0.isZero
    self.assertBool(result, expected, file, line)
bid{bit_width}_isFinite
    let result = arg0.isFinite
    self.assertBool(result, expected, file, line)
bid{bit_width}_isInf
    let result = arg0.isInfinite
    self.assertBool(result, expected, file, line)

bid{bit_width}_isNormal
    let result = arg0.isNormal
    self.assertBool(result, expected, file, line)
bid{bit_width}_isSubnormal
    let result = arg0.isSubnormal
    self.assertBool(result, expected, file, line)
bid{bit_width}_isCanonical
    let result = arg0.isCanonical
    self.assertBool(result, expected, file, line)

bid{bit_width}_isNaN
    let result = arg0.isNaN
    self.assertBool(result, expected, file, line)
bid{bit_width}_isSignaling
    let result = arg0.isSignalingNaN
    self.assertBool(result, expected, file, line)

bid{bit_width}_isSigned
    let result = arg0.sign
    self.assertSign(result, expected, file, line)

# ==============
# === String ===
# ==============

bid{bit_width}_from_string
    let result = Decimal{bit_width}._parse(arg0, rounding: rounding, status: &status)
    // In swift parsing failure is 'nil', in Cbid 'NaN'.
    self.assertEqual(result ?? .nan, expected, {compare_enum_value}, file, line)

bid{bit_width}_to_string
    let result = arg0._toString(status: &status)
    self.assertToString(Decimal{bit_width}.self, result, expected, file, line)

# ================
# === From Int ===
# ================

# For Int32:
# - Decimal32 needs rounding
# - Decimal64 and Decimal128 do not

bid32_from_int32
    let result = Decimal32._fromInt(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid32_from_uint32
    let result = Decimal32._fromInt(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid64_from_int32
    let result = Decimal64(arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid64_from_uint32
    let result = Decimal64(arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid128_from_int32
    let result = Decimal128(arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid128_from_uint32
    let result = Decimal128(arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# For Int64:
# - Decimal32 and Decimal64 need rounding
# - Decimal128 does not

bid32_from_int64
    let result = Decimal32._fromInt(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid32_from_uint64
    let result = Decimal32._fromInt(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid64_from_int64
    let result = Decimal64._fromInt(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid64_from_uint64
    let result = Decimal64._fromInt(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid128_from_int64
    let result = Decimal128(arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid128_from_uint64
    let result = Decimal128(arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# ==============
# === To Int ===
# ==============

bid{bit_width}_to_{int.intel}_ceil
    let result = {int.swift}(arg0, rounding: .up, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_floor
    let result = {int.swift}(arg0, rounding: .down, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_int
    let result = {int.swift}(arg0, rounding: .towardZero, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_rnint
    let result = {int.swift}(arg0, rounding: .toNearestOrEven, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_rninta
    let result = {int.swift}(arg0, rounding: .toNearestOrAwayFromZero, status: &status)
    self.assertInt(result, expected, file, line)


bid{bit_width}_to_{int.intel}_xceil
    let result = {int.swift}(exactly: arg0, rounding: .up, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_xfloor
    let result = {int.swift}(exactly: arg0, rounding: .down, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_xint
    let result = {int.swift}(exactly: arg0, rounding: .towardZero, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_xrnint
    let result = {int.swift}(exactly: arg0, rounding: .toNearestOrEven, status: &status)
    self.assertInt(result, expected, file, line)

bid{bit_width}_to_{int.intel}_xrninta
    let result = {int.swift}(exactly: arg0, rounding: .toNearestOrAwayFromZero, status: &status)
    self.assertInt(result, expected, file, line)

# =============================
# === Binary floating point ===
# =============================

{binary_floating_point.intel}_to_bid{bit_width}
    let result = Decimal{bit_width}._from{binary_floating_point.swift}(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_to_{binary_floating_point.intel}
    let result = arg0._to{binary_floating_point.swift}(rounding: rounding, status: &status)
    self.assertBinaryFloatingPoint(result, expected, file, line)

# ====================
# === From Decimal ===
# ====================

bid64_to_bid32
    let result = Decimal32._fromDecimal64(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid128_to_bid32
    let result = Decimal32._fromDecimal128(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid32_to_bid64
    let result = Decimal64._fromDecimal32(arg0, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid128_to_bid64
    let result = Decimal64._fromDecimal128(arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid32_to_bid128
    let result = Decimal128._fromDecimal32(arg0, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid64_to_bid128
    let result = Decimal128._fromDecimal64(arg0, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# ============
# === Math ===
# ============

bid{bit_width}_negate
    let result1 = -arg0
    self.assertEqual(result1, expected, {compare_enum_value}, file, line)

    var result2 = arg0
    result2.negate()
    self.assertEqual(result2, expected, {compare_enum_value}, file, line)

bid{bit_width}_abs
    let result = arg0.magnitude
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_add
    let result = arg0._adding(other: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)
bid{bit_width}_sub
    let result = arg0._subtracting(other: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_mul
    let result = arg0._multiplied(by: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)
bid{bit_width}_div
    let result = arg0._divided(by: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)
bid{bit_width}_rem
    let result = arg0._formRemainder(dividingBy: arg1, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_pow
    let result = arg0._pow(exponent: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, ulp: ulp, rounding: rounding, file, line)

bid{bit_width}_sqrt
    let result = arg0._squareRoot(rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, ulp: ulp, rounding: rounding, file, line)

bid{bit_width}_fma
    let result = arg0._addingProduct(arg1, arg2, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# ===============
# === Compare ===
# ===============

bid{bit_width}_quiet_equal
    let result = arg0._isEqual(to: arg1, status: &status)
    self.assertBool(result, expected, file, line)

bid{bit_width}_quiet_not_equal
    let result = arg0._isEqual(to: arg1, status: &status)
    self.assertNotBool(result, expected, file, line)

bid{bit_width}_quiet_less
    let result = arg0._isLess(than: arg1, status: &status)
    self.assertBool(result, expected, file, line)

bid{bit_width}_quiet_not_less
    let result = arg0._isLess(than: arg1, status: &status)
    self.assertNotBool(result, expected, file, line)

bid{bit_width}_quiet_less_equal
    let result = arg0._isLessThanOrEqualTo(arg1, status: &status)
    self.assertBool(result, expected, file, line)

# Is it greater or unordered?
# Table 5.3 — Required unordered-quiet predicates and negations
# LT EQ | compareQuietLessEqual            isLessEqual
# GT UN | compareQuietGreaterUnordered ?>, NOT(isLessEqual)
bid{bit_width}_quiet_greater_unordered
    let result = arg0._isLessThanOrEqualTo(arg1, status: &status)
    self.assertNotBool(result, expected, file, line)

bid{bit_width}_quiet_greater
    // Notice switched order! 'arg1' is on before '.'.
    let result = arg1._isLess(than: arg0, status: &status)
    self.assertBool(result, expected, file, line)

bid{bit_width}_quiet_not_greater
    // Notice switched order! 'arg1' is on before '.'.
    let result = arg1._isLess(than: arg0, status: &status)
    self.assertNotBool(result, expected, file, line)

bid{bit_width}_quiet_greater_equal
    // Notice switched order! 'arg1' is on before '.'.
    let result = arg1._isLessThanOrEqualTo(arg0, status: &status)
    self.assertBool(result, expected, file, line)

# Is it less or unordered?
# Table 5.3 — Required unordered-quiet predicates and negations
# GT EQ | compareQuietGreaterEqual isGreaterEqual
# LT UN | compareQuietLessUnordered ?<, NOT(isGreaterEqual)
bid{bit_width}_quiet_less_unordered
    // Notice switched order! 'arg1' is on before '.'.
    let result = arg1._isLessThanOrEqualTo(arg0, status: &status)
    self.assertNotBool(result, expected, file, line)

# ===================
# === Total order ===
# ===================

bid{bit_width}_totalOrder
    let result = arg0.isTotallyOrdered(belowOrEqualTo: arg1)
    self.assertBool(result, expected, file, line)

bid{bit_width}_totalOrderMag
    let arg0Mag = arg0.magnitude
    let arg1Mag = arg1.magnitude
    let result = arg0Mag.isTotallyOrdered(belowOrEqualTo: arg1Mag)
    self.assertBool(result, expected, file, line)

# =======================
# === Minimum/maximum ===
# =======================

bid{bit_width}_minnum
    let result = Decimal{bit_width}._minimum(arg0, arg1, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_minnum_mag
    let result = Decimal{bit_width}._minimumMagnitude(arg0, arg1, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_maxnum
    let result = Decimal{bit_width}._maximum(arg0, arg1, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_maxnum_mag
    let result = Decimal{bit_width}._maximumMagnitude(arg0, arg1, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# =============
# === Scale ===
# =============

bid{bit_width}_scalbln
    let result = Decimal{bit_width}._initByScaling(sign: .plus, exponent: arg1, significand: arg0, rounding: rounding, status: &status)
    _ = longIntSize // Never used; silence compiler warning
    self.assertEqual(result, expected, {compare_enum_value}, ulp: ulp, rounding: rounding, file, line)

bid{bit_width}_scalbn
    let result = Decimal{bit_width}._initByScaling(sign: .plus, exponent: Int(arg1), significand: arg0, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, ulp: ulp, rounding: rounding, file, line)

bid{bit_width}_ilogb
    assert(ulp?.isZero ?? true) // 'ulp' does not make sense in this test
    let result = arg0._getExponent(status: &status)
    let resultIntel = self.convertToIntelLogB(arg0, exponent: result)
    self.assertInt(resultIntel, expected, file, line)

# We will use 'frexp' to test 'significand'
bid{bit_width}_frexp
    let exponent = arg0._getExponent(status: &status)
    let significand = arg0._getSignificand()
    let intel = self.convertToIntelFrexp(arg0, exponent: exponent, significand: significand)

    // 'arg1' is the expected exponent
    self.assertInt(intel.exponent, arg1, file, line, "Exponent")
    self.assertEqual(intel.significand, expected, {compare_enum_value}, ulp: ulp, rounding: rounding, file, line, "Significand")

    if !arg0.isInfinite && !arg0.isNaN {
      // Rounding should not matter
      let restored = Decimal{bit_width}(sign: arg0.sign, exponent: exponent, significand: significand, rounding: .towardZero)
      self.assertEqual(restored, arg0, {compare_enum_value}, ulp: ulp, rounding: rounding, file, line, "Decimal{bit_width}(sign:exponent:significand:)")
    }

    // 'frexp' does not signal any exceptions
    status = ExceptionStatus()

# ===================
# === bid <-> dpd ===
# ===================

bid_to_dpd{bit_width}
    let result = arg0.decimalEncoding
    self.assertInt(result, expected, file, line)

bid_dpd_to_bid{bit_width}
    let result = Decimal{bit_width}(decimalEncoding: arg0)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# ============
# === Next ===
# ============

bid{bit_width}_nextup
    let result = arg0._nextUp(status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_nextdown
    let result = arg0._nextDown(status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# ===============
# === Quantum ===
# ===============

bid{bit_width}_quantize
    let result = arg0._quantize(other: arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_sameQuantum
    let result = arg0._sameQuantum(other: arg1)
    self.assertBool(result, expected, file, line)

bid{bit_width}_quantum
    var status = ExceptionStatus()
    let result = arg0._quantum(status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

# =============
# === Round ===
# =============

bid{bit_width}_round_integral_nearest_away
    let result = arg0._round(.toNearestOrAwayFromZero, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_round_integral_nearest_even
    let result = arg0._round(.toNearestOrEven, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_round_integral_positive
    let result = arg0._round(.up, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_round_integral_negative
    let result = arg0._round(.down, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)

bid{bit_width}_round_integral_zero
    let result = arg0._round(.towardZero, status: &status)
    self.assertEqual(result, expected, {compare_enum_value}, file, line)








# ============
# === Next ===
# ============

# 5.8 Details of conversions from floating-point to integer formats
# Convert to integer, signaling if inexact.
bid{bit_width}_round_integral_exact

# =======================
# === Not implemented ===
# =======================

# We do not have Float128
binary128_to_bid{bit_width}
bid{bit_width}_to_binary128

# String to Decimal - we already have parse
bid_strtod{bit_width}
bid_wcstod{bit_width}

# Extract unbiased exponent - we don't need it
bid{bit_width}_quantexp

# Are operands ordered? (none of them is NaN?)
bid{bit_width}_quiet_ordered
# Are operands unordered? (at least one of them NaN?)
bid{bit_width}_quiet_unordered

# We do not have signaling operations
bid{bit_width}_signaling_greater
bid{bit_width}_signaling_greater_equal
bid{bit_width}_signaling_greater_unordered
bid{bit_width}_signaling_less
bid{bit_width}_signaling_less_equal
bid{bit_width}_signaling_less_unordered
bid{bit_width}_signaling_not_greater
bid{bit_width}_signaling_not_less

# Breaks x into an integral and a fractional part.
# Not needed.
bid{bit_width}_modf

# ???
str64

# Transcendental
bid{bit_width}_acos
bid{bit_width}_acosh
bid{bit_width}_asin
bid{bit_width}_asinh
bid{bit_width}_atan
bid{bit_width}_atan2
bid{bit_width}_atanh
bid{bit_width}_cbrt
bid{bit_width}_cos
bid{bit_width}_cosh
bid{bit_width}_erf
bid{bit_width}_erfc
bid{bit_width}_exp
bid{bit_width}_exp10
bid{bit_width}_exp2
bid{bit_width}_expm1
bid{bit_width}_fdim
bid{bit_width}_fmod
bid{bit_width}_hypot
bid{bit_width}_ldexp
bid{bit_width}_lgamma
bid{bit_width}_llquantexp
bid{bit_width}_llrint
bid{bit_width}_llround
bid{bit_width}_log
bid{bit_width}_log10
bid{bit_width}_log1p
bid{bit_width}_log2
bid{bit_width}_logb
bid{bit_width}_lrint
bid{bit_width}_lround
bid{bit_width}_nearbyint
bid{bit_width}_nextafter
bid{bit_width}_nexttoward
bid{bit_width}_sin
bid{bit_width}_sinh
bid{bit_width}_tan
bid{bit_width}_tanh
bid{bit_width}_tgamma

# Mixed operands
bid128d_sqrt
bid128dd_add
bid128dd_div
bid128dd_mul
bid128dd_sub
bid128ddd_fma
bid128ddq_fma
bid128dq_add
bid128dq_div
bid128dq_mul
bid128dq_sub
bid128dqd_fma
bid128dqq_fma
bid128qd_add
bid128qd_div
bid128qd_mul
bid128qd_sub
bid128qdd_fma
bid128qdq_fma
bid128qqd_fma

bid64ddq_fma
bid64dq_add
bid64dq_div
bid64dq_mul
bid64dq_sub
bid64dqd_fma
bid64dqq_fma
bid64q_sqrt
bid64qd_add
bid64qd_div
bid64qd_mul
bid64qd_sub
bid64qdd_fma
bid64qdq_fma
bid64qq_add
bid64qq_div
bid64qq_mul
bid64qq_sub
bid64qqd_fma
bid64qqq_fma

# IEEE 754 config
bid_feclearexcept
bid_fegetexceptflag
bid_feraiseexcept
bid_fesetexceptflag
bid_fetestexcept
bid_getDecimalRoundingDirection
bid_is754
bid_is754R
bid_lowerFlags
bid_restoreFlags
bid_saveFlags
bid_setDecimalRoundingDirection
bid_signalException
bid_testFlags
bid_testSavedFlags
"""
