//
//  CommentViewController.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommentViewController: UIViewController {
    
    private var data: ClassDetailInfo?
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
    
    func moveData(data: ClassDetailInfo?) {
        self.data = data
    }
    
    private let reload = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let viewModel = CommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else { return }
        setupUI(data: data)
        bind(data: data)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload.accept(())
    }
    
    private func setupUI(data: ClassDetailInfo) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: writeButton)
        navigationItem.title = data.title
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind(data: ClassDetailInfo) {
        let deleteComment = PublishRelay<String>()
        let input = CommentViewModel.Input(data: self.data!, loadData: self.reload, deleteComment: deleteComment)
        let output = viewModel.transform(input: input)
        
        output.data
            .bind(with: self) { owner, value in
                owner.commentCount?(value.count)
            }
            .disposed(by: disposeBag)
        
        output.data
            .asDriver()
            .drive(tableView.rx
                .items(cellIdentifier: CommentTableViewCell.identifier,
                       cellType: CommentTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.showAlert
                    .bind(with: self) { owner, message in
                        UIViewController.showAlert(message: message, viewController: owner)
                    }
                    .disposed(by: cell.disposeBag)
                cell.editButtonTap
                    .bind(with: self) { owner, _ in
                        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "댓글 수정", style: .default) { _ in
                            let vc = CreateCommentViewController()
                            vc.moveData(isCreated: false, detailData: data, commentData: element)
                            let nav = UINavigationController(rootViewController: vc)
                            nav.modalPresentationStyle = .fullScreen
                            owner.present(nav, animated: true)
                        })
                        alert.addAction(UIAlertAction(title: "댓글 삭제", style: .destructive) { _ in
                            deleteComment.accept(element.comment_id)
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
                vc.moveData(isCreated: true, detailData: data, commentData: nil)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind(with: self) { owner, message in
                UIViewController.showAlert(message: message, viewController: owner)
            }
            .disposed(by: disposeBag)
    }
}
