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
    
    var urlBuilder: URLBuildable { get }
    var requestInfo: RequestInfo { get }
    var errorDefinition: any APIErrorDefinition.Type { get }
    func urlRequest() throws -> URLRequest
}
