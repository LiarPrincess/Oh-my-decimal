/// Flags that describe the result of a decimal floating point operation in
/// more detail.
public struct DecimalStatus: Equatable, CustomStringConvertible {

  private typealias Storage = UInt8

  /// IEEE 754 - 7.2 Invalid operation
  public static let isInvalidOperation = Self(1 << 0)
  /// IEEE 754 - 7.3 Division by zero
  public static let isDivisionByZero = Self(1 << 1)
  /// IEEE 754 - 7.4 Overflow
  public static let isOverflow = Self(1 << 2)
  /// IEEE 754 - 7.5 Underflow
  public static let isUnderflow = Self(1 << 3)
  /// IEEE 754 - 7.6 Inexact
  public static let isInexact = Self(1 << 4)
  /// Binary floating point value is subnormal.
  ///
  /// This is only relevant during binary ⇄ decimal floating point conversions.
  /// It should NOT be used in most of the situations.
  public static let isBinaryFloatingPointSubnormal = Self(1 << 5)

  /// `isUnderflow | isInexact`
  internal static let isUnderflowInexact = Self.isUnderflow | Self.isInexact
  /// `isOverflow | isInexact`
  internal static let isOverflowInexact = Self.isOverflow | Self.isInexact

  public var isInvalidOperation: Bool { self.isSet(.isInvalidOperation) }
  public var isDivisionByZero: Bool { self.isSet(.isDivisionByZero) }
  public var isOverflow: Bool { self.isSet(.isOverflow) }
  public var isUnderflow: Bool { self.isSet(.isUnderflow) }
  public var isInexact: Bool { self.isSet(.isInexact) }
  public var isBinaryFloatingPointSubnormal: Bool { self.isSet(.isBinaryFloatingPointSubnormal) }

  /// No flags raised?
  public var isEmpty: Bool { self.value == 0 }

  public var description: String {
    var result = "DecimalStatus("

    func append(_ flag: Self, _ s: String) {
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
    append(.isBinaryFloatingPointSubnormal, "isBinaryFloatingPointSubnormal")

    result.append(")")
    return result
  }

  private var value: Storage

  public init() {
    self.value = 0
  }

  private init(_ value: Storage) {
    self.value = value
  }

  /// Are all of the given flags raised?
  public func isSet(_ status: Self) -> Bool {
    let mask = status.value
    return (self.value & mask) == mask
  }

  /// Raise the given flags.
  public mutating func set(_ status: Self) {
    let mask = status.value
    self.value = self.value | mask
  }

  /// Remove the given flags.
  public mutating func clear(_ status: Self) {
    // Be VERY careful with this one! If a method was called with flag raised
    // then you are not allowed to clear it.
    let mask = ~status.value
    self.value = self.value & mask
  }

  /// Remove all flags.
  public mutating func clearAll() {
    self.value = 0
  }

  /// Returns a new status with the elements of both this and the given status.
  public static func | (lhs: Self, rhs: Self) -> Self {
    return Self(lhs.value | rhs.value)
  }

  /// Returns a new status with flags that are common to both this and the given
  /// status.
  public static func & (lhs: Self, rhs: Self) -> Self {
    return Self(lhs.value & rhs.value)
  }
}
