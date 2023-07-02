// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RKPDesign",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RKPDesign",
            targets: ["RKPDesign"]),
    ],
    dependencies: [
        .package(
          url: "https://github.com/pointfreeco/swift-snapshot-testing",
          from: "1.10.0"
        ),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RKPDesign",
            dependencies: [
                .product(name: "FLAnimatedImage", package: "FLAnimatedImage")
            ],
            resources: [.process("Images")]),
        .testTarget(
            name: "RKPDesignTests",
            dependencies: ["RKPDesign",
                           .product(name: "SnapshotTesting", package: "swift-snapshot-testing")],
            resources: [.process("TestResources")]),
    ]
)
