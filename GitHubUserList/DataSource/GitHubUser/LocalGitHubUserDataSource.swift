//
//  LocalGitHubUserDataSource.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 25/3/2564 BE.
//

import Foundation
import RxSwift
class LocalGitHubUserDataSource : GitHubUserDataSourceProtocol{
    
    var dataProvider : FavoriteLocalDataProvider
    
    init(_ dataProvider : FavoriteLocalDataProvider){
        self.dataProvider = dataProvider
    }

    func getUser(_ query: String) -> Observable<SearchEntity<GitHubUserEntity>> {
        return .empty()
    }

    func getUserList() -> Observable<[GitHubUserEntity]> {
        return .empty()
    }

    func getUserRepositorie(_ name: String) -> Observable<[RepositoryEntity]> {
        return .empty()
    }

    func addFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        return Observable.just(dataProvider.save(data))
    }

    func removeFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        return Observable.just(dataProvider.delete(data.id))
    }

    func getFavoriteList() -> Observable<[GitHubUserLocalModel]> {
        return .just(dataProvider.getFavUser()) 
    }
}
