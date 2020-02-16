//
//  File.swift
//  
//
//  Created by Steve Bryce on 16/02/2020.
//

import Foundation

public struct EmailAddress {
    let address: String
    let name: String?

    public init(address: String, name: String? = nil) {
        self.address = address
        self.name = name
    }
}
