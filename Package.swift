// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfiniteScroll",
    platforms: [
      .iOS(.v15),
      .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "InfiniteScroll",
            targets: ["InfiniteScroll"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-identified-collections", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "InfiniteScroll",
            dependencies: [
              .product(name: "IdentifiedCollections", package: "swift-identified-collections")
            ]
        ),
        .testTarget(
            name: "InfiniteScrollTests",
            dependencies: ["InfiniteScroll"]
        ),
    ]
)
