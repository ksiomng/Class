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
}
