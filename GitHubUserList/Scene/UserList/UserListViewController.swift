//
//  UserListViewController.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import UIKit

class UserListViewController: BaseViewController {

    @IBOutlet weak var tableView :UITableView!
    @IBOutlet weak var favItemButton : UIBarButtonItem!
    @IBOutlet weak var filterButton : UIButton!
    @IBOutlet weak var searchBar : UISearchBar!
    weak var emptyView : EmptyView!
    var refreshControl = UIRefreshControl()
    
    var viewModel : UsetListViewModel!
    var router : UserListRoutingProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
        let dataSource = GitHubUserDataSource()
        let localDataSource = LocalGitHubUserDataSource(FavoriteLocalDataProvider())
        let repository = GitHubUserRepository(dataSource,localDataSource)
        viewModel = UsetListViewModel(repository)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.input.fetchUser("")
    }
    
    override func setup() {
        self.router = UserListRouter(self)
    }
    
    override func setupUI() {
        title = "Users"
        let emptyView = EmptyView(frame: tableView.frame)
        self.emptyView = emptyView
        refreshControl.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.identifier)
        self.emptyView.isHidden = true
        tableView.backgroundView = emptyView
        setTintColorButton()
    }

    func setTintColorButton(){
        if #available(iOS 13.0, *) {
            switch self.traitCollection.userInterfaceStyle {
            case .light:
                filterButton.tintColor = .black
            default:
                filterButton.tintColor = .white
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        setTintColorButton()
    }

    override func bindViewModel() {
        self.viewModel.output.onLoadDataSuccess = onLoadDataSuccess()
        self.viewModel.output.onSortDataSuccess = onSortDataSuccess()
        self.viewModel.output.onFilterDataSuccess = onFilterDataSuccess()
        self.viewModel.output.onInsertFavoriteSuccess = onInsertFavoriteSuccess()
        self.viewModel.output.onInsertFavoriteFailed = onInsertFavoriteFailed()
        self.viewModel.output.onRemoveFavoriteSuccess = onRemoveFavoriteSuccess()
        self.viewModel.output.onRemoveFavoriteFailed = onRemoveFavoriteFailed()
        self.viewModel.output.showSortView = showSortView()
        self.viewModel.output.showLoading = showLoading()
        self.viewModel.output.showError = showError()
        self.viewModel.output.onSearch = onSearch()
        self.viewModel.output.onReloadRemoveFavoriteSuccess = onReloadRemoveFavoriteSuccess()
    }
    
    @objc func onRefresh(_ sender: UIRefreshControl) {
        self.viewModel.input.fetchUser(searchBar.text ?? "")
    }
    
    @IBAction func didSort(sender :UIButton){
        self.viewModel.input.getSortType(sender)
    }
    
    @IBAction func didFilter(_ sender: Any) {
        self.viewModel.input.filterFavorite(searchBar.text ?? "")
    }
}

extension UserListViewController{
    func onLoadDataSuccess() ->  ((_ isEmpty : Bool) -> Void){
        return {[weak self] isEmpty in
            guard let `self` = self else{return}
            self.emptyView.isHidden = !isEmpty
            self.tableView.separatorStyle = isEmpty ? .none : .singleLine
            self.tableView.reloadData()
        }
    }
    
    func onFilterDataSuccess() ->  ((_ favImage: UIImage?) -> Void){
        return {[weak self] favImage in
            guard let `self` = self else{return}
            self.favItemButton.image = favImage
        }
    }
    
    func onSortDataSuccess() ->  ((_ isEmpty : Bool) -> Void){
        return {[weak self] isEmpty in
            guard let `self` = self else{return}
            self.emptyView.isHidden = !isEmpty
            self.tableView.separatorStyle = isEmpty ? .none : .singleLine
            self.tableView.reloadData()
        }
    }
    
    func onInsertFavoriteFailed() ->  ((String) -> Void){
        return {[weak self] errorMessage in
            guard let `self` = self else{return}
            self.showAlert(title: "", message: errorMessage)
        }
    }
    
    func onInsertFavoriteSuccess() ->  ((Int) -> Void){
        return {[weak self] index in
            guard let `self` = self else{return}
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func onReloadRemoveFavoriteSuccess() ->  ((Int) -> Void){
        return {[weak self] index in
            guard let `self` = self else{return}
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func onRemoveFavoriteSuccess() ->  ((Int ,Bool) -> Void){
        return {[weak self] index , isEmpty in
            guard let `self` = self else{return}
            self.emptyView.isHidden = !isEmpty
            self.tableView.separatorStyle = isEmpty ? .none : .singleLine
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func onRemoveFavoriteFailed() ->  ((String) -> Void){
        return {[weak self]errorMessage in
            guard let `self` = self else{return}
            self.showAlert(title: "", message: errorMessage)
        }
    }

    func showError() ->  ((String) -> Void){
        return {[weak self] error in
            guard let `self` = self else{return}
            self.showAlert(title: "", message: error)
        }
    }
    
    func showLoading() ->  ((Bool) -> Void){
        return {[weak self] isShow in
            guard let `self` = self else{return}
            if(isShow){
                self.refreshControl.beginRefreshing()
            }else{
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func showSortView() ->  ((SortType , UIView) -> Void){
        return {[weak self] sortType , view in
            guard let `self` = self else{return}
            let vc = SortPopUpView(nibName: SortPopUpView.identifier, bundle: nil)
            vc.sortType = sortType
            vc.complete = {[weak self]sortType in
                self?.viewModel.input.sortList(sortType)
            }
            let popup = PopUpView.configure(forController: vc)
            popup?.sourceView = view
            popup?.sourceRect = view.bounds
            popup?.permittedArrowDirections = [.right]
            vc.preferredContentSize = CGSize(width: 185, height: 88)
            self.present(vc, animated: true)
        }
    }

    func onSearch() -> ((String) -> Void){
        return {[weak self] searchText in
            guard let `self` = self else{return}
            self.viewModel.fetchUser(searchText)
        }
    }
}

extension UserListViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.didBufferSearch(searchText)
    }
}

extension UserListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.filterUserList[indexPath.row]
        router?.navigateToUserRepositorieList(data)
    }
}

extension UserListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filterUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell else{
            return UITableViewCell()
        }
        let data = self.viewModel.filterUserList[indexPath.row]
        cell.delegate = self
        cell.configCell(data, indexPath.row)
        return cell
    }
}
 
extension UserListViewController: UserTableViewCellDelegate{
    func addFavorite(_ data: GitHubUserModel,_ index :Int) {
        self.viewModel.input.didAddFavorite(data: data,index)
    }
    
    func removeFavorite(_ data: GitHubUserModel,_ index :Int) {
        self.viewModel.input.didRemoveFavorite(data: data,index)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
