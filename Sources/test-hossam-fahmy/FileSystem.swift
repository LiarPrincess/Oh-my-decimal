import Foundation

struct File: CustomStringConvertible {
  fileprivate let url: URL

  var name: String { self.url.lastPathComponent }
  var path: String { self.url.path }
  var `extension`: String { self.url.pathExtension }
  var description: String { self.path }

  init(path: String) {
    self.url = URL(fileURLWithPath: path)
  }

  fileprivate init(url: URL) {
    self.url = url
  }
}

@available(macOS 10.15.4, *)
struct FileDescriptor {
  fileprivate let raw: FileHandle

  func read(count: Int) throws -> Data {
    let result = try self.raw.read(upToCount: count)
    return result ?? Data()
  }

  func close() throws {
    try self.raw.close()
  }
}

private let fm = FileManager.default

@available(macOS 10.15.4, *)
enum FileSystem {

  static func openForReading(file: File) throws -> FileDescriptor {
    let raw = try FileHandle(forReadingFrom: file.url)
    return FileDescriptor(raw: raw)
  }

  static func readdir(
    path: String,
    recursive: Bool = false
  ) throws -> [File] {
    var result = [File]()
    let url = URL(fileURLWithPath: path, isDirectory: true)
    try Self.readdir(url: url, recursive: recursive, into: &result)
    return result
  }

  private static func readdir(
    url: URL,
    recursive: Bool,
    into result: inout [File]
  ) throws {
    let entries = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

    for e in entries {
      if e.hasDirectoryPath && recursive {
        try Self.readdir(url: e, recursive: recursive, into: &result)
      } else {
        result.append(File(url: e))
      }
    }
  }
}
