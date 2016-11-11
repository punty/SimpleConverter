//
//  Conversion.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 10/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation
import GraphKit
import SimpleNetworking

private struct Conversion: JSONInitializable {
    var from: String
    var to: String
    var rate: Double
    
    init(json: [String : Any]) throws {
        
        guard let from = json["from"] as? String else {throw ServiceError.missing("from")}
        guard let to = json["to"] as? String else {throw ServiceError.missing("to")}
        guard let rate = json["rate"] as? Double else {throw ServiceError.missing("rate")}
        
        self.from = from
        self.rate = rate
        self.to = to
    }
}

struct ConversionData: JSONInitializable {
    
    private let conversions: [Conversion]
    
    let graphView: Graph<String>
    
    init(json: [String : Any]) throws {
        guard let conversionsJson = json["conversions"] as? [[String:Any]] else {
            throw ServiceError.missing("conversions")
        }
        
        conversions = conversionsJson.flatMap {try? Conversion (json: $0)}
        graphView = Graph<String>()
        
        for conversion in self.conversions {
            graphView.createVertex(data: conversion.from)
            graphView.createVertex(data: conversion.to)
            try! graphView.addDirectedEdge(from: conversion.from, to: conversion.to, withWeight: conversion.rate)
            try! graphView.addDirectedEdge(from: conversion.to, to: conversion.from, withWeight: 1.0 / conversion.rate)
        }
    }
}
