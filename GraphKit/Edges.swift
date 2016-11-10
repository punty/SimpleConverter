//
//  Edges.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 10/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation

public func == <T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to && lhs.weight == rhs.weight
}

public struct Edge<T>: Equatable where T: Equatable, T: Hashable {
    let from: Vertex<T>
    let to: Vertex<T>
    let weight: Double
}

extension Edge : Hashable {
    public var hashValue: Int {
        return "\(from.index)\(to.index)\(weight)".hashValue
    }
}
