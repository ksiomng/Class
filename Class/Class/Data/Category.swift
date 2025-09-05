//
//  Category.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

final class Category {
    private init() { }
    
    static let categories = ["개발": 101,
                               "디자인": 102,
                               "외국어": 201,
                               "라이프": 202,
                               "뷰티": 203,
                               "제테크": 301,
                               "기타": 900
    ]
    
    static var names: [String] {
        var arr = categories.keys.map {$0}
        arr.insert("전체", at: 0)
        return arr
    }
}
