//
//  ProfileViewController.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit

class ProfileViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필"
        label.textColor = .black
        label.font = .largeBoldFont
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}
