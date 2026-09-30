// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "maps_launcher",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // Esportiamo il prodotto con entrambi i nomi (con e senza trattino) 
        // per soddisfare la richiesta esatta del generatore di Flutter
        .library(name: "maps-launcher", targets: ["maps_launcher"]),
        .library(name: "maps_launcher", targets: ["maps_launcher"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "maps_launcher",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/maps_launcher"
        )
    ]
)