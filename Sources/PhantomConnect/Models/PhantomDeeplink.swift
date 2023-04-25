//
//  PhantomDeeplink.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation
import Solana

public enum PhantomDeeplink {
    
    case connect(publicKey: PublicKey?, phantomEncryptionPublicKey: PublicKey?, session: String?, error: Error?)
    case disconnect(error: Error?)
    case signTransaction
    case signAllTransactions
    case signAndSendTransaction(signature: String?, error: Error?)
    case signMessage(signature: String?, error: Error?)
    case unknown
 
}
