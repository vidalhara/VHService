// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VHService",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "VHService",
            targets: ["VHService"]
        )
    ],
    targets: [
        .target(
            name: "VHService",
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
