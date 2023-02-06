// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "StipopImageEditor",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "StipopImageEditor",
            targets: ["StipopImageEditor"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "StipopImageEditor",
            url: "https://ios-sdk.stipop.com/0.0.2/StipopImageEditor.xcframework.zip",
            checksum: "0747f8476f15892e172b66eda72fddc01a95692d7f6fe01d4d892c1edefd001e"
        )
    ]
)
