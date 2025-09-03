//
//  NetworkRouter.swift
//  Class
//
//  Created by Song Kim on 9/3/25.
//

import UIKit
import Alamofire

enum NetworkRouter {
    case login(email: String, password: String)
    
    var baseURL: String {
        APIURL.baseURL
    }
    
    var endPoint: URL {
        switch self {
        case .login(let email, let password):
            return URL(string: "\(baseURL)\(APIURL.loginURL)")!
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .login(let email, let password):
            return ["email": email,
                    "password": password]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login(let email, let password):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)"]
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
}
