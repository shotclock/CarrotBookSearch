//
//  RootInteractor.swift
//  CarrotBookSearch
//
//  Created by 이상호 on 1/10/26.
//

import Foundation
import Base

// 뷰모델 -> 라우터
protocol RootRoutable: Routable {
    func attachBookList()
}

final class RootInteractor: Interactor<Any?>,
                            RootInteractable {
    weak var router: RootRoutable?
    
    init() {
        super.init(presenter: nil)
    }
    
    override func attached() {
        super.attached()
        
        router?.attachBookList()
    }
    
    override func detached() {
        super.detached()
    }
}
