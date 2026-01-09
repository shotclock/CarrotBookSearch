//
//  BookDetailBuilder.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import Foundation
import Base

public final class BookDetailBuilder: BookDetailBuildable {
    private let component: BookDetailComponent
    
    public init(component: BookDetailComponent) {
        self.component = component
    }
    
    public func build(withListener listener: BookDetailListener?) -> ViewableRoutable {
        let viewController = BookDetailViewController()
        let interactor = BookDetailInteractor(presenter: viewController)
        interactor.listener = listener
        
        return BookDetailRouter(
            interactor: interactor,
            viewControllable: viewController
        )
    }
}
