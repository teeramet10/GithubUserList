//
//  UserRepositoryListViewModel.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
class UserRepositoryListViewModel : UserRepositoryInterface , UserRepositoryViewModelOutput{
    
    //Interface
    var input: UserRepositoryViewModelInput {return self}
    var output: UserRepositoryViewModelOutput {return self}
    
    //Output
    var showLoading: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    var onSetUser: ((GitHubUserModel) -> Void)?
    var onGetUserFailed: ((String) -> Void)?
    var onFetchDataSuccess: ((_ isEmpty : Bool) -> Void)?
    
    //Data
    var gitHubUser: GitHubUserModel?
    var listRepository: [RepositoryModel] = []
    
    var disposeBag = DisposeBag()
    let repository : GitHubUserRepositoryProtocol
    
    init(_ repository : GitHubUserRepositoryProtocol) {
        self.repository = repository
    }
}

extension UserRepositoryListViewModel: UserRepositoryViewModelInput{
    func getUser() {
        guard let user = gitHubUser else{
            self.output.onGetUserFailed?("ไม่พบข้อมูลผู้ใช้งาน")
            return
        }
        self.output.onSetUser?(user)
    }
    
    func getRepositories() {
        guard let name = gitHubUser?.login else{return}
        self.output.showLoading?(true)
        repository.getUserRepositorie(name).subscribe(onNext: {[weak self] list in
            guard let `self` = self else{return}
            self.output.showLoading?(false)
            self.listRepository = list
            let isEmpty = list.count == 0
            self.output.onFetchDataSuccess?(isEmpty)
        }, onError: {[weak self]error in
            guard let `self` = self else{return}
            self.output.showLoading?(false)
            self.output.showError?(error.describe)
        }).disposed(by: disposeBag)
    }
}
