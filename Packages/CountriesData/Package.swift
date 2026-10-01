// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CountriesData",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "CountriesData",
            targets: ["CountriesData"]
        ),
    ],
    targets: [
        .target(name: "CountriesData"),
    ],
    swiftLanguageModes: [.v6]
)
