//
//  RootBuilder.swift
//  CarrotBookSearch
//
//  Created by 이상호 on 1/10/26.
//

import Foundation
import Base

public final class RootBuilder {
    private let component: RootComponent
    
    public init(component: RootComponent) {
        self.component = component
    }
    
    public func build() -> LaunchRoutable {
        let interactor = RootInteractor()
        
        return RootRouter(interactor: interactor)
    }
}
