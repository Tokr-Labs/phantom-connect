//
//  PhantomConnectError.swift
//  Rhove
//
//  Created by Eric McGary on 6/26/22.
//

import Foundation

enum PhantomConnectError: Error {
    
    case missingRequiredData
    case serializationIssue
    case notConfigured
    
}
