//
//  BookListInteractor.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Foundation
import Base
import ListInterface

// 뷰모델 -> 라우터
protocol BookListRoutable: Routable {
    func detach(_ router: Routable)
}

// 뷰모델 -> 뷰 컨트롤러
protocol BookListViewControllerPresentable: AnyObject {
    var listener: BookListViewControllerListener? { get set }
}

final class BookListInteractor: Interactor<BookListViewControllerPresentable>, BookListInteractable, BookListViewControllerListener {
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
