//
//  RouterTests.swift
//  BaseTests
//
//  Created by 이상호 on 1/9/26.
//

import Testing
@testable import Base

struct RouterTests {
    
    @Test("기존 하이어라키에 없는 라우터를 attach 할 경우에 성공한다.")
    func attachRouter_success() async throws {
        let interactor = TestInteractor()
        let parent = TestRouter()
        let child = TestRouter(interactor: interactor)
        
        try parent.attachRouter(child)
        
        #expect(parent.childRouters.count == 1)
        #expect(interactor.attachedCalled)
    }
    
    @Test("기존에 자식으로 등록된 라우터를 detach 할 경우에 성공한다.")
    func detachRouter_success() throws {
        let interactor = TestInteractor()
        let parent = TestRouter()
        let child = TestRouter(interactor: interactor)
        
        try parent.attachRouter(child)
        try parent.detachRouter(child)
        
        #expect(parent.childRouters.isEmpty)
        #expect(interactor.detachedCalled)
    }
    
    @Test("기존 하이어라키에 있는 라우터를 attach 할 경우에 RouterError.alreadyAttached 에러를 throw한다.")
    func attachRouter_Failure() async throws {
        let interactor = TestInteractor()
        let parent = TestRouter()
        let child = TestRouter(interactor: interactor)
        
        try parent.attachRouter(child)
        
        #expect(throws: RouterError.alreadyAttached, performing: {
            try parent.attachRouter(child)
        })
        #expect(parent.childRouters.count == 1)
    }
    
    @Test("기존 자식에 없는 라우터를 detach 할 경우에 RouterError.notAttached 에러를 throw한다.")
    func detachRouter_Failure() async throws {
        let interactor = TestInteractor()
        let parent = TestRouter()
        let child = TestRouter(interactor: interactor)
        
        #expect(throws: RouterError.notAttached, performing: {
            try parent.detachRouter(child)
        })
        #expect(parent.childRouters.isEmpty)
        #expect(interactor.detachedCalled == false)
    }
}
