[![Build Status](https://travis-ci.com/omisego/ios-sdk.svg?branch=master)](https://travis-ci.com/omisego/ios-sdk)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/OmiseGO.svg)](https://cocoapods.org/pods/OmiseGO)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/OmiseGO.svg?style=flat)](https://github.com/omisego/ios-sdk)
[![Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/omise_go)



# OmiseGO iOS SDK

The [OmiseGO](https://omisego.network) iOS SDK allows developers to easily interact with the [OmiseGO eWallet](https://github.com/omisego/ewallet).
This SDK is split into 3 Cocoapods subspecs: Core, Client and Admin.
The Core is a common dependency that contains the shared logic.
The Client and Admin modules contain specific logic to respectively access the client or admin API.

---

# Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Carthage](#carthage)
- [Usage](#usage)
  - [Client API](documentation/client.md)
  - [Admin API](documentation/admin.md)
  - [Pagination and filtering](documentation/pagination.md)
- [Tests](#tests)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

---

# Requirements

- iOS 10.0+
- Xcode 10.2+
- Swift 5.0

This version of the SDK is compatible with the version `1.2.0` of the [eWallet](https://github.com/omisego/ewallet/tree/v1.2).

---

# Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
gem install cocoapods
```

If you are using Cocoapods to integrate the SDK, you can take advantage of the subspecs that allows the integration of specific parts of the SDK separately.

If you only need to integrate and support the `Client` API then you can add only the `Client` subscpec by adding the following line in your `Podfile`:

```ruby
pod 'OmiseGO/Client'
```

Or if you only want to support the `Admin` API, you can use:

```ruby
pod 'OmiseGO/Admin'
```

Or if you need both simply use:

```ruby
pod 'OmiseGO'
```

Alternatively you can also specify a version ([read more about the Podfile] (https://guides.cocoapods.org/using/the-podfile.html)):

```ruby
pod 'OmiseGO', '~> 1.2'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

```bash
brew install carthage
```

To integrate the `omisego` SDK into your Xcode project using Carthage, add the following line in your `Cartfile`:

```
github "omisego/ios-sdk"
```

Then, run the following command:

```bash
carthage update --platform ios
```

Drag the built `OmiseGO.framework` into your Xcode project.

---

# Usage

[Client API usage](documentation/client.md)

[Admin API usage](documentation/admin.md)

[Pagination and filtering](documentation/pagination.md)

# Tests

In order to run the live tests (bound to a working server) you need to fill the corresponding variables in the plist file `secret.plist`.

> Note: Alternatively, these keys can be provided with environment variables, making it easier and safer for CI to run since you don't need to keep them in the source code.

The variables are:
- `OMG_BASE_URL`
- `OMG_WEBSOCKET_URL`
- `OMG_API_KEY`
- `OMG_AUTHENTICATION_TOKEN`
- `OMG_TOKEN_ID`

You can then for example run the tests with the following command:

`xcodebuild -workspace "OmiseGO.xcworkspace" -scheme "OmiseGO" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone X' OMG_BASE_URL="https://your.base.server.url" OMG_API_KEY="yourAPIKey" OMG_AUTHENTICATION_TOKEN="yourTestAuthenticationToken" OMG_TOKEN_ID="aTokenId" OMG_WEBSOCKET_URL="wss://your.base.socket.url" test`


---

# Dependencies

There are two dependencies required to run the SDK.
- [Starscream](https://github.com/daltoniam/Starscream) to manage websockets
- [BigInt](https://github.com/attaswift/BigInt) to manage big numbers

---

# Contributing

See [how you can help](.github/CONTRIBUTING.md).

---

# License

The OmiseGO iOS SDK is released under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
