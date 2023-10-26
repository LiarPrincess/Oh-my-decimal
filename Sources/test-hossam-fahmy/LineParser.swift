struct LineParser {

  private let line: String
  private var index: String.Index

  var isEnd: Bool { self.index == self.line.endIndex }

  init(line: String) {
    self.line = line
    self.index = line.startIndex
  }

  mutating func consumeSpaces() {
    var index = self.index
    self.advanceWhile(&index) { $0.isWhitespace }
    self.index = index
  }

  mutating func consumeUntilSpace() -> Substring {
    let start = self.index
    var end = start
    self.advanceWhile(&end) { !$0.isWhitespace }
    self.index = end
    return self.line[start..<end]
  }

  private mutating func advanceWhile(
    _ index: inout String.Index,
    fn: (Character) -> Bool
  ) {
    while index != self.line.endIndex, fn(self.line[index]) {
      self.line.formIndex(after: &index)
    }
  }
}
