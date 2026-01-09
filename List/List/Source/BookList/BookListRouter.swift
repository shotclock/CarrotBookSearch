//
//  BookListRouter.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import UIKit
import Base
import ListInterface

// 라우터 -> 뷰모델
// 하위 뷰모델의 리스너 conform
protocol BookListInteractable: Interactable {
    var router: BookListRoutable? { get set }
    var listener: BookListListener? { get set }
}

// 라우터 -> 뷰컨트롤러
protocol BookListViewControllable: UIViewController {
    
}

final class BookListRouter: ViewableRouter<BookListInteractable, BookListViewControllable> {
    
    init(interactor: BookListInteractable,
         viewControllable: UIViewController) {
        super.init(interactor: interactor,
                   viewControllable: viewControllable)
        
        interactor.router = self
    }
}

extension BookListRouter: BookListRoutable {
    func detach(_ router: Routable) {
        
    }
}
