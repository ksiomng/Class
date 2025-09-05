//
//  ClassTableViewCell.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit
import RxSwift

class ClassTableViewCell: UITableViewCell {
    
    private let classImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let classTitleLabel = {
        let label = UILabel()
        label.font = .largeBoldFont
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let classDescLabel = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        return label
    }()
    
    private let salePriceLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.textColor = .black
        return label
    }()
    
    private let salePersentLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.textColor = .orangeC
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        return button
    }()
    
    private let categoryTag = {
        let label = InsetLabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .orangeC
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.orangeC.cgColor
        label.contentInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        label.lineBreakMode = .byClipping
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let viewModel = ClassTableViewCellModel()
    var disposeBag = DisposeBag()
    var likeStatus = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.attributedText = nil
    }
    
    private func setupUI() {
        contentView.addSubview(classImageView)
        contentView.addSubview(classTitleLabel)
        contentView.addSubview(classDescLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(salePriceLabel)
        contentView.addSubview(salePersentLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(categoryTag)
        
        classImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        classTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        categoryTag.snp.makeConstraints { make in
            make.centerY.equalTo(classTitleLabel)
            make.leading.equalTo(classTitleLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualTo(likeButton.snp.leading).offset(-8) // 버튼 왼쪽까지만
        }
        
        classDescLabel.snp.makeConstraints { make in
            make.top.equalTo(classTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(classDescLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        salePriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.leading.equalTo(priceLabel.snp.trailing).offset(4)
        }
        
        salePersentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.leading.equalTo(salePriceLabel.snp.trailing).offset(4)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(30)
        }
    }
    
    func setupData(row: ClassInfo) {
        let input = ClassTableViewCellModel.Input(imagePath: row.image_url)
        let output = viewModel.transform(input: input)
        
        output.image
            .drive(with: self) { owner, image in
                owner.classImageView.image = image
            }
            .disposed(by: disposeBag)
        
        classTitleLabel.text = row.title
        classDescLabel.text = row.description
        
        categoryTag.text = Category.categories[row.category]
        PriceLabel.priceCalculateSale(price: row.price, salePrice: row.sale_price, priceLabel: priceLabel, saleLabel: salePriceLabel, persentLabel: salePersentLabel)
        
        self.likeStatus = row.is_liked
        if likeStatus {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func bind(id: String, handler: @escaping (Bool) -> Void) {
        likeButton.rx.tap
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .like(id: id, status: !self.likeStatus), type: Like.self) { [self] result in
                    switch result {
                    case .success(let success):
                        self.likeStatus = success.like_status
                        if likeStatus {
                            owner.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        } else {
                            owner.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                        }
                        handler(success.like_status)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
