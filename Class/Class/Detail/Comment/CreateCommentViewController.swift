//
//  CreateCommentViewController.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import RxSwift
import RxCocoa

class CreateCommentViewController: UIViewController {
    
    var titleNavigation = ""
    var category = 0
    var titleClass = ""
    var id: String = ""
    
    private let categoryTag = {
        let label = InsetLabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .orangeC
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.orangeC.cgColor
        label.contentInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .largeBoldFont
        return label
    }()
    
    let textViewBackground = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGrayC.cgColor
        return view
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.isScrollEnabled = true
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        return tv
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글을 작성해주세요."
        label.textColor = .lightGrayC
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let statusComment = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.textColor = .grayC
        return label
    }()
    
    let backButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let okButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .largeBoldFont
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = titleNavigation
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okButton)
        
        view.addSubview(categoryTag)
        view.addSubview(titleLabel)
        view.addSubview(textViewBackground)
        textViewBackground.addSubview(textView)
        textViewBackground.addSubview(placeholderLabel)
        view.addSubview(statusComment)
        
        categoryTag.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTag.snp.bottom).offset(4)
            make.leading.equalTo(categoryTag)
        }
        
        textViewBackground.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(categoryTag)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(240)
        }
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        statusComment.snp.makeConstraints { make in
            make.top.equalTo(textViewBackground.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func bind() {
        backButton.rx.tap
            .bind { _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        categoryTag.text = Category.categories[category] ?? ""
        titleLabel.text = titleClass
        
        textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.placeholderLabel.isHidden = !text.isEmpty
            })
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .map { $0.replacingOccurrences(of: " ", with: "") }
            .bind(with: self) { owner, text in
                let count = text.count
                
                owner.statusComment.text = "\(count)/200"
                owner.statusComment.textColor = count >= 150 ? .orangeC : .grayC
                
                if count >= 2 && count <= 200 {
                    owner.okButton.isEnabled = true
                    owner.okButton.alpha = 1.0
                } else {
                    owner.okButton.isEnabled = false
                    owner.okButton.alpha = 0.5
                }
                
                if count > 200 {
                    owner.statusComment.text = "200자 초과"
                }
            }
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .withLatestFrom(textView.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                NetworkManager.shared.callRequest(api: .writeComment(id: owner.id, content: value), type: Comment.self) { result in
                    switch result {
                    case .success(let success):
                        self.dismiss(animated: true)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
