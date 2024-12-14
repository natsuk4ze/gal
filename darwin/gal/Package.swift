// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gal",
    platforms: [
        .iOS("11.0"),
        .macOS("11.0")
    ],
    products: [
        .library(name: "gal", targets: ["gal"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "gal",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)

