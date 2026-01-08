//
//  RequestSpecification.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public protocol NetworkAPIParameterable: Encodable { }

public protocol RequestSpecification {
    associatedtype Response: Decodable
    associatedtype Parameter: NetworkAPIParameterable
    associatedtype ErrorResponse: APIErrorDefinition
    
    var urlBuilder: URLBuilder { get }
    var requestInfo: RequestInfo<Parameter> { get }
}

public extension RequestSpecification {
    func urlRequest() throws -> URLRequest {
        guard let url = urlBuilder.build() else {
            throw NetworkError.wrongURL
        }
        return try requestInfo.makeRequest(url: url)
    }
}

public extension RequestSpecification {
    func request() async throws -> Response {
        let urlSession = URLSession(configuration: .default)
        let (data, urlResponse) = try await urlSession.data(for: urlRequest())
        
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard urlResponse.statusCode >= 200 && urlResponse.statusCode < 300 else {
            throw NetworkError.serverError(errorCode: urlResponse.statusCode)
        }
        
        if data.isEmpty {
            throw NetworkError.emptyResponseData
        }
        
        do {
            let response = try JSONDecoder().decode(Response.self,
                                                    from: data)
            return response
        } catch {
            let errorResponse = try JSONDecoder().decode(
                ErrorResponse.Response.self,
                from: data
            )
            
            throw ErrorResponse.init(errorResponse: errorResponse)
        }
    }
}
