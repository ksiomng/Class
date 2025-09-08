//
//  CommentViewModel.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentViewModel {
    struct Input {
        let data: ClassDetailInfo
        let loadData: PublishRelay<Void>
        let deleteComment: PublishRelay<String>
    }
    
    struct Output {
        let data: BehaviorRelay<[Comment]>
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let data = BehaviorRelay<[Comment]>(value: [])
        
        input.loadData
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .comment(id: input.data.class_id), type: Comments.self) { result in
                    switch result {
                    case .success(let success):
                        data.accept(success.data)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteComment
            .bind(with: self) { owner, value in
                NetworkManager.shared.callRequest(api: .deleteComment(id: input.data.class_id, commentId: value), type: EmptyResponse.self) { _ in
                    input.loadData.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return Output(data: data)
    }
}
