// swift-tools-version:5.3
import PackageDescription
let package = Package(
    name: "ComponentLibrary",
    products: [
        .executable(name: "ComponentLibrary", targets: ["ComponentLibrary"])
    ],
    dependencies: [
        .package(name: "JavaScriptKit", url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "ComponentLibrary",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ],
          resources: [
            .copy("Assets/spaghetti.jpeg"),
            .copy("Assets/veggietomatomix.jpeg")
          ]
          ),
        .testTarget(
            name: "ComponentLibraryTests",
            dependencies: ["ComponentLibrary"]),
    ]
)
