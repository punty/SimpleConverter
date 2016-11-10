//
//  SimpleNetworking.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 09/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation

//Something that can become use as URLRequest
public protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest?
}

//Describe network parsing and serialising error
public enum ServiceError: Error {
    case jsonCreationError
    case parsingError
    case networkError
    case missing(String)
    case invalid(String, Any)
}

//Describes anything that can be initialised from a json dictionary
public protocol JSONInitializable {
    init (json: [String:Any]) throws
}

public protocol ServiceClientType {
    func get<T:JSONInitializable>(api: URLRequestConvertible, completion:@escaping (T?,Error?)->())
}

//Simple class used to get json from the network, parse and return the parsed object or the generated error
//I am using generic so this class will return any JSONInitializable in this way I can improve code reuse
public final class ServiceClient: ServiceClientType {
    
    public init() {
        //nothing to do
    }
    
    internal static func handleSession<T:JSONInitializable>(data: Data?, response: URLResponse?, error: Error?, completion:@escaping (T?,Error?)->()) {
        if let networkError = error {
            completion(nil, networkError)
            return
        }
        guard let jsonData = data else {
            completion(nil, ServiceError.jsonCreationError)
            return
        }
        do {
            guard let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else { completion(nil, ServiceError.jsonCreationError)
                return
            }
            let obj = try T(json:json)
            completion(obj, nil)

        } catch (let error) {
            completion(nil, error)
        }
    }
    
    public func get<T:JSONInitializable>(api: URLRequestConvertible, completion:@escaping (T?,Error?)->()) {
        guard let request = api.asURLRequest() else {completion(nil, ServiceError.networkError)
            return
        }
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            ServiceClient.handleSession(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
}
