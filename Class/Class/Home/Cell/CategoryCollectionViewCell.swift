//
//  CategoryCollectionViewCell.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let labelBackgroundView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 17
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGrayC.cgColor
        return view
    }()
    
    private let categoryLabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.textColor = .lightGrayC
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(labelBackgroundView)
        labelBackgroundView.addSubview(categoryLabel)
        
        labelBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setCategoryName(title: String) {
        categoryLabel.text = title
    }
    
    func setSelectedUI(_ selected: Bool) {
        if selected {
            labelBackgroundView.layer.borderColor = UIColor.orangeC.cgColor
            categoryLabel.textColor = .orangeC
        } else {
            labelBackgroundView.layer.borderColor = UIColor.lightGrayC.cgColor
            categoryLabel.textColor = .lightGrayC
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
