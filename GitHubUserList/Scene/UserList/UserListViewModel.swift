//
//  UserListViewModel.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import RxSwift
class UsetListViewModel : UserListInterface , UserListViewModelOutput{
    
    //Interface
    var input: UserListViewModelInput {return self}
    var output: UserListViewModelOutput {return self}
    
    //Output
    var onSearch: ((String)->Void)?
    var onLoadDataSuccess: ((_ isEmpty : Bool) -> Void)?
    var onFilterDataSuccess: ((_ favImage: UIImage?) -> Void)?
    var onSortDataSuccess: ((_ isEmpty : Bool) -> Void)?
    var onInsertFavoriteSuccess: ((_ index : Int) -> Void)?
    var onInsertFavoriteFailed: ((_ errorMessage :String) -> Void)?
    var onRemoveFavoriteSuccess: ((_ index : Int, _ isEmpty : Bool) -> Void)?
    var onReloadRemoveFavoriteSuccess: ((_ index : Int) -> Void)?
    var onRemoveFavoriteFailed: ((_ errorMessage :String) -> Void)?
    var showLoading: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    var showSortView:((SortType , UIView) -> Void)?
    
    //Data
    var userList : [GitHubUserModel] = []
    var filterUserList: [GitHubUserModel] = []
    var sortType : SortType = .none
    var isFilterFavorite: Bool = false
    
    var disposeBag = DisposeBag()
    var repository : GitHubUserRepositoryProtocol
    private var dispatchWork: DispatchWorkItem?
    
    init(_ repository : GitHubUserRepositoryProtocol) {
        self.repository = repository
    }
    
    private func getUserList( _ complete : @escaping (([GitHubUserModel]) -> Void)) {
        self.output.showLoading?(true)
        repository.getUserList().subscribe(onNext: {list in
            self.output.showLoading?(false)
            complete(list)
        }, onError: {[weak self]error in
            guard let `self` = self else{return}
            self.output.showLoading?(false)
            self.output.showError?(error.describe)
        }).disposed(by: disposeBag)
    }
    
    private func getUser(_ query: String  ,_ complete : @escaping (([GitHubUserModel]) -> Void)) {
        self.output.showLoading?(true)
        repository.getUser(query).subscribe(onNext: {list in
            self.output.showLoading?(false)
            complete(list)
        }, onError: {[weak self]error in
            guard let `self` = self else{return}
            self.output.showLoading?(false)
            self.output.showError?(error.describe)
        }).disposed(by: disposeBag)
    }
    
    private func getFavoriteList(_ complete : @escaping (([GitHubUserModel]) -> Void)){
        self.output.showLoading?(true)
        repository.getFavoriteList().subscribe(onNext: {[weak self]list in
            guard let `self` = self else{return}
            self.output.showLoading?(false)
            complete(list)
        }, onError: {[weak self]error in
            guard let `self` = self else{return}
            self.output.showLoading?(false)
            self.output.showError?(error.describe)
        }).disposed(by: disposeBag)
    }
    
    private func filter(_ query : String){
        self.output.showLoading?(true)
        if(query != ""){
            self.filterUserList = userList.filter{($0.login?.lowercased().contains(query.lowercased()) ?? false)}
        }else{
            self.filterUserList = userList
        }
        self.output.showLoading?(false)
        self.output.onLoadDataSuccess?(self.filterUserList.isEmpty)
    }
    
    private func sortList(_ list : [GitHubUserModel]) -> [GitHubUserModel]{
        var newList = list
        switch self.sortType {
        case .name:
            newList = newList.sorted { ($0.login?.lowercased() ?? "") < ($1.login?.lowercased() ?? "")}
        case .favorite:
            newList = newList.sorted{ $0.isFavorite && !$1.isFavorite}
        case .none:
           break
        }
        return newList
    }
}

