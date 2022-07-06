//
//  SigningKeypair.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana

public struct SigningKeypair: Codable {
    
    // ============================================================
    // === Public API =============================================
    // ============================================================
    
    // MARK: - Public Static API
    
    // MARK: Public Static Methods
    
    /// 32 byte public key
    public let publicKey: PublicKey
    
    /// 64 byte secret key
    public let secretKey: Data
    
}
