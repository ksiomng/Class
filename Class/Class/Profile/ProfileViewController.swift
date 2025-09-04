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

class ProfileViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필"
        label.textColor = .black
        label.font = .largeBoldFont
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton.defaultButton(title: "로그아웃", color: .lightOrangeC)
        return button
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    func bind() {
        logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                UserDefaultsHelper.shared.clearToken()
                self.view.window?.rootViewController = RootViewControllerManager.getRootViewController()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
