//
//  SearchModel.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
class SearchEntity<T : Codable> : Codable{
    var totalCount : Int?
    var incompleteResults : Bool? = false
    var items : [T]? = []
    
    enum CodingKeys : String, CodingKey{
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
