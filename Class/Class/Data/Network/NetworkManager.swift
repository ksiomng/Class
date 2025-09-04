//
//  NetworkManager.swift
//  Class
//
//  Created by Song Kim on 9/3/25.
//

import UIKit
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T: Decodable>(api: NetworkRouter, type: T.Type, handler: @escaping ((Result<T, Error>) -> Void)) {
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.headers)
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                handler(.success(value))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
