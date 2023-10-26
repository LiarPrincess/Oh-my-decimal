/// `DecimalFloatingPointRoundingRule.toNearestOrEven`
let BID_ROUNDING_TO_NEAREST: Int32 = 0
/// `DecimalFloatingPointRoundingRule.down`
let BID_ROUNDING_DOWN: Int32 = 1
/// `DecimalFloatingPointRoundingRule.up`
let BID_ROUNDING_UP: Int32 = 2
/// `DecimalFloatingPointRoundingRule.towardZero`
let BID_ROUNDING_TO_ZERO: Int32 = 3
/// `DecimalFloatingPointRoundingRule.toNearestOrAwayFromZero`
let BID_ROUNDING_TIES_AWAY: Int32 = 4

// Status
let BID_INVALID_EXCEPTION: Int32 = 1
let BID_DENORMAL_EXCEPTION: Int32 = 2
let BID_ZERO_DIVIDE_EXCEPTION: Int32 = 4
let BID_OVERFLOW_EXCEPTION: Int32 = 8
let BID_UNDERFLOW_EXCEPTION: Int32 = 16
let BID_INEXACT_EXCEPTION: Int32 = 32

// Floating point class
let BID_CLASS_SIGNALING_NAN: Int32 = 0
let BID_CLASS_QUIET_NAN: Int32 = 1
let BID_CLASS_NEGATIVE_INFINITY: Int32 = 2
let BID_CLASS_NEGATIVE_NORMAL: Int32 = 3
let BID_CLASS_NEGATIVE_SUBNORMAL: Int32 = 4
let BID_CLASS_NEGATIVE_ZERO: Int32 = 5
let BID_CLASS_POSITIVE_ZERO: Int32 = 6
let BID_CLASS_POSITIVE_SUBNORMAL: Int32 = 7
let BID_CLASS_POSITIVE_NORMAL: Int32 = 8
let BID_CLASS_POSITIVE_INFINITY: Int32 = 9
