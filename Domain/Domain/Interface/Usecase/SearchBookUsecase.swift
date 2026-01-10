//
//  SearchBookUsecase.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

public protocol SearchBookUsecase {
    func execute(keyword: String) async throws -> [BookSummary]
    func loadNextPages() async throws -> [BookSummary]
}
