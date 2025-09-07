//
//  SearchViewController.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    let centerLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.text = "원하는 클래스가 있으신가요?"
        return label
    }()
    
    let classTableView = {
        let tableView = UITableView()
        return tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: setLeftNavigationTitle(title: "클래스 검색"))
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
