//
//  PhantomUtils.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana
import TweetNacl

class PhantomUtils {
    
    /// Encrypt the payload for the outgoing deeplink to the phantom app
    /// - Parameters:
    ///   - payload: Dictionary payload for sending to phantom app
    ///   - phantomEncryptionPublicKey: Public key returned form the original connection
    ///   - dappSecretKey: Private key for
    /// - Returns: <#description#>
    static func encryptPayload(
        payload: [String: Any],
        phantomEncryptionPublicKey: PublicKey?,
        dappSecretKey: Data?
    ) throws -> (payload: String, nonce: String) {
        
        guard let phantomEncryptionPublicKey = phantomEncryptionPublicKey, let dappSecretKey = dappSecretKey else {
            throw PhantomConnectError.missingRequiredData
        }

        let sharedSecret = try TweetNacl.NaclBox.before(
            publicKey: phantomEncryptionPublicKey.data,
            secretKey: dappSecretKey
        )
        
        let nonce = try TweetNacl.NaclUtil.secureRandomData(count: 24)
        
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
    ///   - data: <#data description#>
    ///   - nonce: <#nonce description#>
    ///   - phantomEncryptionPublicKey: <#phantomEncryptionPublicKey description#>
    ///   - dappSecretKey: <#dappSecretKey description#>
    /// - Returns: <#description#>
    static func decryptPayload(
        data: String,
        nonce: String,
        phantomEncryptionPublicKey: PublicKey?,
        dappSecretKey: Data?
    ) throws -> [String: String]? {

        guard let phantomEncryptionPublicKey = phantomEncryptionPublicKey, let dappSecretKey = dappSecretKey else {
            throw PhantomConnectError.missingRequiredData
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