//
//  UserRepositoryProtocol.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
protocol UserRepositoryViewModelInput {
    func getUser()
    func getRepositories()
}

protocol UserRepositoryViewModelOutput :class {
    var showLoading: ((Bool) -> Void)? {get set}
    var showError : ((String) ->Void)? {get set}
    var onSetUser : ((GitHubUserModel) ->Void)? {get set}
    var onFetchDataSuccess : ((_ isEmpty : Bool)->Void)? {get set}
    var onGetUserFailed: ((String) -> Void)? {get set}
    var gitHubUser : GitHubUserModel? {get }
    var listRepository : [RepositoryModel] {get }
}

protocol UserRepositoryInterface  : UserRepositoryViewModelInput , UserRepositoryViewModelOutput {
    var input : UserRepositoryViewModelInput {get}
    var output : UserRepositoryViewModelOutput {get}
}

protocol UserRepositoryRoutingProtocol {

}
