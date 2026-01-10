//
//  BookRepository.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

public protocol BookRepository {
    func searchBooks(query: String,
                     page: Int) async throws -> [BookSummary]
    func fetchBookDetail(isbn13: String) async throws -> BookDetail
}
