//
//  UrlUtils.swift
//  Rhove
//
//  Created by Eric McGary on 6/17/22.
//

import Foundation

class UrlUtils {
    
    // ============================================================
    // === Internal Static API ====================================
    // ============================================================
    
    // MARK: Internal Static Methods
    
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
