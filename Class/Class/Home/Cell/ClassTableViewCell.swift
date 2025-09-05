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
    
    private let likeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
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
        return label
    }()
    
    let viewModel = ClassTableViewCellModel()
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        classImageView.image = nil
        priceLabel.attributedText = nil
        priceLabel.text = nil
        salePriceLabel.text = nil
        salePriceLabel.isHidden = true
        salePersentLabel.text = nil
        salePersentLabel.isHidden = true
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    private func setupUI() {
        contentView.addSubview(classImageView)
        contentView.addSubview(classTitleLabel)
        contentView.addSubview(classDescLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(salePriceLabel)
        contentView.addSubview(salePersentLabel)
        classImageView.addSubview(likeButton)
        contentView.addSubview(categoryTag)
        
        classImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        classTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(categoryTag.snp.leading).offset(-4)
        }
        
        categoryTag.snp.makeConstraints { make in
            make.centerY.equalTo(classTitleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(16).priority(.required)
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
            make.top.trailing.equalToSuperview().inset(8)
            make.height.width.equalTo(30)
        }
    }
    
    func setupData(image: String, title: String, desc: String, price: Int?, salePrice: Int?, category: Int, like: Bool) {
        let input = ClassTableViewCellModel.Input(imagePath: image)
        let output = viewModel.transform(input: input)
        
        output.image
            .drive(with: self) { owner, image in
                owner.classImageView.image = image
            }
            .disposed(by: disposeBag)
        
        classTitleLabel.text = title
        classDescLabel.text = desc
        
        categoryTag.text = Category.categories[category]
        PriceLabel.priceCalculateSale(price: price, salePrice: salePrice, priceLabel: priceLabel, saleLabel: salePriceLabel, persentLabel: salePersentLabel)
        
        if like {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
