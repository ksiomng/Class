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
    
    struct Input { }
    
    struct Output {
        var list: PublishSubject<[ClassInfo]>
    }
    
    let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let list = PublishSubject<[ClassInfo]>()
        
        NetworkManager.shared.callRequest(api: .loadClass, type: ClassInfoResponse.self) { result in
            switch result {
            case .success(let success):
                list.onNext(success.data)
            case .failure(let failure):
                print(failure)
            }
        }
        
        
        
        return Output(list: list)
    }
}
