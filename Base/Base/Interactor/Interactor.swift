//
//  Interactor.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

public class Interactor<Presenter>: Interactable {
    var presenter: Presenter?
    
    init(presenter: Presenter? = nil) {
        self.presenter = presenter
    }
    
    public func attached() {
        
    }
    
    public func detached() {
        presenter = nil
    }
}
