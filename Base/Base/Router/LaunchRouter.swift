//
//  LaunchRouter.swift
//  Base
//
//  Created by 이상호 on 1/10/26.
//

import UIKit

public protocol LaunchRoutable: Routable {
    var window: UIWindow? { get set }
    func launch(from window: UIWindow?)
}

public extension LaunchRoutable {
    func launch(from window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
        interactor?.attached()
    }
}

open class LaunchRouter<InteractorType>: LaunchRoutable {
    public var intereactorType: InteractorType
    public var childRouters: [any Routable] = []
    public var window: UIWindow?
    public var interactor: (any Interactable)? {
        intereactorType as? Interactable
    }
    
    public init(interactor: InteractorType) {
        self.intereactorType = interactor
    }
}
