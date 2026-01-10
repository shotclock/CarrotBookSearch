//
//  BookDetailRouter.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import UIKit
import Base

// 라우터 -> 뷰모델
// 하위 뷰모델의 리스너 conform
protocol BookDetailInteractable: Interactable {
    var router: BookDetailRoutable? { get set }
    var listener: BookDetailListener? { get set }
}

// 라우터 -> 뷰컨트롤러
protocol BookDetailViewControllable: UIViewController {
    
}

final class BookDetailRouter: ViewableRouter<BookDetailInteractable, BookDetailViewControllable> {
    
    init(interactor: BookDetailInteractable,
         viewControllable: UIViewController) {
        super.init(interactor: interactor,
                   viewControllable: viewControllable)
        
        interactor.router = self
    }
}

extension BookDetailRouter: BookDetailRoutable {
    func routeToExternalURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
