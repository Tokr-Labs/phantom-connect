# PhantomConnect
This package aims to create a simple, uniform way of using the [Phantom Deeplinking](https://phantom.app/blog/introducing-phantom-deeplinks) for native iOS projects.

## Requirements
- iOS 13.0+ / macOS 10.15+
- Swift 5.3+

## Installation
From Xcode 12, you can use [Swift Package Manager](https://swift.org/package-manager/) to add PhantomConnect to your project.

- Select your Project from the project browser, then Package Dependencies and click the "+" icon to add a new package.
- Add https://github.com/Tokr-Labs/phantom-connect
- Select "branch" with "main"
- Select PhantomConnect

If you encounter any problem or have a question on adding the package to an Xcode project, I suggest reading the [Adding Package Dependencies](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) to Your App guide article from Apple.

## Core Files

`PhantomConnect.swift`
- Entrypoint into the framework that contains configuration methods.

`PhantomUrlHandler.swift`
- Helper class to determine whether a URL is from phantom and how to parse its contents to be used within the recieving application.

`PhantomConnectError.swift`
- Custom errors to this framework that help with UX when something goes wrong.

`PhantomDeeplink.swift`
- Deeplink enumeration that aligns with the `PhantomConnectService.swift` methods.

`PhantomConnectViewModel.swift`
- This helper class is an ObservableObject that contains business logic used to create, encrypt and open universal links in the phantom wallet. If you can't or don't want to use the view model in a manner suitable to the [SwiftUI MVVM pattern](https://www.hackingwithswift.com/books/ios-swiftui/introducing-mvvm-into-your-swiftui-project), you can use the `PhantomUtils.swift` and `PhantomConnectService.swift` files directly.   

## Setup

### Configuration

You'll need to configure the framework to make sure you're pulling in the right metadata, connecting to the correct cluster and redirecting to the right application. Storing these properties in `.xcconfig` files allows for different values to be used in CI/CD workflows.

```
PhantomConnect.configure(
    appUrl: <YOUR_APP_URL>, // used for metadata (e.g. image shown in phantom dialog during deeplinking)
    cluster: <SOLANA_CLUSTER>, // `devnet`|`mainnet-beta`
    redirectUrl: <YOUR_APP_URL_SCHEME> // reverse app domain url ensures uniqueness, but this can be what ever you define
)
```

### Usage

This framework was built with SwiftUI in mind, but that does not mean it cannot be used elsewhere. The following are code snippets that assume SwiftUI. 

The example application in this repository stores all wallet information, including the dapp secret key used in creating the shared secret for encryption and decryption, in memory. For a real-world implementation you would want to store this information in a local keychain or on a remote server. *NOTE* that ideally the dapp encryption secret key would be saved behind some form of authentication within the app keychain and never leave the device.

#### Connect

<img src="https://github.com/Tokr-Labs/phantom-connect/blob/aa94d0b68cbbfb5f131095d3419a6f1e34084191/Assets/connect.gif" alt="connect" width="250"/>

```

import PhantomConnect

...

@StateObject var phantomConnectViewModel = PhantomConnectViewModel()

...

Button {
    
    try? phantomConnectViewModel.connectWallet()
    
} label: {

    Text("Connect with Phantom")
    
}
.onWalletConnect(viewModel: phantomConnectViewModel) { publicKey, phantomEncryptionPublicKey, session, error in
    
   // wallet connected
    
}

...

```

#### Disconnect

<img src="https://github.com/Tokr-Labs/phantom-connect/blob/aa94d0b68cbbfb5f131095d3419a6f1e34084191/Assets/disconnect.gif" alt="connect" width="250"/>

```

import PhantomConnect

...

@StateObject var phantomConnectViewModel = PhantomConnectViewModel()

...

Button {

    try? phantomConnectViewModel.disconnectWallet(
        dappEncryptionKey: <DAPP_ENCRYPTION_PUBLIC_KEY>,
        phantomEncryptionKey: <PHANTOM_ENCRYPTION_PUBLIC_KEY>,
        session: <CONNECTED_PHANTOM_SESSION>,
        dappSecretKey: <DAPP_ENCRYPTION_SECRET_KEY>
    )
    
} label: {

    Text("Disconnect Wallet")
    
}
.onWalletDisconnect { error in
    
    // wallet disconnected
    
}

...

```

#### Send And Sign Transaction

<img src="https://github.com/Tokr-Labs/phantom-connect/blob/aa94d0b68cbbfb5f131095d3419a6f1e34084191/Assets/transaction.gif" alt="connect" width="250"/>

```

import PhantomConnect

...

@StateObject var phantomConnectViewModel = PhantomConnectViewModel()

...

Button {

    try? phantomConnectViewModel.sendAndSignTransaction(
        serializedTransaction: <SERIALIZED_TRANSACTION>,
        dappEncryptionKey: <DAPP_ENCRYPTION_PUBLIC_KEY>,
        phantomEncryptionKey: <PHANTOM_ENCRYPTION_PUBLIC_KEY>,
        session: <CONNECTED_PHANTOM_SESSION>,
        dappSecretKey: <DAPP_ENCRYPTION_SECRET_KEY>
    )
    
} label: {
    
    Text("Disconnect Wallet")
    
}
.onWalletTransaction(
    phantomEncryptionPublicKey: <PHANTOM_ENCRYPTION_PUBLIC_KEY>,
    dappEncryptionSecretKey: <DAPP_ENCRYPTION_SECRET_KEY>
) { signature, error in
    
    // handle transaction response
    
}

...

```

