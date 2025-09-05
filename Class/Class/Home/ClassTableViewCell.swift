//
//  ClassTableViewCell.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit
import Kingfisher

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
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
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        classTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        categoryTag.snp.makeConstraints { make in
            make.centerY.equalTo(classTitleLabel)
            make.leading.equalTo(classTitleLabel.snp.trailing).offset(4)
        }
        
        classDescLabel.snp.makeConstraints { make in
            make.top.equalTo(classTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(classDescLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
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
            make.top.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(30)
        }
    }
    
    func bindData(image: String, title: String, content: String, price: String?, salePrice: String?, category: String) {
        classImageView.kf.setImage(with: URL(string: image)!)
        classTitleLabel.text = title
        classDescLabel.text = content
        categoryTag.text = category
        if let price = price {
            priceLabel.text = price + "원"
            if let salePrice = salePrice {
                let attributeString = NSAttributedString(
                    string: price + "원",
                    attributes: [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.lightGrayC
                    ]
                )
                priceLabel.attributedText = attributeString
                
                salePriceLabel.isHidden = false
                salePersentLabel.isHidden = false
                salePriceLabel.text = salePrice + "원"
                salePersentLabel.text = calculate(price: price, sale: salePrice)
            } else {
                priceLabel.attributedText = nil
                priceLabel.text = price + "원"
                priceLabel.textColor = .black
                salePriceLabel.isHidden = true
                salePersentLabel.isHidden = true
            }
        } else {
            priceLabel.attributedText = nil
            priceLabel.text = "무료"
            priceLabel.textColor = .black
            salePriceLabel.isHidden = true
            salePersentLabel.isHidden = true
        }
    }
    
    private func calculate(price: String, sale: String) -> String {
        let discountRate = ((Float(price)! - Float(sale)!) / Float(price)!) * 100
        let roundedRate = Int(discountRate.rounded())
        return "\(roundedRate)%"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
