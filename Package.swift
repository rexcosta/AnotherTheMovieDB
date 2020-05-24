// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnotherTheMovieDB",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "AnotherTheMovieDB",
            targets: ["AnotherTheMovieDB"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/rexcosta/AnotherSwiftCommonLib.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/rexcosta/AnotherPagination",
            .branch("master")
        ),
        .package(
            url: "https://github.com/rexcosta/AnotherCombineCache",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "AnotherTheMovieDB",
            dependencies: ["AnotherSwiftCommonLib", "AnotherPagination", "AnotherCombineCache"]
        ),
        .testTarget(
            name: "AnotherTheMovieDBTests",
            dependencies: ["AnotherTheMovieDB"]
        ),
    ]
)
