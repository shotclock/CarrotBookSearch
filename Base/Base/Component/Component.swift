//
//  Component.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

import Foundation

open class Component<DependencyType> {
    public let dependency: DependencyType
    
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
