//
//  RepositoryTableViewCell.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    static let identifier = String(describing: RepositoryTableViewCell.self)
    static let nib = UINib(nibName: RepositoryTableViewCell.identifier , bundle: nil)
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var languageLabel : UILabel!
    @IBOutlet weak var stargazersLabel : UILabel!

    var data : RepositoryModel?
    var index :Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ data : RepositoryModel,_ index :Int){
        self.index = index
        self.data = data
        nameLabel.text = data.fullName
        nameLabel.sizeToFit()
        languageLabel.text = data.language
        stargazersLabel.text = String(data.stargazersCount ?? 0)
    }
}
