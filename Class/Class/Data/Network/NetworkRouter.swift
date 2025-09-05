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
    case like(id: String, status: Bool)
    
    var baseURL: String {
        APIURL.baseURL
    }
    
    var endPoint: URL {
        switch self {
        case .login(_, _):
            return URL(string: "\(baseURL)\(APIURL.loginURL)")!
        case .loadClass:
            return URL(string: "\(baseURL)\(APIURL.getClassURL)")!
        case .like(let id, _):
            return URL(string: "\(baseURL)\(APIURL.likeURL(id: id))")!
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return ["email": email,
                    "password": password]
        case .loadClass:
            return nil
        case .like(_, let status):
            return ["like_status": status]
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
        case .like(_, _):
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
        case .like(_, _):
            return JSONEncoding.default
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .loadClass:
            return .get
        case .like(_, _):
            return .post
        }
    }
}
