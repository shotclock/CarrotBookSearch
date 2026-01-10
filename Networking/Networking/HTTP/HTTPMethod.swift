//
//  HTTPMethod.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

public enum HTTPMethod: RawRepresentable {
    case get(encoding: GETParameterEncoding)
    case post
    
    public var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "GET":
            self = .get(encoding: .queryString)
        case "POST":
            self = .post
        default:
            return nil
        }
    }
}

public enum GETParameterEncoding {
    case queryString
    case pathSegments(order: [String])
}
