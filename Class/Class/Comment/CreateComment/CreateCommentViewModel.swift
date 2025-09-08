//
//  CreateCommentViewModel.swift
//  Class
//
//  Created by Song Kim on 9/8/25.
//


import UIKit
import RxSwift
import RxCocoa

final class CreateCommentViewModel {
    
    struct Input {
        let detailData: ClassDetailInfo
        let commentData: Comment?
        let isCreated: Bool
        let content: ControlProperty<String>
        let okButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let status: BehaviorRelay<Bool>
        let statusText: BehaviorRelay<String>
        let statusColor: BehaviorRelay<UIColor>
        let successWriteComment: PublishSubject<Bool>
        let showAlert: PublishRelay<String>
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let status = BehaviorRelay<Bool>(value: false)
        let statusText = BehaviorRelay<String>(value: "0/200")
        let statusColor = BehaviorRelay<UIColor>(value: .grayC)
        let successWriteComment = PublishSubject<Bool>()
        let showAlert = PublishRelay<String>()
        
        input.content
            .map { $0.replacingOccurrences(of: " ", with: "") }
            .bind(with: self) { owner, text in
                let count = text.count
                
                statusText.accept("\(count)/200")
                statusColor.accept(count >= 150 ? .orangeC : .grayC)
                status.accept(count >= 2 && count <= 200)
                
                if count > 200 {
                    statusText.accept("200자 초과")
                }
            }
            .disposed(by: disposeBag)
        
        input.okButtonTap
            .withLatestFrom(input.content)
            .bind(with: self) { owner, value in
                if input.isCreated {
                    NetworkManager.shared.callRequest(api: .writeComment(id: input.detailData.class_id, content: value), type: Comment.self) { result in
                        switch result {
                        case .success(_):
                            successWriteComment.onNext(true)
                        case .failure(let failure):
                            showAlert.accept(failure.message)
                        }
                    }
                } else {
                    NetworkManager.shared.callRequest(api: .editComment(id: input.detailData.class_id, commentId: input.commentData!.comment_id, content: value), type: Comment.self) { result in
                        switch result {
                        case .success(_):
                            successWriteComment.onNext(true)
                        case .failure(let failure):
                            showAlert.accept(failure.message)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(status: status, statusText: statusText, statusColor: statusColor, successWriteComment: successWriteComment, showAlert: showAlert)
    }
}
