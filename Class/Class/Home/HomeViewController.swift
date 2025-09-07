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
        collectionView.backgroundColor = .white
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumBoldFont
        return label
    }()
    
    private let sortButton: UIButton = {
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
    private let selectedCategory = BehaviorRelay<[String]>(value: ["전체"])
    private let isLatest = BehaviorRelay<Bool>(value: true)
    let reload = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(reload: reload)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload.accept(())
    }
    
    private func bind(reload: PublishRelay<Void>) {
        let input = HomeViewModel.Input(reload: reload, selectedCategory: selectedCategory, isLatest: isLatest)
        let output = viewModel.transform(input: input)
        
        output.list
            .drive(classTableView.rx
                .items(cellIdentifier: ClassTableViewCell.identifier,
                       cellType: ClassTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element) {
                    reload.accept(())
                }
            }
                       .disposed(by: disposeBag)
        
        output.list
            .drive(with: self) { owner, list in
                owner.totalCountLabel.text = StringFormatter.formatWithComma(list.count) + "개"
            }
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind(with: self) { owner, _ in
                if owner.isLatest.value {
                    owner.isLatest.accept(false)
                    owner.sortButton.setTitle("가격순", for: .normal)
                } else {
                    owner.isLatest.accept(true)
                    owner.sortButton.setTitle("최신순", for: .normal)
                }
                owner.classTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.categories
            .bind(to: categoryCollectionView.rx
                .items(cellIdentifier: CategoryCollectionViewCell.identifier,cellType: CategoryCollectionViewCell.self)) { index, element, cell in
                    cell.setCategoryName(title: element)
                    let isSelected = self.selectedCategory.value.contains(element)
                    cell.setSelectedUI(isSelected)
                }
                .disposed(by: disposeBag)
        
        
        categoryCollectionView.rx.itemSelected
            .map { Category.names[$0.row] }
            .bind(with: self) { owner, tapped in
                var current = owner.selectedCategory.value
                
                if tapped == "전체" {
                    current = ["전체"]
                } else {
                    current.removeAll { $0 == "전체" }
                    if current.contains(tapped) {
                        current.removeAll { $0 == tapped }
                    } else {
                        current.append(tapped)
                    }
                }
                owner.selectedCategory.accept(current)
                owner.categoryCollectionView.reloadData()
                owner.classTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
