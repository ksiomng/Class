//
//  UIViewController.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit

extension UIViewController {
    
    func setLeftNavigationTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = .largeBoldFont
        return label
    }
}
