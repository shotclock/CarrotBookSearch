//
//  BookListBuilder.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Foundation
import BookListInterface
import Base
import UIKit

public final class BookListBuilder: BookListBuildable {
    private let component: BookListComponent
    
    public init(dependency: BookListDependency) {
        self.component = .init(dependency: dependency)
    }
    
    public func build(withListener listener: BookListListener?) -> ViewableRoutable {
        let viewController = BookListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let interactor = BookListInteractor(presenter: viewController)
        interactor.listener = listener
        
        return BookListRouter(
            interactor: interactor,
            viewControllable: viewController,
            navigationController: navigationController,
            bookDetailBuilder: component.bookDetailBuilder
        )
    }
}
