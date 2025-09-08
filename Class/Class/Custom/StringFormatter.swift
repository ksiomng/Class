//
//  StringFormatter.swift
//  Class
//
//  Created by Song Kim on 9/6/25.
//

import UIKit

final class StringFormatter {
    private init() { }
    
    static func formatWithComma(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func calculate(price: Int, sale: Int) -> String {
        let discountRate = ((Float(price) - Float(sale)) / Float(price)) * 100
        let roundedRate = Int(discountRate.rounded())
        return "\(roundedRate)%"
    }
    
    static func formatCommentDate(str: String) -> String {
        let formatter = DateFormatter()
        
        guard let date = formatter.date(from: str) else {
            return ""
        }
        
        let now = Date()
        let diff = Int(now.timeIntervalSince(date))
        
        if diff < 60 {
            return "방금 전"
        } else if diff < 3600 {
            let minutes = diff / 60
            return "\(minutes)분 전"
        } else if diff < 86400 {
            let hours = diff / 3600
            return "\(hours)시간 전"
        } else if diff < 86400 * 7 {
            let days = diff / 86400
            return "\(days)일 전"
        } else {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yy년 M월 d일 a h시 m분"
            return displayFormatter.string(from: date)
                .replacingOccurrences(of: "AM", with: "오전")
                .replacingOccurrences(of: "PM", with: "오후")
        }
    }
}
