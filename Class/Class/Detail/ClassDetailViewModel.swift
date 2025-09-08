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
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let images = BehaviorRelay<[UIImage]>(value: [])
        let profileImage = BehaviorRelay<UIImage>(value: UIImage())
        let commentsCount = BehaviorRelay<Int>(value: 0)
        let isLiked = BehaviorRelay<Bool>(value: input.liked)
        
        input.detailsData
            .bind(with: self) { owner, value in
                for image_url in value.image_urls {
                    NetworkManager.shared.callImage(imagePath: image_url) { result in
                        switch result {
                        case .success(let success):
                            var currentImages = images.value
                            currentImages.append(success)
                            images.accept(currentImages)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
                
                if let image = value.creator.profileImage {
                    NetworkManager.shared.callImage(imagePath: image) { result in
                        switch result {
                        case .success(let success):
                            profileImage.accept(success)
                        case .failure(let failure):
                            print(failure)
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
                        print(failure)
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
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(images: images, profileImage: profileImage, commentsCount: commentsCount, isLiked: isLiked)
    }
}
