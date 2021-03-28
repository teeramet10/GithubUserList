//
//  Storyboard.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
import UIKit
enum Storyboard : String{
    case main = "Main"
}

protocol StoryboardInitializable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
  
  static var storyboardIdentifier: String {
    return String(describing: Self.self)
  }
  
  static func initFromStoryboard(name: Storyboard) -> Self? {
    let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
    return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
  }
}
