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

final class HomeViewController: UIViewController {
    
    private let categoryCollectionView: UICollectionView = {
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
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = .orangeC
        button.setTitleColor(.orangeC, for: .normal)
        return button
    }()
    
    private let classTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ClassTableViewCell.self, forCellReuseIdentifier: ClassTableViewCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    private let reload = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(reload: reload)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIViewController.setLeftNavigationTitle(title: "클래스 조회"))
        
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
    
    private func bind(reload: PublishRelay<Void>) {
        let input = HomeViewModel.Input(reload: reload, sortButtonTap: sortButton.rx.tap, categoryTap: categoryCollectionView.rx.itemSelected, moveDetailTap: classTableView.rx.modelSelected(ClassInfo.self))
        let output = viewModel.transform(input: input)
        
        output.list
            .asDriver()
            .drive(classTableView.rx
                .items(cellIdentifier: ClassTableViewCell.identifier,
                       cellType: ClassTableViewCell.self)) { (row, element, cell) in
                cell.setupData(row: element)
                cell.showAlert
                    .bind(with: self) { owner, message in
                        UIViewController.showAlert(message: message, viewController: owner)
                    }
                    .disposed(by: cell.disposeBag)
                cell.showToast
                    .bind(with: self) { owner, message in
                        UIViewController.showToast(message: message, viewController: owner)
                    }
                    .disposed(by: cell.disposeBag)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.list
            .asDriver()
            .drive(with: self) { owner, list in
                owner.totalCountLabel.text = StringFormatterHelper.formatWithComma(list.count) + "개"
            }
            .disposed(by: disposeBag)
        
        output.isLatest
            .asDriver()
            .drive(with: self) { owner, value in
                if value {
                    owner.sortButton.setTitle("최신순", for: .normal)
                } else {
                    owner.sortButton.setTitle("가격순", for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.allCategories
            .bind(to: categoryCollectionView.rx
                .items(cellIdentifier: CategoryCollectionViewCell.identifier,cellType: CategoryCollectionViewCell.self)) { index, element, cell in
                    cell.setCategoryName(title: element)
                    let isSelected = output.selectedCategory.value.contains(element)
                    cell.setSelectedUI(isSelected)
                }
                .disposed(by: disposeBag)
        
        output.selectedCategory
            .bind(with: self) { owner, _ in
                owner.categoryCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.moveDetail
            .skip(1)
            .bind { value in
                let vc = ClassDetailViewController()
                vc.setData(data: value)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind(with: self) { owner, message in
                UIViewController.showAlert(message: message, viewController: owner)
            }
            .disposed(by: disposeBag)
    }
}
