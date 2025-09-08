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

final class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    private let centerLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.text = "원하는 클래스가 있으신가요?"
        return label
    }()
    
    private let classTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchClassTableViewCell.self, forCellReuseIdentifier: SearchClassTableViewCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private let reload = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIViewController.setLeftNavigationTitle(title: "클래스 검색"))
        
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
    
    private func bind() {
        let input = SearchViewModel.Input(reload: reload, searchTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, moveDetailTap: classTableView.rx.modelSelected(ClassInfo.self))
        let output = viewModel.transform(input: input)
        
        output.message
            .asDriver()
            .drive(with: self) { owner, value in
                owner.view.endEditing(true)
                if value != nil {
                    owner.classTableView.isHidden = true
                    owner.centerLabel.isHidden = false
                    owner.centerLabel.text = value
                } else {
                    owner.classTableView.isHidden = false
                    owner.centerLabel.isHidden = true
                    owner.classTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.list
            .drive(classTableView.rx
                .items(cellIdentifier: SearchClassTableViewCell.identifier,
                       cellType: SearchClassTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.showAlert
                    .bind(with: self) { owner, message in
                        UIViewController.showAlert(message: message, viewController: owner)
                    }
                    .disposed(by: cell.disposeBag)
                cell.showToast
                    .bind(with: self) { owner, message in
                        UIViewController.showToast(message: message, viewController: owner)
                    }
                    .disposed(by: cell.disposeBag)
                cell.selectionStyle = .none
            }
                       .disposed(by: disposeBag)
        
        output.moveDetail
            .skip(1)
            .bind { value in
                let vc = ClassDetailViewController()
                vc.setData(data: value)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