extension UsetListViewModel : UserListViewModelInput{
    func fetchUser(_ query: String) {
        let complete : (([GitHubUserModel]) -> Void) = {[weak self] list in
            guard let `self` = self else{return}
            var newList = list
            if  self.isFilterFavorite{
                newList = newList.filter{$0.isFavorite}
            }
            newList = self.sortList(newList)
            self.userList = list
            self.filterUserList = newList
            let isEmpty = self.filterUserList.isEmpty
            self.output.onLoadDataSuccess?(isEmpty)
        }
        
        guard !isFilterFavorite else{
            self.filter(query)
            return
        }
        guard !query.isEmpty else{
            self.getUserList(complete)
            return
        }
        self.getUser(query,complete)
    }

    func didAddFavorite(data: GitHubUserModel , _ index :Int) {
        repository.addFavorite(data).subscribe(onNext: { [weak self ]isSuccess in
            guard let `self` = self else{return}
            guard isSuccess else{
                self.output.onInsertFavoriteFailed?("ไม่สามารถเพิ่มรายการโปรดได้")
                return
            }
            guard index < self.filterUserList.count else{
                self.output.onInsertFavoriteFailed?("ไม่สามารถเพิ่มรายการโปรดได้")
                return
            }
            self.filterUserList[index].isFavorite = true
            self.output.onInsertFavoriteSuccess?(index)
        }, onError: {[weak self]_ in
            guard let `self` = self else{return}
            self.output.onInsertFavoriteFailed?("ไม่สามารถเพิ่มรายการโปรดได้")
        }).disposed(by: disposeBag)
    }
    
    func didRemoveFavorite(data: GitHubUserModel,_ index :Int) {

        repository.removeFavorite(data).subscribe(onNext: { [weak self]isSuccess in
            guard let `self` = self else{return}
            guard isSuccess else{
                self.output.onRemoveFavoriteFailed?("ไม่สามารถลบรายการโปรดได้")
                return
            }
            guard !self.isFilterFavorite else{
                guard index < self.filterUserList.count else{
                    self.output.onRemoveFavoriteFailed?("ไม่สามารถลบรายการโปรดได้")
                    return
                }
                self.filterUserList.remove(at: index)
                let isEmpty = self.filterUserList.isEmpty
                self.output.onRemoveFavoriteSuccess?(index,isEmpty)
                return
            }
            guard index < self.filterUserList.count else{
                self.output.onRemoveFavoriteFailed?("ไม่สามารถลบรายการโปรดได้")
                return
            }
            self.filterUserList[index].isFavorite = false
            self.output.onReloadRemoveFavoriteSuccess?(index)
        }, onError: {[weak self] _ in
            guard let `self` = self else{return}
            self.output.onRemoveFavoriteFailed?("ไม่สามารถลบรายการโปรดได้")
        }).disposed(by: disposeBag)
    }

    func sortList(_ sortType : SortType) {
        self.sortType = sortType
        let list = self.sortList(userList)
        self.filterUserList = list
        let isEmpty = list.isEmpty
        self.output.onSortDataSuccess?(isEmpty)
    }

    func filterFavorite(_ query :String){
        self.isFilterFavorite = !self.isFilterFavorite
        let image:String = self.isFilterFavorite ? "ic_heart_fill" : "ic_heart"
        if isFilterFavorite{
            getFavoriteList{ [weak self] list in
                guard let `self` = self else{return}
                let newList = self.sortList(list)
                self.userList = list
                self.filterUserList = newList
                self.output.onLoadDataSuccess?(newList.isEmpty)
            }
        }else{
            self.fetchUser(query)
        }
        let isEmpty = filterUserList.isEmpty
        self.output.onFilterDataSuccess?(UIImage(named:image))
    }

    func getSortType(_ view: UIView) {
        self.output.showSortView?(self.sortType , view)
    }

    func didBufferSearch(_ text: String) {
        dispatchWork?.cancel()
        let request = DispatchWorkItem { [weak self] in
            guard let `self` = self else{return}
            self.output.onSearch?(text)
        }
        dispatchWork = request
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000),
                                      execute: request)
    }
}
