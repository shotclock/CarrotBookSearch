//
//  Interactable.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

public protocol Interactable: AnyObject {
    /// router가 attach된 경우 호출됨
    func attached()
    /// router가 detach된 경우 호출됨
    func detached()
}
