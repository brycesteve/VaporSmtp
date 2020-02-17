// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "VaporSmtp",
    platforms: [
        // specify each minimum deployment requirement,
        //otherwise the platform default minimum is used.
       .macOS(.v10_14),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.3"),
    ],
    targets: [
        .target(name: "VaporSmtp", dependencies: [
            .product(name: "Vapor", package: "vapor"),
        ])
    ]
)

