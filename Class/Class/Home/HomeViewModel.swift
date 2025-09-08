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
        let moveDetailTap: ControlEvent<ClassInfo>
    }
    
    struct Output {
        let list: BehaviorRelay<[ClassInfo]>
        let isLatest: BehaviorRelay<Bool>
        let selectedCategory: BehaviorRelay<[String]>
        let allCategories: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: CategoryHelper.names)
        let moveDetail: BehaviorRelay<ClassDetailInfo?>
        let showAlert: PublishRelay<String>
        let scrollToTop: BehaviorRelay<Void>
    }
    
    private let allList = BehaviorRelay<[ClassInfo]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let list = BehaviorRelay<[ClassInfo]>(value: [])
        let isLatest = BehaviorRelay<Bool>(value: true)
        let selectedCategory = BehaviorRelay<[String]>(value: ["전체"])
        let moveDetail = BehaviorRelay<ClassDetailInfo?>(value: nil)
        let showAlert = PublishRelay<String>()
        let scrollToTop = BehaviorRelay<Void>(value: ())
        
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
                        showAlert.accept(failure.message)
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
                scrollToTop.accept(())
            }
            .disposed(by: disposeBag)
        
        input.sortButtonTap
            .withLatestFrom(isLatest)
            .bind { value in
                isLatest.accept(!value)
            }
            .disposed(by: disposeBag)
        
        input.categoryTap
            .map { CategoryHelper.names[$0.row] }
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
        
        input.moveDetailTap
            .bind(with: self) { owner , model in
                NetworkManager.shared.callRequest(api: .detail(id: model.class_id), type: ClassDetailInfo.self) { result in
                    switch result {
                    case .success(let success):
                        moveDetail.accept(success)
                    case .failure(let failure):
                        showAlert.accept(failure.message)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(list: list, isLatest: isLatest, selectedCategory: selectedCategory, moveDetail: moveDetail, showAlert: showAlert, scrollToTop: scrollToTop)
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
            result = data.filter { categories.contains(CategoryHelper.categories[$0.category]!) }
        }
        return result
    }
}
