// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Forma",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Forma",
            targets: ["Forma"]),
    ],
    targets: [
        .target(
            name: "Forma",
            path: "src/main/objc",
            sources: ["Core", "FormItems", "TableViewCells"],
            cSettings: [
                .headerSearchPath("Core"),
                .headerSearchPath("FormItems"),
                .headerSearchPath("TableViewCells")
            ]
        ),

    ]
)
