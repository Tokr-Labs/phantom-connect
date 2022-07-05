//
//  PhantomConnectError.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation

enum PhantomConnectError: Error {
    
    case missingRequiredData
    case serializationIssue
    case notConfigured
    case invalidUrl
    
}
