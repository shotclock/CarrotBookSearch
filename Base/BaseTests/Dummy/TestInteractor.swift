//
//  TestInteractor.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

import Base

final class TestInteractor: Interactable {
    var attachedCalled = false
    var detachedCalled = false

    func attached() { attachedCalled = true }
    func detached() { detachedCalled = true }
}
