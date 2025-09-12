//
//  ClassTableViewCellModel.swift
//  Class
//
//  Created by Song Kim on 9/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ClassTableViewCellModel {
    
    struct Input {
        let imagePath: String
        let likeButtonTap: ControlEvent<Void>
        let id: String
        let liked: Bool
        let className: String
    }
    
    struct Output {
        var image: Driver<UIImage>
        let isLiked: BehaviorRelay<Bool>
        let toastMsg: PublishRelay<String>
        let showAlert: PublishRelay<String>
    }
    
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let image = BehaviorRelay<UIImage>(value: UIImage())
        let isLiked = BehaviorRelay<Bool>(value: input.liked)
        let toastMsg = PublishRelay<String>()
        let showAlert = PublishRelay<String>()
        
        NetworkManager.shared.callImage(api: .image(path: input.imagePath)) { result in
            switch result {
            case .success(let success):
                image.accept(success)
            case .failure(let failure):
                showAlert.accept(failure.message)
            }
        }
        
        input.likeButtonTap
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .like(id: input.id, status: !isLiked.value), type: Like.self) { result in
                    switch result {
                    case .success(let success):
                        isLiked.accept(success.likeStatus)
                        if success.likeStatus {
                            toastMsg.accept("[\(input.className)] 클래스를 찜했습니다.")
                        } else {
                            toastMsg.accept("[\(input.className)] 클래스 찜을 취소했습니다.")
                        }
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(image: image.asDriver(), isLiked: isLiked, toastMsg: toastMsg, showAlert: showAlert)
    }
}
