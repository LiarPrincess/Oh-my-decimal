import Decimal
import Foundation

@MainActor
private func print(result: TestResult) {
  let name = result.file.name
  let path = result.file.path
  let duration = result.duration.secondsString

  if result.fileErrors.any {
    print("\(name) FILE ERROR (!!1)")
  } else if result.failures.any {
    print("\(name) failed (\(duration)s)")
  } else {
    print("\(name) passed (\(duration)s)")
  }

  for i in result.invalidLines {
    print("🟡 \(path):\(i.lineNo) \(i.message)")
  }

  for i in result.failures {
    print("🔴 \(path):\(i.lineNo) \(i.message)")
    print(i.line)
  }

  for i in result.fileErrors {
    let lineNo = i.lineNo.map { ": \($0)" } ?? ""
    let error = i.error.map { " \($0)" } ?? ""
    print("💀 \(path)\(lineNo) \(i.message)\(error)")
  }
}

@MainActor
@available(macOS 10.15.4, *)
func main() async throws -> Int32 {
#if DEBUG
  print(String(repeating: "=", count: 80))
  print("Hossam Fahmy tests should be run in RELEASE mode!")
  print("(unless you have a lot of time)")
  print(String(repeating: "=", count: 80))
  print()
#endif

  if CommandLine.arguments.count < 2 {
    print("USAGE: test-hossam-fahmy DIRECTORIES_WITH_TESTS…")
    return EXIT_FAILURE
  }

  var files = [File]()

  for dir in CommandLine.arguments.dropFirst() {
    let dirFiles = try FileSystem.readdir(path: dir, recursive: true)

    for file in dirFiles where file.extension == "txt" {
      files.append(file)
    }
  }

  var timer = Timer()
  timer.start()

  // Execute tests in parallel.
  let results = await withTaskGroup(of: TestResult.self) { group -> [TestResult] in
    for file in files {
      group.addTask {
        let runner = TestRunner(file: file)
        let result = await runner.run()
        await print(result: result)
        return result
      }
    }

    var acc = [TestResult]()

    for await result in group {
      acc.append(result)
    }

    return acc
  }

  timer.end()
  let duration = timer.duration.secondsString

  var lineCount = 0
  var invalidLineCount = 0
  var failureCount = 0
  var fileErrorCount = 0

  for r in results {
    lineCount += r.lineCount
    failureCount += r.failures.count
    fileErrorCount += r.fileErrors.count
    invalidLineCount += r.invalidLines.count
  }

  let fileCount = files.count
  let fileCountS = fileCount == 1 ? "" : "s"

  if fileErrorCount != 0 {
    let s = fileErrorCount == 1 ? "" : "s"
    print("💀 Executed \(fileCount) test\(fileCountS), with \(fileErrorCount) file error\(s). CRITICAL!!1")
    return EXIT_FAILURE
  }

  if failureCount != 0 {
    let s = failureCount == 1 ? "" : "s"
    let emoji = ["💩", "🙈", "😵", "😟"].randomElement() ?? "FAIL"
    print("\(emoji) Executed \(fileCount) test\(fileCountS), with \(failureCount) failure\(s) in \(duration)s")
    return EXIT_FAILURE
  }

  if lineCount == 0 {
    print("🦄 No tests? ")
  }

  // There are more emoji for success than failure, because we are optimists.
  let emoji = ["🩷", "🎉", "⭐", "😊", "😘", "😍"].randomElement() ?? "OK"
  let invalid = invalidLineCount == 0 ? "" : ", \(invalidLineCount) invalid"
  print("\(emoji) Executed \(fileCount) test\(fileCountS) (\(lineCount) lines\(invalid)) in \(duration)s")
  return EXIT_SUCCESS
}

if #available(macOS 10.15.4, *) {
  let status = try await main()
  exit(status)
} else {
  print("Unsupported macOS version")
  exit(EXIT_FAILURE)
}
