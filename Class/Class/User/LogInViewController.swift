//
//  LogInViewController.swift
//  Class
//
//  Created by Song Kim on 9/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LogInViewController: UIViewController {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let emailLabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .mediumBoldFont
        return label
    }()
    
    private let emailTextField = {
        let textField = UITextField.loginStyle(placeholder: "이메일을 입력하세요")
        return textField
    }()
    
    private let passwordLabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .mediumBoldFont
        return label
    }()
    
    private let passwordTextField = {
        let textField = UITextField.loginStyle(placeholder: "비밀번호를 입력하세요")
        return textField
    }()
    
    private let loginButton = {
        let button = UIButton.defaultButton(title: "로그인", color: .lightGrayC)
        return button
    }()
    
    private let statusLabel = {
        let label = UILabel()
        label.text = "이메일 또는 비밀번호를 입력해주세요."
        label.font = .smallBoldFont
        label.textColor = .orangeC
        label.textAlignment = .center
        return label
    }()
    
    private let viewModel = LogInViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(statusLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(140)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(44)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
    }
    
    private func bind() {
        let input = LogInViewModel.Input(emailTextField: emailTextField.rx.text.orEmpty, passwordTextField: passwordTextField.rx.text.orEmpty, loginButtonTap: loginButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.statusString
            .asDriver()
            .drive { [weak self] value in
                self?.statusLabel.text = value
            }
            .disposed(by: disposeBag)
        
        output.enabledButton
            .asDriver()
            .drive { [weak self] value in
                if value {
                    self?.loginButton.backgroundColor = .lightOrangeC
                } else {
                    self?.loginButton.backgroundColor = .lightGrayC
                }
                self?.loginButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output.login
            .bind(with: self) { owner, value in
                if value {
                    owner.view.window?.rootViewController = RootViewControllerManager.getRootViewController()
                }
            }
            .disposed(by: disposeBag)
    }
}
