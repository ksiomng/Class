//
//  CommentViewController.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: UIViewController {
    
    var titleNavigation = ""
    var data: [Comment] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let writeButtonView = {
        let view = UIImageView()
        view.image = UIImage(named: "comment")
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
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
    
    private func bind() {
        BehaviorRelay(value: data)
            .asDriver()
            .drive(tableView.rx
                .items(cellIdentifier: CommentTableViewCell.identifier,
                       cellType: CommentTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
}
