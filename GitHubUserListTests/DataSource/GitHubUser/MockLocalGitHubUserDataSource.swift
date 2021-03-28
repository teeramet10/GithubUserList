//
//  MockLocalGitHubUserDataSource.swift
//  GitHubUserListTests
//
//  Created by Teeramet Kanchanapiroj on 27/3/2564 BE.
//

import RxSwift
import Foundation
@testable import GitHubUserList
class MockLocalGitHubUserDataSource : GitHubUserDataSourceProtocol{

    var isSuccess : Bool = false
    var isEmpty : Bool = false

    var dataProvider : MockFavoriteLocalDataProvider

    init(_ dataProvider : MockFavoriteLocalDataProvider){
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
        guard isSuccess else{
            return .error(AppError("Something wrong."))
        }
        return .just(dataProvider.save(data))
    }

    func removeFavorite(_ data: GitHubUserModel) -> Observable<Bool> {
        guard isSuccess else{
            return .error(AppError("Something wrong."))
        }
        return .just(dataProvider.delete(data.id))
    }

    func getFavoriteList() -> Observable<[GitHubUserLocalModel]> {
        guard isSuccess else{
            return .error(AppError("Something wrong."))
        }
        guard !isEmpty else { return .just([])}
        let list = dataProvider.getFavUser()
        return .just(list)
    }

}
