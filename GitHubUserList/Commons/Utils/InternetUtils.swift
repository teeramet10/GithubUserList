//
//  InternetUtils.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
import Reachability

class InternetUtils : NSObject{
    
    static let share = InternetUtils()

    static func isConnect() -> Bool{
        let reachability  = try? Reachability()
        
        switch reachability?.connection  {
        case .cellular:
            return true
        case .wifi:
            return true
        default:
            return false
        }
    }
}
