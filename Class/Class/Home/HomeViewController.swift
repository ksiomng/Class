//
//  HomeViewController.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: 60, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        label.text = "4,400"
        return label
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .mediumBoldFont
        button.setTitle("최신순", for: .normal)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = .orangeC
        button.setTitleColor(.orangeC, for: .normal)
        return button
    }()
    
    private lazy var classTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ClassTableViewCell.self, forCellReuseIdentifier: ClassTableViewCell.identifier)
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func bind() {
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: setLeftNavigationTitle(title: "클래스 조회"))
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        
        view.addSubview(totalCountLabel)
        view.addSubview(sortButton)
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(totalCountLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        view.addSubview(classTableView)
        classTableView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Category.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.setCategoryName(title: Category.names[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassTableViewCell.identifier, for: indexPath) as! ClassTableViewCell
        cell.bindData(image: "https://cdn.travie.com/news/photo/first/201710/img_19975_1.jpg", title: "하이", content: "ㅇ너ㅏ리너ㅏ리너ㅏ", price: nil, salePrice: nil, category: "외국어")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}
