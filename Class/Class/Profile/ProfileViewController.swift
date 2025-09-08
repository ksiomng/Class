//
//  ProfileViewController.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    
    private let logoutButton: UIButton = {
        let button = UIButton.defaultButton(title: "로그아웃", color: .lightOrangeC)
        return button
    }()
    
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIViewController.setLeftNavigationTitle(title: "프로필"))
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func bind() {
        let input = ProfileViewModel.Input(logoutButtonTap: logoutButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.logout
            .bind(with: self) { owner, _ in
                self.view.window?.rootViewController = RootViewControllerManager.getRootViewController()
            }
            .disposed(by: disposeBag)
    }
}
