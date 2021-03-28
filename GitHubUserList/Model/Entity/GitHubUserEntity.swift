//
//  GitHubUserEntity.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
class GitHubUserEntity : Codable{
    var login :String? = ""
    var id : Int?
    var nodeId : String? = ""
    var avatarURL : String? = ""
    var url :String? = ""
    var htmlURL :String? = ""
    var reposURL : String? = ""
    var type :String? = ""
    
    
    enum CodingKeys : String, CodingKey{
        case id
        case login
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case reposURL = "repos_url"
        case type
    }
    
    func toModel() -> GitHubUserModel{
        let model = GitHubUserModel()
        model.login = login
        model.id = id
        model.nodeId = nodeId
        model.avatarURL = avatarURL
        model.url = url
        model.htmlURL = htmlURL
        model.reposURL = reposURL
        model.type = type
        return model
    }
}
