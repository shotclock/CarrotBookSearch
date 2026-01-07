//
//  URLBuilder.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation
import NetworkInterface

public final class URLBuilder: URLBuildable {
    private var product: URLComponents?
    
    init(urlString: String) {
        self.product = URLComponents(string: urlString)
    }
    
    public func addScheme(_ scheme: String = "https") -> Self {
        product?.scheme = scheme
        
        return self
    }
    
    public func addHost(_ host: String) -> Self {
        product?.host = host
        
        return self
    }
    
    public func addQuery(_ query: [String: Any?]) -> Self {
        var queryItems: [URLQueryItem] = product?.queryItems ?? []
        
        queryItems.append(
            contentsOf: query.compactMap { (key: String, value: Any?) in
                guard let value else {
                    return nil
                }
                
                return URLQueryItem(name: key,
                                    value: "\(value)")
            }
        )
        product?.queryItems = queryItems
        
        return self
    }
    
    public func addPath(_ path: String) -> Self {
        product?.path = path
        
        return self
    }
    
    public func build() -> URL? {
        product?.url
    }
}
