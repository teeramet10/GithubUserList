//
//  GitHubUserRepository.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
class GitHubUserRepository :GitHubUserRepositoryProtocol{

    var dataSource : GitHubUserDataSourceProtocol
    var localDataSource : GitHubUserDataSourceProtocol
    
    init(_ dataSource : GitHubUserDataSourceProtocol , _ localDataSource : GitHubUserDataSourceProtocol){
        self.dataSource = dataSource
        self.localDataSource = localDataSource
    }
    
    func getUser(_ query: String) -> Observable<[GitHubUserModel]> {
        let favList = self.localDataSource.getFavoriteList()
        let userList =  self.dataSource.getUser(query)
        return Observable.zip(userList,favList).map {(users , favs) -> [GitHubUserModel] in
            return users.items?.map{user in
                let model = user.toModel()
                favs.forEach{data in
                    if let id = model.id {
                        if id == data.id{
                            model.isFavorite = true
                            return
                        }
                    }
                }
                return model
            } ?? []
        }
    }
    
    func getUserList() -> Observable<[GitHubUserModel]> {
        let favList = self.localDataSource.getFavoriteList()
        let userList =  self.dataSource.getUserList()
        return Observable.zip(userList,favList).map {(users , favs) -> [GitHubUserModel] in
            return users.map{user in
                let model = user.toModel()
                favs.forEach{data in
                    if let id = model.id {
                        if id == data.id{
                            model.isFavorite = true
                            return
                        }
                    }
                }
                return model
            }
        }
    }
    
    func getUserRepositorie(_ name: String) -> Observable<[RepositoryModel]> {
        return dataSource.getUserRepositorie(name).map{data in
            data.map{$0.toModel()}
        }
    }
    
    func getFavoriteList() -> Observable<[GitHubUserModel]> {
        return localDataSource.getFavoriteList().map{data in
            data.map{
                let model = $0.toModel()
                model.isFavorite = true
                return model
            }
        }
    }
    
    func addFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        return localDataSource.addFavorite(data)
    }
    
    func removeFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        return localDataSource.removeFavorite(data)
    }
    
}
