extension DecimalMixin {

  internal mutating func _negate() {
    // In swift -snan -> nan
    self = self._convert(Self.fnNegate)
  }

  internal var _magnitude: Self {
    return self._convert(Self.fnAbs)
  }

  internal func _adding(
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnAdd, other: other, rounding: rounding, status: &status)
  }

  internal func _subtracting(
    other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnSub, other: other, rounding: rounding, status: &status)
  }

  internal func _multiplied(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnMul, other: other, rounding: rounding, status: &status)
  }

  internal func _divided(
    by other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnDiv, other: other, rounding: rounding, status: &status)
  }

  internal func _formRemainder(
    dividingBy other: Self,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnRem, other: other, status: &status)
  }

  internal func _pow(
    exponent: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._binaryOp(Self.fnPow, other: exponent, rounding: rounding, status: &status)
  }

  internal func _squareRoot(
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._convert(Self.fnSquareRoot, rounding: rounding, status: &status)
  }

  internal func _addingProduct(
    _ lhs: Self,
    _ rhs: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout ExceptionStatus
  ) -> Self {
    return self._ternaryOp(Self.fnFusedMulAdd, lhs, rhs, rounding: rounding, status: &status)
  }
}
