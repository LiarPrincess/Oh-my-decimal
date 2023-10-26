import Foundation

private let LF: UInt8 = 10
private let CR: UInt8 = 13
private let bufferSize = 8192
private let encoding = String.Encoding.ascii

@available(macOS 10.15.4, *)
class LineReader {

  private enum State {
    case new
    case open(FileDescriptor)
    case finished
  }

  private let file: File
  private var state = State.new
  private var data = Data()
  private var dataOffset = 0

  init(file: File) {
    self.file = file
  }

  enum Result {
    case line(String)
    case openError(Error)
    case readingError(Error)
    case decodingError(Data)
    case lineTooLong(maxLength: Int)
    case end
  }

  func readLine() -> Result {
    let fd: FileDescriptor

    switch self.state {
    case .new:
      do {
        fd = try FileSystem.openForReading(file: self.file)
        self.state = .open(fd)
      } catch {
        self.state = .finished
        return self.error(.openError(error))
      }
    case .open(let f):
      fd = f
    case .finished:
      return .end
    }

    if let endIndex = self.findLineEndIndex(data: self.data, offset: self.dataOffset) {
      let data = self.data[self.dataOffset..<endIndex]
      self.dataOffset = endIndex + 1
      return self.decode(data: data)
    }

    let newData: Data

    do {
      newData = try fd.read(count: bufferSize)
    } catch {
      self.state = .finished
      return self.error(.readingError(error))
    }

    if newData.isEmpty {
      self.state = .finished

      if self.data.isEmpty {
        return .end
      }

      let data = self.data[self.dataOffset...]
      return self.decode(data: data)
    }

    guard let endIndex = self.findLineEndIndex(data: newData, offset: 0) else {
      return self.error(.lineTooLong(maxLength: bufferSize))
    }

    let start = self.data[self.dataOffset...]
    let end = newData[..<endIndex]
    let lineData = start + end

    self.data = newData
    self.dataOffset = endIndex + 1

    return self.decode(data: lineData)
  }

  // Returns the index of the next `LF`.
  private func findLineEndIndex(data: Data, offset: Int) -> Int? {
    for i in offset..<data.count {
      let char = data[i]

      // We don't care about CR/CRLF.
      if char == LF {
        return i
      }
    }

    return nil
  }

  private func decode(data: Data) -> Result {
    if let s = String(data: data, encoding: encoding) {
      return .line(s)
    }

    return self.error(.decodingError(data))
  }

  private func error(_ error: Result) -> Result {
    self.state = .finished
    return error
  }

  func close() -> Error? {
    switch self.state {
    case .open(let fd):
      do {
        try fd.close()
      } catch {
        return error
      }

    case .new,
         .finished:
      break
    }

    self.state = .finished
    return nil
  }
}
