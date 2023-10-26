// swift-tools-version: 5.5

import PackageDescription

let package = Package(
  name: "Decimal",
  products: [
    .library(name: "Decimal", targets: ["Decimal"]),
    .executable(name: "test-hossam-fahmy", targets: ["test-hossam-fahmy"])
  ],
  targets: [
    .target(
      name: "Decimal",
      exclude: ["Generated/README.md"]
    ),
    // Run tests from: http://eece.cu.edu.eg/~hfahmy/arith_debug
    .executableTarget(
      name: "test-hossam-fahmy",
      dependencies: ["Decimal"]
    ),
    .testTarget(
      name: "DecimalTests",
      dependencies: ["Decimal"],
      exclude: [
        "Generated/README.md",
        "Intel - generated/README.md",
        "Speleotrove - generated/README.md"
      ]
    )
  ]
)
