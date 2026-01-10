//
//  BookListRouter.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import UIKit
import Base
import BookListInterface

// 라우터 -> 뷰모델
// 하위 뷰모델의 리스너 conform
protocol BookListInteractable: Interactable,
                               BookDetailListener {
    var router: BookListRoutable? { get set }
    var listener: BookListListener? { get set }
}

// 라우터 -> 뷰컨트롤러
protocol BookListViewControllable: UIViewController {
    func pushBookDetailViewController(_ viewController: UIViewController)
    func popToBookListController()
}

final class BookListRouter: ViewableRouter<BookListInteractable, BookListViewControllable> {
    
    private let navigationPopObserver: NavigationPopObserver
    private let bookDetailBuilder: BookDetailBuildable
    private var bookDetailRouter: ViewableRoutable?
    
    init(interactor: BookListInteractable,
         viewControllable: UIViewController,
         navigationController: UINavigationController,
         bookDetailBuilder: BookDetailBuildable) {
        self.bookDetailBuilder = bookDetailBuilder
        navigationPopObserver = .init(toObserve: navigationController)
        super.init(interactor: interactor,
                   viewControllable: viewControllable,
                   navigationController: navigationController)
        
        interactor.router = self
        navigationPopObserver.delegate = self
    }
}

extension BookListRouter: BookListRoutable {
    func attachBookDetail(with data: String) {
        guard bookDetailRouter == nil else {
            return
        }
        
        let router = bookDetailBuilder.build(withListener: interactorType,
                                             isbn13: data)
        
        do {
            try attachRouter(router)
            viewControllable?.pushBookDetailViewController(router.viewController)
            bookDetailRouter = router
        } catch {
            assertionFailure("attach 실패 \(#function) \(error.localizedDescription)")
        }
    }
    
    func detachBookDetail() {
        guard let bookDetailRouter else {
            return
        }
        
        do {
            try detachRouter(bookDetailRouter)
            viewControllable?.popToBookListController()
            self.bookDetailRouter = nil
        } catch {
            assertionFailure("detach 실패 \(#function) \(error.localizedDescription)")
        }
    }
}

extension BookListRouter: NavigationPopDelegate {
    func didPopViewController(_ viewController: UIViewController) {
        if viewController === bookDetailRouter?.viewController {
            detachBookDetail()
        }
    }
}
