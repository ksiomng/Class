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
    
    static func showToast(message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = .mediumBoldFont
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        let maxSize = CGSize(width: window.frame.width - 40, height: window.frame.height)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        expectedSize.width += 20
        expectedSize.height += 16
        
        toastLabel.frame = CGRect(
            x: (window.frame.width - expectedSize.width) / 2,
            y: window.frame.height - expectedSize.height - 100,
            width: expectedSize.width,
            height: expectedSize.height
        )
        
        window.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
