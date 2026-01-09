//___FILEHEADER___

import UIKit
import Base
import ___VARIABLE_moduleName:identifier___Interface

// 라우터 -> 뷰모델
// 하위 뷰모델의 리스너 conform
protocol ___VARIABLE_productName:identifier___Interactable: Interactable {
    var router: ___VARIABLE_productName:identifier___Routable? { get set }
    var listener: ___VARIABLE_productName:identifier___Listener? { get set }
}

// 라우터 -> 뷰컨트롤러
protocol ___VARIABLE_productName:identifier___ViewControllable: UIViewController {
    
}

final class ___FILEBASENAMEASIDENTIFIER___: ViewableRouter<___VARIABLE_productName:identifier___Interactable, ___VARIABLE_productName:identifier___ViewControllable> {
    
    init(interactor: ___VARIABLE_productName:identifier___Interactable,
         viewControllable: UIViewController) {
        super.init(interactor: interactor,
                   viewControllable: viewControllable)
        
        interactor.router = self
    }
}

extension ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName:identifier___Routable {
    func detach(_ router: Routable) {
        
    }
}
