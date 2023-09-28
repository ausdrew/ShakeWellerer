// swift-tools-version:5.7.1
import PackageDescription


let package = Package(
    name: "ShakeWellerer",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "ShakeWellerer",
            dependencies: ["ShakeWellererCore"]
        ),
        .target(name: "ShakeWellererCore")
    ]
)