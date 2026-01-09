//
//  Routable.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

import Foundation

public protocol Routable: AnyObject {
    /// 현재 본인의 영역에서 가지고 있는 다른 영역의 라우터를 담는 배열입니다.
    var childRouters: [any Routable] { get set }
    /// 해당 라우터가 attach / detach 되는 경우에 호출 해줄 메서드가 구현된 인터액터입니다.
    var interactor: Interactable? { get }
    /// 다른 영역의 라우터를 등록합니다.
    /// 이미 등록되어있는 경우라면 alreadyAttached 에러를 throw합니다.
    func attachRouter(_ router: any Routable) throws
    /// 등록된 하위 라우터를 제거합니다.
    /// 전달받은 라우터가 등록되어있지 않은경우 notAttached 에러를 throw 합니다.
    func detachRouter(_ router: any Routable) throws
}

public extension Routable {
    func attachRouter(_ router: any Routable) throws {
        guard !childRouters.contains(where: { $0 === router }) else {
            throw RouterError.alreadyAttached
        }
        
        childRouters.append(router)
        router.interactor?.attached()
    }
    
    func detachRouter(_ router: any Routable) throws {
        guard childRouters.contains(where: { $0 === router }) else {
            throw RouterError.notAttached
        }
        childRouters.removeAll(where: { $0 === router })
        router.interactor?.detached()
    }
}
 
public protocol ViewableRoutable: Routable {
    
}
