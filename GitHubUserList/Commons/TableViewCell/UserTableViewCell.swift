//
//  UserTableViewCell.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 25/3/2564 BE.
//

import UIKit
protocol UserTableViewCellDelegate : class {
    func addFavorite(_ data: GitHubUserModel,_ index :Int)
    func removeFavorite(_ data: GitHubUserModel,_ index :Int)
}

class UserTableViewCell: UITableViewCell {

    static let identifier = String(describing: UserTableViewCell.self)
    static let nib = UINib(nibName: UserTableViewCell.identifier , bundle: nil)

    @IBOutlet weak var userDetailView : UserDetailView!
    
    weak var delegate :UserTableViewCellDelegate?
    
    var index : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configCell(_ data : GitHubUserModel,_ index :Int){
        self.index = index
        userDetailView.delegate = self
        userDetailView.setData(data)
    }
}

extension UserTableViewCell : UserDetailViewDelegate{
    func addFavorite(_ data: GitHubUserModel) {
        guard let index = index else{return}
        delegate?.addFavorite(data,index)
    }
    
    func removeFavorite(_ data: GitHubUserModel) {
        guard let index = index else{return}
        delegate?.removeFavorite(data,index)
    }
}
