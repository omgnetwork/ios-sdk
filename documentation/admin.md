# OmiseGO admin iOS SDK

The admin iOS SDK allows developers to easily interact with the OmiseGO admin eWallet API.

# Table of Contents

- [HTTP Requests](#http-requests)
  - [Initialization](#initialization-of-the-http-client)
  - [Retrieving resources](#retrieving-resources)
    - [Get wallet for an address](#get-wallet-for-an-address)
    - [Get wallets for a user](#get-wallets-for-a-user)
    - [Get wallets for an account](#get-wallets-for-an-account)
    - [Get accounts](#get-accounts)
    - [Get transactions](#get-transactions)
  - [Transferring tokens](#transferring-tokens)
    - [Create a transaction](#create-a-transaction)
    - [Generate a transaction request](#generate-a-transaction-request)
    - [Consume a transaction request](#consume-a-transaction-request)
---

# Usage

Different part of the SDK work with 2 different protocols: http(s) and ws(s).

## HTTP Requests

This section describes the use of the http client in order to retrieve or create resources.

### Initialization of the HTTP client

Before using the SDK to retrieve a resource, you need to initialize an `HTTPAdminAPI` with a `AdminConfiguration` object.

This requires a `baseURL`, which is the http(s) URL of your OmiseGO eWallet API, and an optional `AdminCredential` object.

The `AdminCredential` contains the authentication credentials which consist in a `userId` and an `authenticationToken`. These parameters can be retrieved by logging in an admin user:

```swift
let config = AdminConfiguration(baseURL: "https://your.base.url")
let apiClient = HTTPAdminAPI(config: self.config)
let params = LoginParams(email: "admin@example.com", password: "password")
apiClient.login(withParams: params) { (response) in
    switch response {
    case .success(let result):
        // Now the api client is authenticated automatically and you'll be able to perform authenticated calls with it.
        // You can also access to the `User` object: `result.user.id` and the `authenticationToken`: `result.token`
    case .fail(error: let error): print(error)
    }
}


#### Sign out

You can sign out an admin and invalidate the client's authentication token with:

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

#### Get wallet for an address:

```swift
let address = "a_wallet_address"
let params = WalletGetParams(address: address)
Wallet.get(using: client, params: params) { result in
    switch result {
    case let .success(data: wallet):
        //TODO: Do something with the wallet
    case let .fail(error: error):
        //TODO: Handle the error
    }
}
```

#### Get wallets for a user:

```swift
let userId = "a_user_id"
let paginationParams: PaginatedListParams<Wallet> = PaginatedListParams<Wallet>(page: 1, perPage: 10, sortBy: .address, sortDirection: .ascending)
let params = WalletListForUserParams(paginatedListParams: paginationParams, userId: userId)
Wallet.listForUser(using: client, params: params) { result in
    switch result {
    case let .success(data: paginatedWallets):
        //TODO: Do something with the wallets
    case let .fail(error: error):
        //TODO: Handle the error
    }
}
```

#### Get wallets for an account:

```swift
let accountId = "an_account_id"
let paginationParams: PaginatedListParams<Wallet> = PaginatedListParams<Wallet>(page: 1, perPage: 10, sortBy: .address, sortDirection: .ascending)
let params = WalletListForAccountParams(paginatedListParams: paginationParams, accountId: accountId, owned: false)
Wallet.listForAccount(using: client, params: params) { result in
    switch result {
    case let .success(data: paginatedWallets):
        //TODO: Do something with the wallets
    case let .fail(error: error):
        //TODO: Handle the error
    }
}
```


#### Get accounts:

```swift
let params: PaginatedListParams<Account> = PaginatedListParams<Account>(page: 1, perPage: 10, sortBy: .name, sortDirection: .ascending)
Account.list(using: client, params: params) { (result) in
    switch result {
    case let .success(data: paginatedAccounts):
        //TODO: Do something with the accounts
    case let .fail(error: error):
        //TODO: Handle the error
    }
}
```

#### Get transactions:

```swift
let params: PaginatedListParams<Transaction> = PaginatedListParams<Transaction>(page: 1, perPage: 10, sortBy: .status, sortDirection: .ascending)
Transaction.list(using: client, params: params) { (result) in
    switch result {
    case let .success(data: paginatedTransactions):
        //TODO: Do something with the transactions
    case let .fail(error: error):
        //TODO: Handle the error
    }
}
```


### Transferring tokens

#### Create a transaction

```swift
let params = TransactionCreateParams(fromAddress: "dqhg022708121978",
                                     toAddress: "iciu825817955943",
                                     amount: nil,
                                     fromAmount: nil,
                                     toAmount: 200,
                                     fromTokenId: "tok_NT2_01cqx98daqa6qf0pdzn3e5csjq",
                                     toTokenId: "tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48",
                                     tokenId: nil,
                                     fromAccountId: "acc_01cqwwqz8zpsgta8rsm244w8rr",
                                     toAccountId: "acc_01cqx8qt9hgnbz1vkwhm5ymkbn",
                                     fromProviderUserId: nil,
                                     toProviderUserId: nil,
                                     fromUserId: nil,
                                     toUserId: nil,
                                     idempotencyToken: "82492734829374123",
                                     exchangeAccountId: "acc_01cqwwqz8zpsgta8rsm244w8rr",
                                     exchangeAddress: "dqhg022708121978",
                                     metadata: ["a_key": "a_value"],
                                     encryptedMetadata: ["a_key": "a_value"])
Transaction.create(using: self.apiClient, params: params) { (result) in
    switch result {
    case .success(data: let transaction):
         // TODO: Do something with the transaction
    case .fail(error: let error):
         //TODO: Handle the error
    }
}
```

There are different ways to initialize a `TransactionCreateParams` by specifying either `address`, `userId`, `provider_user_id`, `token_id` or `accountId`.

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
