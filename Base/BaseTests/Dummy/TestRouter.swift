//
//  TestRouter.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

import Base

final class TestRouter: Routable {
    var childRouters: [any Routable] = []
    let interactor: Interactable?

    init(interactor: Interactable? = nil) {
        self.interactor = interactor
    }
}
