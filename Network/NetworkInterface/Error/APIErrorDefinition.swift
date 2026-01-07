//
//  APIErrorDefinition.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public protocol APIErrorDefinition: LocalizedError {
    associatedtype ErrorResponse: Decodable
    
    var errorResponse: ErrorResponse? { get }

    init(errorResponse: ErrorResponse?)
}
