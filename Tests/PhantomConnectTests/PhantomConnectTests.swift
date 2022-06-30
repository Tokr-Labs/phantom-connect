import XCTest
@testable import PhantomConnect

final class PhantomConnectTests: XCTestCase {
    
    func testExample() throws {
            
        PhantomConnect.configure(appUrl: "url", cluster: "cluster", redirectUrl: "redirect")
        
        XCTAssertEqual(PhantomConnectService.appUrl, "url")
        XCTAssertEqual(PhantomConnectService.cluster, "cluster")
        XCTAssertEqual(PhantomConnectService.redirectUrl, "redirect")
        
    }
    
}
