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
        let reload: PublishRelay<Void>
        let selectedCategory: BehaviorRelay<[String]>
        let sortButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let list: Driver<[ClassInfo]>
        let isLatest: BehaviorRelay<Bool>
    }
    
    let categories = BehaviorRelay<[String]>(value: Category.names)
    private let allList = BehaviorRelay<[ClassInfo]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let list = BehaviorRelay<[ClassInfo]>(value: [])
        let isLatest = BehaviorRelay<Bool>(value: true)
        
        input.reload
            .withLatestFrom(Observable.combineLatest(input.selectedCategory, isLatest))
            .bind(with: self) { owner, state in
                NetworkManager.shared.callRequest(api: .loadClass, type: ClassInfoResponse.self) { result in
                    switch result {
                    case .success(let success):
                        owner.allList.accept(success.data)
                        let processedData = owner.sortAndFilter(data: owner.allList.value, categories: state.0, isLatest: state.1)
                        list.accept(processedData)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(input.selectedCategory, isLatest)
            .skip(1)
            .bind(with: self) { owner, state in
                let processedData = owner.sortAndFilter(data: owner.allList.value, categories: state.0, isLatest: state.1)
                list.accept(processedData)
            }
            .disposed(by: disposeBag)
        
        input.sortButtonTap
            .bind(with: self) { owner, _ in
                let data = owner.sortAndFilter(data: list.value, categories: input.selectedCategory.value, isLatest: isLatest.value)
                list.accept(data)
                isLatest.accept(!isLatest.value)
            }
            .disposed(by: disposeBag)
        
        return Output(list: list.asDriver(), isLatest: isLatest)
    }
    
    private func sortAndFilter(data: [ClassInfo], categories: [String], isLatest: Bool) -> [ClassInfo] {
        let filterData = filterCategory(data: data, categories: categories)
        
        let sortAndFilterData = isLatest ? sortByLatest(list: filterData) : sortByHighPrice(list: filterData)
        
        return sortAndFilterData
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
    
    private func filterCategory(data: [ClassInfo], categories: [String]) -> [ClassInfo] {
        var result: [ClassInfo] = []
        if categories.contains("전체") {
            result = data
        } else {
            result = data.filter { categories.contains(Category.categories[$0.category]!) }
        }
        return result
    }
}
