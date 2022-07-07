//
//  PhantomUtils.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana
import TweetNacl

public class PhantomUtils {
    
    /// Encrypt the payload for the outgoing deeplink to the phantom app
    /// - Parameters:
    ///   - payload: Dictionary payload for sending to phantom app
    ///   - phantomEncryptionPublicKey: Public key returned form the original connection
    ///   - dappSecretKey: Private key for
    /// - Returns: Returns tuple containing the base58 encrypted payload and the nonce used during encryption
    public static func encryptPayload(
        payload: [String: Any],
        phantomEncryptionPublicKey: PublicKey?,
        dappSecretKey: Data?
    ) throws -> (payload: String, nonce: String) {
        
        guard let dappSecretKey = dappSecretKey else {
            throw PhantomConnectError.invalidDappSecretKey
        }
        
        guard let phantomEncryptionPublicKey = phantomEncryptionPublicKey else {
            throw PhantomConnectError.invalidEncryptionPublicKey
        }

        let sharedSecret = try TweetNacl.NaclBox.before(
            publicKey: phantomEncryptionPublicKey.data,
            secretKey: dappSecretKey
        )
        
        let nonce = try SolanaUtils.generateNonce()
        
        let payload = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let encryptedPayload = try TweetNacl.NaclSecretBox.secretBox(
            message: payload,
            nonce: nonce,
            key: sharedSecret
        )
        
        return (Base58.encode(encryptedPayload.bytes), Base58.encode(nonce.bytes))
        
    }
    
    /// Decrypt the message payload in the incoming deeplink
    /// - Parameters:
    ///   - data: Data returned from phantom deeplink
    ///   - nonce: nonce to use for decryption
    ///   - phantomEncryptionPublicKey: the 32 byte public key returned from original phantom connection
    ///   - dappSecretKey: 32 byte secret key generated for original connection
    /// - Returns: Returns a dictionary representing the descrypted data
    static func decryptPayload(
        data: String,
        nonce: String,
        phantomEncryptionPublicKey: PublicKey?,
        dappSecretKey: Data?
    ) throws -> [String: String]? {

        guard let dappSecretKey = dappSecretKey else {
            throw PhantomConnectError.invalidDappSecretKey
        }
        
        guard let phantomEncryptionPublicKey = phantomEncryptionPublicKey else {
            throw PhantomConnectError.invalidEncryptionPublicKey
        }
        
        let sharedSecret = try TweetNacl.NaclBox.before(
            publicKey: phantomEncryptionPublicKey.data,
            secretKey: dappSecretKey
        )
        
        let decryptedData = try TweetNacl.NaclSecretBox.open(
            box: data.base58DecodedData!,
            nonce: nonce.base58DecodedData!,
            key: sharedSecret
        )
        
        return try JSONSerialization.jsonObject(with: decryptedData) as? [String: String]
    
    }
    
}
