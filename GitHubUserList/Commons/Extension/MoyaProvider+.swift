//
//  MoyaProvider+.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 25/3/2564 BE.
//

import Foundation
import Moya
import RxSwift
extension MoyaProvider {
    
    func requestAPI<T : Codable> (_ target : Target) -> Observable<T>{
        if InternetUtils.isConnect(){
            let request = self.rx.request(target).debug()
            return request
                .filter(statusCodes: 200...299)
                .map(T.self)
                .asObservable()
                .catchError{error in throw AppError(error:error)}
        }else{
            return .error( AppError.init("Internet isn't connected"))
        }
    }
}
