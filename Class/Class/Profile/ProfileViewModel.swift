//
//  ProfileViewModel.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    struct Input {
        let logoutButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let logout: Observable<Void>
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let logoutSubject = PublishSubject<Void>()
        
        input.logoutButtonTap
            .bind(with: self) { owner, _ in
                UserDefaultsHelper.shared.clearToken()
                logoutSubject.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(logout: logoutSubject.asObservable())
    }
}
