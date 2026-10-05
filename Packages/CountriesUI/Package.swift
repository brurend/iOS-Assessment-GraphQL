// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CountriesUI",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "CountriesUI",
            targets: ["CountriesUI"]
        ),
    ],
    dependencies: [
        .package(path: "../CountriesData"),
    ],
    targets: [
        .target(
            name: "CountriesUI",
            dependencies: ["CountriesData"]
        ),
        .testTarget(
            name: "CountriesUITests",
            dependencies: ["CountriesUI", "CountriesData"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
