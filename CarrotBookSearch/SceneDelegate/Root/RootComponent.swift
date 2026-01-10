//
//  RootComponent.swift
//  CarrotBookSearch
//
//  Created by 이상호 on 1/10/26.
//

import Base
import BookList
import Domain
import DomainInterface

public final class EmptyDependency: Dependency {
    
}

public final class RootComponent: Component<EmptyDependency> {
    var bookListBuilder: BookListBuilder {
        .init(dependency: self)
    }
    
    init() {
        super.init(dependency: .init())
    }
}

extension RootComponent: BookListDependency {
    public var searchBookUsecase: SearchBookUsecase {
        DefaultSearchBookUsecase(repository: DefaultBookRepository())
    }
}
