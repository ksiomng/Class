//
//  CommentTableViewCell.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    private let profileImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
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
        return label
    }()
    
    private let editButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .grayC
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(editButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(timeLabel)
        }
    }
    
    func setupData(row: Comment) {
        if let profileImage = row.creator.profileImage {
            NetworkManager.shared.callImage(imagePath: profileImage) { result in
                switch result {
                case .success(let success):
                    self.profileImageView.image = success
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        nameLabel.text = row.creator.nick
        timeLabel.text = StringFormatter.formatCommentDate(str: row.created_at)
        contentLabel.text = row.content
        
        if UserDefaultsHelper.shared.userId == row.creator.user_id {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
