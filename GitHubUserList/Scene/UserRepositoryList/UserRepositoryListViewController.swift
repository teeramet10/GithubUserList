//
//  UserRepositoryListViewController.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import UIKit

class UserRepositoryListViewController:
    BaseViewController  {
    
    @IBOutlet weak var userDetailView: UserDetailView!
    @IBOutlet weak var tableView : UITableView!
    var refreshControl = UIRefreshControl()
    
    var viewModel : UserRepositoryListViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let dataSource = GitHubUserDataSource()
        let localDataSource = LocalGitHubUserDataSource(FavoriteLocalDataProvider())
        let repository = GitHubUserRepository(dataSource,localDataSource)
        viewModel = UserRepositoryListViewModel(repository)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.getUser()
        viewModel.input.getRepositories()
    }

    override func setupUI(){
        title = "Repositories"
        refreshControl.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.register(RepositoryTableViewCell.nib, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
    }
    
    override func bindViewModel() {
        self.viewModel.output.showError = showError()
        self.viewModel.output.showLoading = showLoading()
        self.viewModel.output.onSetUser = onSetUser()
        self.viewModel.output.onFetchDataSuccess = onFetchDataSuccess()
        self.viewModel.output.onGetUserFailed = onGetUserFailed()
    }
    
    @objc func onRefresh(_ sender: UIRefreshControl) {
        self.viewModel.input.getRepositories()
    }
}

extension UserRepositoryListViewController{

    func onGetUserFailed()-> ((String) -> Void){
        return {[weak self] message in
            guard let `self` = self else{return}
            self.showAlert(title: "", message: message)
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
    
    func onSetUser() ->((GitHubUserModel) -> Void){
        return {[weak self] data in
            guard let `self` = self else{return}
            self.userDetailView.setData(data,true)
        }
    }
    
    func onFetchDataSuccess()-> ((_ isEmpty : Bool) -> Void){
        return {[weak self] isEmpty in
            guard let `self` = self else{return}
            self.tableView.reloadData()
        }
    }
}

extension UserRepositoryListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UserRepositoryListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listRepository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as? RepositoryTableViewCell else{
            return UITableViewCell()
        }
        let data = viewModel.listRepository[indexPath.row]
        cell.configCell(data, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
