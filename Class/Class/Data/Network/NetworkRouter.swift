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
    case seasrch(keyword: String)
    case detail(id: String)
    case comment(id: String)
    case writeComment(id: String, content: String)
    case editComment(id: String, commentId: String, content: String)
    case deleteComment(id: String, commentId: String)
    
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
        case .seasrch(_):
            return URL(string: "\(baseURL)\(APIURL.searchURL)")!
        case .detail(let id):
            return URL(string: "\(baseURL)\(APIURL.detailURL(id: id))")!
        case .comment(let id):
            return URL(string: "\(baseURL)\(APIURL.commnet(id: id))")!
        case .writeComment(let id, _):
            return URL(string: "\(baseURL)\(APIURL.commnet(id: id))")!
        case .editComment(let id, let commentId, _):
            return URL(string: "\(baseURL)\(APIURL.editComment(id: id, commentId: commentId))")!
        case .deleteComment(let id, let commentId):
            return URL(string: "\(baseURL)\(APIURL.editComment(id: id, commentId: commentId))")!
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
        case .seasrch(let keyword):
            return ["title": keyword]
        case .detail(_):
            return nil
        case .comment(_):
            return nil
        case .writeComment(_, let content):
            return ["content": content]
        case .editComment(_, _, let content):
            return ["content": content]
        case .deleteComment(_, _):
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
        case .like(_, _):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        case .seasrch(_):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        case .detail(_):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        case .comment(_):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        case .writeComment(_, _):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        case .editComment(_, _, _):
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.key)",
                    "Authorization": UserDefaultsHelper.shared.token!]
        case .deleteComment(_, _):
            return ["SesacKey": "\(APIKey.key)",
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
        case .seasrch(_):
            return URLEncoding.default
        case .detail(_):
            return URLEncoding.default
        case .comment(_):
            return URLEncoding.default
        case .writeComment(_, _):
            return JSONEncoding.default
        case .editComment(_, _, _):
            return JSONEncoding.default
        case .deleteComment(_, _):
            return URLEncoding.default
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
        case .seasrch(_):
            return .get
        case .detail(_):
            return .get
        case .comment(_):
            return .get
        case .writeComment(_, _):
            return .post
        case .editComment(_, _, _):
            return .put
        case .deleteComment(_, _):
            return .delete
        }
    }
}
