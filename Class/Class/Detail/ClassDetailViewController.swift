//
//  ClassDetailViewController.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ClassDetailViewController: UIViewController {
    
    private var data: ClassDetailInfo?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return cv
    }()
    
    private let userProfile = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.tintColor = .grayC
        return imageView
    }()
    
    private let userName = {
        let label = UILabel()
        label.font = .smallBoldFont
        return label
    }()
    
    private let infoView = {
        let view = InfoView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGrayC.cgColor
        return view
    }()
    
    private let classDescTitle = {
        let label = UILabel()
        label.text = "클래스 소개"
        label.font = .largeBoldFont
        return label
    }()
    
    private let classDescText = {
        let text = UITextView()
        text.font = .mediumFont
        text.isEditable = false
        return text
    }()
    
    private let commentButton = {
        let button = UIButton.defaultButton(title: "댓글보기", color: .grayC)
        return button
    }()
    
    private let likeButton = UIButton()
    
    func moveData(data: ClassDetailInfo?) {
        self.data = data
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailData = data else { return }
        setupUI()
        bind(detailData: detailData)
    }
    
    private func setupUI() {
        guard let detailData = data else { return }
        view.backgroundColor = .white
        navigationItem.title = detailData.title
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        view.addSubview(userProfile)
        userProfile.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(36)
        }
        
        view.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.centerY.equalTo(userProfile)
            make.leading.equalTo(userProfile.snp.trailing).offset(8)
        }
        
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(userProfile.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(130)
        }
        
        view.addSubview(classDescTitle)
        classDescTitle.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        view.addSubview(classDescText)
        classDescText.snp.makeConstraints { make in
            make.top.equalTo(classDescTitle.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        view.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(classDescText.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(44)
            make.trailing.equalTo(commentButton.snp.leading).offset(-16)
            make.centerY.equalTo(commentButton).offset(-4)
        }
    }
    
    private let viewModel = ClassDetailViewModel()
    
    private func bind(detailData: ClassDetailInfo) {
        var liked = detailData.isLiked
        
        let input = ClassDetailViewModel.Input(detailsData: BehaviorRelay(value: detailData), likeButtonTap: likeButton.rx.tap, liked: liked)
        let output = viewModel.transform(input: input)
        
        output.images
            .bind(to: collectionView.rx
                .items(cellIdentifier: ImageCollectionViewCell.identifier,cellType: ImageCollectionViewCell.self)) { index, element, cell in
                    cell.setImage(image: element)
                }
                .disposed(by: disposeBag)
        
        output.profileImage
            .bind(with: self) { owner, value in
                owner.userProfile.image = value
            }
            .disposed(by: disposeBag)
        
        output.isLiked
            .asDriver()
            .drive(with: self) { owner, value in
                owner.statusLikeButton(value)
                liked = value
            }
            .disposed(by: disposeBag)
        
        output.commentsCount
            .bind(with: self) { owner, value in
                owner.setCommentButton(value)
            }
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .bind { _ in
                let vc = CommentViewController()
                vc.commentCount = { value in
                    self.setCommentButton(value)
                }
                vc.moveData(data: detailData)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.toastMsg
            .bind(with: self) { owner, value in
                UIViewController.showToast(message: value, viewController: owner)
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind(with: self) { owner, message in
                UIViewController.showAlert(message: message, viewController: owner)
            }
            .disposed(by: disposeBag)
        
        userName.text = detailData.creator.nick
        infoView.setupData(location: detailData.location, date: detailData.date, capacity: detailData.capacity)
        classDescText.text = detailData.description
        statusLikeButton(detailData.isLiked)
    }
    
    private func setCommentButton(_ count: Int) {
        self.commentButton.setTitle("댓글보기 (\(count))", for: .normal)
        self.commentButton.backgroundColor = count == 0 ? .grayC : .orangeC
        self.commentButton.isEnabled = !(count == 0)
    }
    
    private func statusLikeButton(_ isLiked: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
            likeButton.tintColor = .orangeC
        } else {
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
            likeButton.tintColor = .grayC
        }
    }
}
