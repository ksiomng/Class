//
//  SearchClassTableViewCellModel.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchClassTableViewCellModel {
    
    struct Input {
        let imagePath: String
        let likeButtonTap: ControlEvent<Void>
        let id: String
        let liked: Bool
    }
    
    struct Output {
        let image: Driver<UIImage>
        let isLiked: BehaviorRelay<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let image = BehaviorRelay<UIImage>(value: UIImage())
        let isLiked = BehaviorRelay<Bool>(value: input.liked)
        
        NetworkManager.shared.callImage(imagePath: input.imagePath) { result in
            switch result {
            case .success(let success):
                image.accept(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
        input.likeButtonTap
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .like(id: input.id, status: !isLiked.value), type: Like.self) { result in
                    switch result {
                    case .success(let success):
                        isLiked.accept(success.like_status)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(image: image.asDriver(), isLiked: isLiked)
    }
}
