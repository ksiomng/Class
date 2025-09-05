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
    
    let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let list = BehaviorRelay<[ClassInfo]>(value: [])
        
        input.callData
            .bind {
                NetworkManager.shared.callRequest(api: .loadClass, type: ClassInfoResponse.self) { result in
                    switch result {
                    case .success(let success):
                        list.accept(success.data)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        return Output(list: list.asDriver())
    }
}
