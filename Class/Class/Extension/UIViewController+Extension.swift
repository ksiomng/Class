//
//  UIViewController.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit

extension UIViewController {
    
    static func setLeftNavigationTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = .largeBoldFont
        return label
    }
    
    static func showAlert(message: String, viewController: UIViewController) {
         let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "확인", style: .default))
         viewController.present(alert, animated: true)
     }
    
    static func showToast(message : String, viewController: UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: 25 , y: UIScreen.main.bounds.size.height-150, width: UIScreen.main.bounds.size.width - 50, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .mediumBoldFont
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        viewController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
