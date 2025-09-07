//
//  SearchViewController.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    let centerLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.text = "원하는 클래스가 있으신가요?"
        return label
    }()
    
    private lazy var classTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchClassTableViewCell.self, forCellReuseIdentifier: SearchClassTableViewCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    let reload = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(reload: reload)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload.accept(())
    }
    
    private func bind(reload: PublishRelay<Void>) {
        let input = SearchViewModel.Input(reload: reload, searchTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.message
            .bind(with: self) { owner, value in
                if value != nil {
                    owner.classTableView.isHidden = true
                    owner.centerLabel.isHidden = false
                    owner.centerLabel.text = value
                } else {
                    owner.classTableView.isHidden = false
                    owner.centerLabel.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        output.list
            .drive(classTableView.rx
                .items(cellIdentifier: SearchClassTableViewCell.identifier,
                       cellType: SearchClassTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element) {
                    reload.accept(())
                }
            }
            .disposed(by: disposeBag)
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
        view.addSubview(classTableView)
        classTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
