//
//  BookSpecification.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import Foundation
import Networking

enum BookAPI {
    static var urlBuilder: URLBuilder {
        return .init()
            .addScheme()
            .addHost("api.itbook.store")
    }
    
    struct Search: RequestSpecification {
        var requestInfo: Networking.RequestInfo<Path>
        var urlBuilder: Networking.URLBuilder
        
        struct Path: NetworkAPIParameterable {
            let keyword: String
            let page: Int
        }
        
        struct Response: Decodable {
            let error: String
            let total: String
            let page: String
            let books: [BookData]
            
            struct BookData: Decodable, Hashable {
                let title: String
                let subtitle: String
                let isbn13: String
                let price: String
                let image: URL
                let url: String
            }
        }
        
        struct ErrorResponse: APIErrorDefinition {
            struct Response: Decodable {
                let error: String
            }
            
            var errorResponse: Response?
            init(errorResponse: Response?) {
                self.errorResponse = errorResponse
            }
        }
        
        init(pathParameter: Path) {
            self.requestInfo = .init(method: .get(encoding: .pathSegments(order: [pathParameter.keyword,
                                                                                  "\(pathParameter.page)"])),
                                     parameters: pathParameter)
            self.urlBuilder = BookAPI.urlBuilder.addPath("/1.0/search")
        }
    }
    
    struct Detail: RequestSpecification {
        var requestInfo: Networking.RequestInfo<Path>
        var urlBuilder: Networking.URLBuilder
        
        struct Path: NetworkAPIParameterable {
            let isbn13: String
        }
        
        struct Response: Decodable {
            let error: String
            let title: String
            let subtitle: String
            let authors: String
            let publisher: String
            let language: String
            let isbn10: String
            let isbn13: String
            let pages: String
            let year: String
            let rating: String
            let desc: String
            let price: String
            let image: URL
            let url: URL
            let pdf: [String: URL]?
        }
        
        struct ErrorResponse: APIErrorDefinition {
            struct Response: Decodable {
                let error: String
            }
            
            var errorResponse: Response?
            
            var errorDescription: String? {
                return errorResponse?.error
            }
            
            init(errorResponse: Response?) {
                self.errorResponse = errorResponse
            }
        }
        
        init(pathParameter: Path) {
            self.requestInfo = .init(method: .get(encoding: .pathSegments(order: [pathParameter.isbn13])),
                                     parameters: pathParameter)
            self.urlBuilder = BookAPI.urlBuilder.addPath("/1.0/books")
        }
    }
}
