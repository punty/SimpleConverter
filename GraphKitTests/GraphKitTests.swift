//
//  GraphKitTests.swift
//  GraphKitTests
//
//  Created by Francesco Puntillo on 10/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import XCTest

@testable import GraphKit

class GraphKitTests: XCTestCase {
    
    func testShortestPath() {
        let g = Graph<String>()
        g.createVertex(data: "EUR")
        g.createVertex(data: "CNY")
        g.createVertex(data: "JPY")
        g.createVertex(data: "USD")
        do {
            try g.addDirectedEdge(from: "EUR", to: "USD", withWeight: 1)
            try g.addDirectedEdge(from: "USD", to: "CNY", withWeight: 1)
            try g.addDirectedEdge(from: "CNY", to: "JPY", withWeight: 1)
            try g.addDirectedEdge(from: "EUR", to: "JPY", withWeight: 10)
            let d = try g.shortestPath(from: "EUR", to: "JPY")
            XCTAssert(d == 3.0, "testShortestPath Fail. The shortest path is: \(d) instad of: 1.0")
        } catch {
            XCTFail()
        }
    }
}
