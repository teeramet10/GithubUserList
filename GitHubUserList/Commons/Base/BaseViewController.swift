//
//  BaseViewController.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import UIKit
class BaseViewController : UIViewController , StoryboardInitializable{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        bindViewModel()
    }
    
    func setup(){
        
    }
    
    func setupUI(){
        
    }
    
    func bindViewModel(){
        
    }
    
    func showAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

