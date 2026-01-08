//
//  URLBuilder.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public final class URLBuilder {
    private var product: URLComponents
    
    public init() {
        product = URLComponents()
    }
    
    public func addScheme(_ scheme: String = "https") -> Self {
        product.scheme = scheme
        
        return self
    }
    
    public func addHost(_ host: String) -> Self {
        product.host = host
        
        return self
    }
    
    public func addPath(_ path: String) -> Self {
        product.path = path
        
        return self
    }
    
    public func build() -> URL? {
        product.url
    }
}
