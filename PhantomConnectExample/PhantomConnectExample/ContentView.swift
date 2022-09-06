//
//  ContentView.swift
//  PhantomConnectExample
//
//  Created by Eric McGary on 7/8/22.
//

import SwiftUI
import Solana
import PhantomConnect

struct ContentView: View {
    
    @StateObject var viewModel = PhantomConnectViewModel()
    
    @State var walletConnected = false
    @State var walletPublicKey: PublicKey?
    @State var phantomEncryptionKey: PublicKey?
    @State var session: String?
    @State var transactionSignature: String?
    
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
            
            walletConnected.toggle()
            
        }
        
    }
    
    var connectedContent: some View {
        
        VStack(spacing: 24) {
            
            VStack {
                Text("Wallet Public Key:")
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
            ) { signature, _ in
                
                transactionSignature = signature
                
            }
            
            Button {
                
                try? viewModel.disconnectWallet(
                    dappEncryptionKey: viewModel.linkingKeypair?.publicKey,
                    phantomEncryptionKey: phantomEncryptionKey,
                    session: session,
                    dappSecretKey: viewModel.linkingKeypair?.secretKey
                )
                
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
            
            DispatchQueue.main.async {
                completion(Base58.encode(serializedTransaction!.bytes))
            }
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
