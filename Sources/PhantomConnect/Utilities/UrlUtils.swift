//
//  UrlUtils.swift
//  PhantomConnect
//
//  Created by Eric McGary on 6/28/22.
//

import Foundation

class UrlUtils {
    
    // ============================================================
    // === Internal Static API ====================================
    // ============================================================
    
    // MARK: - Internal Static API

    // MARK: Internal Static Methods
    
    /// <#Description#>
    /// - Parameters:
    ///   - path: <#path description#>
    ///   - parameters: <#parameters description#>
    /// - Returns: <#description#>
    static func format(_ path: String, parameters: [String: String]?) -> URL? {
        
        var queryItems: [URLQueryItem] = []
        
        parameters?.forEach({ (parameter) in
            queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
        })
        
        var urlComponents = URLComponents(string: path)!
        if parameters != nil {
            urlComponents.queryItems = queryItems
        }
        
        return urlComponents.url
        
    }
    
}
