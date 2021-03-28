//
//  MockGitHubUserDataSource.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
@testable import GitHubUserList

class MockGitHubUserDataSource : GitHubUserDataSourceProtocol{

    var isSuccess : Bool = false
    var isEmpty : Bool = false

    func getUser(_ query: String) -> Observable<SearchEntity<GitHubUserEntity>> {
        guard isSuccess else{
            return .error(AppError("Something wrong."))
        }
        let response = SearchEntity<GitHubUserEntity>()
        guard !isEmpty else { return .just(response)}
        let model = GitHubUserEntity()
        model.id = 1
        model.login = "test1"
        response.items = [model]
        return .just(response)
    }
    
    func getUserList() -> Observable<[GitHubUserEntity]> {
        guard isSuccess else{
            return .error(AppError("Something wrong."))
        }
        guard !isEmpty else { return .just([])}
        let model1 = GitHubUserEntity()
        model1.id = 1
        model1.login = "test1"

        let model2 = GitHubUserEntity()
        model2.id = 2
        model2.login = "test2"
        return .just([model1,model2])
    }
    
    func getUserRepositorie(_ name: String) -> Observable<[RepositoryEntity]> {
        guard !name.isEmpty else{
            return .error(AppError("Not found Username."))
        }
        guard isSuccess else{
            return .error(AppError("Something wrong."))
        }
        guard !isEmpty else { return .just([])}
        let model1 = RepositoryEntity()
        model1.fullName = "test1"
        model1.language = "Swift"
        model1.stargazersCount = 10

        let model2 = RepositoryEntity()
        model2.fullName = "test1"
        model2.language = "Kotlin"
        model2.stargazersCount = 5

        return .just([model1,model2])
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
