//
//  APIError.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import Foundation

struct APIError: Decodable, Error {
    let message: String
}
