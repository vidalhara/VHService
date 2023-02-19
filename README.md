# VHService

[![Swift](https://img.shields.io/badge/Swift-4.0_5.1_5.2_5.3_5.4_5.5-blue)](https://img.shields.io/badge/Swift-4.0_5.1_5.2_5.3_5.4_5.5-Orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-blue)](https://img.shields.io/badge/Platforms-iOS-Blue)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/VHService?color=pistachiogreen)](https://img.shields.io/cocoapods/v/VHService?color=pistachiogreen)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-pistachiogreen)](https://img.shields.io/badge/Swift_Package_Manager-compatible-pistachiogreen)

VHService is a simple HTTP networking library written in Swift.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [License](#license)

## Features

- [x] Request / Response Methods
- [x] Combine Support Back to iOS 13
- [x] URL / JSON Parameter Encoding
- [x] Upload / Download File
- [x] Upload / Download Progress Closures with Progress
- [x] Dynamically Adapt and Retry Requests
- [x] [Complete Documentation](https://vidalhara.github.io/VHService/)

## Requirements

| Platform | Minimum Swift Version | Installation |
| --- | --- | --- |
| iOS 10.0+ | 4.0 | [CocoaPods](#cocoapods), [Carthage](#carthage), [Swift Package Manager](#swift-package-manager) |

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate VHService into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
pod 'VHService', '~> 1.0.0'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate VHService into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "vidalhara/VHService" ~> 1.0
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding VHService as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```
dependencies: [
    .package(url: "https://github.com/vidalhara/VHService.git", .upToNextMajor(from: "1.0.0"))
]
```

## License

VHService is released under the MIT license. [See LICENSE](https://github.com/vidalhara/VHService/blob/master/LICENSE) for details.
