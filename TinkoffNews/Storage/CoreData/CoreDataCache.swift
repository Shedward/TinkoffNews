//
//  CoreDataCache.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import CoreData

class CoreDataCache<T: CoreDataCachableModel>: RepositoryCache where T.CachingEntityType: NSManagedObject {

    typealias Element = T
    typealias CoreDataEntity = Element.CachingEntityType
    
    private var coreDataManager: CoreDataManager
    
    private var performingBatchUpdate: Bool = true
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func add(element: Element) throws {
        let newEntity = CoreDataEntity.create(in: coreDataManager.mainManagedObjectContext)
        newEntity.populate(from: element)
        try saveContextIfNeeded()
    }
    
    func get(by id: Int32) throws -> Element? {
        let fetchRequest: NSFetchRequest<CoreDataEntity> = CoreDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let firstEntity = try coreDataManager.mainManagedObjectContext.fetch(fetchRequest).first
        return firstEntity?.toModel()
    }
    
    func getAll(sortedBy sortDescriptors: [NSSortDescriptor] = []) throws -> [Element] {
        let fetchRequest: NSFetchRequest<CoreDataEntity> = CoreDataEntity.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
    
        let entities = try coreDataManager.mainManagedObjectContext.fetch(fetchRequest)
        let models = entities.map { $0.toModel() }
        return models
    }
    
    func clear() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try coreDataManager.mainManagedObjectContext.execute(batchDeleteRequest)
        try saveContextIfNeeded()
    }
    
    func beginUpdates() {
        performingBatchUpdate = true
    }
    
    func endUpdates() throws {
        performingBatchUpdate = false
        try saveContextIfNeeded()
    }
    
    private func saveContextIfNeeded() throws {
        if performingBatchUpdate {
            return
        }
        
        try coreDataManager.mainManagedObjectContext.save()
    }
}
