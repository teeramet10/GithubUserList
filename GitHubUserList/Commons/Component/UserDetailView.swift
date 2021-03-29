//
//  UserDetailView.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import UIKit
protocol UserDetailViewDelegate : class{
    func addFavorite(_ data : GitHubUserModel)
    func removeFavorite(_ data : GitHubUserModel)
}

class UserDetailView : BaseView {
    
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var urlLabel : UILabel!
    @IBOutlet weak var favButton : UIButton!

    var data : GitHubUserModel?
    
    weak var delegate : UserDetailViewDelegate?

    func setData(_ data : GitHubUserModel , _ isReadOnly : Bool = false){
        self.data = data
        nameLabel.text = data.login ?? ""
        urlLabel.text = data.htmlURL
        urlLabel.sizeToFit()
        let image = data.isFavorite ? "ic_heart_fill" : "ic_heart"
        favButton.setImage(UIImage(named: image), for: .normal)
        ImageUtils.loadImage(imgProfile, data.avatarURL)
        favButton.isHidden = isReadOnly
    }

    @IBAction func onFavorite(_ sender: Any) {
        guard let data = self.data else{return}
        guard !data.isFavorite else{
            delegate?.removeFavorite(data)
            return
        }
        delegate?.addFavorite(data)
    }
    
}
