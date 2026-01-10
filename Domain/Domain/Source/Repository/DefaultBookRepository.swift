//
//  DefaultBookRepository.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import DomainInterface

public final class DefaultBookRepository: BookRepository {
    public init() {
        
    }
    
    public func searchBooks(query: String,
                            page: Int) async throws -> [DomainInterface.BookSummary] {
        let response = try await BookAPI.Search(pathParameter: .init(keyword: query,
                                                                     page: page)).request()
        
        return response
            .books
            .map {
                BookSummary(isbn13: $0.isbn13,
                            title: $0.title,
                            subtitle: $0.subtitle,
                            priceText: $0.price,
                            imageURL: $0.image,
                            detailURLString: $0.url)
        }
    }
    
    public func fetchBookDetail(isbn13: String) async throws -> DomainInterface.BookDetail {
        let response = try await BookAPI.Detail(pathParameter: .init(isbn13: isbn13)).request()
        
        return .init(isbn13: response.isbn13,
                     title: response.title,
                     subtitle: response.subtitle,
                     authors: response.authors,
                     publisher: response.publisher,
                     desc: response.desc,
                     priceText: response.price,
                     imageURL: response.image,
                     linkURL: response.url)
    }
}
