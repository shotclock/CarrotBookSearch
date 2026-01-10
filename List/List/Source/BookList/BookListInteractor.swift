//
//  BookListInteractor.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Foundation
import Base
import BookListInterface
import DomainInterface

// 뷰모델 -> 라우터
protocol BookListRoutable: Routable {
    func attachBookDetail(with data: String)
    func detachBookDetail()
}

// 뷰모델 -> 뷰 컨트롤러
protocol BookListViewControllerPresentable: AnyObject {
    var listener: BookListViewControllerListener? { get set }
    
    func presentSearchResult(data: [BookSummary]) async
}

final class BookListInteractor: Interactor<BookListViewControllerPresentable>, BookListInteractable {
    struct Usecase {
        let searchBookUsecase: SearchBookUsecase
    }
    
    weak var router: BookListRoutable?
    weak var listener: BookListListener?
    
    private let usecases: Usecase
    private var isLoading: Bool
    private var books: [BookSummary]
    
    init(presenter: BookListViewControllerPresentable?,
         usecases: Usecase) {
        self.usecases = usecases
        isLoading = false
        books = []
        super.init(presenter: presenter)
        
        presenter?.listener = self
    }
    
    override func attached() {
        super.attached()
    }
    
    override func detached() {
        super.detached()
    }
}

// MARK: BookListViewControllerListener
extension BookListInteractor: BookListViewControllerListener {
    func didRequestSearch(keyword: String) {
        isLoading = true
        books = []
        Task {
            do {
                let response = try await usecases.searchBookUsecase.execute(keyword: keyword)
                
                // 필요 할 시 뷰가 사용할 모델로 가공
                books = response
                await presenter?.presentSearchResult(data: books)
                
                isLoading = false
            } catch {
                isLoading = false
                // 실패 알림
            }
        }
    }
    
    func didSelectBook(_ book: BookSummary) {
        router?.attachBookDetail(with: book.isbn13)
    }
    
    func loadNextPageIfNeeded() {
        // 현재 로딩중이면 로직을 수행하지 않음
        guard !isLoading else {
            return
        }
        
        isLoading = true
        // task cancel까지 구현하자 --> 로드 중에 다시 서칭한다거나 하는
        Task {
            do {
                let response = try await usecases.searchBookUsecase.loadNextPages()
                
                books.append(contentsOf: response)
                await presenter?.presentSearchResult(data: books)
                isLoading = false
            } catch {
                isLoading = false
                // 실패 알림
            }
        }
    }
}
