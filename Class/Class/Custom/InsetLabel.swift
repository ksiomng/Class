//
//  InsetLabel.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit

class InsetLabel: UILabel {
    var contentInsets = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += contentInsets.left + contentInsets.right
        size.height += contentInsets.top + contentInsets.bottom
        return size
    }
}
