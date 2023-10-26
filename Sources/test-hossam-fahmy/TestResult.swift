struct TestResult {

  let file: File
  let lineCount: Int
  let duration: Timer.Duration

  let failures: [Failure]
  let invalidLines: [InvalidLine]
  let fileErrors: [FileError]

  /// Test failed
  struct Failure {
    let message: String
    let lineNo: Int
    let line: String
  }

  /// Line is not valid.
  struct InvalidLine {
    let message: String
    let lineNo: Int
    let line: String
  }

  /// Error when reading the file.
  struct FileError {
    let message: String
    let lineNo: Int?
    let error: Error?
  }
}
