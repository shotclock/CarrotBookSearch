//
//  StubSpecification.swift
//  NetworkingTests
//
//  Created by 이상호 on 1/8/26.
//

import Foundation
@testable import Networking

struct StubSpecification: RequestSpecification {
    static var url = "https://example.com/api"
    var urlBuilder: URLBuilder
    var requestInfo: RequestInfo<Parameter>
    
    struct Response: Codable, Equatable {
        let id: Int
    }
    
    struct Parameter: NetworkAPIParameterable {
        let test1: String
        let test2: String
    }

    struct ErrorResponse: APIErrorDefinition {
        struct Response: Codable {
            let message: String
        }
        
        let errorResponse: Response?
        init(errorResponse: Response?) {
            self.errorResponse = errorResponse
        }
    }
    
    enum Mode {
        case getQueryString
        case getPathSegments
        case postJSON
    }

    init(mode: Mode = .getQueryString,
         parameter: Parameter = .init(test1: "value1",
                                      test2: "value2"),
         useWrongURL: Bool = false) {
        
        
        switch mode {
        case .getQueryString:
            requestInfo = .init(method: .get(encoding: .queryString),
                                parameters: parameter)

        case .getPathSegments:
            requestInfo = .init(method: .get(encoding: .pathSegments(order: [parameter.test1, parameter.test2])),
                                parameters: parameter)

        case .postJSON:
            requestInfo = .init(method: .post,
                                parameters: parameter)
        }
        
        if useWrongURL {
            urlBuilder = .init()
                .addScheme("https")
                .addHost("example")
                .addPath("api")
        } else {
            urlBuilder = .init()
                .addScheme("https")
                .addHost("example.com")
                .addPath("/api")
        }
    }
}
