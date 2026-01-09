//
//  BookListBuilder.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Foundation
import BookListInterface
import Base

public final class BookListBuilder: BookListBuildable {
    private let component: BookListComponent
    
    public init(component: BookListComponent) {
        self.component = component
    }
    
    public func build(withListener listener: BookListListener?) -> ViewableRoutable {
        let viewController = BookListViewController()
        let interactor = BookListInteractor(presenter: viewController)
        interactor.listener = listener
        
        return BookListRouter(
            interactor: interactor,
            viewControllable: viewController
        )
    }
}
