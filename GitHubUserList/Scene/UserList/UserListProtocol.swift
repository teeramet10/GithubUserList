//
//  UsetListProtocol.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import UIKit
protocol UserListViewModelInput {
    func fetchUser(_ query :String)
    func didAddFavorite(data : GitHubUserModel,_ index :Int)
    func didRemoveFavorite(data : GitHubUserModel,_ index :Int)
    func sortList(_ sortType : SortType)
    func filterFavorite(_ query :String)
    func getSortType(_ view : UIView)
    func didBufferSearch(_ text : String)
}

protocol UserListViewModelOutput :class {
    var showLoading: ((Bool) -> Void)? {get set}
    var showError : ((String) ->Void)? {get set}
    var onSearch : ((String)->Void)?{get set}
    var onLoadDataSuccess : ((_ isEmpty : Bool) ->Void)? {get set}
    var onSortDataSuccess : ((_ isEmpty : Bool) ->Void)? {get set}
    var onReloadRemoveFavoriteSuccess: ((_ index : Int) -> Void)?{get set}
    var onFilterDataSuccess : ((_ favImage: UIImage?)->Void)? {get set}
    var onInsertFavoriteSuccess : ((_ index : Int) ->Void)? {get set}
    var onInsertFavoriteFailed : ((_ errorMessage :String)->Void)? {get set}
    var onRemoveFavoriteSuccess : ((_ index : Int ,_ isEmpty :Bool) ->Void)? {get set}
    var onRemoveFavoriteFailed : ((_ errorMessage :String)->Void)? {get set}
    var showSortView:((SortType , UIView) -> Void)? {get set}
    var userList : [GitHubUserModel] {get}
    var filterUserList : [GitHubUserModel] {get}
    var sortType : SortType {get}
    var isFilterFavorite : Bool {get}
}

protocol UserListInterface  : UserListViewModelInput , UserListViewModelOutput {
    var input : UserListViewModelInput {get}
    var output : UserListViewModelOutput {get}
}

protocol UserListRoutingProtocol {
    func navigateToUserRepositorieList(_ data : GitHubUserModel?)
}
