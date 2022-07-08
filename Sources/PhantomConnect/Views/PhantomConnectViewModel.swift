//
//  PhantomConnectViewModel.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana

#if os(iOS)
import UIKit
#endif

@available(iOS 13.0, macOS 10.15, *)
public class PhantomConnectViewModel: ObservableObject {
    
    // ============================================================
    // === Public API =============================================
    // ============================================================
    
    // MARK: - Public API
    
    // MARK: Public Properties
   
    /// Initial keypair used for connecting with phantom. This property should only be counted on being present during the app session where connection was made, unless manually set.
    public var linkingKeypair: BoxedKeypair?
    
    /// Linking key pair public key used for shared secret. This property should only be counted on being present during the app session where connection was made, unless manually set.
    public var encryptionPublicKey: PublicKey {
        return linkingKeypair?.publicKey ?? PublicKey(bytes: PublicKey.NULL_PUBLICKEY_BYTES)!
    }
    
    // MARK: Public Methods
    
    /// Constructor
    /// - Parameter phantomConnectService: Dependency injected service
    public init(phantomConnectService: PhantomConnectService? = PhantomConnectService()) {
        self.phantomConnectService = phantomConnectService!
    }
    
    /// This method kicks the app over to the  phantom app via a universal link created in the `PhantomConnectService`
    public func connectWallet() throws {
        
        linkingKeypair = try SolanaUtils.generateBoxedKeypair()
    
        let url = try phantomConnectService.connect(
            publicKey: linkingKeypair?.publicKey.data ?? Data()
        )
        
#if os(iOS)
        UIApplication.shared.open(url)
#endif
        
    }
    
    /// Generates url for disconnecting phantom wallet
    /// - Parameters:
    ///   - dappEncryptionKey: The public key generated for original connection
    ///   - phantomEncryptionKey: Public key returned from phantom during initial connection
    ///   - session: Session returned from original connection with phantom
    ///   - dappSecretKey: 32 Byte private key generated for initial phatom wallet connection
    public func disconnectWallet(
        dappEncryptionKey: PublicKey?,
        phantomEncryptionKey: PublicKey?,
        session: String?,
        dappSecretKey: Data?
    ) throws {
        
        let (encryptedPayload, nonce) = try PhantomUtils.encryptPayload(
            payload: [
                "session": session ?? ""
            ],
            phantomEncryptionPublicKey: phantomEncryptionKey,
            dappSecretKey: dappSecretKey
        )
        
        let url = try phantomConnectService.disconnect(
            encryptionPublicKey: dappEncryptionKey,
            nonce: nonce,
            payload: encryptedPayload
        )
        
#if os(iOS)
        UIApplication.shared.open(url)
#endif
        
    }
    
    /// Creates url for sending and signing a serialized solana transaction with the phantom app
    /// - Parameters:
    ///   - serializedTransaction: Serialized solana transaction
    ///   - dappEncryptionKey: The public key generated for original connection
    ///   - phantomEncryptionKey: Public key returned from phantom during initial connection
    ///   - session: Session returned from original connection with phantom
    ///   - dappSecretKey: 32 Byte private key generated for initial phatom wallet connection
    public func sendAndSignTransaction(
        serializedTransaction: String?,
        dappEncryptionKey: PublicKey?,
        phantomEncryptionKey: PublicKey?,
        session: String?,
        dappSecretKey: Data?
    ) throws {
        
        guard let serializedTransaction = serializedTransaction else {
            throw PhantomConnectError.invalidSerializedTransaction
        }
        
        let (encryptedPayload, nonce) = try PhantomUtils.encryptPayload(
            payload: [
                "session": session ?? "",
                "transaction": serializedTransaction
            ],
            phantomEncryptionPublicKey: phantomEncryptionKey,
            dappSecretKey: dappSecretKey
        )
        
        let url = try phantomConnectService.signAndSendTransaction(
            encryptionPublicKey: dappEncryptionKey,
            nonce: nonce,
            payload: encryptedPayload
        )
        
#if os(iOS)
        UIApplication.shared.open(url)
#endif
        
    }
    
    // ============================================================
    // === Private API ============================================
    // ============================================================
    
    // MARK: - Private API
    
    // MARK: Private Properties
    
    private let phantomConnectService: PhantomConnectService
    
}
