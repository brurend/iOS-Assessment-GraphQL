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
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            exact: "2.4.0"
        ),
    ],
    targets: [
        .target(
            name: "CountriesData",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .testTarget(
            name: "CountriesDataTests",
            dependencies: [
                "CountriesData",
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloAPI", package: "apollo-ios"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
