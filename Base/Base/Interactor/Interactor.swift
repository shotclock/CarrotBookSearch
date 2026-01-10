//
//  Interactor.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

open class Interactor<Presenter>: Interactable {
    public var presenter: Presenter?
    
    public init(presenter: Presenter? = nil) {
        self.presenter = presenter
    }
    
    open func attached() {
        
    }
    
    open func detached() {
        presenter = nil
    }
}
