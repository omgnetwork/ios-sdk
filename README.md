# OmiseGO
---

The [OmiseGO](https://omisego.network) iOS SDK allows developers to easily interact with a node of the OmiseGO eWallet.
It supports the following functionalities:
- Retrieve the current user
- Get the user addresses and balances
- List the settings for a node


# Requirements
---

- iOS 9.0+
- Xcode 9+
- Swift 4.0

# Installation
---

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate the `omisego` SDK into your Xcode project using CocoaPods, add the following line in your `Podfile`:

### Beta Installation

Until the `omisego` SDK is released, you will need to specify the git URL for this pod:

```ruby
pod 'OmiseGO', :git => 'ssh://git@github.com:omisego/ios-sdk.git'
```

### Installation

```ruby
pod 'OmiseGO', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```

# Usage
---

### Initialization

Before using the SDK to retrieve a resource, you need to initialize a client (`APIClient`) with an `APIConfiguration` object.
You should do this as soon as you obtain a valid authentication token corresponding to the current user from the Wallet API.

```swift
let configuration = OMGConfiguration(baseURL: "your.base.url",
                                     apiKey: "apiKey",
                                     authenticationToken: "authenticationToken")
let client = OMGClient(config: configuration)
```

Where:
`baseURL` is the URL of the OmiseGO Wallet API.
`apiKey` is the api key generated from your OmiseGO admin panel.
`authenticationToken` is the token corresponding to an OmiseGO Wallet user retrievable using one of our server-side SDKs.
> You can find more info on how to retrieve this token in the OmiseGO server SDK documentations.

### Retrieving resources

Once you have an initialized client, you can retrieve different resources.
Each call take a `Callback` closure that returns a `Response` enum:

```swift
public enum Response<Data> {
    case success(data: Data)
    case fail(error: OmiseGOError)
}
```

You can then use a switch-case to access the `data` if the call succeeded or `error` if the call failed.
The `OmiseGOError` represents an error that have occurred before, during or after the request. It's an enum with 4 cases:
```swift
case unexpected(message: String)
case configuration(message: String)
case api(apiError: APIError)
case other(error: Error)
```
An `Error` returned by the OmiseGO Wallet server will be mapped to an `APIError` which contains informations about the failure.
> There are some errors that you really want to handle, especially the ones related to authentication failure. This may occur if the `authenticationToken` is invalid or expired, you can check this using the `isAuthorizationError()` method on `APIError`. If the `authenticationToken` is invalid, you should query a new one and setup the client again.

#### Get the current user:

```swift
User.getCurrent(using: client) { (userResult) in
    switch userResult {
    case .success(data: let user):
        //TODO: Do something with the user
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

#### Get the addresses of the current user:

```swift
Address.getAll(using: client) { (addressesResult) in
    switch addressesResult {
    case .success(data: let addresses):
        //TODO: Do something with the addresses
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

> Note: For now a user will have only one address so for the sake of simplicity you can get this address using:

```swift
Address.getMain(using: client) { (addressResult) in
    switch addressResult {
    case .success(data: let address):
        //TODO: Do something with the address
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

#### Get the provider settings:

```swift
Setting.get(using: client) { (settingResult) in
    switch settingResult {
    case .success(data: let settings):
        //TODO: Do something with the settings
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

# Tests

In order to run the live tests (bound to a working server) you need to fill the corresponding variables in the file `LiveTestCase.swift`.
```
/// Replace with yours!
var validBaseURL = ""
/// Replace with yours!
var validAPIKey = ""
/// Replace with yours!
var validAuthenticationToken = ""
```

> Note: These en can also be provided with environment variables, making it easier and safer for CI to run since you don't need to hardcode them.

The variables are:
- `OMG_BASE_URL`
- `OMG_API_KEY`
- `OMG_AUTHENTICATION_TOKEN`

You can then for example run the tests with the following command:
`xcodebuild -project OmiseGO.xcodeproj -scheme "OmiseGO" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8' OMG_BASE_URL="https://your.base.server.url" OMG_API_KEY="yourAPIKey" OMG_AUTHENTICATION_TOKEN="yourTestAuthenticationToken" test`

# License

OmiseGO is released under the Apache license. See LICENSE for details.
