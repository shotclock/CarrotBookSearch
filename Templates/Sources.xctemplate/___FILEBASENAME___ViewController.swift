//___FILEHEADER___

import UIKit
import Base

// 뷰 컨트롤러 -> 뷰모델
protocol ___FILEBASENAMEASIDENTIFIER___Listener: AnyObject {
    
}

final class ___FILEBASENAMEASIDENTIFIER___: UIViewController, ___VARIABLE_productName:identifier___ViewControllable, ___VARIABLE_productName:identifier___ViewControllerPresentable {
    // MARK: Definition
    
    // MARK: Properties
    weak var listener: ___FILEBASENAMEASIDENTIFIER___Listener?

    // MARK: initializer
    deinit {
        print(#fileID, #line, #function)
    }
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: UI setting
    private func setupUI() {
        
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
}

