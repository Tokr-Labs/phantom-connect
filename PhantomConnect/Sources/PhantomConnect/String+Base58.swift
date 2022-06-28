import Foundation
import Solana

extension String {
    
    public var base58EncodedString: String {
        return Base58.encode(self.bytes)
    }
    
    public var base58DecodedData: Data? {
        let bytes = Base58.decode(self)
        return Data(bytes)
    }
    
}
