//
//  UITextField+Extension.swift
//  Class
//
//  Created by Song Kim on 9/3/25.
//

import UIKit

extension UITextField {
    
    static func loginStyle(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.lightOrangeC.cgColor
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.smallFont,
                .foregroundColor: UIColor.lightGrayC,
            ]
        )
        textField.font = .systemFont(ofSize: 13)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }
}
