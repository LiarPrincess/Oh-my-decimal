import Cbid

extension FloatingPointClassification {

  internal init(_ int: Int32) {
    let unit = UInt32(int)


    switch unit {
    case Cbid.signalingNaN.rawValue: self = .signalingNaN
    case Cbid.quietNaN.rawValue: self = .quietNaN
    case Cbid.negativeInfinity.rawValue: self = .negativeInfinity
    case Cbid.negativeNormal.rawValue: self = .negativeNormal
    case Cbid.negativeSubnormal.rawValue: self = .negativeSubnormal
    case Cbid.negativeZero.rawValue: self = .negativeZero
    case Cbid.positiveZero.rawValue: self = .positiveZero
    case Cbid.positiveSubnormal.rawValue: self = .positiveSubnormal
    case Cbid.positiveNormal.rawValue: self = .positiveNormal
    case Cbid.positiveInfinity.rawValue: self = .positiveInfinity
    default:
      preconditionFailure("Unknown decimal floating point class: \(unit).")
    }
  }
}
