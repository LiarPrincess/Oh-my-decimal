import Cbid

internal typealias IDEC_flags = _IDEC_flags
internal typealias IDEC_flagsPtr = UnsafeMutablePointer<IDEC_flags>

internal struct ExceptionStatus {

  /// IEEE 754 - 7.2 Invalid operation
  internal static let isInvalidOperation = ExceptionStatus(BID_INVALID_EXCEPTION)
  /// IEEE 754 - 7.3 Division by zero
  internal static let isDivisionByZero = ExceptionStatus(BID_ZERO_DIVIDE_EXCEPTION)
  /// IEEE 754 - 7.4 Overflow
  internal static let isOverflow = ExceptionStatus(BID_OVERFLOW_EXCEPTION)
  /// IEEE 754 - 7.5 Underflow
  internal static let isUnderflow = ExceptionStatus(BID_UNDERFLOW_EXCEPTION)
  /// IEEE 754 - 7.6 Inexact
  internal static let isInexact = ExceptionStatus(BID_INEXACT_EXCEPTION)
  internal static let isDenormal = ExceptionStatus(BID_DENORMAL_EXCEPTION)

  /// isUnderflow | isInexact
  internal static let isUnderflowInexact = ExceptionStatus(BID_UNDERFLOW_INEXACT_EXCEPTION)
  /// isOverflow | isInexact
  internal static let isOverflowInexact = ExceptionStatus(BID_OVERFLOW_INEXACT_EXCEPTION)

  internal var value: IDEC_flags

  /// No exceptions.
  internal var isEmpty: Bool { self.value == 0 }

  internal init() {
    self.value = 0
  }

  internal init(_ value: IDEC_flags) {
    self.value = value
  }

  internal init(_ value: Int32) {
    self.value = IDEC_flags(value)
  }

  internal func isSet(_ exception: ExceptionStatus) -> Bool {
    let mask = exception.value
    return (self.value & mask) == mask
  }

  internal mutating func set(_ exception: ExceptionStatus) {
    let mask = exception.value
    self.value = self.value | mask
  }

  internal static func | (lhs: Self, rhs: Self) -> Self {
    return Self(lhs.value | rhs.value)
  }
}

#if DEBUG

// Never ever try to print this thing in production code!
extension ExceptionStatus: Equatable, CustomStringConvertible {
  internal var description: String {
    var result = "ExceptionStatus("

    func append(_ flag: ExceptionStatus, _ s: String) {
      if self.isSet(flag) {
        if !result.hasSuffix("(") {
          result.append(", ")
        }

        result.append(s)
      }
    }

    append(.isInvalidOperation, "isInvalidOperation")
    append(.isDivisionByZero, "isDivisionByZero")
    append(.isOverflow, "isOverflow")
    append(.isUnderflow, "isUnderflow")
    append(.isInexact, "isInexact")
    append(.isDenormal, "isDenormal")

    result.append(")")
    return result
  }
}

#endif
