//
//  BoxedKeypair.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana

public struct BoxedKeypair {
    
    // ============================================================
    // === Public API =============================================
    // ============================================================
    
    // MARK: - Public Static API
    
    // MARK: Public Static Methods
    
    /// <#Description#>
    public let publicKey: PublicKey
    
    /// <#Description#>
    public let secretKey: Data
    
}
