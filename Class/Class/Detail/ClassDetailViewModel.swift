//
//  ClassDetailViewModel.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ClassDetailViewModel {
    
    struct Input {
        let detailsData: BehaviorRelay<ClassDetailInfo>
        let likeButtonTap: ControlEvent<Void>
        let liked: Bool
    }
    
    struct Output {
        let images: BehaviorRelay<[UIImage]>
        let profileImage: BehaviorRelay<UIImage>
        let commentsCount: BehaviorRelay<Int>
        let isLiked: BehaviorRelay<Bool>
        let toastMsg: PublishRelay<String>
        let showAlert: PublishRelay<String>
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let images = BehaviorRelay<[UIImage]>(value: [])
        let profileImage = BehaviorRelay<UIImage>(value: UIImage())
        let commentsCount = BehaviorRelay<Int>(value: 0)
        let isLiked = BehaviorRelay<Bool>(value: input.liked)
        let toastMsg = PublishRelay<String>()
        let showAlert = PublishRelay<String>()
        
        input.detailsData
            .bind(with: self) { owner, value in
                for image_url in value.image_urls {
                    NetworkManager.shared.callImage(api: .image(path: image_url)) { result in
                        switch result {
                        case .success(let success):
                            var currentImages = images.value
                            currentImages.append(success)
                            images.accept(currentImages)
                        case .failure(let failure):
                            showAlert.accept(failure.message)
                        }
                    }
                }
                
                if let image = value.creator.profileImage {
                    NetworkManager.shared.callImage(api: .image(path: image)) { result in
                        switch result {
                        case .success(let success):
                            profileImage.accept(success)
                        case .failure(let failure):
                            showAlert.accept(failure.message)
                        }
                    }
                } else {
                    profileImage.accept(UIImage(systemName: "person.fill")!)
                }
                
                NetworkManager.shared.callRequest(api: .comment(id: value.class_id), type: Comments.self) { result in
                    switch result {
                    case .success(let success):
                        commentsCount.accept(success.data.count)
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.likeButtonTap
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .like(id: input.detailsData.value.class_id, status: !isLiked.value), type: Like.self) { result in
                    switch result {
                    case .success(let success):
                        isLiked.accept(success.like_status)
                        if success.like_status {
                            toastMsg.accept("[\(input.detailsData.value.title)] 클래스를 찜했습니다.")
                        } else {
                            toastMsg.accept("[\(input.detailsData.value.title)] 클래스 찜을 취소했습니다.")
                        }
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(images: images, profileImage: profileImage, commentsCount: commentsCount, isLiked: isLiked, toastMsg: toastMsg, showAlert: showAlert)
    }
}
