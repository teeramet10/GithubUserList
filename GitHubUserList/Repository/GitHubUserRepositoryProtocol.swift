//
//  GitHubUserRepositoryProtocol.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
protocol GitHubUserRepositoryProtocol {
    func getUser(_ query :String) -> Observable<[GitHubUserModel]>
    func getUserList() -> Observable<[GitHubUserModel]>
    func getUserRepositorie(_ name :String) -> Observable<[RepositoryModel]>
    func getFavoriteList() -> Observable<[GitHubUserModel]>
    func addFavorite(_ data : GitHubUserModel) -> Observable<Bool>
    func removeFavorite(_ data : GitHubUserModel) -> Observable<Bool>
}
