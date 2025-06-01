// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CursorWatch",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CursorWatch",
            dependencies: [],
            path: "Sources/CursorWatch"
        )
    ]
) 
