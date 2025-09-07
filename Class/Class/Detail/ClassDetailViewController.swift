//
//  ClassDetailViewController.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ClassDetailViewController: UIViewController {
    
    var data: ClassDetailInfo?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return cv
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        guard let detailData = data else { return }
        view.backgroundColor = .white
        navigationItem.title = detailData.title
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
    }
    
    private func bind() {
        guard let detailData = data else { return }
        let imageList = BehaviorSubject(value: detailData.image_urls)
        
        imageList
            .bind(to: collectionView.rx
                .items(cellIdentifier: ImageCollectionViewCell.identifier,cellType: ImageCollectionViewCell.self)) { index, element, cell in
                    NetworkManager.shared.callImage(imagePath: element) { result in
                        switch result {
                        case .success(let success):
                            cell.setImage(image: success)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
                .disposed(by: disposeBag)
        
    }
}
