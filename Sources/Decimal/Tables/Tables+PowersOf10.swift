extension Tables {

  /// 10 to the `exponent`.
  ///
  /// - 0 -> 1
  /// - 1 -> 10
  /// - 2 -> 100
  ///
  /// Usage: `let pow10: UInt64 = Tables.getPowerOf10(exponent: 3)`.
  internal static func getPowerOf10<T: FixedWidthInteger>(exponent index: Int) -> T {
    assert(index >= 0, "Negative exponent in pow10?")

    if index < data128.count {
      let r = data128[index]
      assert(r <= T.max)
      return T(truncatingIfNeeded: r)
    }

    let index256 = index - data128.count
    let r = data256[index256]
    assert(r <= T.max)
    return T(truncatingIfNeeded: r)
  }
}

// Use following code to generate:
//
// var n = UInt256(0, 0, 0, 1)
//
// for exponent in 0..<1000 {
//   if n.w0 == 0 && n.w1 == 0 {
//     print("  UInt128(\(hex(n.w2)), \(hex(n.w3))), // 10^\(exponent)")
//   } else {
//     print("  UInt256(\(hex(n.w0)), \(hex(n.w1)), \(hex(n.w2)), \(hex(n.w3))), // 10^\(exponent)")
//   }
//
//   let mul = n.multipliedReportingOverflow(by: 10 as UInt128)
//   if mul.overflow { print("UInt256 overflow"); break }
//   n = mul.partialValue
// }
//
// func hex(_ n: UInt64) -> String {
//   let s = String(n, radix: 16)
//   let pad = String(repeating: "0", count: 16 - s.count)
//   return "0x" + pad + s
// }

private let data128: [UInt128] = [
  UInt128(0x0000000000000000, 0x0000000000000001), // 10^0
  UInt128(0x0000000000000000, 0x000000000000000a), // 10^1
  UInt128(0x0000000000000000, 0x0000000000000064), // 10^2
  UInt128(0x0000000000000000, 0x00000000000003e8), // 10^3
  UInt128(0x0000000000000000, 0x0000000000002710), // 10^4
  UInt128(0x0000000000000000, 0x00000000000186a0), // 10^5
  UInt128(0x0000000000000000, 0x00000000000f4240), // 10^6
  UInt128(0x0000000000000000, 0x0000000000989680), // 10^7
  UInt128(0x0000000000000000, 0x0000000005f5e100), // 10^8
  UInt128(0x0000000000000000, 0x000000003b9aca00), // 10^9
  UInt128(0x0000000000000000, 0x00000002540be400), // 10^10
  UInt128(0x0000000000000000, 0x000000174876e800), // 10^11
  UInt128(0x0000000000000000, 0x000000e8d4a51000), // 10^12
  UInt128(0x0000000000000000, 0x000009184e72a000), // 10^13
  UInt128(0x0000000000000000, 0x00005af3107a4000), // 10^14
  UInt128(0x0000000000000000, 0x00038d7ea4c68000), // 10^15
  UInt128(0x0000000000000000, 0x002386f26fc10000), // 10^16
  UInt128(0x0000000000000000, 0x016345785d8a0000), // 10^17
  UInt128(0x0000000000000000, 0x0de0b6b3a7640000), // 10^18
  UInt128(0x0000000000000000, 0x8ac7230489e80000), // 10^19
  UInt128(0x0000000000000005, 0x6bc75e2d63100000), // 10^20
  UInt128(0x0000000000000036, 0x35c9adc5dea00000), // 10^21
  UInt128(0x000000000000021e, 0x19e0c9bab2400000), // 10^22
  UInt128(0x000000000000152d, 0x02c7e14af6800000), // 10^23
  UInt128(0x000000000000d3c2, 0x1bcecceda1000000), // 10^24
  UInt128(0x0000000000084595, 0x161401484a000000), // 10^25
  UInt128(0x000000000052b7d2, 0xdcc80cd2e4000000), // 10^26
  UInt128(0x00000000033b2e3c, 0x9fd0803ce8000000), // 10^27
  UInt128(0x00000000204fce5e, 0x3e25026110000000), // 10^28
  UInt128(0x00000001431e0fae, 0x6d7217caa0000000), // 10^29
  UInt128(0x0000000c9f2c9cd0, 0x4674edea40000000), // 10^30
  UInt128(0x0000007e37be2022, 0xc0914b2680000000), // 10^31
  UInt128(0x000004ee2d6d415b, 0x85acef8100000000), // 10^32
  UInt128(0x0000314dc6448d93, 0x38c15b0a00000000), // 10^33
  UInt128(0x0001ed09bead87c0, 0x378d8e6400000000), // 10^34
  UInt128(0x0013426172c74d82, 0x2b878fe800000000), // 10^35
  UInt128(0x00c097ce7bc90715, 0xb34b9f1000000000), // 10^36
  UInt128(0x0785ee10d5da46d9, 0x00f436a000000000), // 10^37
  UInt128(0x4b3b4ca85a86c47a, 0x098a224000000000), // 10^38
]

