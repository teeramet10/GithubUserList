//
//  GitHubUserDataSource.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
import Moya
class GitHubUserDataSource : GitHubUserDataSourceProtocol{
    
    let provider : MoyaProvider<GitHubUserAPI>
    
    init(){
        provider = MoyaProvider<GitHubUserAPI>()
    }
    
    func getUser(_ query: String) -> Observable<SearchEntity<GitHubUserEntity>> {
        return provider.requestAPI(.getUser(query))
    }
    
    func getUserList() -> Observable<[GitHubUserEntity]> {
        return provider.requestAPI(.getUserList)
    }
    
    func getUserRepositorie(_ name: String) -> Observable<[RepositoryEntity]> {
        return provider.requestAPI(.getUserRepositorie(name))
    }
    
    func addFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        return .empty()
    }
    
    func removeFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        return .empty()
    }
    
    func getFavoriteList() -> Observable<[GitHubUserLocalModel]> {
        return .empty()
    }
}
