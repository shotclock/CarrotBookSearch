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
        try await repository.fetchBookDetail(isbn13: isbn13)
    }
}
