//
//  NetworkError.swift
//  Network
//
//  Created by 이상호 on 1/8/26.
//

public enum NetworkError: Error {
    case emptyResponseData
    case serverError(errorCode: Int)
    case wrongURL
}
