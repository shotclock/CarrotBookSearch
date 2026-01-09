//___FILEHEADER___

import Foundation
import Base
import ___VARIABLE_moduleName:identifier___Interface

// 뷰모델 -> 라우터
protocol ___VARIABLE_productName:identifier___Routable: Routable {
    func detach(_ router: Routable)
}

// 뷰모델 -> 뷰 컨트롤러
protocol ___VARIABLE_productName:identifier___ViewControllerPresentable: AnyObject {
    var listener: ___VARIABLE_productName:identifier___ViewControllerListener? { get set }
}

final class ___FILEBASENAMEASIDENTIFIER___: Interactor<___VARIABLE_productName:identifier___ViewControllerPresentable>, ___VARIABLE_productName:identifier___Interactable, ___VARIABLE_productName:identifier___ViewControllerListener {
    weak var router: ___VARIABLE_productName:identifier___Routable?
    weak var listener: ___VARIABLE_productName:identifier___Listener?
    
    override init(presenter: ___VARIABLE_productName:identifier___ViewControllerPresentable?) {
        super.init(presenter: presenter)
        
        presenter?.listener = self
    }
    
    override func attached() {
        super.attached()
    }
    
    override func detached() {
        super.detached()
    }
}
