//
//  Graph.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 10/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation

internal struct Pair {
    let index: Int
    var distance: Double
}

public enum GraphKitError: Error {
    case VertexNotFoundInGraph
}

public class Graph<T> where T:Hashable {
    public lazy var edgesList: [AdjacencyList<T>] = [AdjacencyList<T>] ()
    
    //return the vertext corresponding to the data
    internal func vertex(data: T) -> Vertex<T>? {
        let dataMathcing = edgesList.map {$0.vertex}.filter {$0.data ==  data}
        return dataMathcing.first
    }
    
    public init () {
        //nothing to do
    }
    
    public func vertexes () -> [T] {
        return edgesList.map {$0.vertex.data}
    }
    
    //create a vertex with our data
    public func createVertex(data: T) {
        let dataMathcing = edgesList.map {$0.vertex}.filter {$0.data ==  data}
        if (dataMathcing.count == 0) {
            let vertex = Vertex(data: data, index: edgesList.count)
            edgesList.append(AdjacencyList(vertex: vertex))
        }
    }
    
    //Add an edge between two nodes and define the weight
    public func addDirectedEdge(from: T, to: T, withWeight weight: Double) throws {
        guard let vertexFrom = vertex(data: from), let vertexTo = vertex(data: to) else {
            throw GraphKitError.VertexNotFoundInGraph
        }
        let edge = Edge(from: vertexFrom, to: vertexTo, weight: weight)
        let edgeList = edgesList[vertexFrom.index]
        print("\(edge.from.data) -> \(edge.to.data) \(edge.weight)")
        edgeList.add(edge:edge)
    }
    
    //return an array containing the shortest paths to the node
    public func shortestPahts(from: T) throws -> [Double] {
        guard let vertexFrom = vertex(data: from) else {
            throw GraphKitError.VertexNotFoundInGraph
        }
         let vertexArray = edgesList.map {$0.vertex}
         var distances = Array(repeating: Double.infinity, count: vertexArray.count)
         distances[vertexFrom.index] = 0
        for _ in 1..<vertexArray.count {
            for item in edgesList {
                for edge in item.edges {
                    let fromIndex = edge.from.index
                    let toIndex = edge.to.index
                    let weight = edge.weight
                    let c = distances[fromIndex] + weight
                    if (distances[fromIndex] != Double.infinity && c < distances[toIndex]) {
                        distances[toIndex] = c
                    }
                }
            }
        }
        return distances
    }
    
    //return the shortest path to a specific one
    public func shortestPath(from:T, to:T) throws -> Double {
        let paths = try shortestPahts(from: from)
        guard let vertexTo = vertex(data: to) else {
            throw GraphKitError.VertexNotFoundInGraph
        }
        return paths[vertexTo.index]
    }
}
