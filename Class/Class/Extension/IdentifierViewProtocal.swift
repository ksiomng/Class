//
//  IdentifierViewProtocal.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit

protocol IdentifierViewProtocal {
    static var identifier: String {get}
}

extension UICollectionViewCell: IdentifierViewProtocal {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifierViewProtocal {
    static var identifier: String {
        return String(describing: self)
    }
}
