//
//  RequestInfo.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public struct RequestInfo<T: NetworkAPIParameterable> {
    public var method: HTTPMethod
    public var headers: [HTTPHeader]?
    public var cookies: [HTTPCookie]?
    public var parameters: Encodable?
    public var timeout: TimeInterval
    
    public init(method: HTTPMethod,
                timeout: TimeInterval = 5.0,
                header: [HTTPHeader]? = nil,
                cookies: [HTTPCookie]? = nil,
                parameters: NetworkAPIParameterable? = nil) {
        self.method = method
        self.timeout = timeout
        self.headers = header
        self.cookies = cookies
        self.parameters = parameters
    }
}

extension RequestInfo {
    public func makeRequest(url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        
        if let parameters,
           let parameterData = try? JSONEncoder().encode(parameters) {
            switch method {
            case .get(let encoding):
                request.url = configureGetQuery(url: url,
                                                parameterData: parameterData,
                                                by: encoding)
            case .post:
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = parameterData
            }
        }
        
        if let headers {
            headers.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.name)
            }
        }
        
        if let cookies {
            request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            request.httpShouldHandleCookies = true
        }
        return request
    }
    
    private func configureGetQuery(url: URL,
                                   parameterData: Data,
                                   by encoding: GETParameterEncoding) -> URL? {
        var components = URLComponents(url: url,
                                       resolvingAgainstBaseURL: false)
        
        switch encoding {
        case .queryString:
            let parameterDictionary = (try? JSONSerialization.jsonObject(with: parameterData) as? [String: Any]) ?? [:]
            
            var queryItems: [URLQueryItem] = components?.queryItems ?? []
            queryItems.append(
                contentsOf: parameterDictionary.map { (key: String, value: Any) in
                    return URLQueryItem(name: key,
                                        value: "\(value)")
                }
            )
            
            components?.queryItems = queryItems
            
            return components?.url
        case .pathSegments(let order):
            let segments = order.compactMap {
                $0.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            }
            
            let basePath = components?.path ?? url.path
            
            let newPath = segments.reduce(basePath) { partial, segment in
                if partial.hasSuffix("/") {
                    return partial + segment
                } else {
                    return partial + "/" + segment
                }
            }
            components?.path = newPath
            
            return components?.url
        }
    }
}
