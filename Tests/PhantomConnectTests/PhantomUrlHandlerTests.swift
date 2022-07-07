//
//  PhantomUtilsTests.swift
//  
//
//  Created by Eric McGary on 7/7/22.
//

import XCTest
@testable import PhantomConnect

class PhantomUrlHandlerTests: XCTestCase {
    
    func testCanHandle() throws {
        
        let connect = URL(string: "url.scheme://phantom_connect")!
        let disconnect = URL(string: "url.scheme://phantom_disconnect")!
        let singAndSendTransaction = URL(string: "url.scheme://phantom_sign_and_send_transaction")!
        
        let unknown = URL(string: "url.scheme://unknown")!
        
        XCTAssertTrue(PhantomUrlHandler.canHandle(url: connect))
        XCTAssertTrue(PhantomUrlHandler.canHandle(url: disconnect))
        XCTAssertTrue(PhantomUrlHandler.canHandle(url: singAndSendTransaction))
        
        XCTAssertFalse(PhantomUrlHandler.canHandle(url: unknown))
        
    }
    
    func xtestParse() throws {
        
    }
    
}
