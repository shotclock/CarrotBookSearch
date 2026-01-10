//
//  SearchBookError.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

public enum SearchBookError: Error, Equatable {
    case emptyKeyword
    case invalidPage
    case apiError(message: String)
}
