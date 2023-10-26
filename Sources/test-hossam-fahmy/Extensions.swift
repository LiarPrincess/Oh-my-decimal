import Decimal

extension Array {
  var any: Bool { !self.isEmpty }
}

extension DecimalFloatingPoint {
  var isQuietNaN: Bool { self.isNaN && !self.isSignalingNaN }
}
