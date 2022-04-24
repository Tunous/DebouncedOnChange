// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "DebouncedOnChange",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "DebouncedOnChange",
            targets: ["DebouncedOnChange"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DebouncedOnChange",
            dependencies: []),
        .testTarget(
            name: "DebouncedOnChangeTests",
            dependencies: ["DebouncedOnChange"]),
    ]
)
