//
//  HTTPHeader.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

public struct HTTPHeader {
    public let name: String
    public let value: String
    
    public init(name: String,
                value: String) {
        self.name = name
        self.value = value
    }
}
