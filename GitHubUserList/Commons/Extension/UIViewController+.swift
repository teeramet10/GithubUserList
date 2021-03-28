//
//  UIViewController+.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import UIKit

extension UIViewController {
  
    static var identifier: String {
      return String(describing: Self.self)
    }
    
    func presentPopUp(_ viewController : UIViewController,_ sourceView :UIView , _ arrow : UIPopoverArrowDirection){
        let presentationController = PopUpView.configure(forController: viewController)
        presentationController?.sourceView = sourceView
        presentationController?.sourceRect = sourceView.bounds
        presentationController?.permittedArrowDirections = [arrow]
        self.present(viewController, animated: true)
    }
}
