# OmiseGO

The OmiseGO iOS SDK allows developers to easily interact with a node of the OmiseGO eWallet.
It supports the following functionalities:
- Retrieve the current user
- Get the user addresses and balances
- List the settings for a node

# Installation.

For this initial beta version, the SDK will be provided as pod hosted on our private repo.

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

For security reason, the authentication token can't be retrieved from the client so you'll need to obtain it from the server. You can find more info on how to retrieve this token in the server side SDK documentations.

# Usage

Once the SDK is initialized, you can then retrieve different resources:
- Get the current user:

```sh
User.getCurrent { (result) in
    switch result {
    case .success(data: let user):
        //TODO: Do something with the user
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

- Get the addresses of the current user:

```sh
Address.getAll { (addresses) in
    switch result {
    case .success(data: let addresses):
        //TODO: Do something with the balances
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

- Note that for now a user will have only one address so for the sake of simplicity you can get this address using:


```sh
Address.getMain { (address) in
    switch result {
    case .success(data: let address):
        //TODO: Do something with the address
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```

- Get the provider settings:

```sh
Setting.get { (result) in
    switch result {
    case .success(data: let settings):
        //TODO: Do something with the settings
    case .fail(error: let error):
        //TODO: Handle the error
    }
}
```
