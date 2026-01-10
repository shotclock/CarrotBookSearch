//
//  NavigationPopObserver.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import UIKit

protocol NavigationPopDelegate: AnyObject {
    func didPopViewController(_ viewController: UIViewController)
}

final class NavigationPopObserver: NSObject,
                                   UINavigationControllerDelegate {
    
    weak var delegate: NavigationPopDelegate?
    private weak var fromViewController: UIViewController?
    
    init(toObserve: UINavigationController) {
        super.init()
        
        toObserve.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard let coordinator = navigationController.transitionCoordinator else { return }

        // 지금 화면 전환의 "from"이 뭔지 저장
        fromViewController = coordinator.viewController(forKey: .from)
        
        coordinator.animate(alongsideTransition: nil) { [weak self] context in
            // 스와이프 취소된 경우에는 진행하지 않는다.
            guard context.isCancelled == false else {
                return
            }
            
            if let fromViewController = self?.fromViewController,
               navigationController.viewControllers.contains(fromViewController) == false {
                self?.delegate?.didPopViewController(fromViewController)
            }
        }
    }
}
