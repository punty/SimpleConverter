//
//  Vertex.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 10/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation

public func == <T: Equatable>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    return lhs.index == rhs.index && lhs.data == rhs.data
}

public struct Vertex<T>: Equatable where T: Equatable, T: Hashable {
    public var data: T
    public let index: Int
}

extension Vertex: Hashable {
    public var hashValue: Int {
        get {
            return "\(data)\(index)".hashValue
        }
    }
}
