//
//  FavoriteLocalDataProvider.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 25/3/2564 BE.
//

import Foundation
import CoreData
import UIKit
class FavoriteLocalDataProvider {

    let keyCoreData = "GitHubUserLocalModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: keyCoreData)
        container.loadPersistentStores { description, error in
            guard let error = error else{return}
            fatalError("\(error)")
        }
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func getFavUser() -> [GitHubUserLocalModel]{
        let context = persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<GitHubUserLocalModel>(entityName: keyCoreData)
        do {
            let  list = try context.fetch(fetchRequest)
            return list

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func save(_ data : GitHubUserModel) -> Bool{

        let context = persistentContainer.viewContext

        let entity = GitHubUserLocalModel(context: context)
        guard let id = data.id else { return false}
        entity.id = Int64(id)
        entity.login = data.login
        entity.nodeId = data.nodeId
        entity.avatarURL = data.avatarURL
        entity.htmlURL = data.htmlURL
        entity.reposURL = data.reposURL
        entity.type = data.type

        do {
            context.insert(entity)
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }
    
    func delete(_ id : Int?) -> Bool{
        guard let id = id  else {
            return false
        }
        let context = persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<GitHubUserLocalModel>(entityName: keyCoreData)
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
            let  list = try context.fetch(fetchRequest)
            guard let model =  list.first else {
                return false
            }
            context.delete(model)
            try context.save()
            return true

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
}