private let data256: [UInt256] = [
  UInt256(0x0000000000000000, 0x0000000000000002, 0xf050fe938943acc4, 0x5f65568000000000), // 10^39
  UInt256(0x0000000000000000, 0x000000000000001d, 0x6329f1c35ca4bfab, 0xb9f5610000000000), // 10^40
  UInt256(0x0000000000000000, 0x0000000000000125, 0xdfa371a19e6f7cb5, 0x4395ca0000000000), // 10^41
  UInt256(0x0000000000000000, 0x0000000000000b7a, 0xbc627050305adf14, 0xa3d9e40000000000), // 10^42
  UInt256(0x0000000000000000, 0x00000000000072cb, 0x5bd86321e38cb6ce, 0x6682e80000000000), // 10^43
  UInt256(0x0000000000000000, 0x0000000000047bf1, 0x9673df52e37f2410, 0x011d100000000000), // 10^44
  UInt256(0x0000000000000000, 0x00000000002cd76f, 0xe086b93ce2f768a0, 0x0b22a00000000000), // 10^45
  UInt256(0x0000000000000000, 0x0000000001c06a5e, 0xc5433c60ddaa1640, 0x6f5a400000000000), // 10^46
  UInt256(0x0000000000000000, 0x00000000118427b3, 0xb4a05bc8a8a4de84, 0x5986800000000000), // 10^47
  UInt256(0x0000000000000000, 0x00000000af298d05, 0x0e4395d69670b12b, 0x7f41000000000000), // 10^48
  UInt256(0x0000000000000000, 0x00000006d79f8232, 0x8ea3da61e066ebb2, 0xf88a000000000000), // 10^49
  UInt256(0x0000000000000000, 0x000000446c3b15f9, 0x926687d2c40534fd, 0xb564000000000000), // 10^50
  UInt256(0x0000000000000000, 0x000002ac3a4edbbf, 0xb8014e3ba83411e9, 0x15e8000000000000), // 10^51
  UInt256(0x0000000000000000, 0x00001aba4714957d, 0x300d0e549208b31a, 0xdb10000000000000), // 10^52
  UInt256(0x0000000000000000, 0x00010b46c6cdd6e3, 0xe0828f4db456ff0c, 0x8ea0000000000000), // 10^53
  UInt256(0x0000000000000000, 0x000a70c3c40a64e6, 0xc51999090b65f67d, 0x9240000000000000), // 10^54
  UInt256(0x0000000000000000, 0x006867a5a867f103, 0xb2fffa5a71fba0e7, 0xb680000000000000), // 10^55
  UInt256(0x0000000000000000, 0x04140c78940f6a24, 0xfdffc78873d4490d, 0x2100000000000000), // 10^56
  UInt256(0x0000000000000000, 0x28c87cb5c89a2571, 0xebfdcb54864ada83, 0x4a00000000000000), // 10^57
  UInt256(0x0000000000000001, 0x97d4df19d6057673, 0x37e9f14d3eec8920, 0xe400000000000000), // 10^58
  UInt256(0x000000000000000f, 0xee50b7025c36a080, 0x2f236d04753d5b48, 0xe800000000000000), // 10^59
  UInt256(0x000000000000009f, 0x4f2726179a224501, 0xd762422c946590d9, 0x1000000000000000), // 10^60
  UInt256(0x0000000000000639, 0x17877cec0556b212, 0x69d695bdcbf7a87a, 0xa000000000000000), // 10^61
  UInt256(0x0000000000003e3a, 0xeb4ae1383562f4b8, 0x2261d969f7ac94ca, 0x4000000000000000), // 10^62
  UInt256(0x0000000000026e4d, 0x30eccc3215dd8f31, 0x57d27e23acbdcfe6, 0x8000000000000000), // 10^63
  UInt256(0x0000000000184f03, 0xe93ff9f4daa797ed, 0x6e38ed64bf6a1f01, 0x0000000000000000), // 10^64
  UInt256(0x0000000000f31627, 0x1c7fc3908a8bef46, 0x4e3945ef7a25360a, 0x0000000000000000), // 10^65
  UInt256(0x00000000097edd87, 0x1cfda3a5697758bf, 0x0e3cbb5ac5741c64, 0x0000000000000000), // 10^66
  UInt256(0x000000005ef4a747, 0x21e864761ea97776, 0x8e5f518bb6891be8, 0x0000000000000000), // 10^67
  UInt256(0x00000003b58e88c7, 0x5313ec9d329eaaa1, 0x8fb92f75215b1710, 0x0000000000000000), // 10^68
  UInt256(0x00000025179157c9, 0x3ec73e23fa32aa4f, 0x9d3bda934d8ee6a0, 0x0000000000000000), // 10^69
  UInt256(0x00000172ebad6ddc, 0x73c86d67c5faa71c, 0x245689c107950240, 0x0000000000000000), // 10^70
  UInt256(0x00000e7d34c64a9c, 0x85d4460dbbca8719, 0x6b61618a4bd21680, 0x0000000000000000), // 10^71
  UInt256(0x000090e40fbeea1d, 0x3a4abc8955e946fe, 0x31cdcf66f634e100, 0x0000000000000000), // 10^72
  UInt256(0x0005a8e89d752524, 0x46eb5d5d5b1cc5ed, 0xf20a1a059e10ca00, 0x0000000000000000), // 10^73
  UInt256(0x003899162693736a, 0xc531a5a58f1fbb4b, 0x746504382ca7e400, 0x0000000000000000), // 10^74
  UInt256(0x0235fadd81c2822b, 0xb3f07877973d50f2, 0x8bf22a31be8ee800, 0x0000000000000000), // 10^75
  UInt256(0x161bcca7119915b5, 0x0764b4abe8652979, 0x7775a5f171951000, 0x0000000000000000), // 10^76
  UInt256(0xdd15fe86affad912, 0x49ef0eb713f39ebe, 0xaa987b6e6fd2a000, 0x0000000000000000), // 10^77
]