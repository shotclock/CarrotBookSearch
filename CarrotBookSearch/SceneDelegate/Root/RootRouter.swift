//
//  RootRouter.swift
//  CarrotBookSearch
//
//  Created by 이상호 on 1/10/26.
//

import UIKit
import Base

// 라우터 -> 뷰모델
// 하위 뷰모델의 리스너 conform
protocol RootInteractable: Interactable {
    var router: RootRoutable? { get set }
}

// 라우터 -> 뷰컨트롤러
protocol RootViewControllable: UIViewController {
    
}

final class RootRouter: LaunchRouter<RootInteractable> {
    
    override init(interactor: RootInteractable) {
        super.init(interactor: interactor)
        
        interactor.router = self
    }
}

extension RootRouter: RootRoutable {
    func detach(_ router: Routable) {
        
    }
}
