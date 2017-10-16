//
//  CoreDataManager.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    let mainManagedObjectContext: NSManagedObjectContext
    
    private let modelName: String
    private let objectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    init(modelName: String) {
        self.modelName = modelName
        
        self.objectModel = CoreDataManager.createObjectModel(modelName: modelName)
        self.persistentStoreCoordinator = CoreDataManager.createPersistentStoreCoordinator(fileName: modelName, model: objectModel)
        self.mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    }
    
    private static func createObjectModel(modelName: String) -> NSManagedObjectModel {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Failed to load \(modelName).modm")
        }
        
        guard let objectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load object model")
        }
        
        return objectModel
    }
    
    private static func createPersistentStoreCoordinator(fileName: String, model: NSManagedObjectModel) -> NSPersistentStoreCoordinator {
        let storeFileName = "\(fileName).sqlite"
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to find proper direcroty for user's documents")
        }
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeFileName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)

        } catch (let error) {
            fatalError("Failed to create persistent store: \(error)")
        }
        
        return persistentStoreCoordinator
    }
}
