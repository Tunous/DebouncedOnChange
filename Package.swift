// swift-tools-version: 5.6

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
        .package(url: "https://github.com/Tunous/DebouncedOnChange.git", .upToNextMajor(from: "1.0.0"))
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
