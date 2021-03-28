//
//  RepositoryModel.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
class RepositoryModel{
    var id :Int?
    var name : String? = ""
    var fullName : String? = ""
    var owner : OwnerModel?
    var htmlURL :String? = ""
    var description :String? = ""
    var language : String? = ""
    var updateAt : String? = ""
    var stargazersCount : Int?
}
