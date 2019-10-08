// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Zone5",
    products: [
        .library(
			name: "Zone5",
			targets: [
				"Zone5"
			]
		),
    ],
    targets: [
        .target(
			name: "Zone5",
			dependencies: [
			]
		),
        .testTarget(
			name: "Zone5 Tests",
			dependencies: [
				"Zone5"
			]
		),
    ]
)
