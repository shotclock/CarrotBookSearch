//
//  Array+Extension.swift
//  Base
//
//  Created by 이상호 on 1/10/26.
//

public extension Array {
    subscript(safe index: Int) -> Element? {
        get { indices.contains(index) ? self[index] : nil }
        set {
            guard let newValue,
                  indices.contains(index) else {
                return
            }
            
            self[index] = newValue
        }
    }
}
