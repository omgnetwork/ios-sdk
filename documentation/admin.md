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
