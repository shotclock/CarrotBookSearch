//
//  DefaultSearchBookUsecase.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import DomainInterface

public enum SearchBookError: Error {
    case emptyKeyword
    case invalidPage
    case apiError(message: String)
}

public class DefaultSearchBookUsecase: SearchBookUsecase {
    private let repository: BookRepository
    
    private var currentKeyword: String?
    private var currentPage: Int = 1
    private var canLoadMore: Bool = false
    
    public init(repository: BookRepository) {
        self.repository = repository
    }
    
    public func execute(keyword: String) async throws -> [BookSummary] {
        reset()
        
        guard !keyword.isEmpty else {
            throw SearchBookError.emptyKeyword
        }
        
        do {
            let response = try await repository.searchBooks(query: keyword,
                                                            page: 1)
            currentKeyword = keyword
            canLoadMore = canLoadNextPage(totalCount: response.total,
                                          currentItemCount: response.books.count)
            
            return response.books
        } catch {
            throw SearchBookError.apiError(message: error.localizedDescription)
        }
    }
    
    public func loadNextPages() async throws -> [BookSummary] {
        guard canLoadMore else {
            throw SearchBookError.invalidPage
        }
        
        guard let currentKeyword else {
            throw SearchBookError.emptyKeyword
        }
        
        do {
            let response = try await repository.searchBooks(query: currentKeyword,
                                                            page: currentPage + 1)
            currentPage += 1
            
            canLoadMore = canLoadNextPage(totalCount: response.total,
                                          currentItemCount: response.books.count)
            
            return response.books
        } catch {
            throw SearchBookError.apiError(message: error.localizedDescription)
        }
    }
    
    private func reset() {
        currentKeyword = nil
        currentPage = 1
        canLoadMore = false
    }
    
    
    /*
     itbook API는 페이지 범위를 초과한 요청에서 totalCount가 0으로 내려오는 경우가 있어
     total 값만으로는 마지막 페이지 여부를 신뢰할 수 없다.
     또한 마지막 페이지를 명시적으로 알려주는 플래그가 없기 때문에,
     마지막 페이지 판단은 다음 페이지를 한 번 더 요청했을 때
     결과가 비어 있는지 여부로 결정한다.
     */
    private func canLoadNextPage(totalCount: Int,
                                 currentItemCount: Int) -> Bool {
        // 응답 받은 책의 데이터가 없으면 다음 페이지 로드 불가
        guard currentItemCount > 0 else {
            return false
        }
        
        // totalCount가 0인 경우 다음 페이지 로드 불가
        guard totalCount > 0 else {
            return false
        }
        
        return true
    }
}
