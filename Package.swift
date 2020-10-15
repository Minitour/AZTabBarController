// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AZTabBarController",
    products: [
        .library(
            name: "AZTabBarController",
            targets: ["AZTabBarController"]),
    ],
    dependencies: [
        // Replace the code from line 17 to 19 with the code from line 14 to line 16 after `https://github.com/Minitour/EasyNotificationBadge/pull/16` is merged.
        //        .package(name: "EasyNotificationBadge",
        //                 url: "https://github.com/Minitour/EasyNotificationBadge.git",
        //                 from: "1.4.2"),
        .package(name: "EasyNotificationBadge",
                 url: "https://github.com/afnanm1999/EasyNotificationBadge.git",
                 .branch("SPM-Integration"))
    ],
    targets: [
        .target(
            name: "AZTabBarController",
            dependencies: ["EasyNotificationBadge"]),
    ]
)
