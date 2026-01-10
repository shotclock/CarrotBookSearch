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
    
    func presentSearchResult(data: [BookSummary])
}

final class BookListInteractor: Interactor<BookListViewControllerPresentable>, BookListInteractable {
    struct Usecase {
        let searchBookUsecase: SearchBookUsecase
    }
    
    weak var router: BookListRoutable?
    weak var listener: BookListListener?
    
    private let usecases: Usecase
    
    init(presenter: BookListViewControllerPresentable?,
         usecases: Usecase) {
        self.usecases = usecases
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
        Task {
            let response = try await usecases.searchBookUsecase.execute(keyword: keyword)
            
            // 필요 할 시 뷰가 사용할 모델로 가공
            self.presenter?.presentSearchResult(data: response)
        }
    }
    
    func didSelectBook(_ book: BookSummary) {
        router?.attachBookDetail(with: book.isbn13)
    }
}
