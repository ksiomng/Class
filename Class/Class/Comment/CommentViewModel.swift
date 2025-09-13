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
        let comments: [Comment]
    }
    
    struct Output {
        let data: BehaviorRelay<[Comment]>
        let showAlert: PublishRelay<String>
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let data = BehaviorRelay<[Comment]>(value: input.comments)
        let showAlert = PublishRelay<String>()
        
        input.loadData
            .skip(1)
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: .comment(id: input.data.classId), type: Comments.self) { result in
                    switch result {
                    case .success(let success):
                        data.accept(success.data)
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteComment
            .bind(with: self) { owner, value in
                NetworkManager.shared.callRequest(api: .deleteComment(id: input.data.classId, commentId: value), type: EmptyResponse.self) { _ in
                    input.loadData.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return Output(data: data, showAlert: showAlert)
    }
}
