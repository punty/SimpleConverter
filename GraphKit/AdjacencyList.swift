//
//  AdjacencyList.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 10/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation

public class AdjacencyList<T> where T: Equatable, T: Hashable {
    
    public var vertex: Vertex<T>
    public lazy var edges: Set<Edge<T>> = Set<Edge<T>> ()
    
    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    
    func add(edge: Edge<T>) {
        edges.insert(edge)
    }
}
