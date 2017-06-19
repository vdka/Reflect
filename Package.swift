// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Reflect",
    products: [
        .library(name: "Reflect", targets: ["Reflect"]),
    ],
    targets: [
        .target(name: "Reflect"),
        .testTarget(name: "ReflectTests", dependencies: ["Reflect"]),
    ]
)

