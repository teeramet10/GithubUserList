//
//  OwnerEntity.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
class OwnerEntity : Codable{
    var id : Int?
    var login :String? = ""
    var avatarURL :String? = ""
    
    enum CodingKets : String, CodingKey{
        case id
        case login
        case avatarURL = "avartar_url"
    }
    
    func toModel() -> OwnerModel{
        let model = OwnerModel()
        model.id = id
        model.login = login
        model.avatarURL = avatarURL
        return model
    }
}
