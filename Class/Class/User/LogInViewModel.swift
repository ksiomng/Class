//
//  LogInViewModel.swift
//  Class
//
//  Created by Song Kim on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LogInViewModel {
    
    struct Input {
        let emailTextField: ControlProperty<String>
        let passwordTextField: ControlProperty<String>
        let loginButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let enabledButton: BehaviorRelay<Bool>
        let statusString: BehaviorRelay<String>
        let login: PublishRelay<Bool>
    }
    
    init() { }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let statusBool = BehaviorRelay(value: false)
        let statusString = BehaviorRelay(value: "")
        let loginSubject = PublishRelay<Bool>()
        
        Observable
            .combineLatest(input.emailTextField, input.passwordTextField)
            .bind(with: self) { owner, value in
                let email = value.0
                let password = value.1
                
                statusBool.accept(false)
                
                if email.isEmpty || password.isEmpty {
                    statusString.accept("이메일과 비밀번호를 입력해주세요")
                } else if !(email.contains("@") && email.contains(".com")) {
                    statusString.accept("이메일에 @와 .com 을 포함해주세요")
                } else if (password.count < 2) || (password.count >= 10) {
                    statusString.accept("비밀번호는 2글자 이상 10글자 미만으로 설정해주세요")
                } else {
                    statusString.accept("")
                    statusBool.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.loginButtonTap
            .withLatestFrom(
                Observable.combineLatest(input.emailTextField, input.passwordTextField))
            .bind { email, password in
                NetworkManager.shared.callRequest(api: .login(email: email, password: password), type: Login.self) { result in
                    switch result {
                    case .success(let login):
                        UserDefaultsHelper.shared.token = login.accessToken
                        UserDefaultsHelper.shared.userId = login.user_id
                        loginSubject.accept(true)
                    case .failure(_):
                        loginSubject.accept(false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(enabledButton: statusBool, statusString: statusString, login: loginSubject)
    }
}
