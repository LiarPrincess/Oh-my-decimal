from dataclasses import dataclass


@dataclass
class Swift:
    speleotrove_operation: str
    class_name: str
    has_status: bool
    arg0_type: str
    arg1_type: str | None
    arg2_type: str | None
    result_type: str
    code: str


ARG_TYPE_INT = "ARG_TYPE_INT"
ARG_TYPE_BOOL = "ARG_TYPE_BOOL"
ARG_TYPE_STRING = "ARG_TYPE_STRING"
ARG_TYPE_TESTED_DECIMAL = "_ARG_TYPE_TESTED_DECIMAL"
ARG_TYPE_FLOATING_POINT_CLASS = "_ARG_TYPE_FLOATING_POINT_CLASS"

_CLASS_NAME_ADD = "SpeleotroveAddTests"
_CLASS_NAME_COMPARE = "SpeleotroveCompareTests"
_CLASS_NAME_DIV = "SpeleotroveDivTests"
_CLASS_NAME_FMA = "SpeleotroveFusedMultiplyAddTests"
_CLASS_NAME_INIT_FROM_STRING = "SpeleotroveInitFromStringTests"
_CLASS_NAME_LOG_SCALE = "SpeleotroveLogScaleTests"
_CLASS_NAME_MIN_MAX = "SpeleotroveMinMaxTests"
_CLASS_NAME_MUL = "SpeleotroveMulTests"
_CLASS_NAME_NEXT = "SpeleotroveNextTests"
_CLASS_NAME_OTHER = "SpeleotroveOtherTests"
_CLASS_NAME_PROPERTY = "SpeleotrovePropertyTests"
_CLASS_NAME_QUANTUM = "SpeleotroveQuantumTests"
_CLASS_NAME_REM = "SpeleotroveRemTests"
_CLASS_NAME_ROUND = "SpeleotroveRoundTests"
_CLASS_NAME_SUB = "SpeleotroveSubTests"
_CLASS_NAME_TOTAL_ORDER = "SpeleotroveTotalOrderTests"
_CLASS_NAME_UNARY = "SpeleotroveUnaryTests"


_OPERATION_LOWER_TO_SWIFT_CODE: dict[str, Swift] = {}


def get_swift_code(operation: str) -> Swift:
    if not _OPERATION_LOWER_TO_SWIFT_CODE:
        for s in _SWIFT:
            op = s.speleotrove_operation.lower()
            assert op not in _OPERATION_LOWER_TO_SWIFT_CODE, (
                "Duplicate operation: " + op
            )
            _OPERATION_LOWER_TO_SWIFT_CODE[op] = s

    op = operation.lower()
    result = _OPERATION_LOWER_TO_SWIFT_CODE.get(op)
    assert result is not None, "No swift code for: " + op
    return result


