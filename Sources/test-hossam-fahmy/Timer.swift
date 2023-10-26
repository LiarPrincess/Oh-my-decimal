import Foundation

struct Timer {

  struct Duration {
    let seconds: Double
    let secondsString: String
  }

  private var _start = DispatchTime.distantFuture
  private var _end = DispatchTime.distantFuture

  /// Duration in seconds
  var duration: Duration {
    let nano = self._end.uptimeNanoseconds - self._start.uptimeNanoseconds
    let seconds = Double(nano) / 1_000_000_000
    let secondsString = String(format: "%.2f", seconds)
    return Duration(seconds: seconds, secondsString: secondsString)
  }

  mutating func start() {
    self._start = DispatchTime.now()
  }

  mutating func end() {
    self._end = DispatchTime.now()
  }
}
