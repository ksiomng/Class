//
//  CommentViewController.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit

class CommentViewController: UIViewController {
    
    var titleNavigation = ""
    var data: [Comment] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private let writeButtonView = {
        let view = UIImageView()
        view.image = UIImage(named: "comment")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: writeButtonView)
        navigationItem.title = titleNavigation
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
