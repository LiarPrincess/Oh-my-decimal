/// `bid_nr_digits[i - 1] (where 1 <= i <= 113)`
internal struct DecimalDigitCount {
  /// Number of decimal digits; 0 if it requires `k` or `k + 1` digits.
  private let digits: Int
  /// Number of decimal digits if `self.digits == 0`:
  /// `value < threshold ? digits1 : digits1 + 1`
  private let digits1: Int
  private let threshold: UInt128

  fileprivate init(
    _ digits: Int,
    _ thresholdHi: UInt64,
    _ thresholdLo: UInt64,
    _ digits1: Int
  ) {
    self.digits = digits
    self.digits1 = digits1
    self.threshold = UInt128(high: thresholdHi, low: thresholdLo)
  }

  internal func getDigitCount<T: BinaryIntegerDecimal>(significand: T) -> Int {
    if self.digits != 0 {
      return self.digits
    }

    let extraDigit = significand < self.threshold ? 0 : 1
    return self.digits1 + extraDigit
  }
}

extension Tables {

  @available(*, deprecated, renamed: "decimalDigitCount")
  internal static let bid_nr_digits = Self.decimalDigitCount

  internal static let decimalDigitCount: [DecimalDigitCount] = [
    // only the first entry is used if it is not 0
    DecimalDigitCount(1, 0x0000000000000000, 0x000000000000000a, 1),   //   1-bit n < 10^1
    DecimalDigitCount(1, 0x0000000000000000, 0x000000000000000a, 1),   //   2-bit n < 10^1
    DecimalDigitCount(1, 0x0000000000000000, 0x000000000000000a, 1),   //   3-bit n < 10^1
    DecimalDigitCount(0, 0x0000000000000000, 0x000000000000000a, 1),   //   4-bit n ? 10^1
    DecimalDigitCount(2, 0x0000000000000000, 0x0000000000000064, 2),   //   5-bit n < 10^2
    DecimalDigitCount(2, 0x0000000000000000, 0x0000000000000064, 2),   //   6-bit n < 10^2
    DecimalDigitCount(0, 0x0000000000000000, 0x0000000000000064, 2),   //   7-bit n ? 10^2
    DecimalDigitCount(3, 0x0000000000000000, 0x00000000000003e8, 3),   //   8-bit n < 10^3
    DecimalDigitCount(3, 0x0000000000000000, 0x00000000000003e8, 3),   //   9-bit n < 10^3
    DecimalDigitCount(0, 0x0000000000000000, 0x00000000000003e8, 3),   //  10-bit n ? 10^3
    DecimalDigitCount(4, 0x0000000000000000, 0x0000000000002710, 4),   //  11-bit n < 10^4
    DecimalDigitCount(4, 0x0000000000000000, 0x0000000000002710, 4),   //  12-bit n < 10^4
    DecimalDigitCount(4, 0x0000000000000000, 0x0000000000002710, 4),   //  13-bit n < 10^4
    DecimalDigitCount(0, 0x0000000000000000, 0x0000000000002710, 4),   //  14-bit n ? 10^4
    DecimalDigitCount(5, 0x0000000000000000, 0x00000000000186a0, 5),   //  15-bit n < 10^5
    DecimalDigitCount(5, 0x0000000000000000, 0x00000000000186a0, 5),   //  16-bit n < 10^5
    DecimalDigitCount(0, 0x0000000000000000, 0x00000000000186a0, 5),   //  17-bit n ? 10^5
    DecimalDigitCount(6, 0x0000000000000000, 0x00000000000f4240, 6),   //  18-bit n < 10^6
    DecimalDigitCount(6, 0x0000000000000000, 0x00000000000f4240, 6),   //  19-bit n < 10^6
    DecimalDigitCount(0, 0x0000000000000000, 0x00000000000f4240, 6),   //  20-bit n ? 10^6
    DecimalDigitCount(7, 0x0000000000000000, 0x0000000000989680, 7),   //  21-bit n < 10^7
    DecimalDigitCount(7, 0x0000000000000000, 0x0000000000989680, 7),   //  22-bit n < 10^7
    DecimalDigitCount(7, 0x0000000000000000, 0x0000000000989680, 7),   //  23-bit n < 10^7
    DecimalDigitCount(0, 0x0000000000000000, 0x0000000000989680, 7),   //  24-bit n ? 10^7
    DecimalDigitCount(8, 0x0000000000000000, 0x0000000005f5e100, 8),   //  25-bit n < 10^8
    DecimalDigitCount(8, 0x0000000000000000, 0x0000000005f5e100, 8),   //  26-bit n < 10^8
    DecimalDigitCount(0, 0x0000000000000000, 0x0000000005f5e100, 8),   //  27-bit n ? 10^8
    DecimalDigitCount(9, 0x0000000000000000, 0x000000003b9aca00, 9),   //  28-bit n < 10^9
    DecimalDigitCount(9, 0x0000000000000000, 0x000000003b9aca00, 9),   //  29-bit n < 10^9
    DecimalDigitCount(0, 0x0000000000000000, 0x000000003b9aca00, 9),   //  30-bit n ? 10^9
    DecimalDigitCount(10, 0x0000000000000000, 0x00000002540be400, 10), //  31-bit n < 10^10
    DecimalDigitCount(10, 0x0000000000000000, 0x00000002540be400, 10), //  32-bit n < 10^10
    DecimalDigitCount(10, 0x0000000000000000, 0x00000002540be400, 10), //  33-bit n < 10^10
    DecimalDigitCount(0, 0x0000000000000000, 0x00000002540be400, 10),  //  34-bit n ? 10^10
    DecimalDigitCount(11, 0x0000000000000000, 0x000000174876e800, 11), //  35-bit n < 10^11
    DecimalDigitCount(11, 0x0000000000000000, 0x000000174876e800, 11), //  36-bit n < 10^11
    DecimalDigitCount(0, 0x0000000000000000, 0x000000174876e800, 11),  //  37-bit n ? 10^11
    DecimalDigitCount(12, 0x0000000000000000, 0x000000e8d4a51000, 12), //  38-bit n < 10^12
    DecimalDigitCount(12, 0x0000000000000000, 0x000000e8d4a51000, 12), //  39-bit n < 10^12
    DecimalDigitCount(0, 0x0000000000000000, 0x000000e8d4a51000, 12),  //  40-bit n ? 10^12
    DecimalDigitCount(13, 0x0000000000000000, 0x000009184e72a000, 13), //  41-bit n < 10^13
    DecimalDigitCount(13, 0x0000000000000000, 0x000009184e72a000, 13), //  42-bit n < 10^13
    DecimalDigitCount(13, 0x0000000000000000, 0x000009184e72a000, 13), //  43-bit n < 10^13
    DecimalDigitCount(0, 0x0000000000000000, 0x000009184e72a000, 13),  //  44-bit n ? 10^13
    DecimalDigitCount(14, 0x0000000000000000, 0x00005af3107a4000, 14), //  45-bit n < 10^14
    DecimalDigitCount(14, 0x0000000000000000, 0x00005af3107a4000, 14), //  46-bit n < 10^14
    DecimalDigitCount(0, 0x0000000000000000, 0x00005af3107a4000, 14),  //  47-bit n ? 10^14
    DecimalDigitCount(15, 0x0000000000000000, 0x00038d7ea4c68000, 15), //  48-bit n < 10^15
    DecimalDigitCount(15, 0x0000000000000000, 0x00038d7ea4c68000, 15), //  49-bit n < 10^15
    DecimalDigitCount(0, 0x0000000000000000, 0x00038d7ea4c68000, 15),  //  50-bit n ? 10^15
    DecimalDigitCount(16, 0x0000000000000000, 0x002386f26fc10000, 16), //  51-bit n < 10^16
    DecimalDigitCount(16, 0x0000000000000000, 0x002386f26fc10000, 16), //  52-bit n < 10^16
    DecimalDigitCount(16, 0x0000000000000000, 0x002386f26fc10000, 16), //  53-bit n < 10^16
    DecimalDigitCount(0, 0x0000000000000000, 0x002386f26fc10000, 16),  //  54-bit n ? 10^16
    DecimalDigitCount(17, 0x0000000000000000, 0x016345785d8a0000, 17), //  55-bit n < 10^17
    DecimalDigitCount(17, 0x0000000000000000, 0x016345785d8a0000, 17), //  56-bit n < 10^17
    DecimalDigitCount(0, 0x0000000000000000, 0x016345785d8a0000, 17),  //  57-bit n ? 10^17
    DecimalDigitCount(18, 0x0000000000000000, 0x0de0b6b3a7640000, 18), //  58-bit n < 10^18
    DecimalDigitCount(18, 0x0000000000000000, 0x0de0b6b3a7640000, 18), //  59-bit n < 10^18
    DecimalDigitCount(0, 0x0000000000000000, 0x0de0b6b3a7640000, 18),  //  60-bit n ? 10^18
    DecimalDigitCount(19, 0x0000000000000000, 0x8ac7230489e80000, 19), //  61-bit n < 10^19
    DecimalDigitCount(19, 0x0000000000000000, 0x8ac7230489e80000, 19), //  62-bit n < 10^19
    DecimalDigitCount(19, 0x0000000000000000, 0x8ac7230489e80000, 19), //  63-bit n < 10^19
    DecimalDigitCount(0, 0x0000000000000000, 0x8ac7230489e80000, 19),  //  64-bit n ? 10^19
    DecimalDigitCount(20, 0x0000000000000005, 0x6bc75e2d63100000, 20), //  65-bit n < 10^20
    DecimalDigitCount(20, 0x0000000000000005, 0x6bc75e2d63100000, 20), //  66-bit n < 10^20
    DecimalDigitCount(0, 0x0000000000000005, 0x6bc75e2d63100000, 20),  //  67-bit n ? 10^20
    DecimalDigitCount(21, 0x0000000000000036, 0x35c9adc5dea00000, 21), //  68-bit n < 10^21
    DecimalDigitCount(21, 0x0000000000000036, 0x35c9adc5dea00000, 21), //  69-bit n < 10^21
    DecimalDigitCount(0, 0x0000000000000036, 0x35c9adc5dea00000, 21),  //  70-bit n ? 10^21
    DecimalDigitCount(22, 0x000000000000021e, 0x19e0c9bab2400000, 22), //  71-bit n < 10^22
    DecimalDigitCount(22, 0x000000000000021e, 0x19e0c9bab2400000, 22), //  72-bit n < 10^22
    DecimalDigitCount(22, 0x000000000000021e, 0x19e0c9bab2400000, 22), //  73-bit n < 10^22
    DecimalDigitCount(0, 0x000000000000021e, 0x19e0c9bab2400000, 22),  //  74-bit n ? 10^22
    DecimalDigitCount(23, 0x000000000000152d, 0x02c7e14af6800000, 23), //  75-bit n < 10^23
    DecimalDigitCount(23, 0x000000000000152d, 0x02c7e14af6800000, 23), //  76-bit n < 10^23
    DecimalDigitCount(0, 0x000000000000152d, 0x02c7e14af6800000, 23),  //  77-bit n ? 10^23
    DecimalDigitCount(24, 0x000000000000d3c2, 0x1bcecceda1000000, 24), //  78-bit n < 10^24
    DecimalDigitCount(24, 0x000000000000d3c2, 0x1bcecceda1000000, 24), //  79-bit n < 10^24
    DecimalDigitCount(0, 0x000000000000d3c2, 0x1bcecceda1000000, 24),  //  80-bit n ? 10^24
    DecimalDigitCount(25, 0x0000000000084595, 0x161401484a000000, 25), //  81-bit n < 10^25
    DecimalDigitCount(25, 0x0000000000084595, 0x161401484a000000, 25), //  82-bit n < 10^25
    DecimalDigitCount(25, 0x0000000000084595, 0x161401484a000000, 25), //  83-bit n < 10^25
    DecimalDigitCount(0, 0x0000000000084595, 0x161401484a000000, 25),  //  84-bit n ? 10^25
    DecimalDigitCount(26, 0x000000000052b7d2, 0xdcc80cd2e4000000, 26), //  85-bit n < 10^26
    DecimalDigitCount(26, 0x000000000052b7d2, 0xdcc80cd2e4000000, 26), //  86-bit n < 10^26
    DecimalDigitCount(0, 0x000000000052b7d2, 0xdcc80cd2e4000000, 26),  //  87-bit n ? 10^26
    DecimalDigitCount(27, 0x00000000033b2e3c, 0x9fd0803ce8000000, 27), //  88-bit n < 10^27
    DecimalDigitCount(27, 0x00000000033b2e3c, 0x9fd0803ce8000000, 27), //  89-bit n < 10^27
    DecimalDigitCount(0, 0x00000000033b2e3c, 0x9fd0803ce8000000, 27),  //  90-bit n ? 10^27
    DecimalDigitCount(28, 0x00000000204fce5e, 0x3e25026110000000, 28), //  91-bit n < 10^28
    DecimalDigitCount(28, 0x00000000204fce5e, 0x3e25026110000000, 28), //  92-bit n < 10^28
    DecimalDigitCount(28, 0x00000000204fce5e, 0x3e25026110000000, 28), //  93-bit n < 10^28
    DecimalDigitCount(0, 0x00000000204fce5e, 0x3e25026110000000, 28),  //  94-bit n ? 10^28
    DecimalDigitCount(29, 0x00000001431e0fae, 0x6d7217caa0000000, 29), //  95-bit n < 10^29
    DecimalDigitCount(29, 0x00000001431e0fae, 0x6d7217caa0000000, 29), //  96-bit n < 10^29
    DecimalDigitCount(0, 0x00000001431e0fae, 0x6d7217caa0000000, 29),  //  97-bit n ? 10^29
    DecimalDigitCount(30, 0x0000000c9f2c9cd0, 0x4674edea40000000, 30), //  98-bit n < 10^30
    DecimalDigitCount(30, 0x0000000c9f2c9cd0, 0x4674edea40000000, 30), //  99-bit n < 10^30
    DecimalDigitCount(0, 0x0000000c9f2c9cd0, 0x4674edea40000000, 30),  // 100-bit n ? 10^30
    DecimalDigitCount(31, 0x0000007e37be2022, 0xc0914b2680000000, 31), // 101-bit n < 10^31
    DecimalDigitCount(31, 0x0000007e37be2022, 0xc0914b2680000000, 31), // 102-bit n < 10^31
    DecimalDigitCount(0, 0x0000007e37be2022, 0xc0914b2680000000, 31),  // 103-bit n ? 10^31
    DecimalDigitCount(32, 0x000004ee2d6d415b, 0x85acef8100000000, 32), // 104-bit n < 10^32
    DecimalDigitCount(32, 0x000004ee2d6d415b, 0x85acef8100000000, 32), // 105-bit n < 10^32
    DecimalDigitCount(32, 0x000004ee2d6d415b, 0x85acef8100000000, 32), // 106-bit n < 10^32
    DecimalDigitCount(0, 0x000004ee2d6d415b, 0x85acef8100000000, 32),  // 107-bit n ? 10^32
    DecimalDigitCount(33, 0x0000314dc6448d93, 0x38c15b0a00000000, 33), // 108-bit n < 10^33
    DecimalDigitCount(33, 0x0000314dc6448d93, 0x38c15b0a00000000, 33), // 109-bit n < 10^33
    DecimalDigitCount(0, 0x0000314dc6448d93, 0x38c15b0a00000000, 33),  // 100-bit n ? 10^33
    DecimalDigitCount(34, 0x0001ed09bead87c0, 0x378d8e6400000000, 34), // 111-bit n < 10^34
    DecimalDigitCount(34, 0x0001ed09bead87c0, 0x378d8e6400000000, 34), // 112-bit n < 10^34
    DecimalDigitCount(0, 0x0001ed09bead87c0, 0x378d8e6400000000, 34),  // 113-bit n ? 10^34
    // DecimalDigitCount(35, 0x0013426172c74d82, 0x2b878fe800000000, 35) // 114-bit n < 10^35
  ]
}
