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
    
    func callRequest<T: Decodable>(api: NetworkRouter, type: T.Type, handler: @escaping ((Result<T, APIError>) -> Void)) {
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.headers)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    handler(.success(value))
                } catch {
                    if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        handler(.failure(apiError))
                    } else {
                        handler(.failure(APIError(message: error.localizedDescription)))
                    }
                }
            case .failure(_):
                handler(.failure(APIError(message: "네트워크 연결에 실패했습니다")))
            }
        }
    }
    
    func callImage(api: NetworkRouter, handler: @escaping (Result<UIImage, APIError>) -> Void) {
            guard case .image = api else { return }

            AF.request(api.endPoint,
                       method: api.method,
                       headers: api.headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        handler(.success(image))
                    } else {
                        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            handler(.failure(apiError))
                        } else {
                            handler(.failure(APIError(message: "이미지 변환 실패")))
                        }
                    }
                case .failure:
                    handler(.failure(APIError(message: "네트워크 연결에 실패했습니다")))
                }
            }
        }
}
