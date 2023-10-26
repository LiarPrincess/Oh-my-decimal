// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Decimal",
  products: [
    .library(
      name: "Decimal",
      targets: ["Decimal"]
    ),
  ],
  targets: [
    .target(
      name: "Decimal",
      dependencies: ["Cbid"]
    ),
    .systemLibrary(
      name: "Cbid"
    ),
    .testTarget(
      name: "DecimalTests",
      dependencies: ["Decimal"]
    ),
  ]
)
