//
//  RxSwift+.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
import RxSwift
extension Observable{
    func subscribe(onNext: ((Element) -> Void)? = nil, onError: ((AppError) -> Void)? = nil) -> Disposable{
        return  self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: onNext, onError:{error in
            guard let error = error as? AppError else{return}
            onError?(error)
        }, onCompleted: nil, onDisposed: nil)
    }
}
