//
//  RequestInfo.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public struct RequestInfo {
    public var method: HTTPMethod
    public var headers: [HTTPHeader]?
    public var cookies: [HTTPCookie]?
    public var parameters: Encodable?
    public var timeout: TimeInterval
    
    public init(method: HTTPMethod,
                timeout: TimeInterval = 5.0,
                header: [HTTPHeader]? = nil,
                cookies: [HTTPCookie]? = nil,
                parameters: Encodable? = nil) {
        self.method = method
        self.timeout = timeout
        self.headers = header
        self.cookies = cookies
        self.parameters = parameters
    }
}
