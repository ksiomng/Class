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

class ClassDetailViewController: UIViewController {
    
    var data: ClassDetailInfo?
    
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
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.tintColor = .grayC
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
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
    
    private func bind() {
        guard let detailData = data else { return }
        
        BehaviorSubject(value: detailData.image_urls)
            .bind(to: collectionView.rx
                .items(cellIdentifier: ImageCollectionViewCell.identifier,cellType: ImageCollectionViewCell.self)) { index, element, cell in
                    NetworkManager.shared.callImage(imagePath: element) { result in
                        switch result {
                        case .success(let success):
                            cell.setImage(image: success)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
                .disposed(by: disposeBag)
        
        if let image = detailData.creator.profileImage {
            NetworkManager.shared.callImage(imagePath: image) { result in
                switch result {
                case .success(let success):
                    self.userProfile.image = success
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            userProfile.image = UIImage(systemName: "person.fill")
        }
        
        userName.text = detailData.creator.nick
        
        infoView.setData(location: detailData.location, date: detailData.date, capacity: detailData.capacity)
        
        classDescText.text = detailData.description
        
    }
}
