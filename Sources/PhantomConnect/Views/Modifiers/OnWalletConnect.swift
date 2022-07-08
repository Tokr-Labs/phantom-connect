//
//  OnPhantomConnect.swift
//  Rhove
//
//  Created by Eric on 7/8/21.
//

import SwiftUI
import Solana

public typealias OnWalletConnectAction = (_ publicKey: PublicKey?, _ phantomEncryptionPublicKey: PublicKey?, _ session: String? ,_ error: Error?) -> Void

@available(iOS 14.0, macOS 11, *)
public struct OnWalletConnect: ViewModifier {
    
    // ============================================================
    // === Public API =============================================
    // ============================================================
    
    // MARK: - Public API
    
    // MARK: Public Properties
    
    public var viewModel: PhantomConnectViewModel
    public var perform: OnWalletConnectAction
    
    // MARK: Public Methods
    
    public func body(content: Content) -> some View {
        
        content
            .onOpenURL { url in
                
                if PhantomUrlHandler.canHandle(url: url) {
                    
                    if let deeplink = try? PhantomUrlHandler.parse(
                        url: url,
                        dappSecretKey: viewModel.linkingKeypair?.secretKey
                    ) {
                        
                        switch deeplink {
                                
                            case .connect(let publicKey, let phantomEncryptionPublicKey, let session, let error):
                                action(publicKey, phantomEncryptionPublicKey, session, error)
                                
                            default:
                                break
                        }
                        
                    }
                    
                }
            }
        
    }
    
}


extension View {
    
    @available(iOS 14.0, macOS 11, *)
    public func onWalletConnect(
        viewModel: PhantomConnectViewModel,
        perform: @escaping OnWalletConnectAction
    ) -> some View {
        
        self.modifier(OnWalletConnect(viewModel: viewModel, perform: perform))
        
    }
}
