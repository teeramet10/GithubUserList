//
//  SortPopUpView.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
import UIKit

class SortPopUpView :BaseViewController{
    
    typealias SortComplete = (SortType) ->Void?
    
    @IBOutlet weak var sortNameButton : UIButton!
    @IBOutlet weak var sortFavButton : UIButton!
    @IBOutlet weak var sortNameImage : UIImageView!
    @IBOutlet weak var sortFavImage : UIImageView!
    
    var complete : SortComplete?
    var sortType : SortType = .none
    
    override func viewDidLoad() {
        configView()
    }
    
    func configView(){
        switch sortType {
        case .name:
            sortNameImage.isHidden = false
            sortFavImage.isHidden = true
        case .favorite:
            sortNameImage.isHidden = true
            sortFavImage.isHidden = false
        default:
            sortNameImage.isHidden = true
            sortFavImage.isHidden = true
        }
    }
    
    @IBAction func sortName(sender : UIButton){
        complete?(.name)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortFavorite(sender : UIButton){
        complete?(.favorite)
        dismiss(animated: true, completion: nil)
    }
}

