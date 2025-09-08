//
//  SearchClassTableViewCell.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import UIKit
import SnapKit
import RxSwift

final class SearchClassTableViewCell: UITableViewCell {
    
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
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
    
    private lazy var discountStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [salePriceLabel, salePersentLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, discountStack])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
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
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let viewModel = SearchClassTableViewCellModel()
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        priceLabel.attributedText = nil
    }
    
    private func setupUI() {
        contentView.addSubview(classImageView)
        contentView.addSubview(classTitleLabel)
        contentView.addSubview(priceStack)
        contentView.addSubview(likeButton)
        contentView.addSubview(categoryTag)
        
        classImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(150)
            make.height.equalTo(classImageView.snp.width).multipliedBy(0.66)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-12)
        }
        
        categoryTag.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.top)
            make.leading.equalTo(classImageView.snp.trailing).offset(16)
        }
        
        classTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTag.snp.bottom).offset(8)
            make.leading.equalTo(classImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        priceStack.snp.makeConstraints { make in
            make.leading.equalTo(classImageView.snp.trailing).offset(16)
            make.bottom.equalTo(classImageView.snp.bottom)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(classTitleLabel.snp.bottom)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.width.equalTo(30)
        }
    }
    
    func setupData(row: ClassInfo) {
        let input = SearchClassTableViewCellModel.Input(imagePath: row.image_url, likeButtonTap: likeButton.rx.tap, id: row.class_id, liked: row.is_liked, className: row.title)
        let output = viewModel.transform(input: input)
        
        output.image
            .drive(with: self) { owner, image in
                owner.classImageView.image = image
            }
            .disposed(by: disposeBag)
        
        output.isLiked
            .asDriver()
            .drive(with: self) { owner, value in
                owner.statusLikeButton(isLiked: value, className: row.title)
            }
            .disposed(by: disposeBag)
        
        output.toastMsg
            .bind(with: self) { owner, value in
                UIViewController.showToast(message: value)
            }
            .disposed(by: disposeBag)
        
        classTitleLabel.text = row.title
        categoryTag.text = CategoryHelper.categories[row.category]
        PriceLabel.priceCalculateSale(price: row.price, salePrice: row.sale_price, priceLabel: priceLabel, saleLabel: salePriceLabel, persentLabel: salePersentLabel)
    }
    
    private func statusLikeButton(isLiked: Bool, className: String) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .orangeC
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .grayC
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
