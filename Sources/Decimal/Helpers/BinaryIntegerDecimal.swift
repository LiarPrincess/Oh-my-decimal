internal protocol BinaryIntegerDecimal: FixedWidthInteger, UnsignedInteger {}

extension UInt32: BinaryIntegerDecimal {}
extension UInt64: BinaryIntegerDecimal {}
extension UInt128: BinaryIntegerDecimal {}
