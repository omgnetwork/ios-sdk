# OmiseGO client iOS SDK

The client iOS SDK allows developers to easily interact with the OmiseGO client eWallet API.

# Table of Contents

- [HTTP Requests](#http-requests)
  - [Initialization](#initialization-of-the-http-client)
    - [Sign in and Sign up](#sign-in-and-sign-up)
    - [Sign out](#sign-out)
  - [Retrieving resources](#retrieving-resources)
    - [Get the current user](#get-the-current-user)
    - [Get the wallets of the current user](#get-the-wallets-of-the-current-user)
    - [Get the provider settings](#get-the-provider-settings)
    - [Get the current user's transactions](#get-the-current-users-transactions)
  - [Transferring tokens](#transferring-tokens)
    - [Create a transaction](#create-a-transaction)
    - [Generate a transaction request](#generate-a-transaction-request)
    - [Consume a transaction request](#consume-a-transaction-request)
    - [Approve a transaction consumption](#approve-a-transaction-consumption)
    - [Reject a transaction consumption](#reject-a-transaction-consumption)
    - [Cancel a transaction consumption](#cancel-a-transaction-consumption)
  - [QR codes](#qr-codes)
    - [Generate a QR code](#create-a-qr-code-representation-of-a-transaction-request)
    - [Scan a QR code](#scan-a-qr-code)
  - [Reset user password](#reset-user-password)
    - [Reset password](#reset-password)
    - [Update password](#update-password)
- [Websockets](#websockets)
  - [Initialization](#initialization-of-the-websocket-client)
  - [Listenable resources](#listenable-resources)
    - [Transaction request events](#transaction-request-events)
    - [Transaction consumption events](#transaction-consumption-events)
    - [User events](#user-events)
    - [Stop listening](#stop-listening-for-events)

---

# Usage

Different part of the SDK work with 2 different protocols: http(s) and ws(s).

## HTTP Requests

This section describes the use of the http client in order to retrieve or create resources.

### Initialization of the HTTP client

Before using the SDK to retrieve a resource, you need to initialize an `HTTPClientAPI` with a `ClientConfiguration` object.

This requires a `baseURL`, which is the http(s) URL of your OmiseGO eWallet API, and a `ClientCredential` object.

The `ClientCredential` contains the authentication credentials which consist in an `apiKey` that can be generated on the admin panel,
and optionally an `authenticationToken`.

The `authenticationToken` can be retrieved in 2 ways:

- If your app talks to a server that integrates the eWallet server API:

You may have your server returning this token when your user log in for example.
You can see a sample of this integration [here for iOS](https://github.com/omisego/sample-ios) and [here for the server code](https://github.com/omisego/sample-server).
You can then initialize your `HTTPClientAPI` like so:

```swift
let credentials = ClientCredential(apiKey: "your-api-key",
                                   authenticationToken: "your-authentication-token")
let configuration = ClientConfiguration(baseURL: "https://your.base.url",
                                        credentials: credentials,
                                        debugLog: false)
let client = HTTPClientAPI(config: configuration)
```

#### Sign in and Sign up

- If you are running a standalone version of the eWallet, you can sign up and sign in your users directly from the SDK:

You can retrieve an authentication token using the `HTTPClientAPI.login`.
This call does not require an `authenticationToken` to be set to the `ClientCredential`, so you can do the following:

```swift
let credentials = ClientCredential(apiKey: "your-api-key") // Note here that we don't need to provide an authenticationToken
let configuration = ClientConfiguration(baseURL: "https://your.base.url",
                                        credentials: credentials,
                                        debugLog: false)
let client = HTTPClientAPI(config: configuration)
let params = LoginParams(email: "some@email.com", password: "password")
client.login(withParams: params) { (result) in
    switch result {
    case .fail(error: let error): // TODO: Handle error
    case .success(data: let authenticationToken):
        // Now the client is authenticated automatically and you'll be able to perform authenticated calls with it.
        // You can also access to the `User` object: `authenticationToken.user`
    }
}
```

You can register a user using the `HTTPClientAPI.signup`.

```swift
let params = SignupParams(email: "some@email.com", password: "password", passwordConfirmation: "password")
client.signup(withParams: params) { (result) in
    switch result {
        case .success:
            // TODO: Handle success
            // The user will receive an email asking him to confirm his email address, so you may want to show a page indicating this.
        case let .fail(error: error):
            // TODO: handle error
    }
}
```

#### Sign out

You can sign out a user and invalidate the client's authentication token with:

```swift
client.logout { _ in

}
```

### Retrieving resources

Once you have an initialized and authenticated client, you can retrieve different resources.
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
case decoding(underlyingError: DecodingError)
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

#### Get the wallets of the current user:

```swift
Wallet.getAll(using: client) { (walletsResult) in
    switch walletsResult {
    case .success(data: let wallets):
        //TODO: Do something with the wallets
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

> Note: For now a user will have only one wallet so for the sake of simplicity you can get this wallet using:

```swift
Wallet.getMain(using: client) { (walletResult) in
    switch walletResult {
    case .success(data: let wallet):
        //TODO: Do something with the wallet
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
let params = TransactionListParams(paginatedListParams: paginationParams, address: nil)
```

Where
- `address` is an optional address that belongs to the current user (primary wallet address by default)
- `paginationParams` is a `PaginatedListParams<Transaction>` object

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


### Transferring tokens

The SDK offers 2 ways for transferring tokens between addresses:
- A simple one way transfer from one of the current user's wallets to an address.
- A highly configurable send/receive mechanism in 2 steps using transaction requests.

#### Create a transaction

The most basic way to transfer tokens is to use the `Transaction.create()` method, which allows the current user to send tokens from one of its wallet to a specific address.

```swift
let params = TransactionCreateParams(fromAddress: "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1",
                                     toAddress: "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1",
                                     amount: 1000,
                                     tokenId: "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1",
                                     idempotencyToken: "some token")
Transaction.create(using: client, params: params) { (result) in
   switch result {
   case .success(data: let transaction):
        // TODO: Do something with the transaction
   case .fail(error: let error):
        //TODO: Handle the error
   }
}
```

There are different ways to initialize a `TransactionCreateParams` by specifying either `address`, `userId` or `accountId`.

#### Generate a transaction request

A more configurable way to transfer tokens between 2 wallets is to use the transaction request flow.
To make a transaction happen, a `TransactionRequest` needs to be created and consumed by a `TransactionConsumption`.

To generate a transaction request you can call:

```swift
let params = TransactionRequestCreateParams(type: .receive,
                                            tokenId: "a token id",
                                            amount: 1337,
                                            address: "an address",
                                            correlationId: "a correlation id",
                                            requireConfirmation: false,
                                            maxConsumptions: 10,
                                            consumptionLifetime: 60000,
                                            expirationDate: nil,
                                            allowAmountOverride: true,
                                            maxConsumptionsPerUser: 5,
                                            consumptionIntervalDuration: 10000,
                                            maxConsumptionsPerInterval: 10,
                                            maxConsumptionsPerIntervalPerUser: 1,
                                            metadata: [:],
                                            encryptedMetadata: [:])!
TransactionRequest.create(using: client, params: params) { (transactionRequestResult) in
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
  - `tokenId`: The id of the desired token.
  In the case of a type "send", this will be the token taken from the requester. In the case of a type "receive" this will be the token received by the requester
  - `amount`: (optional) The amount of token to receive. This amount can be either inputted when generating or consuming a transaction request.
  - `address`: (optional) The address specifying where the transaction should be sent to. If not specified, the current user's primary wallet address will be used.
  - `correlationId`: (optional) An id that can uniquely identify a transaction. Typically an order id from a provider.
  - `requireConfirmation`: (optional) A boolean indicating if the request [needs a confirmation](#transaction-request-events) from the requester before being proceeded
  - `maxConsumptions`: (optional) The maximum number of time that this request can be consumed
  - `consumptionLifetime`: (optional) The amount of time in millisecond during which a consumption is valid
  - `expirationDate`: (optional) The date when the request will expire and not be consumable anymore
  - `allowAmountOverride`: (optional) Allow or not the consumer to override the amount specified in the request. This needs to be true if the amount is not specified
  > Note that if `amount` is nil and `allowAmountOverride` is false the init will fail and return `nil`.

  - `consumptionIntervalDuration`: The duration (in milliseconds) during which the `maxConsumptionsPerInterval` and  `maxConsumptionsPerIntervalPerUser` attributes take effect.
  - `maxConsumptionsPerInterval`: The total number of times the request can be consumed in the defined interval (like 3 times every 24 hours)
  - `maxConsumptionsPerIntervalPerUser`: The total number of times one unique user can consume the request (like once every 24 hours)
  - `maxConsumptionsPerUser`: The maximum number of consumptions allowed per unique user
  - `metadata`: Additional metadata embedded with the request
  - `encryptedMetadata`: Additional encrypted metadata embedded with the request

#### Consume a transaction request

The previously created `transactionRequest` can then be consumed:

```swift
let params = TransactionConsumptionParams(transactionRequest: transactionRequest,
                                          address: "an address",
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
- `address`: (optional) The address from which to take the funds. If not specified, the current user's primary wallet address will be used.
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

#### Cancel a transaction consumption

```swift
transactionConsumption.cancel(using:client, callback: { (result) in
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
let verifier = QRClientVerifier(client: client)
if let vc = QRScannerViewController(delegate: self, verifier: verifier, cancelButtonTitle: "Cancel") {
  self.present(vc, animated: true, completion: nil)
}
```

> Note: that the initialization of the controller may fail if the device doesn't support video capture (ie: the iOS simulator).

The `QRScannerViewControllerDelegate` offers the following interface:

```swift
func userDidChoosePermission(granted: Bool) {
    // Handle whether the user allowed the app to access the camera or not
}

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

### Reset user password

> Note: Only available if the eWallet is running in standalone mode.

If a user forget his password, he will be able to reset it by requesting  a reset password link.
This link will contain a unique token that will need to be submitted along with the updated password chosen by the user.

#### Reset password

To get a password reset link, you can call:

```
User.resetPassword(using: client, params: params) { result in
    switch result {
    case .success:
      // Handle success
    case let .fail(error: error):
      // Handle error
    }
}
```

Where `params` is a `UserResetPasswordParams` struct constructed using:

- `email`: The email of the user (ie: email@example.com)
- `reset_password_url`: The URL of the link that the user will receive by email.
  In most cases this should be the default URL, only override if you are building your custom system.
  The default URL can be retrieved using the `defaultResetPasswordURL(forClient:)` function
- `forward_url`: The default reset password page will try to redirect the user to this forwardURL if present.
  If omitted or invalid, the user will be able to reset his password on the default page.
  You can use this URL if you want the default page to open your app with it's scheme for example.

> These urls needs to be whitelisted on the eWallet configuration page using the `Redirect URL Prefixes` config before being used.

#### Update password

To update the user with a new password, you can call:

```
User.updatePassword(using: client, params: params) { result in
    switch result {
    case .success:
      // Handle success
    case let .fail(error: error):
      // Handle error
    }
}
```

Where `params` is a `UserUpdatePasswordParams` struct constructed using:

- `email`: The email obtained in the previous step
- `token`: The token obtained in the previous step
- `password`: The updated user's password
- `passwordConfirmation`: The updated user's password

## Websockets

This section describes the use of the socket client in order to listen for events for a resource.

### Initialization of the websocket client


Similarly to the HTTP client, the `SocketClient` needs to be first initialized  with a `ClientConfiguration` before using it. The initializer takes an optional `SocketConnectionDelegate` delegate which can be used to listen for connection change events (connection and disconnection).

```swift
let credentials = ClientCredential(apiKey: "your-api-key",
                                   authenticationToken: "your-authentication-token")
let configuration = ClientConfiguration(baseURL: "wss://your.base.url",
                                        credentials: credentials,
                                        debugLog: false)
let socketClient = SocketClient(config: configuration, delegate: nil)
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

`transactionRequest.startListeningEvents(withClient: socketClient, eventDelegate: self)`

Where:
- `client` is a `SocketClient`
- `eventDelegate` is a `TransactionRequestEventDelegate` that will receive incoming events.

An object conforming to `TransactionRequestEventDelegate` needs to implement the 3 common methods mentioned above and also:

- `onTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption)`.

This method will be called when a `TransactionConsumption` is trying to consume the `TransactionRequest`.
This allows the requester to [confirm](#confirm-a-transaction-consumption) or not the consumption if legitimate.

- `onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)`.

This method will be called if a `TransactionConsumption` has been finalized successfully, and the transfer was made between the 2 wallets.

- `onFailedTransactionConsumptionFinalized(_ error: APIError)`.

This method will be called if a `TransactionConsumption` fails to consume the request.


#### Transaction consumption events

Similarly to transaction request events, a `TransactionConsumption` can be listened for incoming confirmations using:

`consumption.startListeningEvents(withClient: socketClient, eventDelegate: self)`

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

`user.startListeningEvents(withClient: socketClient, eventDelegate: self)`

Where:
- `client` is a `SocketClient`
- `eventDelegate` is a `UserEventDelegate` that will receive incoming events.

An object conforming to `UserEventDelegate` needs to implement the 3 common methods mentioned above and also `on(_ object: WebsocketObject, error: APIError?, forEvent event: SocketEvent)`.

This method will be called when any event regarding the user is received. `WebsocketObject` can be enumerated to get the corresponding object received.


#### Stop listening for events

When you don't need to receive events anymore, you should call `stopListening(withClient client: socketClient)` for the corresponding `Listenable` object. This will leave the corresponding socket channel and close the connection if no other channel is active.

---
