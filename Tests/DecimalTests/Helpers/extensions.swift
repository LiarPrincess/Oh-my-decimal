import Decimal

extension DecimalFloatingPoint {
  var isQuietNaN: Bool { self.isNaN && !self.isSignalingNaN }
}

extension BinaryFloatingPoint {
  var isQuietNaN: Bool { self.isNaN && !self.isSignalingNaN }
}
