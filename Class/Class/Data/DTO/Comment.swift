//
//  Comment.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import Foundation

struct Comment: Decodable {
    let comment_id: String
    let content: String
    let created_at: String
    let creator: User
}

struct Comments: Decodable {
    let data: [Comment]
}

struct EmptyResponse: Decodable {}
