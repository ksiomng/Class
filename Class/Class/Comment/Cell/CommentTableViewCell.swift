//
//  CommentTableViewCell.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommentTableViewCell: UITableViewCell {
    let editButtonTap = PublishRelay<Void>()
    let showAlert = PublishRelay<String>()
    
    private let profileImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        return image
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        return label
    }()
    
    private let timeLabel = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        return label
    }()
    
    private let contentLabel = {
        let label = UILabel()
        label.font = .smallFont
        label.numberOfLines = 0
        return label
    }()
    
    private let editButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .grayC
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(editButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(nameLabel)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(timeLabel)
        }
    }
    
    func setupData(row: Comment) {
        if let profileImage = row.creator.profileImage {
            NetworkManager.shared.callImage(api: .image(path: profileImage)) { result in
                switch result {
                case .success(let success):
                    self.profileImageView.image = success
                case .failure(let failure):
                    self.showAlert.accept(failure.message)
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        nameLabel.text = row.creator.nick
        timeLabel.text = StringFormatterHelper.formatCommentDate(str: row.created_at)
        contentLabel.text = row.content
        
        if UserDefaultsHelper.shared.userId == row.creator.user_id {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
        
        editButton.rx.tap
            .bind(to: editButtonTap)
            .disposed(by: disposeBag)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