_SWIFT: list[Swift] = [
    # ==================
    # === Properties ===
    # ==================
    Swift(
        "abs",
        class_name=_CLASS_NAME_PROPERTY,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.magnitude
    let speleotroveResult = self.toSpeleotrove_magnitude(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
""",
    ),
    Swift(
        "class",
        class_name=_CLASS_NAME_PROPERTY,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_FLOATING_POINT_CLASS,
        code="""
    let result = arg0.floatingPointClass
    XCTAssertEqual(result, expected, file: file, line: line)
""",
    ),
    # ==============
    # === String ===
    # ==============
    Swift(
        "apply",
        class_name=_CLASS_NAME_INIT_FROM_STRING,
        has_status=True,
        arg0_type=ARG_TYPE_STRING,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    if let result: {decimal_name} = self.parseDecimal(arg0, rounding: rounding, status: &status, file, line) {
      self.assertEqual(result, expected, file, line)
      self.assertStatus(status, expectedStatus, file, line)
    } else {
      XCTFail(arg0)
    }
""",
    ),
    # =============
    # === Unary ===
    # =============
    Swift(
        "plus",
        class_name=_CLASS_NAME_UNARY,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = +arg0
    let speleotroveResult = self.toSpeleotrove_unaryPlus(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
""",
    ),
    Swift(
        "minus",
        class_name=_CLASS_NAME_UNARY,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = -arg0
    let speleotroveResult = self.toSpeleotrove_unaryMinus(arg0, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
""",
    ),
    # ============
    # === Math ===
    # ============
    Swift(
        "add",
        class_name=_CLASS_NAME_ADD,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.adding(arg1, rounding: rounding, status: &status)
    let speleotroveResult = self.toSpeleotrove_add(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "subtract",
        class_name=_CLASS_NAME_SUB,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.subtracting(arg1, rounding: rounding, status: &status)
    let speleotroveResult = self.toSpeleotrove_sub(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "multiply",
        class_name=_CLASS_NAME_MUL,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.multiplied(by: arg1, rounding: rounding, status: &status)
    let speleotroveResult = self.toSpeleotrove_mul(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "divide",
        class_name=_CLASS_NAME_DIV,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.divided(by: arg1, rounding: rounding, status: &status)
    let speleotroveResult = self.toSpeleotrove_div(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "divideint",
        class_name=_CLASS_NAME_DIV,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.divideInt(arg0, by: arg1, rounding: rounding)
    self.assertEqualByEqualEqual(result, expected, file, line)
""",
    ),
    Swift(
        "remaindernear",
        class_name=_CLASS_NAME_REM,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.remainder(dividingBy: arg1, status: &status)
    let speleotroveResult = self.toSpeleotrove_rem(arg0, arg1, result: result, status: &status)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "remainder",
        class_name=_CLASS_NAME_REM,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.truncatingRemainder(dividingBy: arg1, status: &status)
    let speleotroveResult = self.toSpeleotrove_rem(arg0, arg1, result: result, status: &status)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)

    let result2 = self.truncatingRemainderFromReminder(arg0, dividingBy: arg1)
    self.assertEqual(result2, expected, file, line)
""",
    ),
    Swift(
        "fma",
        class_name=_CLASS_NAME_FMA,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=ARG_TYPE_TESTED_DECIMAL,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg2.addingProduct(arg0, arg1, rounding: rounding, status: &status)
    let speleotroveResult = self.toSpeleotrove_fma(arg0, arg1, arg2, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    # ===============
    # === Compare ===
    # ===============
    Swift(
        "compare",
        class_name=_CLASS_NAME_COMPARE,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_STRING,
        code="""
    self.assertCompare(
      arg0,
      arg1,
      status: &status,
      expected: expected,
      expectedStatus: expectedStatus,
      file,
      line
    )
""",
    ),
    Swift(
        "comparesig",
        class_name=_CLASS_NAME_COMPARE,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_STRING,
        code="""
    self.assertCompareSignaling(
      arg0,
      arg1,
      status: &status,
      expected: expected,
      expectedStatus: expectedStatus,
      file,
      line
    )
""",
    ),
    # ===================
    # === Total order ===
    # ===================
    Swift(
        "comparetotal",
        class_name=_CLASS_NAME_TOTAL_ORDER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_INT,
        code="""
    let result = self.totalOrder(arg0, arg1)
    self.assertInt(result, expected, file, line)
""",
    ),
    Swift(
        "comparetotmag",
        class_name=_CLASS_NAME_TOTAL_ORDER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_INT,
        code="""
    let result = self.totalOrderMagnitude(arg0, arg1)
    self.assertInt(result, expected, file, line)
""",
    ),
    # ===============
    # === Min/max ===
    # ===============
    Swift(
        "min",
        class_name=_CLASS_NAME_MIN_MAX,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = {decimal_name}.minimum(arg0, arg1, status: &status)
    let speleotroveResult = self.toSpeleotrove_min(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "minmag",
        class_name=_CLASS_NAME_MIN_MAX,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = {decimal_name}.minimumMagnitude(arg0, arg1, status: &status)
    let speleotroveResult = self.toSpeleotrove_min(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "max",
        class_name=_CLASS_NAME_MIN_MAX,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = {decimal_name}.maximum(arg0, arg1, status: &status)
    let speleotroveResult = self.toSpeleotrove_max(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "maxmag",
        class_name=_CLASS_NAME_MIN_MAX,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = {decimal_name}.maximumMagnitude(arg0, arg1, status: &status)
    let speleotroveResult = self.toSpeleotrove_max(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    # ============
    # === Next ===
    # ============
    Swift(
        "nextplus",
        class_name=_CLASS_NAME_NEXT,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.nextUp(status: &status)
    self.assertEqual(result, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "nextminus",
        class_name=_CLASS_NAME_NEXT,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.nextDown(status: &status)
    self.assertEqual(result, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "nexttoward",
        class_name=_CLASS_NAME_NEXT,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.nextToward(arg0, arg1, status: &status)
    self.assertEqual(result, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    # ===============
    # === Quantum ===
    # ===============
    Swift(
        "quantize",
        class_name=_CLASS_NAME_QUANTUM,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.quantized(to: arg1, rounding: rounding, status: &status)
    let speleotroveResult = self.toSpeleotrove_quantize(arg0, arg1, result: result)
    self.assertEqual(speleotroveResult, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "samequantum",
        class_name=_CLASS_NAME_QUANTUM,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_BOOL,
        code="""
    let result = arg0.sameQuantum(as: arg1)
    self.assertBool(result, expected, file, line)
""",
    ),
    # ====================
    # === LogB, scaleB ===
    # ====================
    Swift(
        "logb",
        class_name=_CLASS_NAME_LOG_SCALE,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.logB(arg0, status: &status)
    self.assertEqual(result, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    Swift(
        "scaleb",
        class_name=_CLASS_NAME_LOG_SCALE,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.scaleB(arg0, arg1, rounding: rounding, status: &status)
    self.assertEqual(result, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    # =============
    # === Round ===
    # =============
    Swift(
        "tointegralx",
        class_name=_CLASS_NAME_ROUND,
        has_status=True,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0.rounded(rounding, status: &status)
    self.assertEqual(result, expected, file, line)
    self.assertStatus(status, expectedStatus, file, line)
""",
    ),
    # =============
    # === Other ===
    # =============
    Swift(
        "copy",
        class_name=_CLASS_NAME_OTHER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = arg0
    self.assertEqual(result, expected, file, line)
""",
    ),
    Swift(
        "copysign",
        class_name=_CLASS_NAME_OTHER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=ARG_TYPE_TESTED_DECIMAL,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = {decimal_name}(signOf: arg1, magnitudeOf: arg0)
    self.assertEqual(result, expected, file, line)
""",
    ),
    Swift(
        "copyabs",
        class_name=_CLASS_NAME_OTHER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.copyAbs(arg0)
    self.assertEqual(result, expected, file, line)
""",
    ),
    Swift(
        "copynegate",
        class_name=_CLASS_NAME_OTHER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.copyNegate(arg0)
    self.assertEqual(result, expected, file, line)
""",
    ),
    Swift(
        "reduce",
        class_name=_CLASS_NAME_OTHER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.reduce(arg0, expected: expected)
    self.assertEqual(result, expected, file, line)
""",
    ),
    Swift(
        "canonical",
        class_name=_CLASS_NAME_OTHER,
        has_status=False,
        arg0_type=ARG_TYPE_TESTED_DECIMAL,
        arg1_type=None,
        arg2_type=None,
        result_type=ARG_TYPE_TESTED_DECIMAL,
        code="""
    let result = self.canonical(arg0)
    self.assertEqual(result, expected, file, line)
""",
    ),
]
