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
    func detach(_ router: Routable)
}

// 뷰모델 -> 뷰 컨트롤러
protocol BookDetailViewControllerPresentable: AnyObject {
    var listener: BookDetailViewControllerListener? { get set }
}

final class BookDetailInteractor: Interactor<BookDetailViewControllerPresentable>, BookDetailInteractable, BookDetailViewControllerListener {
    weak var router: BookDetailRoutable?
    weak var listener: BookDetailListener?
    
    override init(presenter: BookDetailViewControllerPresentable?) {
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
