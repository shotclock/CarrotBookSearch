//
//  DefaultFetchBookDetailUsecaseTests.swift
//  Domain
//
//  Created by 이상호 on 1/11/26.
//

import Foundation
import Testing
@testable import Domain
import DomainInterface

struct DefaultFetchBookDetailUsecaseTests {

    // MARK: - Stub
    private actor StubBookRepository: BookRepository {
        private(set) var receivedISBN13: String?
        var result: Result<BookDetail, Error> = .failure(StubError.notConfigured)

        func fetchBookDetail(isbn13: String) async throws -> BookDetail {
            receivedISBN13 = isbn13
            return try result.get()
        }

        func searchBooks(query: String, page: Int) async throws -> (total: Int, books: [BookSummary]) {
            throw StubError.unused
        }
        
        func setResult(_ result: Result<BookDetail, Error>) {
            self.result = result
        }

        enum StubError: Error {
            case unused
            case notConfigured
        }
    }

    private func makeDetail(isbn13: String = "9781617294136") -> BookDetail {
        .init(
            title: "t",
            subtitle: "s",
            authors: "a",
            publisher: "p",
            language: "en",
            isbn10: "1617294136",
            isbn13: isbn13,
            pages: "1",
            publishYear: "2018",
            rating: "4",
            description: "desc",
            price: "$1",
            imageURL: "https://example.com/img.png",
            linkURL: "https://example.com",
            pdfData: nil
        )
    }

    // MARK: - Tests

    @Test("공백/개행만 있는 ISBN13이면 emptyISBN13 에러를 throw한다.")
    func execute_whitespaceOnly_throwsEmptyISBN13() async {
        // given
        let repository = StubBookRepository()
        let sut = DefaultFetchBookDetailUsecase(repository: repository)
        
        // then
        await #expect(throws: FetchBookDetailError.emptyISBN13, performing: {
            // when
            _ = try await sut.execute(isbn13: "   \n\t  ")
        })

        let called = await repository.receivedISBN13 != nil
        #expect(called == false)
    }

    @Test("숫자가 아닌 문자가 포함되면 invalidISBN13Format 에러를 throw 한다.")
    func execute_containsNonNumber_throwsInvalidISBN13Format() async {
        // given
        let repository = StubBookRepository()
        let sut = DefaultFetchBookDetailUsecase(repository: repository)

        // then
        await #expect(throws: FetchBookDetailError.invalidISBN13Format, performing: {
            // when
            _ = try await sut.execute(isbn13: "97816172941A6")
        })
        
        let called = await repository.receivedISBN13 != nil
        #expect(called == false)
    }

    @Test("13자리가 아니면 invalidISBN13 에러를 throw 한다.")
    func execute_not13Digits_throwsInvalidISBN13() async {
        // given
        let repository = StubBookRepository()
        let sut = DefaultFetchBookDetailUsecase(repository: repository)

        // then
        await #expect(throws: FetchBookDetailError.invalidISBN13, performing: {
            // when
            _ = try await sut.execute(isbn13: "978161729413") // 12자리
        })
        
        let called = await repository.receivedISBN13 != nil
        #expect(called == false)
    }

    @Test("13자리이나 공백이나 숫자가 아닌값이 포함되어있으면 invalidISBN13Format 에러를 throw 한다.")
    func execute_13Digits_butIncludeNonNumber_throwsInvalidISBN13() async {
        // given
        let repository = StubBookRepository()
        let sut = DefaultFetchBookDetailUsecase(repository: repository)

        // then
        await #expect(throws: FetchBookDetailError.invalidISBN13Format, performing: {
            // when
            _ = try await sut.execute(isbn13: "97. 61729413")
        })
        
        let called = await repository.receivedISBN13 != nil
        #expect(called == false)
    }
    
    @Test("정상 ISBN13이면 repository를 호출하고 결과를 반환한다.")
    func execute_validISBN13_callsRepository_andReturnsDetail() async throws {
        // given
        let repository = StubBookRepository()
        let expected = makeDetail(isbn13: "9781617294136")
        await repository.setResult(.success(expected))

        let sut = DefaultFetchBookDetailUsecase(repository: repository)
        
        // when
        let detail = try await sut.execute(isbn13: "9781617294136")

        // then
        #expect(detail.isbn13 == expected.isbn13)
        let received = await repository.receivedISBN13
        #expect(received == "9781617294136")
    }
}
