//
//  ConversionService.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 11/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation
import SimpleNetworking

protocol ConversionServiceProtocol {
    func conversionData(completion: @escaping (ConversionData?) -> Void)
}

//here I should use API to get the latest conversion
final class ConversionService: ConversionServiceProtocol {
    
    let serviceClient: ServiceClient
    
    init(serviceClient: ServiceClient) {
        self.serviceClient = serviceClient
    }
    
    func conversionData(completion: @escaping (ConversionData?) -> Void) {
        serviceClient.get(api: Router.conversions) {
            (data: ConversionData?, error:Error?) in
            completion(data)
        }
    }
    
}
