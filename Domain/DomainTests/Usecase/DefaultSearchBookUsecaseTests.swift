//
//  DefaultSearchBookUsecaseTests.swift
//  Domain
//
//  Created by 이상호 on 1/11/26.
//

import Foundation
import Testing
@testable import Domain
import DomainInterface

struct DefaultSearchBookUsecaseTests {
    // MARK: - Stub
    actor CallRecorder {
        private(set) var values: [(String, Int)] = []
        func append(_ value: (String, Int)) { values.append(value) }
    }
    
    private func makeBook(_ id: Int) -> BookSummary {
        BookSummary(
            isbn13: "isbn-\(id)",
            title: "title-\(id)",
            subtitle: "subtitle-\(id)",
            priceText: "$\(id)",
            imageURL: URL(string: "https://example.com/image\(id).png")!,
            detailURLString: "https://example.com/books/\(id)"
        )
    }

    private struct StubBookRepository: BookRepository {
        var onSearch: @Sendable (_ query: String, _ page: Int) async throws -> (total: Int, books: [BookSummary])

        func searchBooks(query: String, page: Int) async throws -> (total: Int, books: [BookSummary]) {
            try await onSearch(query, page)
        }

        func fetchBookDetail(isbn13: String) async throws -> BookDetail {
            throw StubError.unused
        }

        enum StubError: Error {
            case unused
            case boom
        }
    }
    
    // MARK: - Tests
    @Test("빈 키워드는 emptyKeyword 에러를 던지고 repository를 호출하지 않는다")
    func execute_emptyKeyword_throwsEmptyKeyword_andDoesNotCallRepository() async {
        // given
        let repository = StubBookRepository { _, _ in
            Issue.record("repository가 호출되면 안된다.")
            return (total: 1, books: [])
        }
        let sut = DefaultSearchBookUsecase(repository: repository)
        
        // then
        await #expect(throws: SearchBookError.emptyKeyword, performing: {
            // when
            _ = try await sut.execute(keyword: "")
        })
    }

    @Test("execute 없이 loadNextPages를 호출하면 invalidPage 에러를 던진다")
    func loadNextPages_withoutExecute_throwsInvalidPage() async {
        // given
        let repository = StubBookRepository { _, _ in
            return (total: 1, books: [makeBook(1)])
        }
        let sut = DefaultSearchBookUsecase(repository: repository)
        
        // then
        await #expect(throws: SearchBookError.invalidPage, performing: {
            // when
            _ = try await sut.loadNextPages()
        })
    }

    @Test("execute 성공 시 이후 loadNextPages는 page=2로 요청한다")
    func execute_thenLoadNextPages_requestsPage2_andAdvancesState() async throws {
        // given
        let received: CallRecorder = .init()
        
        let repository = StubBookRepository { [received] query, page in
            await received.append((query, page))
            if page == 1 {
                return (total: 10, books: [makeBook(1), makeBook(2)])
            } else {
                return (total: 10, books: [makeBook(3)])
            }
        }

        let sut = DefaultSearchBookUsecase(repository: repository)

        // when
        let first = try await sut.execute(keyword: "swift")
        let next = try await sut.loadNextPages()
        
        // then
        #expect(first.count == 2)
        #expect(next.count == 1)
        
        let values = await received.values
        #expect(values.count == 2)
        #expect(values[0].0 == "swift")
        #expect(values[0].1 == 1)
        #expect(values[1].0 == "swift")
        #expect(values[1].1 == 2)
    }

    @Test("응답 books가 비어있으면 canLoadMore=false가 되어 loadNextPages가 invalidPage를 던진다")
    func execute_whenEmptyBooks_disablesPaging() async {
        // given
        let repository = StubBookRepository { _, _ in
            return (total: 10, books: [])
        }

        let sut = DefaultSearchBookUsecase(repository: repository)
        
        // when
        do {
            let books = try await sut.execute(keyword: "swift")
            #expect(books.isEmpty)
        } catch {
            Issue.record("error가 throw되면 안된다.")
        }

        // then
        await #expect(throws: SearchBookError.invalidPage, performing: {
            _ = try await sut.loadNextPages()
        })
    }

    @Test("total이 0이면 canLoadMore=false가 되어 loadNextPages가 invalidPage를 던진다")
    func execute_whenTotalZero_disablesPaging() async {
        // given
        let repository = StubBookRepository { _, _ in
            return (total: 0, books: [makeBook(1)])
        }

        let sut = DefaultSearchBookUsecase(repository: repository)

        // when
        do {
            _ = try await sut.execute(keyword: "swift")
        } catch {
            Issue.record("error가 throw되면 안된다.")
        }
        
        // then
        await #expect(throws: SearchBookError.invalidPage, performing: {
            _ = try await sut.loadNextPages()
        })
    }

    @Test("repository 에러는 apiError로 래핑된다")
    func execute_repositoryError_isWrappedAsApiError() async {
        // given
        let repository = StubBookRepository { _, _ in
            throw StubBookRepository.StubError.boom
        }

        let sut = DefaultSearchBookUsecase(repository: repository)
        
        do {
            _ = try await sut.execute(keyword: "swift")
            Issue.record("error가 throw되어야 함.")
        } catch {
            switch error {
            case let SearchBookError.apiError(message: message):
                #expect(message.isEmpty == false)
            default:
                Issue.record("SearchBookError.apiError가 throw되어야 함.")
            }
        }
    }
    
    @Test("execute: 두 번째 execute 호출 시 이전 상태를 reset하고 page=1부터 다시 요청한다")
    func execute_resetsState_andStartsFromPage1Again() async throws {
        // given
        let recorder = CallRecorder()

        let repo = StubBookRepository { query, page in
            await recorder.append((query, page))
            return (total: 10, books: [makeBook(page)])
        }

        let sut = DefaultSearchBookUsecase(repository: repo)

        // when
        // 첫 번째 검색
        _ = try await sut.execute(keyword: "swift")      // page = 1
        _ = try await sut.loadNextPages()                // page = 2

        // 두 번째 검색 (새 키워드)
        _ = try await sut.execute(keyword: "kotlin")    // 반드시 page = 1이어야 함

        let calls = await recorder.values

        // then
        #expect(calls.count == 3)

        #expect(calls[0].0 == "swift")
        #expect(calls[0].1 == 1)

        #expect(calls[1].0 == "swift")
        #expect(calls[1].1 == 2)
        
        #expect(calls[2].0 == "kotlin")
        #expect(calls[2].1 == 1)
    }
}
