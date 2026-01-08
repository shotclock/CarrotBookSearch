//
//  RequestSpecificationTests.swift
//  NetworkingTests
//
//  Created by 이상호 on 1/8/26.
//

import Foundation
import Testing
@testable import Networking

@Suite(.serialized)
struct RequestSpecificationTests {
    func makeStubConfiguration() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        return config
    }
    
    @Test("statusCode 200 + valid JSON인 경우에 디코딩 성공")
    func request_success_decodesResponse() async throws {
        // given
        let url = URL(string: StubSpecification.url)!
        
        let data = try JSONEncoder().encode(StubSpecification.Response(id: 1))
        let specification = StubSpecification()
        
        StubURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (.success((data, response)))
        }
        
        // when
        let result = try await specification.request(configuration: makeStubConfiguration())
        
        // then
        #expect(result == StubSpecification.Response(id: 1))
    }

    @Test("URLBuilder가 URL을 못 만들면 wrongURL 에러를 throw한다.")
    func request_withWrongURL_throwsWrongURLError() async throws {
        // given
        let wrongURLSpecification = StubSpecification(useWrongURL: true)
        
        let data = try JSONEncoder().encode(StubSpecification.Response(id: 1))
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (.success((data, response)))
        }
        
        // when
        do {
            _ = try await wrongURLSpecification.request(configuration: makeStubConfiguration())
        } catch let error as NetworkError {
            // then
            switch error {
            case .wrongURL:
                #expect(true)
            default:
                Issue.record("wrongURL 대신 받은 에러 \(error)")
            }
        }
    }

    @Test("HTTPURLResponse가 아니면 URLError(.badServerResponse)를 던진다")
    func request_nonHTTPURLResponse_throwsBadServerResponse() async throws {
        // given
        let url = URL(string: StubSpecification.url)!

        let nonHTTP = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        StubURLProtocol.requestHandler = { _ in .success((Data(), nonHTTP)) }
        
        // when
        do {
            _ = try await StubSpecification().request(configuration: makeStubConfiguration())
            Issue.record("URLError(.badServerResponse)가 throw되지 않음")
        } catch let error as URLError {
            // then
            #expect(error.code == .badServerResponse)
        }
    }

    @Test("2xx가 아니면 NetworkError.serverError(errorCode:)를 던진다.")
    func request_non2xx_throwsServerError() async throws {
        // given
        let url = URL(string: StubSpecification.url)!

        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        StubURLProtocol.requestHandler = { _ in .success((Data(), response)) }
        
        // when
        do {
            _ = try await StubSpecification().request(configuration: makeStubConfiguration())
            Issue.record("NetworkError.serverError가 throw되지 않음")
        } catch let error as NetworkError {
            switch error {
            case .serverError(let code):
                #expect(code == 500)
            default:
                Issue.record(".serverError(500) 대신 받은 에러 \(error)")
            }
        }
    }

    @Test("2xx인데 data가 비어있으면 NetworkError.emptyResponseData를 던진다.")
    func request_emptyData_throwsEmptyResponseData() async throws {
        // given
        let url = URL(string: StubSpecification.url)!

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        StubURLProtocol.requestHandler = { _ in .success((Data(), response)) }
        
        // when
        do {
            _ = try await StubSpecification().request(configuration: makeStubConfiguration())
            Issue.record("NetworkError.emptyResponseData가 throw되지 않음")
        } catch let error as NetworkError {
            // then
            switch error {
            case .emptyResponseData:
                #expect(true)
            default:
                Issue.record(".emptyResponseData 대신 받은 에러 \(error)")
            }
        }
    }

    @Test("Response 디코딩 실패 + ErrorResponse 디코딩 성공 -> ErrorResponse(errorResponse:)를 던진다")
    func request_decodingFails_thenThrowsDomainError() async throws {
        // given
        let url = URL(string: StubSpecification.url)!

        let errorJSON = try JSONEncoder().encode(StubSpecification.ErrorResponse.Response(message: "에러!"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        StubURLProtocol.requestHandler = { _ in .success((errorJSON, response)) }
        
        // when
        do {
            _ = try await StubSpecification().request(configuration: makeStubConfiguration())
            Issue.record("StubSpecification.ErrorResponse가 throw되지 않음")
        } catch let error as StubSpecification.ErrorResponse {
            // then
            #expect(error.errorResponse?.message == "에러!")
        }
    }

    @Test("Response/ErrorResponse 모두 디코딩 실패 -> DecodingError 등 원래 에러가 전파된다.")
    func request_bothDecodingFail_propagatesError() async throws {
        // given
        let url = URL(string: StubSpecification.url)!
        let invalid = Data("not json".utf8)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        StubURLProtocol.requestHandler = { _ in .success((invalid, response)) }

        // when
        do {
            _ = try await StubSpecification().request(configuration: makeStubConfiguration())
            Issue.record("에러가 throw되지 않음")
        } catch {
            // then
            #expect((error as? NetworkError) == nil)
        }
    }
}
