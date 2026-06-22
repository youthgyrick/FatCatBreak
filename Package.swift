// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FatCatBreak",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "FatCatBreak", targets: ["FatCatBreak"])
    ],
    targets: [
        .executableTarget(name: "FatCatBreak"),
        .testTarget(name: "FatCatBreakTests", dependencies: ["FatCatBreak"])
    ]
)
