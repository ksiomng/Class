//
//  InfoView.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import UIKit

final class InfoView: UIView {
    
    private let locationTitle = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        label.text = "장소"
        return label
    }()
    
    private let locationImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.fill")
        imageView.tintColor = .orangeC
        return imageView
    }()
    
    private let locationInfo = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        return label
    }()
    
    private let dateTitle = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        label.text = "시간"
        return label
    }()
    
    private let dateImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.fill")
        imageView.tintColor = .orangeC
        return imageView
    }()
    
    private let dateInfo = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        return label
    }()
    
    private let capacityTitle = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        label.text = "인원"
        return label
    }()
    
    private let capacityImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .orangeC
        return imageView
    }()
    
    private let capacityInfo = {
        let label = UILabel()
        label.font = .smallFont
        label.textColor = .grayC
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        let locationStack = UIStackView(arrangedSubviews: [locationTitle, locationImage, locationInfo])
        locationStack.axis = .horizontal
        locationStack.spacing = 2
        locationStack.alignment = .center
        
        let dateStack = UIStackView(arrangedSubviews: [dateTitle, dateImage, dateInfo])
        dateStack.axis = .horizontal
        dateStack.spacing = 2
        dateStack.alignment = .center
        
        let capacityStack = UIStackView(arrangedSubviews: [capacityTitle, capacityImage, capacityInfo])
        capacityStack.axis = .horizontal
        capacityStack.spacing = 2
        capacityStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [locationStack, dateStack, capacityStack])
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(16)
        }
        
        locationImage.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        dateImage.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        capacityImage.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        locationTitle.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        dateTitle.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        capacityTitle.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
    }
    
    func setData(location: String?, date: String?, capacity: Int?) {
        if let loc = location {
            self.locationInfo.text = loc
        } else {
            self.locationInfo.text = "미정"
        }
        if let date = date {
            self.dateInfo.text = StringFormatterHelper.formatInfoDate(str: date)
        } else {
            self.dateInfo.text = "미정"
        }
        if let cap = capacity {
            self.capacityInfo.text = "\(StringFormatterHelper.formatWithComma(cap))명"
        } else {
            self.capacityInfo.text = "미정"
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
