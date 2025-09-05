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
    
    func callImage(imagePath: String,
                   handler: @escaping (Result<UIImage, Error>) -> Void) {
        
        let imageURL = URL(string: "\(APIURL.baseURL)/v1\(imagePath)")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "SesacKey": "\(APIKey.key)",
            "Authorization": UserDefaultsHelper.shared.token!
        ]
        
        AF.request(imageURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        handler(.success(image))
                    }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
    }
}
