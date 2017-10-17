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
    
    private var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }

    func add(element: Element) throws {
        let newEntity = CoreDataEntity.create(in: managedObjectContext)
        newEntity.populate(from: element)
        try managedObjectContext.save()
    }
    
    func add(contentsOf elements: [Element]) throws {
        for element in elements {
            let newEntity = CoreDataEntity.create(in: managedObjectContext)
            newEntity.populate(from: element)
        }
        
        try managedObjectContext.save()
    }
    
    func get(by id: Int32) throws -> Element? {
        let fetchRequest: NSFetchRequest<CoreDataEntity> = CoreDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        let firstEntity = try managedObjectContext.fetch(fetchRequest).first
        return firstEntity?.toModel()
    }
    
    func getAll(sortedBy sortDescriptors: [NSSortDescriptor] = []) throws -> [Element] {
        let fetchRequest: NSFetchRequest<CoreDataEntity> = CoreDataEntity.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
    
        let entities = try managedObjectContext.fetch(fetchRequest)
        let models = entities.map { $0.toModel() }
        return models
    }
    
    func clear() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try managedObjectContext.execute(batchDeleteRequest)
        try managedObjectContext.save()
    }
}
