//
//  GitHubUserLocalModel.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
import CoreData

class GitHubUserLocalModel  : NSManagedObject, Codable{
    
    enum CodingKeys : String, CodingKey{
        case id
        case login
        case nodeId
        case avatarURL
        case htmlURL
        case reposURL
        case type
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("decode failed")
        }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id) ?? -1
        self.login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
        self.nodeId = try container.decodeIfPresent(String.self, forKey: .nodeId) ?? ""
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        self.htmlURL = try container.decodeIfPresent(String.self, forKey: .htmlURL) ?? ""
        self.reposURL = try container.decodeIfPresent(String.self, forKey: .reposURL) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(login, forKey: .login)
        try container.encode(nodeId, forKey: .nodeId)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(htmlURL, forKey: .htmlURL)
        try container.encode(reposURL, forKey: .reposURL)
        try container.encode(type, forKey: .type)
    }
    
    func toModel() -> GitHubUserModel{
        let model = GitHubUserModel()
        model.id = Int(id)
        model.login = login
        model.nodeId = nodeId
        model.avatarURL = avatarURL
        model.htmlURL = htmlURL
        model.reposURL = reposURL
        model.type = type
        return model
    }
}
