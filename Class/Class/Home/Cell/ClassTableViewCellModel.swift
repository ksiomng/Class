//
//  ClassTableViewCellModel.swift
//  Class
//
//  Created by Song Kim on 9/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ClassTableViewCellModel {
    
    struct Input {
        let imagePath: String
    }
    
    struct Output {
        var image: Driver<UIImage>
    }
    
    let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let image = BehaviorRelay<UIImage>(value: UIImage())
        
        NetworkManager.shared.callImage(imagePath: input.imagePath) { result in
            switch result {
            case .success(let success):
                image.accept(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
        return Output(image: image.asDriver())
    }
}
