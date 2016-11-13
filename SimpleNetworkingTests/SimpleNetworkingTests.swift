//
//  SimpleNetworkingTests.swift
//  SimpleNetworkingTests
//
//  Created by Francesco Puntillo on 12/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import XCTest

@testable import SimpleNetworking


class SimpleNetworkingTests: XCTestCase {
    
    class HelloTest: JSONInitializable {
        var hello:[String]
        required init(json: [String : Any]) throws {
            guard let h = json["Hello"] as? [String] else {
                throw ServiceError.missing("hello")
            }
            hello = h
        }
    }
    
    func testParsing() {
        let jsonString = "{\"success\":true,\"Hello\":[\"hi\",\"ciao\"]}"
        let data = jsonString.data(using: .utf8)
        ServiceClient.handleSession(data: data, response: nil, error: nil) { (t: HelloTest?, nil) in
            XCTAssert(t?.hello.count == 2)
            XCTAssert(t?.hello[0] == "hi")
        }
    }
    
}
