//
//  PopUpView.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
import UIKit
class PopUpView : NSObject, UIPopoverPresentationControllerDelegate {
  private static let sharedInstance = PopUpView()
  
  private override init() {
    super.init()
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  static func configure(forController controller : UIViewController) -> UIPopoverPresentationController? {
    controller.modalPresentationStyle = .popover
    let presentationController = controller.presentationController as? UIPopoverPresentationController
    presentationController?.delegate = PopUpView.sharedInstance
    presentationController?.backgroundColor = .white
    return presentationController
  }
  
}
