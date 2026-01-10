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
                            page: Int) async throws -> (total: Int, books: [DomainInterface.BookSummary]) {
        let response = try await BookAPI.Search(pathParameter: .init(keyword: query,
                                                                     page: page)).request()
        
        let books = response
            .books
            .map {
                BookSummary(isbn13: $0.isbn13,
                            title: $0.title,
                            subtitle: $0.subtitle,
                            priceText: $0.price,
                            imageURL: $0.image,
                            detailURLString: $0.url)
        }
        
        return (Int(response.total) ?? .zero, books)
    }
    
    public func fetchBookDetail(isbn13: String) async throws -> BookDetail {
        let response = try await BookAPI.Detail(pathParameter: .init(isbn13: isbn13)).request()
        
        return .init(title: response.title,
                     subtitle: response.subtitle,
                     authors: response.authors,
                     publisher: response.publisher,
                     language: response.language,
                     isbn10: response.isbn10,
                     isbn13: response.isbn13,
                     pages: response.pages,
                     publishYear: response.year,
                     rating: response.rating,
                     description: response.desc,
                     price: response.price,
                     imageURL: response.image,
                     linkURL: response.url,
                     pdfData: response.pdf)
    }
}
