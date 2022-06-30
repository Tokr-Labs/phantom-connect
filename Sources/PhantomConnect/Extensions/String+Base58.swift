//
//  String+Base58.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana

extension String {
    
    // ============================================================
    // === Internal API ===========================================
    // ============================================================
    
    // MARK: - Internal API
    
    // MARK: Internal Properties
    
    /// Helper for converting a UTF8 string to a Base58 encoding string
    var base58EncodedString: String {
        return Base58.encode(self.bytes)
    }
    
    /// Helper for converting a UTF8 string into Base58 encoded data
    var base58DecodedData: Data? {
        let bytes = Base58.decode(self)
        return Data(bytes)
    }
    
}
