//
//  DefaultFetchBookDetailUsecase.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import DomainInterface

public final class DefaultFetchBookDetailUsecase: FetchBookDetailUsecase {
    
    private let repository: BookRepository
    
    public init(repository: BookRepository) {
        self.repository = repository
    }
    
    public func execute(isbn13: String) async throws -> DomainInterface.BookDetail {
        // empty 체크
        let trimmed = isbn13.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else {
            throw FetchBookDetailError.emptyISBN13
        }
        
        // 숫자인지 체크
        let isNumeric = trimmed.allSatisfy { $0.isNumber }
        guard isNumeric else {
            throw FetchBookDetailError.invalidISBN13Format
        }
        
        // 13자인지 체크
        guard isbn13.count == 13 else {
            throw FetchBookDetailError.invalidISBN13
        }
        
        return try await repository.fetchBookDetail(isbn13: isbn13)
    }
}
