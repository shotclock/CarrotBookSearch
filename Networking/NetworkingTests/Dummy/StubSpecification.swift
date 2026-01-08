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
    
    init(useWrongURL: Bool = false) {
        requestInfo = .init(method: .get)
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
