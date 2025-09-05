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
    case loadClass
    
    var baseURL: String {
        APIURL.baseURL
    }
    
    var endPoint: URL {
        switch self {
        case .login(_, _):
            return URL(string: "\(baseURL)\(APIURL.loginURL)")!
        case .loadClass:
            return URL(string: "\(baseURL)\(APIURL.getClass)")!
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return ["email": email,
                    "password": password]
        case .loadClass:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login(_ , _):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)"]
        case .loadClass:
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default
        case .loadClass:
            return URLEncoding.default
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .loadClass:
            return .get
        }
    }
}
