//
//  MockFavoriteLocalDataProvider.swift
//  GitHubUserListTests
//
//  Created by Teeramet Kanchanapiroj on 27/3/2564 BE.
//

import Foundation
import CoreData
@testable import GitHubUserList

class MockFavoriteLocalDataProvider {

    let keyCoreData = "GitHubUserLocalModel"

    var isSuccess = false

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: keyCoreData)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
            return self.persistentContainer.newBackgroundContext()
        }()

    func getFavUser() -> [GitHubUserLocalModel]{
        guard let entity =
                NSEntityDescription.insertNewObject(forEntityName: keyCoreData, into: backgroundContext) as? GitHubUserLocalModel  else { return [] }
        guard isSuccess else{return []}
        entity.id = 100
        entity.login = "favorite"
        return [entity]
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
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }

    func delete(_ id : Int?) -> Bool{
        guard  isSuccess else {
            return true
        }
        guard id != nil else{return false}
        return true
    }
}
