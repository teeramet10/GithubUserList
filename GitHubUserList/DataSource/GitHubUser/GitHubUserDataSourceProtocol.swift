//
//  GitHubUserDataSourceProtocol.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
protocol GitHubUserDataSourceProtocol {
    func getUser(_ query :String) -> Observable<SearchEntity<GitHubUserEntity>>
    func getUserList() -> Observable<[GitHubUserEntity]>
    func getUserRepositorie(_ name :String) -> Observable<[RepositoryEntity]>
    func addFavorite(_ data: GitHubUserModel) -> Observable<Bool>
    func removeFavorite(_ data: GitHubUserModel) -> Observable<Bool>
    func getFavoriteList() -> Observable<[GitHubUserLocalModel]>
}
