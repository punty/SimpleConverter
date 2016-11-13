//
//  SimpleConverterAPIs.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 11/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation
import SimpleNetworking


enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://raw.githubusercontent.com/mydrive/code-tests/master/iOS-currency-exchange-rates/"
    
    case conversions
    
    func asURLRequest() throws -> URLRequest {
        //set path and parameter for all the API calls
        let result: (path: String, parameters: [String:String]?) = {
            switch self {
                //Here we can support multiple APIs for this quick example test
                //we just include a single one
            case .conversions:
                return ("rates.json", nil)
            }
        }()
        
        let path = Router.baseURLString + result.path
        
        //we don't use it but we can also add some parameters this way
        guard let urlComponent = NSURLComponents(string: path) else {
            throw ServiceError.networkError
        }
        
        var queries:[URLQueryItem] = []
        result.parameters?.forEach() {
            item in
            queries.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponent.queryItems = queries
        
        guard let reqURL = urlComponent.url else {
             throw ServiceError.networkError
        }
        
        let request = URLRequest(url: reqURL)
        return request
    }
}
