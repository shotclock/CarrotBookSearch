//
//  BookDetailInteractor.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import Foundation
import Base

// 뷰모델 -> 라우터
protocol BookDetailRoutable: Routable {
    func routeToExternalURL(_ url: URL)
}

// 뷰모델 -> 뷰 컨트롤러
protocol BookDetailViewControllerPresentable: AnyObject {
    var listener: BookDetailViewControllerListener? { get set }
}

final class BookDetailInteractor: Interactor<BookDetailViewControllerPresentable>, BookDetailInteractable {
    weak var router: BookDetailRoutable?
    weak var listener: BookDetailListener?
    
    private let isbn13: String
    
    init(presenter: BookDetailViewControllerPresentable?,
         isbn13: String) {
        self.isbn13 = isbn13
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

extension BookDetailInteractor: BookDetailViewControllerListener {
    func didTapOpenLinkButton(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        router?.routeToExternalURL(url)
    }
}
