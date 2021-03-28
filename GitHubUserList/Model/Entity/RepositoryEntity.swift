//
//  RepositoryEntity.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
class RepositoryEntity : Codable{
    var id :Int?
    var name : String? = ""
    var fullName : String? = ""
    var owner : OwnerEntity?
    var htmlURL :String? = ""
    var description :String? = ""
    var language : String? = ""
    var updateAt : String? = ""
    var stargazersCount : Int?

    enum CodingKeys : String, CodingKey{
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case description
        case language
        case updateAt = "updated_at"
        case stargazersCount = "stargazers_count"
    }
    
    func toModel() -> RepositoryModel{
        let model = RepositoryModel()
        model.name = name
        model.fullName = fullName
        model.owner = owner?.toModel()
        model.htmlURL = htmlURL
        model.description = description
        model.language = language
        model.updateAt = updateAt
        model.stargazersCount = stargazersCount
        return model
    }
}
