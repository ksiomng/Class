//
//  CategoryHelper.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

final class CategoryHelper {
    private init() { }
    
    static let categories = [ 101: "개발",
                              102: "디자인",
                              201: "외국어",
                              202: "라이프",
                              203: "뷰티",
                              301: "제테크",
                              900: "기타"
    ]
    
    static var names: [String] {
        var arr = categories.values.map { $0 }
        arr.insert("전체", at: 0)
        return arr
    }
}
