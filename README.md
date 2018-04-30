[![Build Status](https://travis-ci.org/omisego/ios-sdk.svg?branch=master)](https://travis-ci.org/omisego/ios-sdk)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/OmiseGO.svg)](https://cocoapods.org/pods/OmiseGO)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/OmiseGO.svg?style=flat)](https://github.com/omisego/ios-sdk)
[![Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/omise_go)



# OmiseGO iOS SDK

The [OmiseGO](https://omisego.network) iOS SDK allows developers to easily interact with the [OmiseGO eWallet](https://github.com/omisego/ewallet).

---

# Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Carthage](#carthage)
- [Usage](#usage)
  - [HTTP Requests](#http-requests)
    - [Initialization](#initialization-of-the-http-client)
    - [Retrieving resources](#retrieving-resources)
      - [Get the current user](#get-the-current-user)
      - [Get the addresses of the current user](#get-the-addresses-of-the-current-user)
      - [Get the provider settings](#get-the-provider-settings)
      - [Get the current user's transactions](#get-the-current-users-transactions)
    - [Transferring tokens](#transferring-tokens)
      - [Generate a transaction request](#generate-a-transaction-request)
      - [Consume a transaction request](#consume-a-transaction-request)
      - [Approve a transaction consumption](#approve-a-transaction-consumption)
      - [Reject a transaction consumption](#reject-a-transaction-consumption)
    - [QR codes](#qr-codes)
      - [Generate a QR code](#create-a-qr-code-representation-of-a-transaction-request)
      - [Scan a QR code](#scan-a-qr-code)
  - [Websockets Requests](#websockets-requests)
    - [Initialization](#initialization-of-the-websocket-client)
    - [Listenable resources](#listenable-resources)
      - [Transaction request events](#transaction-request-events)
      - [Transaction consumption events](#transaction-consumption-events)
      - [User events](#user-events)
      - [Stop listening](#stop-listening-for-events)
- [Tests](#tests)
- [Contributing](#contributing)
- [License](#license)

---

# Requirements

- iOS 10.0+
- Xcode 9+
- Swift 4.1

---

# Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
gem install cocoapods
```

To integrate the `OmiseGO` SDK into your Xcode project using CocoaPods, add the following line in your `Podfile`:

```ruby
pod 'OmiseGO'
```

Alternatively you can also specify a version ([read more about the Podfile] (https://guides.cocoapods.org/using/the-podfile.html)):

```ruby
pod 'OmiseGO', '~> 0.9'
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

Different part of the SDK work with 2 different protocols: http(s) and ws(s).

## HTTP Requests

This section describes the use of the http client in order to retrieve or create resources.

### Initialization of the HTTP client

Before using the SDK to retrieve a resource, you need to initialize an `HTTPClient` with a `ClientConfiguration` object.
You should do this as soon as you obtain a valid authentication token corresponding to the current user from the Wallet API.

```swift
let configuration = ClientConfiguration(baseURL: "https://your.base.url/api",
                                        apiKey: "apiKey",
                                        authenticationToken: "authenticationToken",
                                        debugLog: false)
let client = HTTPClient(config: configuration)
```

Where:
- `baseURL` is the URL of the OmiseGO Wallet API, this needs to be an http(s) url.
- `apiKey` is the API key (typically generated on the admin panel)
- `authenticationToken` is the token corresponding to an OmiseGO Wallet user retrievable using one of our server-side SDKs.
> You can find more info on how to retrieve this token in the [OmiseGO server SDK documentations](https://github.com/omisego/ruby-sdk#login).

- `debugLog` is a boolean indicating if the SDK should print logs in the console.

### Retrieving resources

Once you have an initialized client, you can retrieve different resources.
Each call take a `Callback` closure that returns a `Response` enum:

```swift
public enum Response<Data> {
    case success(data: Data)
    case fail(error: OMGError)
}
```

You can then use a switch-case to access the `data` if the call succeeded or `error` if the call failed.
The `OMGError` represents an error that have occurred before, during or after the request. It's an enum with 5 cases:
```swift
case unexpected(message: String)
case configuration(message: String)
case api(apiError: APIError)
case socketError(message: String)
case other(error: Error)
```
An error returned by the OmiseGO Wallet server will be mapped to an `APIError` which contains informations about the failure.
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

#### Get the current user's transactions:

This returns a paginated filtered list of transactions.

In order to get this list you will need to create a `TransactionListParams` object:

```swift
let params = TransactionListParams(paginationParams: paginationParams, address: nil)
```

Where
- `address` is an optional address that belongs to the current user (primary address by default)
- `paginationParams` is a `PaginationParams<Transaction>` object:

```swift
let paginationParams = PaginationParams<Transaction>(
    page: 1,
    perPage: 10,
    searchTerm: nil,
    searchTerms: nil,
    sortBy: .createdAt,
    sortDirection: .descending
)
```

Where:
- `page` is the page you wish to receive.
- `perPage` is the number of results per page.
- `sortBy` is the sorting field. Available values: `.id`, `.status`, `.from`, `.to`, `.createdAt`, `.updatedAt`
- `sortDir` is the sorting direction. Available values: `.ascending`, `.descending`
- `searchTerm` is a term to search for in ALL of the searchable fields. Conflict with search_terms, only use one of them. See list of searchable fields below (same as search_terms).
- `searchTerms` is a dictionary of fields to search in with the following available fields: `.id`, `.status`, `.from`, `.to`, `.createdAt`, `.updatedAt`. Ex: `[.from: "someAddress", .id: "someId"]`

Then you can call:

```swift
Transaction.list(
    using: client,
    params: params) { (transactionsResult) in
        switch transactionsResult {
        case .success(let paginatedList):
            //TODO: Do something with the paginated list of transactions
        case .fail(let error):
            //TODO: Handle the error
        }
}
```

The `paginatedList` here is an object

Where:
- `data` is an array of transactions
- `pagination` is a `Pagination` object

  Where:
  - `perPage` is the number of results per page.
  - `currentPage` is the retrieved page.
  - `isFirstPage` is a bool indicating if the page received is the first page
  - `isLastPage` is a bool indicating if the page received is the last page


### Transferring tokens

In order to transfer tokens between 2 addresses, the SDK offers the possibility to generate and consume transaction requests.
To make a transaction happen, a `TransactionRequest` needs to be created and consumed by a `TransactionConsumption`.

#### Generate a transaction request

To generate a transaction request you can call:

```swift
let params = TransactionRequestCreateParams(type: .receive,
                                            mintedTokenId: "a token id",
                                            amount: 1337,
                                            address: "an address",
                                            correlationId: "a correlation id",
                                            requireConfirmation: false,
                                            maxConsumptions: 10,
                                            consumptionLifetime: 60000,
                                            expirationDate: nil,
                                            allowAmountOverride: true,
                                            metadata: [:],
                                            encryptedMetadata: [:])!
TransactionRequest.generateTransactionRequest(using: client, params: params) { (transactionRequestResult) in
    switch transactionRequestResult {
    case .success(data: let transactionRequest):
        //TODO: Do something with the transaction request (get the QR code representation for example)
    case .fail(error: let error):
        //TODO: Handle the error
}
```

Where:
- `params` is a `TransactionRequestCreateParams` struct constructed using:

  - `type`: The QR code type, `.receive` or `.send`.
  - `mintedTokenId`: The id of the desired token.
  In the case of a type "send", this will be the token taken from the requester. In the case of a type "receive" this will be the token received by the requester
  - `amount`: (optional) The amount of token to receive. This amount can be either inputted when generating or consuming a transaction request.
  - `address`: (optional) The address specifying where the transaction should be sent to. If not specified, the current user's primary address will be used.
  - `correlationId`: (optional) An id that can uniquely identify a transaction. Typically an order id from a provider.
  - `requireConfirmation`: (optional) A boolean indicating if the request [needs a confirmation](#transaction-request-events) from the requester before being proceeded
  - `maxConsumptions`: (optional) The maximum number of time that this request can be consumed
  - `consumptionLifetime`: (optional) The amount of time in millisecond during which a consumption is valid
  - `expirationDate`: (optional) The date when the request will expire and not be consumable anymore
  - `allowAmountOverride`: (optional) Allow or not the consumer to override the amount specified in the request. This needs to be true if the amount is not specified
  > Note that if `amount` is nil and `allowAmountOverride` is false the init will fail and return `nil`.

  - `metadata`: Additional metadata embedded with the request
  - `encryptedMetadata`: Additional encrypted metadata embedded with the request

#### Consume a transaction request

The previously created `transactionRequest` can then be consumed:

```swift
guard let params = TransactionConsumptionParams(transactionRequest: transactionRequest,
                                                address: "an address",
                                                mintedTokenId: "a minted token",
                                                amount: 1337,
                                                idempotencyToken: "an idempotency token",
                                                correlationId: "a correlation id",
                                                metadata: [:],
                                                encryptedMetadata: [:])!
TransactionConsumption.consumeTransactionRequest(using: client, params: params) { (transactionConsumptionResult) in
    switch transactionConsumptionResult {
    case .success(data: let transactionConsumption):
        // Handle success
    case .fail(error: let error):
        // Handle error
    }
}
```

Where `params` is a `TransactionConsumptionParams` struct constructed using:

- `transactionRequest`: The transactionRequest obtained from the QR scanner.
- `address`: (optional) The address from which to take the funds. If not specified, the current user's primary address will be used.
- `mintedTokenId`: (optional) The minted token id to use for the consumption.
- `amount`: (optional) The amount of token to send. This amount can be either inputted when generating or consuming a transaction request.
> Note that if the `amount` was not specified in the transaction request it needs to be specified here, otherwise the init will fail and return `nil`.

- `idempotencyToken`: The idempotency token used to ensure that the transaction will be executed one time only on the server. If the network call fails, you should reuse the same `idempotencyToken` when retrying the request.
- `correlationId`: (optional) An id that can uniquely identify a transaction. Typically an order id from a provider.
- `metadata`: A dictionary of additional data to be stored for this transaction consumption.
- `encryptedMetadata`: A dictionary of additional encrypted data to be stored for this transaction consumption.

#### Approve a transaction consumption


```swift
transactionConsumption.approve(using:client, callback: { (result) in
    switch result {
    case .success(data: let transactionConsumption):
        // Handle success
    case .fail(error: let error):
        // Handle error
    }
})
```

#### Reject a transaction consumption

```swift
transactionConsumption.reject(using:client, callback: { (result) in
    switch result {
    case .success(data: let transactionConsumption):
        // Handle success
    case .fail(error: let error):
        // Handle error
    }
})
```

### QR codes

To improve the UX of the transfers, the SDK offers the possibility to generate a QR code from a `TransactionRequest` and scan it in order to generate a `TransactionConsumption`

#### Create a QR code representation of a transaction request

Once a `TransactionRequest` is created you can get its QR code representation using `transactionRequest.qrImage()`.
This method takes an optional `CGSize` param that can be used to define the expected size of the generated QR image.

#### Scan a QR code

To enable QR code scanning, you first need to add the `NSCameraUsageDescription` permission in your `Info.plist`.

You can then use the integrated `QRScannerViewController` to scan the generated QR code.

Initialize the view controller using:

```swift
if let vc = QRScannerViewController(delegate: self, client: client, cancelButtonTitle: "Cancel") {
  self.present(vc, animated: true, completion: nil)
}
```

> Note: that the initialization of the controller may fail if the device doesn't support video capture (ie: the iOS simulator).

The `QRScannerViewControllerDelegate` offers the following interface:

```swift
func scannerDidCancel(scanner: QRScannerViewController) {
    // Handle tap on cancel button: Typically dismiss the scanner
}

func scannerDidDecode(scanner: QRScannerViewController, transactionRequest: TransactionRequest) {
    // Handle success scan, typically consume the transactionRequest and dismiss the scanner
}

func scannerDidFailToDecode(scanner: QRScannerViewController, withError error: OMGError) {
    // Handle error
}
```

When the scanner successfully decodes a `TransactionRequest` it will call its delegate method `scannerDidDecode(scanner: QRScannerViewController, transactionRequest: TransactionRequest)`.

You should use this `TransactionRequest` to generate a `TransactionConsumptionParams` in order to [consume the request](#consume-a-transaction-request).


## Websockets Requests

This section describes the use of the socket client in order to listen for events for a resource.

### Initialization of the websocket client


Similarly to the HTTP client, the `SocketClient` needs to be first initialized  with a `ClientConfiguration` before using it. The initializer takes an optional `SocketConnectionDelegate` delegate which can be used to listen for connection change events (connection and disconnection).

```swift
let configuration = ClientConfiguration(baseURL: "wss://your.base.url/api/socket",
                                        apiKey: "apiKey",
                                        authenticationToken: "authenticationToken",
                                        debugLog: false)
let client = SocketClient(config: configuration, delegate: self)
```

Where:
- `baseURL` is the URL of the OmiseGO Wallet API, this needs to be an ws(s) url.
- `apiKey` is the API key (typically generated on the admin panel)
- `authenticationToken` is the token corresponding to an OmiseGO Wallet user retrievable using one of our server-side SDKs.
> You can find more info on how to retrieve this token in the [OmiseGO server SDK documentations](https://github.com/omisego/ruby-sdk#login).

- `debugLog` is a boolean indicating if the SDK should print logs in the console.

### Listenable resources

Some resources are listenable, meaning that a `SocketClient` can be used establish a websocket connection and an object conforming to a subclass of the `EventDelegate` protocol can be used to listen for events incoming on this resource.
The `EventDelegate` protocol contains 3 common methods for all event delegates:

```swift
func didStartListening()
func didStopListening()
func onError(_ error: APIError)
```

- `didStartListening` can be used to know when the socket channel has been established and is ready to receive events.
- `didStopListening` can be used to know when the socket channel connection is closed and is not receiving events anymore.
- `onError` is called when there is an incoming error object.

And for each of the listenable resource there is an other specific method to receive related events:

#### Transaction request events

When creating a `TransactionRequest` that requires a confirmation it is possible to listen for all incoming confirmation using:

`transactionRequest.startListeningEvents(withClient: client, eventDelegate: self)`

Where:
- `client` is a `SocketClient`
- `eventDelegate` is a `TransactionRequestEventDelegate` that will receive incoming events.

An object conforming to `TransactionRequestEventDelegate` needs to implement the 3 common methods mentioned above and also:

- `onTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption)`.

This method will be called when a `TransactionConsumption` is trying to consume the `TransactionRequest`.
This allows the requester to [confirm](#confirm-a-transaction-consumption) or not the consumption if legitimate.

- `onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)`.

This method will be called if a `TransactionConsumption` has been finalized successfully, and the transfer was made between the 2 addresses.

- `onFailedTransactionConsumptionFinalized(_ error: APIError)`.

This method will be called if a `TransactionConsumption` fails to consume the request.


#### Transaction consumption events

Similarly to transaction request events, a `TransactionConsumption` can be listened for incoming confirmations using:

`consumption.startListeningEvents(withClient: client, eventDelegate: self)`

Where:
- `client` is a `SocketClient`
- `eventDelegate` is a `TransactionConsumptionEventDelegate` that will receive incoming events.

An object conforming to `TransactionConsumptionEventDelegate` needs to implement the 3 common methods mentioned above and also:

- `onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)`.

This method will be called if the `TransactionConsumption` has been finalized successfully, and the transfer was made between the 2 addresses.

- `onFailedTransactionConsumptionFinalized(_ error: APIError)`.

This method will be called if the `TransactionConsumption` fails to consume the request.

#### User events

A `User` can also be listened and will receive all events that are related to him:

`user.startListeningEvents(withClient: self.socketClient, eventDelegate: self)`

Where:
- `client` is a `SocketClient`
- `eventDelegate` is a `UserEventDelegate` that will receive incoming events.

An object conforming to `UserEventDelegate` needs to implement the 3 common methods mentioned above and also `on(_ object: WebsocketObject, error: APIError?, forEvent event: SocketEvent)`.

This method will be called when any event regarding the user is received. `WebsocketObject` can be enumerated to get the corresponding object received.


#### Stop listening for events

When you don't need to receive events anymore, you should call `stopListening(withClient client: SocketClient)` for the corresponding `Listenable` object. This will leave the corresponding socket channel and close the connection if no other channel is active.

---

# Tests

In order to run the live tests (bound to a working server) you need to fill the corresponding variables in the plist file `secret.plist`.

> Note: Alternatively, these keys can be provided with environment variables, making it easier and safer for CI to run since you don't need to keep them in the source code.

The variables are:
- `OMG_BASE_URL`
- `OMG_WEBSOCKET_URL`
- `OMG_API_KEY`
- `OMG_AUTHENTICATION_TOKEN`
- `OMG_MINTED_TOKEN_ID`

You can then for example run the tests with the following command:

`xcodebuild -workspace "OmiseGO.xcworkspace" -scheme "OmiseGO" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8' OMG_BASE_URL="https://your.base.server.url/api" OMG_API_KEY="yourAPIKey" OMG_AUTHENTICATION_TOKEN="yourTestAuthenticationToken" OMG_MINTED_TOKEN_ID="aMintedTokenId" OMG_WEBSOCKET_URL="wss://your.base.socket.url/api/socket" test`


---

# Contributing

See [how you can help](.github/CONTRIBUTING.md).

---

# License

The OmiseGO iOS SDK is released under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
