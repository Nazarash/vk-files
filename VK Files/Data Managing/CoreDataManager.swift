//
//  CoreDataManager.swift
//  VK Files
//
//  Created by Дмитрий on 01.05.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VK_Files")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var privateContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = persistentContainer.viewContext
        return managedObjectContext
    }()
    
    private var context: NSManagedObjectContext {
        if Thread.current.isMainThread {
            return mainContext
        } else {
            return privateContext
        }
    }
    
    private func saveContext() {
        try? context.save()
        if context == privateContext {
            DispatchQueue.main.async {
                try? self.mainContext.save()
            }
        }
    }
    
    public func clearDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let error {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }

    // MARK: - Sync with online
    
    func sync(withLoaded documents: [VkDocument]) {
        let onlineSet = Set(documents)
        let offlineSet = Set(getDocuments())
        context.performAndWait {
            for document in onlineSet.subtracting(offlineSet) {
                self.putDocument(document, needSave: false)
            }
            for document in offlineSet.subtracting(onlineSet) {
                self.deleteDocument(document, needSave: false)
            }
            saveContext()
        }
    }
    
    // MARK: - Data operations
    
    func getDocuments(using sortMethod: SortMethods? = nil) -> [VkDocument] {
        let request: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        if let sortDescriptor = sortMethod?.descriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        guard let fetchedDocuments = try? context.fetch(request) else { return []}
        return fetchedDocuments.map{ (entity: DocumentEntity) in VkDocument(entity: entity) }
    }
    
    private func getDocEntity(by id: DocumentID) -> DocumentEntity? {
        let request: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", id)
        request.predicate = predicate
        guard
            let fetchedDocuments = try? context.fetch(request),
            fetchedDocuments.count == 1
            else { return nil }
        return fetchedDocuments.first
    }
    
    func putDocument(_ document: VkDocument, needSave: Bool = true) {
        let entity = DocumentEntity(context: context)
        entity.initialize(with: document)
        if needSave {
            saveContext()
        }
    }
    
    func renameDocument(_ document: VkDocument, needSave: Bool = true) {
        guard let entity = getDocEntity(by: document.id) else { return }
        entity.title = document.title
        saveContext()
    }
    
    func deleteDocument(_ document: VkDocument, needSave: Bool = true) {
        guard let entity = getDocEntity(by: document.id) else { return }
        context.delete(entity)
        if needSave {
            saveContext()
        }
    }
    
    // MARK: - User info
    
    func setUserInfo(_ user: User) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        guard let fetchedUsers = try? context.fetch(request) else { return }
        let entity = fetchedUsers.isEmpty ? UserEntity(context: context) : fetchedUsers.first!
        entity.initialize(with: user)
        saveContext()
    }
    
    func getUserInfo() -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        guard
            let fetchedUsers = try? context.fetch(request),
            fetchedUsers.count == 1
            else { return nil }
        return User(entity: fetchedUsers.first!)
    }
}
