import XCTest
@testable import Decimal

// swiftlint:disable switch_case_alignment
// swiftlint:disable function_default_parameter_at_end

enum IntelEqualMode {
  /// COMPARE_FUZZY_STATUS
  ///
  /// ```
  /// expected_status != *pfpsf
  /// check64 (R64, Q64) // return a == b ? 0 : 1
  /// i1 != i2
  /// Qi64 != qi64
  /// R64_1 != B64
  /// ```
  case fuzzyStatus
  /// COMPARE_EQUAL_STATUS
  ///
  /// ```
  /// check64 (R64, Q64)
  /// BIDECIMAL_CALL2_NORND (bid64_quiet_not_equal, Q64, R64);
  /// expected_status != *pfpsf
  /// ```
  case equalStatus
  /// COMPARE_RELATIVE_ERROR
  ///
  /// ```
  /// check64_rel(R64, Q64)
  /// (expected_status&trans_flags_mask) != (*pfpsf&trans_flags_mask)
  /// ```
  case relativeError
}

extension IntelMixin {

  func assertEqual(
    _ lhs: Decimal32,
    _ rhs: Decimal32,
    _ mode: IntelEqualMode,
    ulp: Double? = nil,
    rounding: DecimalFloatingPointRoundingRule? = nil,
    _ file: StaticString,
    _ line: UInt,
    _ message: String = ""
  ) {
    func ulpMax(rounding: DecimalFloatingPointRoundingRule) -> Double {
      switch rounding {
      /* 0 */ case .toNearestOrEven: return 0.5
      /* 2 */ case .up: return 1.01
      /* 1 */ case .down: return 1.01
      /* 3 */ case .towardZero: return 1.01
      /* 4 */ case .toNearestOrAwayFromZero: return 0.5
      }
    }

    self.assertEqual(lhs, rhs, mode, ulp, rounding, ulpMax(rounding:), message, file, line)
  }

  func assertEqual(
    _ lhs: Decimal64,
    _ rhs: Decimal64,
    _ mode: IntelEqualMode,
    ulp: Double? = nil,
    rounding: DecimalFloatingPointRoundingRule? = nil,
    _ file: StaticString,
    _ line: UInt,
    _ message: String = ""
  ) {
    func ulpMax(rounding: DecimalFloatingPointRoundingRule) -> Double {
      switch rounding {
      /* 0 */ case .toNearestOrEven: return 0.55
      /* 2 */ case .up: return 1.05
      /* 1 */ case .down: return 1.05
      /* 3 */ case .towardZero: return 1.05
      /* 4 */ case .toNearestOrAwayFromZero: return 0.55
      }
    }

    self.assertEqual(lhs, rhs, mode, ulp, rounding, ulpMax(rounding:), message, file, line)
  }

  func assertEqual(
    _ lhs: Decimal128,
    _ rhs: Decimal128,
    _ mode: IntelEqualMode,
    ulp: Double? = nil,
    rounding: DecimalFloatingPointRoundingRule? = nil,
    _ file: StaticString,
    _ line: UInt,
    _ message: String = ""
  ) {
    func ulpMax(rounding: DecimalFloatingPointRoundingRule) -> Double {
      switch rounding {
      /* 0 */ case .toNearestOrEven: return 2.0
      /* 2 */ case .up: return 5.0
      /* 1 */ case .down: return 5.0
      /* 3 */ case .towardZero: return 5.0
      /* 4 */ case .toNearestOrAwayFromZero: return 2.0
      }
    }

    self.assertEqual(lhs, rhs, mode, ulp, rounding, ulpMax(rounding:), message, file, line)
  }

  private func assertEqual<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    _ mode: IntelEqualMode,
    _ ulp: Double?,
    _ rounding: DecimalFloatingPointRoundingRule?,
    _ getUlpMax: (DecimalFloatingPointRoundingRule) -> Double,
    _ message: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    // If they are equal according to our NaN notion then here is nothing else to do here.
    if self.isEqualNaN(lhs, rhs) {
      return
    }

    var ulp = ulp

    switch mode {
    case .fuzzyStatus:
      // else if (restype == OP_DEC64 && cmp == CMP_FUZZYSTATUS) {
      //   if (
      //     expected_status != *pfpsf
      //     || check64 (R64, Q64) // return a == b ? 0 : 1
      //     || i1 != i2
      //     || Qi64 != qi64
      //     || R64_1 != B64
      //   )
      //     print_mismatch (cmp);
      // }
      XCTAssertEqual(lhs.bid, rhs.bid, "\(lhs) != \(rhs) (BID) " + message, file: file, line: line)

    case .equalStatus:
      // else if (restype == OP_DEC64 && cmp == CMP_EQUALSTATUS) {
      //   int c;
      //   unsigned int tmp_pfpsf = *pfpsf;
      //   BIDECIMAL_CALL2_NORND (bid64_quiet_not_equal, c, Q64, R64);
      //
      //   if (
      //        expected_status != tmp_pfpsf
      //        ||
      //        (
      //          check64 (R64, Q64) // return a == b ? 0 : 1
      //          &&
      //          c // bid64_quiet_not_equal(a, b)
      //        )
      //      )
      //     print_mismatch (cmp);
      // }
      // TODO: [assertEqual] bid equality?
      XCTAssertEqual(lhs, rhs, message, file: file, line: line)

    case .relativeError:
      // else if (restype == OP_DEC64 && cmp == CMP_RELATIVEERR) {
      //   if (
      //        (expected_status&trans_flags_mask) != (*pfpsf&trans_flags_mask)
      //        || check64_rel(R64, Q64)
      //      )
      //     print_mismatch (cmp);
      // }
      ulp = ulp ?? 0.0
    }

