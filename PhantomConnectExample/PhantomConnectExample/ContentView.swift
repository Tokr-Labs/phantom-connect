//
//  ContentView.swift
//  PhantomConnectExample
//
//  Created by Eric McGary on 7/8/22.
//

import SwiftUI
import Solana
import PhantomConnect
import Foundation

struct ContentView: View {
    
    @StateObject var viewModel = PhantomConnectViewModel()
    
    /// Saving keys in appstorage(user defaults).
    /// THIS IS NOT SECURE! FOR DEMO ONLY!
    /// Keychain can be used as a ssecure storage
    @AppStorage("k_wallet_connected") var walletConnected = false
    @AppStorage("k_wallet_public_key") var walletPublicKeyB58: String?
    @AppStorage("k_wallet_phantom_encryption_key") var phantomEncryptionKeyB58: String?
    @State var walletPublicKey: PublicKey?
    @State var phantomEncryptionKey: PublicKey?
    @AppStorage("k_wallet_phantom_session") var session: String?
    @State var transactionSignature: String?
    
    @State var balance_Sol: Double?
    
    var body: some View {
        
        content
            .buttonStyle(.borderedProminent)
            .padding()
            .onAppear {
                
                PhantomConnect.configure(
                    appUrl: "https://example.com",
                    cluster: "devnet",
                    redirectUrl: "example://"
                )
                
                
                if let pubkey = self.walletPublicKeyB58, let enckey = self.phantomEncryptionKeyB58  {
                    self.walletPublicKey = PublicKey(string: pubkey)
                    self.phantomEncryptionKey = PublicKey(string: enckey)
                }
                self.getWalletAndBalance()
            }
        
    }
    
    @ViewBuilder
    var content: some View {
        
        if walletConnected {
            connectedContent
        } else {
            disconnectedContent
        }
        
    }
    
    var disconnectedContent: some View {
        
        Button {
            try? viewModel.connectWallet()
        } label: {
            Text("Connect with Phantom")
        }
        .onWalletConnect(viewModel: viewModel) { publicKey, phantomEncryptionPublicKey, session, error in
            
            self.walletPublicKey = publicKey
            self.phantomEncryptionKey = phantomEncryptionPublicKey
            self.session = session
            
            self.walletPublicKeyB58 = self.walletPublicKey?.base58EncodedString
            self.phantomEncryptionKeyB58 = self.phantomEncryptionKey?.base58EncodedString
            
            self.getWalletAndBalance()
            
            walletConnected.toggle()
            
        }
        
    }
    
    var connectedContent: some View {
        
        VStack(spacing: 30) {
            
            
            Text("Balance: \(self.balance_Sol ?? 0) SOL")
            
            
            VStack {
                Text("Wallet:")
                Text(walletPublicKey?.base58EncodedString ?? "--")
            }
            
            VStack {
                Text("Transaction Signature:")
                Text(transactionSignature ?? "--")
            }
            
            Button {
                
                createTransaction { serializedTransaction in
                    
                    do {
                        try viewModel.sendAndSignTransaction(
                            serializedTransaction: serializedTransaction,
                            dappEncryptionKey: viewModel.linkingKeypair?.publicKey,
                            phantomEncryptionKey: phantomEncryptionKey,
                            session: session,
                            dappSecretKey: viewModel.linkingKeypair?.secretKey
                        )
                    }
                    catch PhantomConnectError.invalidConfiguration{
                        print("Error:", PhantomConnectError.invalidConfiguration)
                    }
                    catch PhantomConnectError.invalidDappSecretKey{
                        print("Error:", PhantomConnectError.invalidDappSecretKey)
                    }
                    catch PhantomConnectError.invalidEncryptionPublicKey{
                        print("Error:", PhantomConnectError.invalidEncryptionPublicKey)
                    }
                    catch PhantomConnectError.invalidSerializedTransaction{
                        print("Error:", PhantomConnectError.invalidSerializedTransaction)
                    }
                    catch PhantomConnectError.invalidUrl{
                        print("Error:", PhantomConnectError.invalidUrl)
                    }
                    catch PhantomConnectError.missingSharedSecret{
                        print("Error:", PhantomConnectError.missingSharedSecret.description)
                    }
                    catch {
                        print("Error: Unknown")
                    }
                    
                }
                
            } label: {
                
                Text("Send Transaction")
                
            }
            .onWalletTransaction(
                phantomEncryptionPublicKey: phantomEncryptionKey,
                dappEncryptionSecretKey: viewModel.linkingKeypair?.secretKey
            ) { signature, error in
                
                transactionSignature = signature
                self.getWalletAndBalance()
                print("Error(onWalletTransaction): \(String(describing: error))")
            }
            
            Button {
                
                try? viewModel.disconnectWallet(
                    dappEncryptionKey: viewModel.linkingKeypair?.publicKey,
                    phantomEncryptionKey: phantomEncryptionKey,
                    session: session,
                    dappSecretKey: viewModel.linkingKeypair?.secretKey
                )
                
                self.walletPublicKey = nil
                self.phantomEncryptionKey = nil
                self.walletPublicKeyB58 = nil
                self.phantomEncryptionKeyB58 = nil
                //walletConnected.toggle()
                
                
            } label: {
                
                Text("Disconnect from Phantom")
                
            }
            .onWalletDisconnect { error in
                
                walletConnected.toggle()
                
            }
            
        }
        
    }
    
    func createTransaction(completion: @escaping ((_ serializedTransaction: String) -> Void)) {
        
        let solana = Solana(router: NetworkingRouter(endpoint: RPCEndpoint.devnetSolana))
        
        solana.api.getRecentBlockhash { result in
            
            let blockhash = try? result.get()
            
            var transaction = Transaction(
                feePayer: walletPublicKey!,
                instructions: [
                    SystemProgram.transferInstruction(
                        from: walletPublicKey!,
                        to: walletPublicKey!,
                        lamports: 100
                    )
                ],
                recentBlockhash: blockhash!
            )
            
            let serializedTransaction = try? transaction.serialize().get()
            
            print("Transaction:", transaction)
            
            DispatchQueue.main.async {
                completion(Base58.encode(serializedTransaction!.bytes))
            }
            
        }
        
    }
    
    func getWalletAndBalance(){
        guard let publicKey = self.walletPublicKey else {
            return
        }
        
        let solana = Solana(router: NetworkingRouter(endpoint: .devnetSolana))
        
        solana.api.getAccountInfo(account: publicKey.base58EncodedString, decodedTo: AccountInfo.self) { result in
            try? print("Account: \(result.get())")
        }
        solana.api.getBalance(account: publicKey.base58EncodedString){ result in
            try? print("Balance: \(Double(result.get()) / 1000000000) SOL")
            try? self.balance_Sol = Double(result.get()) / 1000000000
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
