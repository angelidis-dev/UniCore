// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UniCore",
    products: [
        .library(
            name: "UniCore",
            targets: ["UniCore"]),
        .library(
            name: "UniCoreValidation",
            targets: ["UniCoreValidation"]),
    ],
    targets: [
        .target(
            name: "UniCore"),
        .testTarget(
            name: "UniCoreTests",
            dependencies: ["UniCore"]
        ),
        .target(
            name: "UniCoreValidation"),
        .testTarget(
            name: "UniCoreValidationTests",
            dependencies: ["UniCoreValidation"]
        ),
    ]
)
