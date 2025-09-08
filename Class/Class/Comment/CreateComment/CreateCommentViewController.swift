//
//  CreateCommentViewController.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateCommentViewController: UIViewController {
    
    private var isCreated = false
    private var detailData: ClassDetailInfo?
    private var commentData: Comment?
    
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
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .largeBoldFont
        return label
    }()
    
    private let textViewBackground = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGrayC.cgColor
        return view
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.isScrollEnabled = true
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글을 작성해주세요."
        label.textColor = .lightGrayC
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let statusComment = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.textColor = .grayC
        return label
    }()
    
    private let backButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let okButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .largeBoldFont
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    func moveData(isCreated: Bool, detailData: ClassDetailInfo?, commentData: Comment?) {
        self.isCreated = isCreated
        self.detailData = detailData
        self.commentData = commentData
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailData = detailData else { return }
        setupUI()
        bind(detailData: detailData)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = isCreated ? "댓글 작성" : "댓글 수정"
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
    
    private let viewModel = CreateCommentViewModel()
    
    private func bind(detailData: ClassDetailInfo) {
        let input = CreateCommentViewModel.Input(detailData: detailData, commentData: commentData, isCreated: isCreated, content: textView.rx.text.orEmpty, okButtonTap: okButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        categoryTag.text = CategoryHelper.categories[detailData.category] ?? ""
        titleLabel.text = detailData.title
        textView.text = commentData?.content
        
        backButton.rx.tap
            .bind { _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .bind(with: self) { owner, value in
                owner.placeholderLabel.isHidden = !value.isEmpty
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(output.statusColor, output.statusText)
            .bind(with: self) { owner, value in
                owner.statusComment.text = value.1
                owner.statusComment.textColor = value.0
            }
            .disposed(by: disposeBag)
        
        output.status
            .bind(with: self) { owner, value in
                if value {
                    owner.okButton.isEnabled = true
                    owner.okButton.alpha = 1.0
                } else {
                    owner.okButton.isEnabled = false
                    owner.okButton.alpha = 0.5
                }
            }
            .disposed(by: disposeBag)
        
        output.successWriteComment
            .bind(with: self) { owner, value in
                if value {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind(with: self) { owner, message in
                UIViewController.showAlert(message: message, viewController: owner)
            }
            .disposed(by: disposeBag)
    }
}
