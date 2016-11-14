//
//  Mocks.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 14/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation
@testable import SimpleConverter

class ServiceMock : ConversionServiceProtocol {
    func conversionData(completion: @escaping (ConversionData?) -> Void) {
        //read from String
        let path = Bundle(for: type(of: self)).path(forResource: "currency", ofType: "json")
        let jsonURL = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: jsonURL)
        guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        completion(try! ConversionData(json: json))
        
    }
}
