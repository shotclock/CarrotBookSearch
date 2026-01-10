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
    
    public init(dependency: BookDetailDependency) {
        self.component = .init(dependency: dependency)
    }
    
    public func build(withListener listener: BookDetailListener?,
                      isbn13: String) -> ViewableRoutable {
        let viewController = BookDetailViewController()
        let interactor = BookDetailInteractor(presenter: viewController,
                                              isbn13: isbn13)
        interactor.listener = listener
        
        return BookDetailRouter(
            interactor: interactor,
            viewControllable: viewController
        )
    }
}
