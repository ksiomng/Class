//
//  Login.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

struct Login: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
}