    if let ulp = ulp {
      guard let rounding = rounding else {
        preconditionFailure("Rounding argument is required when asserting relative equality.")
      }

      let ulpMax = getUlpMax(rounding)
      self.assertRelativeEquality(lhs, rhs, ulp: ulp, ulpMax: ulpMax, message, file, line)
    }
  }

  func assertRelativeEquality<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T,
    ulp: Double,
    ulpMax: Double,
    _ message: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    let message = message.isEmpty ? "ulp" : message + "- ulp"

    func unpack(_ d: T) -> T.FiniteUnpack? {
      if d._isInfiniteOrNaN { return nil }
      return d._unpackFiniteOrZero()
    }

    func quantizeAndUnpack(_ a: T, _ b: T) -> T.FiniteUnpack? {
      var status = DecimalStatus()
      let q = a._quantize(other: b, rounding: .towardZero, status: &status)

      XCTAssert(
        status.isEmpty,
        message + ": error when quantize(\(a), \(b)): \(status).",
        file: file,
        line: line
      )
      let u = unpack(q)
      XCTAssertNotNil(
        u,
        message + ": unable to unpack quantize(\(a), \(b)).",
        file: file,
        line: line
      )

      return u
    }

    // 'ulp' for infinity/NaN does not make sense.
    guard let lhsUnpack = unpack(lhs),
          let rhsUnpack = unpack(rhs) else {
      return
    }

    // We need to quantize to get equal exponent.
    var lhsQuantUnpack = lhsUnpack
    var rhsQuantUnpack = rhsUnpack

    if lhsUnpack.exponent < rhsUnpack.exponent {
      guard let r1 = quantizeAndUnpack(lhs, rhs) else { return }
      lhsQuantUnpack = r1
    } else if lhsUnpack.exponent > rhsUnpack.exponent {
      guard let r2 = quantizeAndUnpack(rhs, lhs) else { return }
      rhsQuantUnpack = r2
    }

    let lhsSig = lhsQuantUnpack.significand.canonical
    let rhsSig = rhsQuantUnpack.significand.canonical

    // Significand is unsigned, be careful to not go <0.
    let diffInt = lhsSig > rhsSig ? lhsSig - rhsSig : rhsSig - lhsSig
    var diff = Double(diffInt).magnitude

    if lhs < rhs {
      diff *= -1
    }

    let ulpResult = (diff + ulp).magnitude
    XCTAssertLessThanOrEqual(ulpResult, ulpMax, message, file: file, line: line)
  }

  func assertStatus(
    _ lhs: DecimalStatus,
    _ rhs: DecimalStatus,
    _ mode: IntelEqualMode,
    _ file: StaticString,
    _ line: UInt
  ) {
    switch mode {
    case .fuzzyStatus,
         .equalStatus:
      XCTAssertEqual(lhs, rhs, file: file, line: line)

    case .relativeError:
      // unsigned int  trans_flags_mask = 0x05;
      let mask: DecimalStatus = .isInvalidOperation | .isDivisionByZero
      let l = lhs & mask
      let r = rhs & mask
      XCTAssertEqual(l, r, file: file, line: line)
    }
  }

  func assertToString<T: DecimalFloatingPoint & DecimalMixin>(
    _ t: T.Type,
    _ result: String,
    _ expected: String,
    _ file: StaticString,
    _ line: UInt
  ) {
    // Intel pseudo-code:
    //
    // if strcmp(func, "bid32_to_string") == 0:
    //   if *op1 == '[':
    //     A32 = a32 = parse_hex_32(op1+1)
    //     istr1 = bid32_to_string(A32)
    //   else:
    //     A32 = a32 = bid32_from_string(op1)
    //     istr1 = op1
    //
    //   if *res == '[':
    //     R32 = q32 = parse_hex_32(res+1)
    //     rstr = bid32_to_string(R32)
    //   else:
    //     R32 = q32 = bid32_from_string(res)
    //     rstr = res
    //
    //   convstr = bid32_to_string(A32)
    //   Q32 = bid32_from_string(convstr)
    //
    //   if (R32 != Q32)
    //     print_mismatch (cmp);

    guard let Q32: T = self.parseDecimal(result, file, line, "parse result") else { return }
    guard let R32: T = self.parseDecimal(expected, file, line, "parse expected") else { return }

    // If they are equal according to our NaN notion then here is nothing else to do here.
    if self.isEqualNaN(Q32, R32) {
      return
    }

    // If only one of them is Nan (or they are different types of NaN)
    // then we can use default compare (NaN are never equal to anything).
    XCTAssertEqual(Q32, R32, "\(result) vs \(expected)", file: file, line: line)
  }

  func assertFloatingPointClass(
    _ lhs: FloatingPointClassification,
    _ rhs: Int32,
    _ file: StaticString,
    _ line: UInt
  ) {
    let rhsClass: FloatingPointClassification

    switch rhs {
    case BID_CLASS_SIGNALING_NAN: rhsClass = .signalingNaN
    case BID_CLASS_QUIET_NAN: rhsClass = .quietNaN
    case BID_CLASS_NEGATIVE_INFINITY: rhsClass = .negativeInfinity
    case BID_CLASS_NEGATIVE_NORMAL: rhsClass = .negativeNormal
    case BID_CLASS_NEGATIVE_SUBNORMAL: rhsClass = .negativeSubnormal
    case BID_CLASS_NEGATIVE_ZERO: rhsClass = .negativeZero
    case BID_CLASS_POSITIVE_ZERO: rhsClass = .positiveZero
    case BID_CLASS_POSITIVE_SUBNORMAL: rhsClass = .positiveSubnormal
    case BID_CLASS_POSITIVE_NORMAL: rhsClass = .positiveNormal
    case BID_CLASS_POSITIVE_INFINITY: rhsClass = .positiveInfinity
    default:
      preconditionFailure("Unknown decimal floating point class: \(rhs).")
    }

    XCTAssertEqual(lhs, rhsClass, file: file, line: line)
  }

  func assertBool(
    _ lhs: Bool,
    _ rhs: Int32,
    _ file: StaticString,
    _ line: UInt
  ) {
    let rhsBool = self.isTrue(rhs)
    XCTAssertEqual(lhs, rhsBool, file: file, line: line)
  }

  func assertNotBool(
    _ lhs: Bool,
    _ rhs: Int32,
    _ file: StaticString,
    _ line: UInt
  ) {
    let rhsBool = self.isTrue(rhs)
    XCTAssertNotEqual(lhs, rhsBool, file: file, line: line)
  }

  func assertInt<T: FixedWidthInteger>(
    _ lhs: T,
    _ rhs: T,
    _ file: StaticString,
    _ line: UInt,
    _ message: String = ""
  ) {
    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
  }

  func assertBinaryFloatingPoint<T: BinaryFloatingPoint>(
    _ lhs: T,
    _ rhs: T,
    _ file: StaticString,
    _ line: UInt,
    _ message: String = ""
  ) {
    // If they are equal according to our NaN notion then here is nothing else to do here.
    if self.isEqualNaN(lhs, rhs) {
      return
    }

    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
  }

  func assertSign(
    _ lhs: FloatingPointSign,
    _ rhs: Int32,
    _ file: StaticString,
    _ line: UInt
  ) {
    let rhsSign: FloatingPointSign = self.isTrue(rhs) ? .minus : .plus
    XCTAssertEqual(lhs, rhsSign, file: file, line: line)
  }

  private func isTrue(_ n: Int32) -> Bool {
    return n != 0
  }

  // MARK: - NaN

  private typealias NaN<T: Equatable> = (
    sign: FloatingPointSign,
    isQuietNaN: Bool,
    isSignalingNaN: Bool,
    payload: T
  )

  private func isEqualNaN<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> Bool {
    guard lhs.isNaN && rhs.isNaN else { return false }
    let l: NaN = (lhs.sign, lhs.isQuietNaN, lhs.isSignalingNaN, 0)
    let r: NaN = (rhs.sign, rhs.isQuietNaN, rhs.isSignalingNaN, 0)
    return self.isEqualNaN(lhs: l, rhs: r)
  }

  private func isEqualNaN<T: DecimalFloatingPoint & DecimalMixin>(
    _ lhs: T,
    _ rhs: T
  ) -> Bool {
    guard lhs.isNaN && rhs.isNaN else { return false }
    let l: NaN = (lhs.sign, lhs.isQuietNaN, lhs.isSignalingNaN, lhs._unpackNaN().canonical)
    let r: NaN = (rhs.sign, rhs.isQuietNaN, rhs.isSignalingNaN, rhs._unpackNaN().canonical)
    return self.isEqualNaN(lhs: l, rhs: r)
  }

  private func isEqualNaN<T: Equatable>(lhs: NaN<T>, rhs: NaN<T>) -> Bool {
    let isQuietEqual = lhs.isQuietNaN && rhs.isQuietNaN
    let isSignalingEqual = lhs.isSignalingNaN && rhs.isSignalingNaN
    let isSignEqual = lhs.sign == rhs.sign
    let isPayloadEqual = lhs.payload == rhs.payload
    return (isQuietEqual || isSignalingEqual) && isSignEqual && isPayloadEqual
  }
}
