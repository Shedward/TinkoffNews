//
//  CachingModel.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import CoreData

protocol CoreDataCachableModel: IdentifiableObject  {
    associatedtype CachingEntityType: CoreDataCachingEntity
        where CachingEntityType.OriginalModel == Self
}

protocol CoreDataCachingEntity {
    associatedtype OriginalModel: CoreDataCachableModel
        where OriginalModel.CachingEntityType == Self
    
    static var entityName: String { get }
    
    func populate(from model: OriginalModel)
    func toModel() -> OriginalModel
}

extension CoreDataCachingEntity where Self: NSManagedObject {
    
    static func create(in context: NSManagedObjectContext) -> Self {
        let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return newObject as! Self
    }
    
    static func fetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}
