//
//  ServiceTests.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 14/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//


import XCTest

@testable import SimpleConverter

//it would be easy to write tests
class ServiceTests: XCTestCase {
    
    func testJSONParsing() {
        let path = Bundle(for: type(of: self)).path(forResource: "currencyFull", ofType: "json")
        let jsonURL = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: jsonURL)
        guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        
        let conversions = try! ConversionData(json: json)
        XCTAssert(conversions.currencies.count == 7, "Wrong Currency count")
        //then do other tests
    }
}
