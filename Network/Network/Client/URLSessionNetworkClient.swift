//
//  URLSessionNetworkClient.swift
//  Network
//
//  Created by 이상호 on 1/8/26.
//

import Foundation
import NetworkInterface

public final class URLSessionNetworkClient: NetworkClient {
    
    private let configuration: URLSessionConfiguration
    
    public init(configuration: URLSessionConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func request<T>(_ specification: T) async throws -> T.Response where T : NetworkInterface.RequestSpecification {
        let urlSession = URLSession(configuration: configuration)
        
        let (data, urlResponse) = try await urlSession.data(for: specification.urlRequest())
        guard let urlResponse = urlResponse as? HTTPURLResponse,
              urlResponse.statusCode >= 200 && urlResponse.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        if data.isEmpty {
            throw NetworkError.emptyResponseData
        }
        
        do {
            let response = try JSONDecoder().decode(T.Response.self,
                                                    from: data)
            return response
        } catch {
            let errorResponse = try JSONDecoder().decode(
                T.ErrorResponse.Response.self,
                from: data
            )
            
            throw T.ErrorResponse.init(errorResponse: errorResponse)
        }
    }
}
