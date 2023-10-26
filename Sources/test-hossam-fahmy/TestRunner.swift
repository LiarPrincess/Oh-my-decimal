import Decimal
import Foundation

@available(macOS 10.15.4, *)
actor TestRunner {

  private let file: File
  /// Current line.
  private var line = ""
  /// Current line number.
  private var lineNo = 0

  private var failures = [TestResult.Failure]()
  private var invalidLines = [TestResult.InvalidLine]()
  private var fileErrors = [TestResult.FileError]()

  private var name: String { self.file.name }
  private var path: String { self.file.path }

  init(file: File) {
    self.file = file
  }

  // MARK: - Run

  func run() -> TestResult {
    var timer = Timer()
    timer.start()

    let reader = LineReader(file: self.file)
    var isReading = true

    while isReading {
      switch reader.readLine() {
      case let .line(l):
        self.line = l
        self.lineNo += 1
        self.runLine()
      case let .openError(e):
        self.addFileError("Error when opening file", error: e)
        isReading = false
      case let .readingError(e):
        self.addFileError("Error when reading file", error: e)
        isReading = false
      case .decodingError:
        self.addFileError("Error when decoding line")
        isReading = false
      case let .lineTooLong(maxLength):
        self.addFileError("Lines longer than \(maxLength) bytes are not supported")
        isReading = false
      case .end:
        isReading = false
      }
    }

    if let error = reader.close() {
      self.addFileError("Error when closing file", error: error)
    }

    timer.end()

    return TestResult(
      file: self.file,
      lineCount: self.lineNo,
      duration: timer.duration,
      failures: self.failures,
      invalidLines: self.invalidLines,
      fileErrors: self.fileErrors
    )
  }

  private func runLine() {
    var parser = LineParser(line: self.line)
    parser.consumeSpaces()

    if parser.isEnd {
      return
    }

    func dispatch<T: DecimalFloatingPoint>(
      _ t: T.Type,
      _ operation: Substring
    ) where T.Exponent == Int {
      switch operation {
      // Operations from http://eece.cu.edu.eg/~hfahmy/arith_debug
      case "+": self.runAdd(T.self, &parser)
      case "-": self.runSub(T.self, &parser)
      case "*": self.runMul(T.self, &parser)
      case "/": self.runDiv(T.self, &parser)
      case "*+": self.runMulAdd(T.self, &parser)
      case "*-": self.runMulSub(T.self, &parser)
      case "V": self.runSqrt(T.self, &parser)
      // Operations from oh-my-decimal-tests:
      case "is_canonical": self.runPropertyTest(T.self, &parser) { $0.isCanonical }
      case "is_finite": self.runPropertyTest(T.self, &parser) { $0.isFinite }
      case "is_infinite": self.runPropertyTest(T.self, &parser) { $0.isInfinite }
      case "is_nan": self.runPropertyTest(T.self, &parser) { $0.isNaN }
      case "is_negative": self.runPropertyTest(T.self, &parser) { $0.sign == .minus }
      case "is_normal": self.runPropertyTest(T.self, &parser) { $0.isNormal }
      case "is_qnan": self.runPropertyTest(T.self, &parser) { $0.isQuietNaN }
      case "is_snan": self.runPropertyTest(T.self, &parser) { $0.isSignalingNaN }
      case "is_subnormal": self.runPropertyTest(T.self, &parser) { $0.isSubnormal }
      case "is_zero": self.runPropertyTest(T.self, &parser) { $0.isZero }
      case "plus": self.runUnary(T.self, &parser) { +$0 }
      case "minus": self.runUnary(T.self, &parser) { -$0 }
      case "abs": self.runUnary(T.self, &parser) { $0.magnitude }
      case "rem_near": self.runRemainderNear(T.self, &parser)
      case "rem_trunc": self.runRemainderTrunc(T.self, &parser)
      case "compare": self.runCompare(T.self, &parser)
      case "compare_total": self.runCompareTotal(T.self, &parser, T.isTotallyOrdered)
      case "compare_total_mag": self.runCompareTotal(T.self, &parser, T.isMagnitudeTotallyOrdered)
      case "min": self.runMinMax(T.self, &parser) { T.minimum($0, $1, status: &$2) }
      case "min_mag": self.runMinMax(T.self, &parser) { T.minimumMagnitude($0, $1, status: &$2) }
      case "max": self.runMinMax(T.self, &parser) { T.maximum($0, $1, status: &$2) }
      case "max_mag": self.runMinMax(T.self, &parser) { T.maximumMagnitude($0, $1, status: &$2) }
      case "next_up": self.runNext(T.self, &parser) { $0.nextUp(status: &$1) }
      case "next_down": self.runNext(T.self, &parser) { $0.nextDown(status: &$1) }
      case "quantize": self.runQuantize(T.self, &parser)
      case "same_quantum": self.runSameQuantum(T.self, &parser)
      case "logb": self.runLogB(T.self, &parser)
      case "scaleb": self.runScaleB(T.self, &parser)
      case "copy_sign": self.runCopySign(T.self, &parser)
      case "round": self.runRound(T.self, &parser)
      case "round_exact": self.runRoundExact(T.self, &parser)
      // ?
      default: self.addInvalidLine("Invalid line header: '\(header)'")
      }
    }

    let header = parser.consumeUntilSpace()

    if header.starts(with: "d64") {
      let operation = header.dropFirst(3)
      dispatch(Decimal64.self, operation)
      return
    }

    if header.starts(with: "d128") {
      let operation = header.dropFirst(4)
      dispatch(Decimal128.self, operation)
      return
    }

    self.addInvalidLine("Invalid line header: '\(header)'")
  }

  private func runAdd<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.adding(rhs, rounding: rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runSub<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.subtracting(rhs, rounding: rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runMul<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.multiplied(by: rhs, rounding: rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runDiv<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.divided(by: rhs, rounding: rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runRemainderNear<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.remainder(dividingBy: rhs, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runRemainderTrunc<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.truncatingRemainder(dividingBy: rhs, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runMulAdd<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let mulLhs: T = self.consumeDecimal(&parser) else { return }
    guard let mulRhs: T = self.consumeDecimal(&parser) else { return }
    guard let add: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard var expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    self.fixMulAddTest(mulLhs: mulLhs, mulRhs: mulRhs, add: add, expected: &expected)

    var status = DecimalStatus()
    let result = add.addingProduct(mulLhs, mulRhs, rounding: rounding, status: &status)

    self.fixMulAdd_zeroInfNaN_raisesInvalidOperation(
      mulLhs: mulLhs,
      mulRhs: mulRhs,
      add: add,
      status: &status
    )

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func fixMulAddTest<T: DecimalFloatingPoint>(
    mulLhs: T,
    mulRhs: T,
    add: T,
    expected: inout T
  ) {
    // Incorrect line:
    //   d64*+ > -5064047626626594E276 +9999999999990028E64 +1E-398 -> -4131706727960463E341 x
    //
    // The correct result:
    //   -5064047626621544E+356
    //
    // In Python:
    //   context = decimal.Context(
    //       prec=16,
    //       rounding=decimal.ROUND_CEILING,
    //       Emin=-383,
    //       Emax=384,
    //       clamp=1,
    //   )
    //
    //   mulLhs = Decimal("-5064047626626594E276")
    //   mulRhs = Decimal("+9999999999990028E64")
    //   add = Decimal("+1E-398")
    //
    //   result = context.fma(mulLhs, mulRhs, add)
    //   print(result)  # -5.064047626621544e371
    //
    // In Intel:
    //   _IDEC_flags status = 0;
    //   BID_UINT64 mulLhs = __bid64_from_string("-5064047626626594E276", BID_ROUNDING_TO_ZERO, &status);
    //   BID_UINT64 mulRhs = __bid64_from_string("+9999999999990028E64", BID_ROUNDING_TO_ZERO, &status);
    //   BID_UINT64 add = __bid64_from_string("+1E-398", BID_ROUNDING_TO_ZERO, &status);
    //
    //   status = 0;
    //   BID_UINT64 result = __bid64_fma(mulLhs, mulRhs, add, BID_ROUNDING_UP, &status);
    //
    //   __bid64_to_string(str, result, &status);
    //   printf("result: %s\n", str); // result: -5064047626621544E+356

    if mulLhs.binaryEncoding == (15299288382176831010 as T.BitPattern)
        && mulRhs.binaryEncoding == (7958853342308915468 as T.BitPattern)
        && add.binaryEncoding == (1 as T.BitPattern) {
      expected = T(binaryEncoding: 16019864322556105320)
    }
  }

  private func runMulSub<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let mulLhs: T = self.consumeDecimal(&parser) else { return }
    guard let mulRhs: T = self.consumeDecimal(&parser) else { return }
    guard var add: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    // 'fusedMultiplySub', not 'add'
    if !add.isNaN {
      add.negate()
    }

    var status = DecimalStatus()
    let result = add.addingProduct(mulLhs, mulRhs, rounding: rounding, status: &status)

    self.fixMulAdd_zeroInfNaN_raisesInvalidOperation(
      mulLhs: mulLhs,
      mulRhs: mulRhs,
      add: add,
      status: &status
    )

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func fixMulAdd_zeroInfNaN_raisesInvalidOperation<T: DecimalFloatingPoint>(
    mulLhs: T,
    mulRhs: T,
    add: T,
    status: inout DecimalStatus
  ) {
    // IEEE-754 -> 7.2 Invalid operation
    // These operations are:
    // ― fusedMultiplyAdd(0, ∞, c) or fusedMultiplyAdd(∞, 0, c) unless c is a
    //   quiet NaN; if c is a quiet NaN then it is implementation defined whether
    //   the invalid operation exception is signaled
    //
    // Our decision was to not raise 'invalid operation', tests expect raise.
    let zeroInf = mulLhs.isZero && mulRhs.isInfinite
    let infZero = mulLhs.isInfinite && mulRhs.isZero

    if (zeroInf || infZero) && add.isQuietNaN {
      status.set(.isInvalidOperation)
    }
  }

  private func runSqrt<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = d.squareRoot(rounding: rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runPropertyTest<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser,
    apply: (T) -> Bool
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected = self.consumeBool(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfStatusIsNotEmpty("Property", expectedStatus)
    self.addInvalidLineIfNotEnd(&parser)

    let result = apply(d)
    self.assertEqual(result, expected)
  }

  private func runUnary<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser,
    apply: (T) -> T
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)

    if !expectedStatus.isEmpty {
      self.addInvalidLine("Unary operations do not have status")
    }

    self.addInvalidLineIfNotEnd(&parser)

    let result = apply(d)
    self.assertEqual(result, expected)
  }

  private func runCompare<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expectedResult = self.consumeCompareResult(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    let expectedEqual = expectedResult == .equal
    let expectedLess = expectedResult == .less
    let expectedGreater = expectedResult == .greater
    var status = DecimalStatus()

    let isEqual = lhs.isEqual(to: rhs, status: &status)
    self.assertEqual(isEqual, expectedEqual, "isEqual")
    self.assertEqual(status, expectedStatus, "isEqual")
    status.clearAll()

    let isLess = lhs.isLess(than: rhs, status: &status)
    self.assertEqual(isLess, expectedLess, "isLess")
    self.assertEqual(status, expectedStatus, "isLess")
    status.clearAll()

    let isLessEqual = lhs.isLessThanOrEqualTo(rhs, status: &status)
    let expectedLessEqual = expectedEqual || expectedLess
    self.assertEqual(isLessEqual, expectedLessEqual, "isLessEqual")
    self.assertEqual(status, expectedStatus, "isLessEqual")
    status.clearAll()

    let isGreater = rhs.isLess(than: lhs, status: &status)
    self.assertEqual(isGreater, expectedGreater, "isGreater")
    self.assertEqual(status, expectedStatus, "isGreater")
    status.clearAll()

    let isGreaterEqual = rhs.isLessThanOrEqualTo(lhs, status: &status)
    let expectedGreaterEqual = expectedEqual || expectedGreater
    self.assertEqual(isGreaterEqual, expectedGreaterEqual, "isGreaterEqual")
    self.assertEqual(status, expectedStatus, "isGreaterEqual")
    status.clearAll()
  }

  private func runCompareTotal<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser,
    _ apply: (T) -> (T) -> Bool
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expectedResult = self.consumeCompareTotalResult(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfStatusIsNotEmpty("Compare total", expectedStatus)
    self.addInvalidLineIfNotEnd(&parser)

    let expectedBool: Bool
    switch expectedResult {
    case .equal, .less: expectedBool = true
    case .greater: expectedBool = false
    }

    let isBelowOrEqualTo = apply(lhs)(rhs)
    self.assertEqual(isBelowOrEqualTo, expectedBool)
  }

  private func runMinMax<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser,
    apply: (T, T, inout DecimalStatus) -> T
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = apply(lhs, rhs, &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runNext<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser,
    apply: (T, inout DecimalStatus) -> T
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = apply(d, &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runQuantize<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = lhs.quantized(to: rhs, rounding: rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runSameQuantum<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let lhs: T = self.consumeDecimal(&parser) else { return }
    guard let rhs: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected = self.consumeBool(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfStatusIsNotEmpty("Same quantum", expectedStatus)
    self.addInvalidLineIfNotEnd(&parser)

    let result = lhs.sameQuantum(as: rhs)
    self.assertEqual(result, expected)
  }

  private func runLogB<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) where T.Exponent == Int {
    self.consumeWhatever(&parser) // Rounding
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected = self.consumeInt(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = d.exponent(status: &status)
    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runScaleB<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) where T.Exponent == Int {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let significand: T = self.consumeDecimal(&parser) else { return }
    guard let exponent = self.consumeInt(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = T(
      sign: .plus,
      exponent: exponent,
      significand: significand,
      rounding: rounding,
      status: &status
    )

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runCopySign<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    self.consumeWhatever(&parser) // Rounding
    guard let magnitude: T = self.consumeDecimal(&parser) else { return }
    guard let sign: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfStatusIsNotEmpty("Copy sign", expectedStatus)
    self.addInvalidLineIfNotEnd(&parser)

    let result = T(signOf: sign, magnitudeOf: magnitude)
    self.assertEqual(result, expected)
  }

  private func runRound<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = d.rounded(rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  private func runRoundExact<T: DecimalFloatingPoint>(
    _ t: T.Type,
    _ parser: inout LineParser
  ) {
    guard let rounding = self.consumeRounding(&parser) else { return }
    guard let d: T = self.consumeDecimal(&parser) else { return }
    self.consumeArrow(&parser)
    guard let expected: T = self.consumeDecimal(&parser) else { return }
    let expectedStatus = self.consumeStatus(&parser)
    self.addInvalidLineIfNotEnd(&parser)

    var status = DecimalStatus()
    let result = d.rounded(rounding, status: &status)

    self.assertEqual(result, expected)
    self.assertEqual(status, expectedStatus)
  }

  // MARK: - Assert

  /// Bid equality.
  private func assertEqual<T: DecimalFloatingPoint>(_ lhs: T, _ rhs: T) {
    let lhsBid = lhs.binaryEncoding
    let rhsBid = rhs.binaryEncoding

    if lhsBid != rhsBid {
      let exp = lhs == rhs ? ", invalid exponent?" : ""
      self.addFailure("Assert equal \(lhsBid) != \(rhsBid) (BID), \(lhs) != \(rhs)\(exp)")
    }
  }

  /// Equal via `==`.
  private func assertEqualViaEqualEqual<T: DecimalFloatingPoint>(_ lhs: T, _ rhs: T) {
    if lhs.isNaN || rhs.isNaN {
      // NaN uses bid equality
      self.assertEqual(lhs, rhs)
    } else {
      self.addFailure("Assert equal \(lhs) != \(rhs)")
    }
  }

  private func assertEqual(_ lhs: Bool, _ rhs: Bool, _ message: String = "") {
    if lhs != rhs {
      let m = message.isEmpty ? "" : ": " + message
      self.addFailure("Assert equal \(lhs) != \(rhs)\(m)")
    }
  }

  private func assertEqual(_ lhs: Int, _ rhs: Int) {
    if lhs != rhs {
      self.addFailure("Assert equal \(lhs) != \(rhs)")
    }
  }

  private func assertEqual(
    _ lhs: DecimalStatus,
    _ rhs: DecimalStatus,
    _ message: String = ""
  ) {
    if lhs != rhs {
      let m = message.isEmpty ? "" : ": " + message
      self.addFailure("Assert equal \(lhs) == \(rhs)\(m)")
    }
  }

  // MARK: - Parse

  private func consumeWhatever(_ parser: inout LineParser) {
    parser.consumeSpaces()
    _ = parser.consumeUntilSpace()
  }

  private func consumeRounding(_ parser: inout LineParser) -> DecimalFloatingPointRoundingRule? {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()

    switch s {
    case ">": return .up
    case "<": return .down
    case "0": return .towardZero
    case "=0": return .toNearestOrEven
    case "h>": return .toNearestOrAwayFromZero
    default:
      self.addInvalidLine("Invalid rounding: \(s)")
      return nil
    }
  }

  private func consumeDecimal<T: DecimalFloatingPoint>(_ parser: inout LineParser) -> T? {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()
    var status = DecimalStatus()

    if s == "S" {
      return T.signalingNaN
    }

    if s == "Q" {
      return T.nan
    }

    if s == "->" {
      self.addInvalidLine("Expected decimal, got '->'")
      return nil
    }

    guard let result = T(s, status: &status) else {
      if s.contains("#") {
        self.addInvalidLine("Decimal should not contain: #.")
      } else {
        self.addFailure("Invalid decimal: \(s).")
      }

      return nil
    }

    guard status.isEmpty else {
      self.addFailure("Parsed '\(s)' as \(result) with invalid status: \(status)")
      return nil
    }

    return result
  }

  private func consumeArrow(_ parser: inout LineParser) {
    parser.consumeSpaces()
    _ = parser.consumeUntilSpace()
  }

  private func consumeInt(_ parser: inout LineParser) -> Int? {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()

    switch s {
    case "max": return Int.max
    case "min": return Int.min
    default:
      if let result = Int(s) {
        return result
      }

      self.addInvalidLine("Invalid Int: \(s).")
      return nil
    }
  }

  private func consumeBool(_ parser: inout LineParser) -> Bool? {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()

    switch s {
    case "0": return false
    case "1": return true
    default:
      self.addInvalidLine("Invalid Bool: \(s).")
      return nil
    }
  }

  private enum CompareResult {
    case nan
    case equal
    case less
    case greater
  }

  private func consumeCompareResult(_ parser: inout LineParser) -> CompareResult? {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()

    switch s {
    case "nan": return .nan
    case "eq": return .equal
    case "lt": return .less
    case "gt": return .greater
    default:
      self.addInvalidLine("Invalid compare result: \(s).")
      return nil
    }
  }

  private enum CompareTotalResult {
    case equal
    case less
    case greater
  }

  private func consumeCompareTotalResult(_ parser: inout LineParser) -> CompareTotalResult? {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()

    switch s {
    case "eq": return .equal
    case "lt": return .less
    case "gt": return .greater
    default:
      self.addInvalidLine("Invalid compare total result: \(s).")
      return nil
    }
  }

  private func consumeStatus(_ parser: inout LineParser) -> DecimalStatus {
    parser.consumeSpaces()
    let s = parser.consumeUntilSpace()

    // Mark as invalid, but only once.
    var isInvalidLine = false
    var result = DecimalStatus()

    for c in s {
      switch c {
      case "x": result.set(.isInexact)
      case "u": result.set(.isUnderflow)
      case "o": result.set(.isOverflow)
      case "z": result.set(.isDivisionByZero)
      case "i": result.set(.isInvalidOperation)
      default:
        if !isInvalidLine {
          isInvalidLine = true
          self.addInvalidLine("Invalid status: \(s).")
        }
      }
    }

    return result
  }

  // MARK: - Result

  func addFailure(_ message: String) {
    let f = TestResult.Failure(message: message, lineNo: lineNo, line: line)
    self.failures.append(f)
  }

  func addInvalidLine(_ message: String) {
    let i = TestResult.InvalidLine(message: message, lineNo: self.lineNo, line: self.line)
    self.invalidLines.append(i)
  }

  private func addInvalidLineIfNotEnd(_ parser: inout LineParser) {
    parser.consumeSpaces()

    if !parser.isEnd {
      self.addInvalidLine("Expected end")
    }
  }

  private func addInvalidLineIfStatusIsNotEmpty(_ operation: String, _ status: DecimalStatus) {
    if !status.isEmpty {
      self.addInvalidLine("\(operation) does not have status")
    }
  }

  func addFileError(_ message: String, error: Error? = nil) {
    let e = TestResult.FileError(message: message, lineNo: self.lineNo, error: error)
    self.fileErrors.append(e)
  }
}
