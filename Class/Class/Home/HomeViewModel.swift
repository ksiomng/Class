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
        let selectedCategory: BehaviorRelay<[String]>
        let isLatest: BehaviorRelay<Bool>
    }
    
    struct Output {
        let list: Driver<[ClassInfo]>
    }
    
    let categories = BehaviorRelay<[String]>(value: Category.names)
    private let allList = BehaviorRelay<[ClassInfo]>(value: [])
    let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let list = BehaviorRelay<[ClassInfo]>(value: [])
        
        input.callData
            .bind(with: self) { owenr, _ in
                NetworkManager.shared.callRequest(api: .loadClass, type: ClassInfoResponse.self) { result in
                    switch result {
                    case .success(let success):
                        list.accept(success.data)
                        owenr.allList.accept(success.data)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.selectedCategory
            .bind(with: self) { owner, value in
                print(value)
                list.accept(owner.filterCategory(categories: value))
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(input.isLatest, input.selectedCategory)
            .bind(with: self) { owner, value in
                if value.0 {
                    list.accept(owner.sortByLatest(list: list.value))
                } else {
                    list.accept(owner.sortByHighPrice(list: list.value))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(list: list.asDriver())
    }
    
    private func sortByLatest(list: [ClassInfo]) -> [ClassInfo] {
        let sorted = list.sorted { $0.created_at > $1.created_at }
        return sorted
    }
    
    private func sortByHighPrice(list: [ClassInfo]) -> [ClassInfo] {
        let sorted = list.sorted { lhs, rhs in
            let lhsPrice = lhs.price ?? 0
            let rhsPrice = rhs.price ?? 0
            if lhsPrice == rhsPrice {
                return lhs.created_at > rhs.created_at
            } else {
                return lhsPrice > rhsPrice
            }
        }
        return sorted
    }
    
    private func filterCategory(categories: [String]) -> [ClassInfo] {
        let result = allList.value.filter { classInfo in
            return categories.contains(Category.categories[classInfo.category]!)
        }
        return result
    }
}
