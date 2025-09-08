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
    let reload = PublishRelay<Void>()
    var commentCount: ((Int) -> Void)?
    
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
        let dataRelay = BehaviorRelay<[Comment]>(value: [])
        
        reload
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .comment(id: owner.id), type: Comments.self) { result in
                    switch result {
                    case .success(let success):
                        dataRelay.accept(success.data)
                        owner.commentCount?(success.data.count)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        dataRelay
            .asDriver()
            .drive(tableView.rx
                .items(cellIdentifier: CommentTableViewCell.identifier,
                       cellType: CommentTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.editButtonTap
                    .bind(with: self) { owner, _ in
                        let alert = UIAlertController(title: nil,
                                                      message: nil,
                                                      preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "댓글 수정", style: .default) { _ in
                            let vc = CreateCommentViewController()
                            vc.isCreated = false
                            vc.beforeText = element.content
                            vc.titleClass = owner.titleNavigation
                            vc.category = owner.category
                            vc.id = owner.id
                            vc.commentId = element.comment_id
                            
                            let nav = UINavigationController(rootViewController: vc)
                            nav.modalPresentationStyle = .fullScreen
                            owner.present(nav, animated: true)
                        })
                        alert.addAction(UIAlertAction(title: "댓글 삭제", style: .destructive) { _ in
                            NetworkManager.shared.callRequest(api: .deleteComment(id: owner.id, commentId: element.comment_id), type: EmptyResponse.self) { _ in
                                owner.reload.accept(())
                            }
                        })
                        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                        self.present(alert, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                cell.selectionStyle = .none
            }
                       .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CreateCommentViewController()
                vc.isCreated = true
                vc.titleClass = owner.titleNavigation
                vc.category = owner.category
                vc.id = owner.id
                
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
