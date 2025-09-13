//
//  SearchViewModel.swift
//  Class
//
//  Created by Song Kim on 9/7/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    struct Input {
        let reload: PublishRelay<Void>
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let moveDetailTap: ControlEvent<ClassInfo>
    }
    
    struct Output {
        let message: BehaviorRelay<String?>
        let list: Driver<[ClassInfo]>
        let moveDetail: PublishRelay<ClassDetailInfo?>
        let showAlert: PublishRelay<String>
    }
    
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let message = BehaviorRelay<String?>(value: "원하는 클래스가 있으신가요?")
        let list = BehaviorRelay<[ClassInfo]>(value: [])
        let moveDetail = PublishRelay<ClassDetailInfo?>()
        let showAlert = PublishRelay<String>()
        
        input.reload
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, value in
                NetworkManager.shared.callRequest(api: .seasrch(keyword: value), type: ClassInfoResponse.self) { result in
                    switch result {
                    case .success(let success):
                        list.accept(success.data)
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.searchTap
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                NetworkManager.shared.callRequest(api: .seasrch(keyword: value), type: ClassInfoResponse.self) { result in
                    switch result {
                    case .success(let success):
                        list.accept(success.data)
                        if success.data.count == 0 {
                            message.accept("검색 결과가 없습니다.")
                        } else {
                            message.accept(nil)
                        }
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.moveDetailTap
            .bind(with: self) { owner , model in
                NetworkManager.shared.callRequest(api: .detail(id: model.classId), type: ClassDetailInfo.self) { result in
                    switch result {
                    case .success(let success):
                        moveDetail.accept(success)
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(message: message, list: list.asDriver(), moveDetail: moveDetail, showAlert: showAlert)
    }
}
