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
    var category = 0
    var id = ""
    var data: [Comment] = []
    let reload = PublishRelay<Void>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let writeButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: writeButton)
        navigationItem.title = titleNavigation
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        let dataRelay = BehaviorRelay<[Comment]>(value: data)
        
        dataRelay
            .asDriver()
            .drive(tableView.rx
                .items(cellIdentifier: CommentTableViewCell.identifier,
                       cellType: CommentTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.selectionStyle = .none
            }
                       .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CreateCommentViewController()
                vc.titleNavigation = "댓글 작성"
                vc.titleClass = owner.titleNavigation
                vc.category = owner.category
                vc.id = owner.id
                
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        reload
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .comment(id: owner.id), type: Comments.self) { result in
                    switch result {
                    case .success(let success):
                        dataRelay.accept(success.data)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
