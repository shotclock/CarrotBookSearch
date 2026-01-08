//
//  StubURLProtocol.swift
//  NetworkingTests
//
//  Created by 이상호 on 1/8/26.
//

import Foundation

final class StubURLProtocol: URLProtocol {
    enum ResponseBehavior {
        case success((Data, URLResponse))
        case failure(Error)
    }

    static var requestHandler: ((URLRequest) -> ResponseBehavior)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.requestHandler else {
            fatalError("requestHandler 설정 필요 !")
        }

        switch handler(request) {
        case .success(let (data, response)):
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
