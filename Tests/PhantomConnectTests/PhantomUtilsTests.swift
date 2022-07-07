//
//  PhantomUtilsTests.swift
//  
//
//  Created by Eric McGary on 7/7/22.
//

import XCTest
import Solana
@testable import PhantomConnect

class PhantomUtilsTests: XCTestCase {
    
    func testEncryptDecrypt() throws {
        
        do {
            
            let phantomEncryptionPublicKey = PublicKey(string: "5XnzYqWYgoojELKb781u2uUSPQyuWG8HwCn2kQtwL4aA")
            let dappEncryptionSecretKey = PublicKey(string: "3j1z4h8NPdS5dePXXa67aTT38F6juqqW9vwLXzxMNhaV")
            
            let givenPayload = ["foo": "bar"]
            
            let (payload, nonce) = try PhantomUtils.encryptPayload(
                payload: givenPayload,
                phantomEncryptionPublicKey: phantomEncryptionPublicKey!,
                dappSecretKey: dappEncryptionSecretKey!.data
            )
            
            let decryptedPayload = try PhantomUtils.decryptPayload(
                data: payload,
                nonce: nonce,
                phantomEncryptionPublicKey: phantomEncryptionPublicKey!,
                dappSecretKey: dappEncryptionSecretKey!.data
            )
            
            XCTAssertEqual(givenPayload, decryptedPayload)
            
        } catch {
            
            XCTAssertNil(error)
            
        }
        
    }
    
}
