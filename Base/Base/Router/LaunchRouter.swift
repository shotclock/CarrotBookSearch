//
//  LaunchRouter.swift
//  Base
//
//  Created by 이상호 on 1/10/26.
//

import UIKit

public protocol LaunchRoutable: ViewableRoutable {
    func launch() -> UIViewController
    func launch(from window: UIWindow?)
}

public extension LaunchRoutable {
    func launch() -> UIViewController {
        interactor?.attached()
        
        return viewController
    }
    
    func launch(from window: UIWindow?) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

open class LaunchRouter<InteractorType, ViewControllable>: LaunchRoutable {
    public var intereactorType: InteractorType
    public var navigationController: UINavigationController?
    public var childRouters: [any Routable] = []
    
    public var interactor: (any Interactable)? {
        intereactorType as? Interactable
    }
    
    public var viewController: UIViewController
    open var viewControllable: ViewControllable? {
        viewController as? ViewControllable
    }
    
    public init(interactor: InteractorType,
                viewControllable: UIViewController,
                navigationController: UINavigationController? = nil) {
        self.viewController = UINavigationController(rootViewController: viewControllable)
        self.navigationController = navigationController
        self.intereactorType = interactor
    }
}
