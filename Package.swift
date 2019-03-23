// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AbsoluteHSB",
    products: [
        .executable(name: "absolute-hsb", targets: ["AbsoluteHSB"]),
        .library(name: "AbsoluteHSBKit", targets: ["AbsoluteHSBKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "0.40200.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "AbsoluteHSB", dependencies: ["AbsoluteHSBKit"]),
        .target(name: "AbsoluteHSBKit", dependencies: ["SwiftSyntax"]),
        .testTarget(name: "AbsoluteHSBTests", dependencies: ["AbsoluteHSBKit"]),
    ]
)
