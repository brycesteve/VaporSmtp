// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaporSmtp",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "VaporSmtp",
            targets: ["VaporSmtp"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
	    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.3"),   
    ],
    targets: [
        .target(
            name: "VaporSmtp",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        ),
    ]
)
