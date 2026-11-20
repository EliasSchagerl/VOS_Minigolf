// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RCPCustomComponents",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RCPCustomComponents",
            type: .dynamic,
            targets: ["RCPCustomComponents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/reality-composer-pro-plugin", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RCPCustomComponents",
            dependencies: [
                .product(name: "RealityComposerPro", package: "reality-composer-pro-plugin")
            ]
        ),
        .testTarget(
            name: "RCPCustomComponentsTests",
            dependencies: [
                "RCPCustomComponents",
                .product(name: "RealityComposerPro", package: "reality-composer-pro-plugin")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
