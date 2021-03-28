//
//  AppError.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 26/3/2564 BE.
//

import Foundation
struct AppError: Error {
    var describe : String = ""

    init(_ describe :String?) {
        self.describe = describe ?? ""
    }
    
    public init(error: Swift.Error) {
        if let errorResponse = error as? Error {
            describe = errorResponse.localizedDescription
        }else{
            self = AppError(error.localizedDescription)
        }
    }
}
