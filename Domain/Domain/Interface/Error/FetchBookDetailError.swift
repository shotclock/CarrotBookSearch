//
//  FetchBookDetailError.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

public enum FetchBookDetailError: Error, Equatable {
    case emptyISBN13
    case invalidISBN13
    case invalidISBN13Format // 숫자만 지원
    case networkError(message: String)
}
