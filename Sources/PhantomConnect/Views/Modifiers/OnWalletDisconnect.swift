//
//  OnPhantomConnect.swift
//  Rhove
//
//  Created by Eric on 7/8/21.
//

import SwiftUI
import Solana

public typealias OnWalletDisconnectAction = (_ error: Error?) -> Void

@available(iOS 14.0, *)
public struct OnWalletDisconnect: ViewModifier {
    
    // ============================================================
    // === Internal API ===========================================
    // ============================================================
    
    // MARK: - Internal API
    
    // MARK: Internal Properties
    
    public var action: OnWalletDisconnectAction
    
    // MARK: Internal Methods
    
    public func body(content: Content) -> some View {
        
        content
            .onOpenURL { url in
                
                if PhantomUrlHandler.canHandle(url: url) {
                    
                    if let deeplink = try? PhantomUrlHandler.parse(
                        url: url
                    ) {
                        
                        switch deeplink {
                                
                            case .disconnect(let error):
                                action(error)
                                
                            default:
                                break
                        }
                        
                    }
                    
                }
            }
        
    }
    
}


extension View {
    
    @available(iOS 14.0, *)
    public func onWalletDisconnect(
        action: @escaping OnWalletDisconnectAction
    ) -> some View {
        
        self.modifier(OnWalletDisconnect(action: action))
        
    }
}
