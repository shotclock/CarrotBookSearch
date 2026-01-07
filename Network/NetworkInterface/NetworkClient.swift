//
//  NetworkClient.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

public protocol NetworkClient {
    func request<T: RequestSpecification>(_ spec: T) async throws -> T.Response
}
