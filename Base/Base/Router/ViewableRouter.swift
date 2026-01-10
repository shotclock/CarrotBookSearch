//
//  ViewableRouter.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

import UIKit

open class ViewableRouter<InteractorType, ViewControllable>: ViewableRoutable {
    public var interactorType: InteractorType
    public var navigationController: UINavigationController?
    public var childRouters: [any Routable] = []
    
    public var interactor: Interactable? {
        interactorType as? Interactable
    }
    
    public var viewController: UIViewController
    open var viewControllable: ViewControllable? {
        viewController as? ViewControllable
    }
    
    public init(interactor: InteractorType,
                viewControllable: UIViewController,
                navigationController: UINavigationController? = nil) {
        self.viewController = viewControllable
        self.navigationController = navigationController
        self.interactorType = interactor
    }
    
    deinit {
        interactor?.detached()
    }
}
