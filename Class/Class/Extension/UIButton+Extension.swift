//
//  UIButton+Extension.swift
//  Class
//
//  Created by Song Kim on 9/3/25.
//

import UIKit

extension UIButton {
    
    static func defaultButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .smallFont
        return button
    }
}
