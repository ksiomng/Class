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
        let sortButtonTap: ControlEvent<Void>
        let categoryTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let list: Driver<[ClassInfo]>
        let isLatest: BehaviorRelay<Bool>
        let selectedCategory: BehaviorRelay<[String]>
        let allCategories: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: Category.names)
    }
    
    private let allList = BehaviorRelay<[ClassInfo]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let list = BehaviorRelay<[ClassInfo]>(value: [])
        let isLatest = BehaviorRelay<Bool>(value: true)
        let selectedCategory = BehaviorRelay<[String]>(value: ["전체"])
        
        input.reload
            .withLatestFrom(Observable.combineLatest(selectedCategory, isLatest))
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
            .combineLatest(selectedCategory, isLatest)
            .skip(1)
            .bind(with: self) { owner, state in
                let processedData = owner.sortAndFilter(data: owner.allList.value, categories: state.0, isLatest: state.1)
                list.accept(processedData)
            }
            .disposed(by: disposeBag)
        
        input.sortButtonTap
            .withLatestFrom(isLatest) {_,value in
                return !value
            }
            .bind(to: isLatest)
            .disposed(by: disposeBag)
        
        input.categoryTap
            .map { Category.names[$0.row] }
            .withLatestFrom(selectedCategory) { tapped, current in
                var updated = current
                
                if tapped == "전체" {
                    updated = ["전체"]
                } else {
                    updated.removeAll { $0 == "전체" }
                    
                    if updated.contains(tapped) {
                        updated.removeAll { $0 == tapped }
                        if updated.isEmpty {
                            updated.append("전체")
                        }
                    } else {
                        updated.append(tapped)
                    }
                }
                
                return updated
            }
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        return Output(list: list.asDriver(), isLatest: isLatest, selectedCategory: selectedCategory)
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
