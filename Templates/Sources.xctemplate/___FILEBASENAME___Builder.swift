//___FILEHEADER___

import Foundation
import ___VARIABLE_moduleName:identifier___Interface
import Base

public final class ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName:identifier___Buildable {
    private let component: ___VARIABLE_productName:identifier___Component
    
    public init(component: ___VARIABLE_productName:identifier___Component) {
        self.component = component
    }
    
    public func build(withListener listener: ___VARIABLE_productName:identifier___Listener?) -> ViewableRoutable {
        let viewController = ___VARIABLE_productName:identifier___ViewController()
        let interactor = ___VARIABLE_productName:identifier___Interactor(presenter: viewController)
        interactor.listener = listener
        
        return ___VARIABLE_productName:identifier___Router(
            interactor: interactor,
            viewControllable: viewController
        )
    }
}
