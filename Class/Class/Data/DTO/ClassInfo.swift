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
    let class_id: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let sale_price: Int?
    let image_url: String
    let created_at: String
    let is_liked: Bool
    let creator: User
}

struct ClassDetailInfo: Decodable {
    let class_id: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let sale_price: Int?
    let location: String?
    let date: String?
    let capacity: Int?
    let image_urls: [String]
    let created_at: String
    let is_liked: Bool
    let creator: User
}

struct User: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

