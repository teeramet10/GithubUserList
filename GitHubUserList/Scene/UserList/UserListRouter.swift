//
//  UserListRepositoryRouter.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import UIKit
class UserListRouter  : UserListRoutingProtocol{
    
    weak var  viewController : UIViewController?
    
    init(_ viewController : UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateToUserRepositorieList(_ data: GitHubUserModel?) {
        guard let vc = UserRepositoryListViewController.initFromStoryboard(name: .main) else{return}
        vc.viewModel.gitHubUser = data
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
