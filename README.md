# OmiseGO

The OmiseGO iOS SDK allows developers to easily interact with a node of the OmiseGO eWallet.

Currently, it can be used to retrieve the current user, get a user's balances and list the settings for a node.

# Installation.

To do.

# Initialization

Before using the SDK to retrieve a resource, you are required to initialize the client.
The easiest way to do so is to setup the shared client using an APIConfiguration object.
You should do this as soon as you have the current user’s authentication token.

```sh
let configuration = APIConfiguration(baseURL: "your.base.url",
                                     apiKey: "apikey",
                                     authenticationToken: "authenticationtoken")
APIClient.setup(withConfig: configuration)
```

# Usage

Once the SDK is initialized, you can then retrieve different resources:
- Get the current user:

```sh
User.getCurrent { (result) in
    switch result {
    case .success(let user):
        //TODO: Do something with the user
    case .fail(let error):
        //TODO: Handle the error
    }
}
```

- Get the balances of the current user:

```sh
Balance.getAll { (balances) in
    switch result {
    case .success(let balances):
        //TODO: Do something with the balances
    case .fail(let error):
        //TODO: Handle the error
    }
}
```

- Get the provider settings:

```sh
Setting.get { (result) in
    switch result {
    case .success(let settings):
        //TODO: Do something with the settings
    case .fail(let error):
        //TODO: Handle the error
    }
}
```
