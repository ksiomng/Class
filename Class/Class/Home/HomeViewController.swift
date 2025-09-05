//
//  HomeViewController.swift
//  Class
//
//  Created by Song Kim on 9/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
        tableView.register(ClassTableViewCell.self, forCellReuseIdentifier: ClassTableViewCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func bind() {
        let reload = BehaviorRelay<Void>(value: ())
        let input = HomeViewModel.Input(callData: reload)
        let output = viewModel.transform(input: input)
        
        output.list
            .drive(classTableView.rx
                .items(cellIdentifier: ClassTableViewCell.identifier,
                       cellType: ClassTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.bind(id: element.class_id) { _ in
                    reload.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        output.list
            .drive(with: self) { owner, list in
                owner.totalCountLabel.text = StringFormatter.formatWithComma(list.count) + "개"
            }
            .disposed(by: disposeBag)
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
            make.horizontalEdges.equalToSuperview()
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
