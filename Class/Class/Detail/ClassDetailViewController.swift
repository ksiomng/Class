//
//  ClassDetailViewController.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import UIKit

class ClassDetailViewController: UIViewController {
    var className = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = className
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}
