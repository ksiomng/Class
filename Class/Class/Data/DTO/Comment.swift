//
//  Comment.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import Foundation

struct Comment: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: User
    
    enum CodingKeys: String, CodingKey {
        case content, creator
        case commentId = "comment_id"
        case createdAt = "created_at"
    }
}

struct Comments: Decodable {
    let data: [Comment]
}

struct EmptyResponse: Decodable {}
