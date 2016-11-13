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
    internal lazy var edgesList: [AdjacencyList<T>] = [AdjacencyList<T>] ()
    
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
        edgeList.add(edge:edge)
    }
    
    //return an array containing the shortest paths to the node
    public func shortestPahts(from: T) throws -> [Double] {
        guard let vertexFrom = vertex(data: from) else {
            throw GraphKitError.VertexNotFoundInGraph
        }
        
        var callBacks = CFBinaryHeapCallBacks()
        callBacks.compare = { (first,second , _) in
            guard let firstPointer = first, let secondPointer = second else {
                fatalError("I want this to crash, how can we compare two non existing things?")
            }
            let firstPair = firstPointer.assumingMemoryBound(to: Pair.self).pointee
            let secondPair = secondPointer.assumingMemoryBound(to: Pair.self).pointee
            if (firstPair.distance == secondPair.distance) {
                if (firstPair.index == secondPair.index) {
                    return CFComparisonResult.compareEqualTo
                }
                if (firstPair.index > secondPair.index) {
                    return CFComparisonResult.compareGreaterThan
                }
                return CFComparisonResult.compareLessThan
            }
            if (firstPair.distance > secondPair.distance) {
                return CFComparisonResult.compareGreaterThan
            }
            return CFComparisonResult.compareLessThan
        }
        
        let pq = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callBacks, nil)
        let vertexes = edgesList.map {$0.vertex}
        var distances = Array(repeating: Double.infinity, count: vertexes.count)
        //lets assume from index 0
        distances[vertexFrom.index] = 0
        
        var first = Pair(index: 0, distance: 0)
        CFBinaryHeapAddValue(pq, &first)
        while CFBinaryHeapGetCount(pq) > 0 {
            let pair = CFBinaryHeapGetMinimum(pq).assumingMemoryBound(to: Pair.self).pointee
            CFBinaryHeapRemoveMinimumValue(pq)
            for edge in edgesList[pair.index].edges {
                //get current distance
                let c = distances [edge.to.index]
                if (c > distances[pair.index] + edge.weight) {
                    //we found a shorter path
                    let shorterDistance = distances[pair.index] + edge.weight
                    distances[edge.to.index] = distances[pair.index] + edge.weight
                    var p = Pair(index: edge.to.index, distance: shorterDistance)
                    CFBinaryHeapAddValue(pq, &p)
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
