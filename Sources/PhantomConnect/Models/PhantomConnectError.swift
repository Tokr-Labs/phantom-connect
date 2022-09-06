//
//  PhantomConnectError.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation

public enum PhantomConnectError: Error {
    
    case invalidEncryptionPublicKey
    case invalidDappSecretKey
    case invalidSerializedTransaction
    case invalidConfiguration
    case invalidUrl
    case missingSharedSecret
    
}

extension PhantomConnectError: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            case .invalidEncryptionPublicKey:
                return "The provided encryption key was not valid."
                
            case .invalidDappSecretKey:
                return "The provided dapp secret key is not valid."
                
            case .invalidSerializedTransaction:
                return "The provided dapp secret key is not valid."
                
            case .invalidConfiguration:
                return "Phantom connect was not configured correctly"
                
            case .invalidUrl:
                return "Invalid URL"
            
            case .missingSharedSecret:
                return "Phantom says 'Missing shared secret'. Something went wrong within Phantom. Either selected not correct wallet in phantom or session expired by phantom. Try to disconnect and connect to Phantom again."
                
        }
        
    }
    
}

extension PhantomConnectError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
            case .invalidEncryptionPublicKey:
                return NSLocalizedString(
                    "The provided encryption key was not valid.",
                    comment: "Invalid Encryption Public Key"
                )
                
            case .invalidDappSecretKey:
                return NSLocalizedString(
                    "The provided dapp secret key is not valid.",
                    comment: "Invalid Dapp Secret Key"
                )
                
            case .invalidSerializedTransaction:
                return NSLocalizedString(
                    "The provided dapp secret key is not valid.",
                    comment: "Invalid Serialized Transaction"
                )
                
            case .invalidConfiguration:
                return NSLocalizedString(
                    "Phantom connect was not configured correctly",
                    comment: "Invalid Phantom Connect Configuration"
                )
                
            case .invalidUrl:
                return NSLocalizedString(
                    "Invalid URL",
                    comment: "Invalid URL"
                )
            
            case .missingSharedSecret:
                return NSLocalizedString(
                    "Phantom says 'Missing shared secret'. Something went wrong within Phantom. Either selected not correct wallet in phantom or session expired by phantom.",
                    comment: "Missing Shared Secret"
                )
                
        }
    }
}
