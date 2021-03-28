//
//  GitHubUserAPI.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 25/3/2564 BE.
//

import Foundation
import Moya
enum GitHubUserAPI{
    case getUser(_ query :String)
    case getUserList
    case getUserRepositorie(_ name :String)
}

extension GitHubUserAPI : TargetType{
    
    var baseURL: URL {
        return URL(string: "http://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .getUser(_):
            return "search/users"
        case .getUserList:
            return "users"
        case .getUserRepositorie(let name):
            return "users/\(name)/repos"
        }
    }
    
    var method: Moya.Method {
        switch  self{
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getUser(let query):
            return .requestParameters(parameters: ["q" :query], encoding: URLEncoding.queryString)
        case .getUserList:
            return .requestPlain
        case .getUserRepositorie(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
