//
//  RootRouter.swift
//  CarrotBookSearch
//
//  Created by 이상호 on 1/10/26.
//

import UIKit
import Base
import BookListInterface

// 라우터 -> 뷰모델
// 하위 뷰모델의 리스너 conform
protocol RootInteractable: Interactable,
                           BookListListener {
    var router: RootRoutable? { get set }
}

// 라우터 -> 뷰컨트롤러
protocol RootViewControllable: UIViewController {
    
}

final class RootRouter: LaunchRouter<RootInteractable> {
    
    private let bookListBuilder: BookListBuildable
    private var bookListRouter: ViewableRoutable?
    
    init(interactor: RootInteractable,
         bookListBuilder: BookListBuildable) {
        self.bookListBuilder = bookListBuilder
        
        super.init(interactor: interactor)
        
        interactor.router = self
    }
}

extension RootRouter: RootRoutable {
    func attachBookList() {
        guard bookListRouter == nil else {
            return
        }
        
        let router = bookListBuilder.build(withListener: intereactorType)
        
        do {
            try attachRouter(router)
            window?.rootViewController = router.navigationController
            bookListRouter = router
        } catch {
            assertionFailure("attach 실패 \(#function) \(error.localizedDescription)")
        }
    }
}
