//
//  Like.swift
//  Class
//
//  Created by Song Kim on 9/6/25.
//

import Foundation

struct Like: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
