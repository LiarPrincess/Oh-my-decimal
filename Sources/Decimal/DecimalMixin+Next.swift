extension DecimalMixin {

  internal func _nextUp(status: inout ExceptionStatus) -> Self {
    return self._convert(Self.fnNextUp, status: &status)
  }

  internal func _nextDown(status: inout ExceptionStatus) -> Self {
    return self._convert(Self.fnNextDown, status: &status)
  }
}
