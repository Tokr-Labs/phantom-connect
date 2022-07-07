# PhantomConnect
This package aims to create a simple, uniform way of using the [Phantom Deeplinking](https://phantom.app/blog/introducing-phantom-deeplinks) for native iOS projects.

## Requirements
- iOS 13.0+ / macOS 10.13+
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
- This helper class is an ObservableObject that contains business logic used to create, encrypt and open universal links in the phantom wallet. If you can't or don't want to use the view model in a manner suitable to the [SwiftUI MVVM pattern](https://www.hackingwithswift.com/books/ios-swiftui/introducing-mvvm-into-your-swiftui-project), you can use the `SolanaUtils.swift` and `PhantomConnectService.swift` files directly.   

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

#### Connect

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
    .onOpenURL { url in
        
        // check to make sure this is a Phantom produced incoming url
        if PhantomUrlHandler.canHandle(url: url) {
            
            // parse the incoming url to determine what type of PhantomDeeplink is incoming
            if let deeplink = try? PhantomUrlHandler.parse(
                url: url,
                dappSecretKey: phantomConnectViewModel.linkingKeypair?.secretKey
            ) {
                
                switch deeplink {
                    case .connect(let publicKey, let phantomEncryptionPublicKey, let session, let error):
                        // phantom wallet connected
                        
                    default:
                        break
                }
                
            }
            
        }
    }

...

```

#### Disconnect

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
    .onOpenURL { url in
    
        // check to make sure this is a Phantom produced incoming url
        if PhantomUrlHandler.canHandle(url: url) {
            
            // parse the incoming url to determine what type of PhantomDeeplink is incoming
            if let deeplink = try? PhantomUrlHandler.parse(
                url: url,
                dappSecretKey: <DAPP_ENCRYPTION_SECRET_KEY>
            ) {
                
                switch deeplink {
                    case .disconnect(let error):
                        // phantom wallet disconnected
                        
                    default:
                        break
                }
                
            }
            
        }
        
    }

...

```

#### Send And Sign Transaction

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
    .onOpenURL { url in
        
        // check to make sure this is a Phantom produced incoming url
        if PhantomUrlHandler.canHandle(url: url) {
            
            // parse the incoming url to determine what type of PhantomDeeplink is incoming
            if let deeplink = try? PhantomUrlHandler.parse(
                url: url,
                phantomEncryptionPublicKey: <PHANTOM_ENCRYPTION_PUBLIC_KEY>,
                dappSecretKey: <DAPP_ENCRYPTION_SECRET_KEY>
            ) {
                
                switch deeplink { 
                    case .signAndSendTransaction(let signature, let error):
                        // transaction sent
                        
                    default:
                        break
                }
                
            }
            
        }
        
    }

...

```
