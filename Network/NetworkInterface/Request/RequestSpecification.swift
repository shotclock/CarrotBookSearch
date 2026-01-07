//
//  RequestSpecification.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public protocol RequestSpecification {
    associatedtype Response: Decodable
    associatedtype Parameter: Encodable
    associatedtype ErrorResponse: APIErrorDefinition
    
    var urlBuilder: URLBuildable { get }
    var requestInfo: RequestInfo { get }
    func urlRequest() throws -> URLRequest
}
