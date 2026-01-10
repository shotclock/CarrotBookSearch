//
//  BookListInteractor.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Foundation
import Base
import BookListInterface

// 뷰모델 -> 라우터
protocol BookListRoutable: Routable {
    func attachBookDetail(with data: DummyBook)
    func detachBookDetail()
}

// 뷰모델 -> 뷰 컨트롤러
protocol BookListViewControllerPresentable: AnyObject {
    var listener: BookListViewControllerListener? { get set }
}

final class BookListInteractor: Interactor<BookListViewControllerPresentable>, BookListInteractable {
    weak var router: BookListRoutable?
    weak var listener: BookListListener?
    
    override init(presenter: BookListViewControllerPresentable?) {
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
        print("키워드 \(keyword)")
    }
    
    func didSelectBook(_ book: DummyBook) {
        router?.attachBookDetail(with: book)
    }
}
