//
//  ClassInfo.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import Foundation

struct ClassInfoResponse: Decodable {
    let data: [ClassInfo]
}

struct ClassInfo: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let imageUrl: String
    let createdAt: String
    let isLiked: Bool
    let creator: User
    
    enum CodingKeys: String, CodingKey {
        case category, title, description, price, creator
        case classId = "class_id"
        case salePrice = "sale_price"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case isLiked = "is_liked"
    }
}

struct ClassDetailInfo: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let location: String?
    let date: String?
    let capacity: Int?
    let imageUrls: [String]
    let createdAt: String
    let isLiked: Bool
    let creator: User
    
    enum CodingKeys: String, CodingKey {
        case category, title, description, price, location, date, capacity, creator
        case classId = "class_id"
        case salePrice = "sale_price"
        case imageUrls = "image_urls"
        case createdAt = "created_at"
        case isLiked = "is_liked"
    }
}

struct User: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case nick, profileImage
        case userId = "user_id"
    }
}

