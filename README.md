# OmiseGO iOS SDK

The [OmiseGO](https://omisego.network) iOS SDK allows developers to easily interact with the [OmiseGO eWallet](https://github.com/omisego/ewallet).

---

# Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Initialization](#initialization)
  - [Retrieving resources](#retrieving-resources)
    - [Get the current user](#get-the-current-user)
    - [Get the addresses of the current user](#get-the-addresses-of-the-current-user)
    - [Get the provider settings](#get-the-provider-settings)
    - [Get the current user's transactions](#get-the-current-users-transactions)
  - [QR codes](#qr-codes)
    - [Generation](#generation)
    - [Scanning](#scanning)
    - [Consumption](#consumption)
- [Tests](#tests)
- [Contributing](#contributing)
- [License](#license)

---

# Requirements

- iOS 9.0+
- Xcode 9+
- Swift 4.0

---

# Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate the `omisego` SDK into your Xcode project using CocoaPods, add the following line in your `Podfile`:

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
- `baseURL` is the URL of the OmiseGO Wallet API.
- `apiKey` is the api key generated from your OmiseGO admin panel.
- `authenticationToken` is the token corresponding to an OmiseGO Wallet user retrievable using one of our server-side SDKs.
> You can find more info on how to retrieve this token in the [OmiseGO server SDK documentations](https://github.com/omisego/ruby-sdk#login).

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


### QR codes

This SDK offers the possibility to generate and consume transaction requests.
Typically these actions should be done through the generation and scan of QR codes.

#### Generation

To generate a new transaction request you can call:

```swift
let params = TransactionRequestCreateParams(type: .receive,
                                            mintedTokenId: "a_token_id",
                                            amount: 13.37,
                                            address: "receiver_address",
                                            correlationId: "correlation_id")
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

  - `type`: The QR code type, only supports `.receive` for now.
  - `mintedTokenId`: The id of the desired token.
  - `amount`: (optional) The amount of token to receive. This amount can be either inputted when generating or consuming a transaction request.
  - `address`: (optional) The address specifying where the transaction should be sent to. If not specified, the current user's primary address will be used.
  - `correlationId`: (optional) An id that can uniquely identify a transaction. Typically an order id from a provider.

A `TransactionRequest` object is passed to the success callback, you can get its QR code representation using `transactionRequest.qrImage()`.

#### Scanning

You can then use the integrated `QRScannerViewController` to scan the generated QR code.

You first need to initialize the view controller using:

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

func scannerDidFailToDecode(scanner: QRScannerViewController, withError error: OmiseGOError) {
    // Handle error
}
```

When the scanner successfully decodes a transaction request it will call its delegate method `scannerDidDecode(scanner: QRScannerViewController, transactionRequest: TransactionRequest)`.

You should use this `transactionRequest` to generate a `TransactionConsumeParams` in order to consume the request.

#### Consumption

```swift
guard let params = TransactionConsumeParams(transactionRequest: transactionRequest,
                                            address: nil,
                                            mintedTokenId: nil,
                                            amount: nil,
                                            idempotencyToken: self.idemPotencyToken,
                                            correlationId: nil,
                                            metadata: [:]) else { return }
TransactionConsume.consumeTransactionRequest(using: client, params: params) { (transactionConsumeResult) in
    switch transactionConsumeResult {
    case .success(data: let transactionConsume):
        // Handle success
    case .fail(error: let error):
        // Handle error
    }
}
```

Where `params` is a `TransactionConsumeParams` struct constructed using:

- `transactionRequest`: The transactionRequest obtained from the QR scanner.
- `address`: (optional) The address from which to take the funds. If not specified, the current user's primary address will be used.
- `mintedTokenId`: (optional) The minted token id to use for the consumption.
- `amount`: (optional) The amount of token to send. This amount can be either inputted when generating or consuming a transaction request.
> Note that if the amount was not specified in the transaction request it needs to be specified here, otherwise the init will fail.

- `idempotencyToken`: The idempotency token used to ensure that the transaction will be executed one time only on the server. If the network call fails, you should reuse the same `idempotencyToken` when retrying the request.
- `correlationId`: (optional) An id that can uniquely identify a transaction. Typically an order id from a provider.
- `metadata`: A dictionary of additional data to be stored for this transaction consumption.

---

# Tests

In order to run the live tests (bound to a working server) you need to fill the corresponding variables in the plist file `secret.plist`.

> Note: Alternatively, these keys can be provided with environment variables, making it easier and safer for CI to run since you don't need to keep them in the source code.

The variables are:
- `OMG_BASE_URL`
- `OMG_API_KEY`
- `OMG_AUTHENTICATION_TOKEN`
- `OMG_MINTED_TOKEN_ID`

You can then for example run the tests with the following command:
`xcodebuild -project OmiseGO.xcodeproj -scheme "OmiseGO" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8' OMG_BASE_URL="https://your.base.server.url" OMG_API_KEY="yourAPIKey" OMG_AUTHENTICATION_TOKEN="yourTestAuthenticationToken" OMG_MINTED_TOKEN_ID="aMintedTokenId" test`

---

# Contributing

See [how you can help](.github/CONTRIBUTING.md).

---

# License

The OmiseGO iOS SDK is released under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
