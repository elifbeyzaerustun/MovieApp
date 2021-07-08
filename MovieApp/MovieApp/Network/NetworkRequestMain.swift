//
//  NetworkRequestMain.swift
//  MovieApp
//
//  Created by Elif Erustun on 6.07.2021.
//

import Foundation

class NetworkRequestMain {
    
    // MARK: Main network request functions
    static func postAction<T:Decodable>(_ requestModel: RequestModel,
                                        _ modelType: T.Type,
                                        completion: @escaping (Result<T, NetworkError>) -> Void) {
        let session = URLSession.shared
        var serviceUrl = URLComponents(string: requestModel.url.description)
        serviceUrl?.queryItems =  requestModel.querryItems
        guard let componentURL = serviceUrl?.url else { return }
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.typeObj.rawValue
        request.allHTTPHeaderFields =  requestModel.httpHeaderField
        
        if let parameterDictionary = requestModel.httpBody  {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch {
                    // type of failure
                    completion(.failure(.decodingError))
                    print(error)
                }
            }
        }.resume()
    }
}
