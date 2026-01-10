//
//  RootComponent.swift
//  CarrotBookSearch
//
//  Created by 이상호 on 1/10/26.
//

import Base

public final class EmptyDependency: Dependency {
    
}

public final class RootComponent: Component<EmptyDependency> {
    init() {
        super.init(dependency: .init())
    }
}
