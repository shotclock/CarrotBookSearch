//
//  FetchBookDetailUsecase.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

public protocol FetchBookDetailUsecase {
    func execute(isbn13: String) async throws -> BookDetail
}
