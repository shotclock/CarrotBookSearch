//
//  DefaultBookRepositoryTests.swift
//  Domain
//
//  Created by 이상호 on 1/11/26.
//

import Foundation
import Testing
@testable import Domain

// MARK: - URLProtocol Stub

final class StubURLProtocol: URLProtocol {
    static var handler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        guard let handler = Self.handler else {
            fatalError("StubURLProtocol.handler 세팅 필요")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

// MARK: - Tests
@Suite(.serialized)
struct DefaultBookRepositoryTests {
    
    private func makeConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        return config
    }
    
    @Test("searchBooks: URLProtocol 스텁 응답을 BookSummary로 매핑하고 total을 Int로 변환한다")
    func searchBooks_mapsAndParsesTotal() async throws {
        // given
        let json = """
        {
          "error":"0",
          "total":"123",
          "page":"1",
          "books":[
            {
              "title":"Learning Swift 2 Programming, 2nd Edition",
              "subtitle":"",
              "isbn13":"9780134431598",
              "price":"$28.32",
              "image":"https://itbook.store/img/books/9780134431598.png",
              "url":"https://itbook.store/books/9780134431598"
            }
          ]
        }
        """.data(using: .utf8)!
        
        StubURLProtocol.handler = { request in
            let absolute = request.url?.absoluteString ?? ""
            #expect(absolute.contains("/search/"))
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, json)
        }
        
        let sut = DefaultBookRepository(sessionConfiguration: makeConfig())
        
        // when
        let result = try await sut.searchBooks(query: "swift", page: 1)
        
        // then
        #expect(result.total == 123)
        #expect(result.books.count == 1)
        
        let first = result.books[0]
        #expect(first.isbn13 == "9780134431598")
        #expect(first.title == "Learning Swift 2 Programming, 2nd Edition")
        #expect(first.subtitle == "")
        #expect(first.priceText == "$28.32")
        #expect(first.imageURL == "https://itbook.store/img/books/9780134431598.png")
        #expect(first.detailURLString == "https://itbook.store/books/9780134431598")
    }
    
    @Test("fetchBookDetail: URLProtocol 스텁 응답을 BookDetail로 매핑하고 pdf 정보를 포함한다")
    func fetchBookDetail_mapsIncludingPDF() async throws {
        // given
        let json = """
        {
          "error":"0",
          "title":"Securing DevOps",
          "subtitle":"Security in the Cloud",
          "authors":"Julien Vehent",
          "publisher":"Manning",
          "language":"English",
          "isbn10":"1617294136",
          "isbn13":"9781617294136",
          "pages":"384",
          "year":"2018",
          "rating":"4",
          "desc":"DevOps team&#039;s highest priority...",
          "price":"$39.65",
          "image":"https://itbook.store/img/books/9781617294136.png",
          "url":"https://itbook.store/books/9781617294136",
          "pdf":{
            "Chapter 2":"https://itbook.store/files/9781617294136/chapter2.pdf",
            "Chapter 5":"https://itbook.store/files/9781617294136/chapter5.pdf"
          }
        }
        """.data(using: .utf8)!
        
        StubURLProtocol.handler = { request in
            let absolute = request.url?.absoluteString ?? ""
            #expect(absolute.contains("/books/"))
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, json)
        }
        
        let sut = DefaultBookRepository(sessionConfiguration: makeConfig())
        
        // when
        let detail = try await sut.fetchBookDetail(isbn13: "9781617294136")
        
        // then
        #expect(detail.title == "Securing DevOps")
        #expect(detail.subtitle == "Security in the Cloud")
        #expect(detail.authors == "Julien Vehent")
        #expect(detail.publisher == "Manning")
        #expect(detail.language == "English")
        #expect(detail.isbn10 == "1617294136")
        #expect(detail.isbn13 == "9781617294136")
        #expect(detail.pages == "384")
        #expect(detail.publishYear == "2018")
        #expect(detail.rating == "4")
        #expect(detail.description.contains("DevOps"))
        #expect(detail.price == "$39.65")
        #expect(detail.imageURL == "https://itbook.store/img/books/9781617294136.png")
        #expect(detail.linkURL == "https://itbook.store/books/9781617294136")
        
        #expect(detail.pdfData?["Chapter 2"] == "https://itbook.store/files/9781617294136/chapter2.pdf")
        #expect(detail.pdfData?["Chapter 5"] == "https://itbook.store/files/9781617294136/chapter5.pdf")
    }
    
    @Test("searchBooks: total이 숫자가 아닌 문자열이면 0을 반환한다")
    func searchBooks_whenTotalIsNotNumeric_returnsZero() async throws {
        // given
        let json = """
        {
          "error":"0",
          "total":"abc",
          "page":"1",
          "books":[
            {
              "title":"Learning Swift 2 Programming, 2nd Edition",
              "subtitle":"",
              "isbn13":"9780134431598",
              "price":"$28.32",
              "image":"https://itbook.store/img/books/9780134431598.png",
              "url":"https://itbook.store/books/9780134431598"
            }
          ]
        }
        """.data(using: .utf8)!

        StubURLProtocol.handler = { request in
            let absolute = request.url?.absoluteString ?? ""
            #expect(absolute.contains("/search/"))

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, json)
        }

        let sut = DefaultBookRepository(sessionConfiguration: makeConfig())

        // when
        let result = try await sut.searchBooks(query: "swift", page: 1)

        // then
        #expect(result.total == 0)
        #expect(result.books.count == 1)
    }
}
