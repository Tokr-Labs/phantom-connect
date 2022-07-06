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
    case serializationIssue
    case notConfigured
    case invalidUrl
    
}
