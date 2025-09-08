//
//  PriceLabel.swift
//  Class
//
//  Created by Song Kim on 9/6/25.
//

import UIKit

final class PriceLabel {
    
    private init() { }
    
    static func priceCalculateSale(price: Int?, salePrice: Int?, priceLabel: UILabel, saleLabel: UILabel, persentLabel: UILabel) {
        if let price = price {
            priceLabel.text = StringFormatterHelper.formatWithComma(price) + "원"
            if let salePrice = salePrice {
                let attributeString = NSAttributedString(
                    string: StringFormatterHelper.formatWithComma(price) + "원",
                    attributes: [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
                priceLabel.attributedText = attributeString
                
                saleLabel.isHidden = false
                persentLabel.isHidden = false
                saleLabel.text = StringFormatterHelper.formatWithComma(salePrice) + "원"
                persentLabel.text = StringFormatterHelper.calculate(price: price, sale: salePrice)
            } else {
                priceLabel.text = StringFormatterHelper.formatWithComma(price) + "원"
                saleLabel.isHidden = true
                persentLabel.isHidden = true
            }
        } else {
            priceLabel.text = "무료"
            saleLabel.isHidden = true
            persentLabel.isHidden = true
        }
    }
}
