//
//  HomeViewModel.swift
//  Class
//
//  Created by Song Kim on 9/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    struct Input {
        let callData: BehaviorRelay<Void>
    }
    
    struct Output {
        let list: Driver<[ClassInfo]>
    }
    
    private let list = BehaviorRelay<[ClassInfo]>(value: [])
    let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        input.callData
            .bind(with: self) { owenr, _ in
                NetworkManager.shared.callRequest(api: .loadClass, type: ClassInfoResponse.self) { result in
                    switch result {
                    case .success(let success):
                        owenr.list.accept(success.data)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(list: list.asDriver())
    }
    
    func sortByLatest() {
        let sorted = list.value.sorted { $0.created_at > $1.created_at }
        list.accept(sorted)
    }
    
    func sortByHighPrice() {
        let sorted = list.value.sorted { lhs, rhs in
            let lhsPrice = lhs.price ?? 0
            let rhsPrice = rhs.price ?? 0
            if lhsPrice == rhsPrice {
                return lhs.created_at > rhs.created_at
            } else {
                return lhsPrice > rhsPrice
            }
        }
        list.accept(sorted)
    }
}
