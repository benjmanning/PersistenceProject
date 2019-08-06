//
//  CoreDataContainer.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataContainer {
  
  private(set) var errored: Bool = false
  
  lazy var persistentContainer: NSPersistentContainer = {
    let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
    
    persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error {
        Logger.e("Failed to create persistent store \(error)")
        self.errored = true
      }
      
      Logger.i(storeDescription.description)
    })
    
    return persistentContainer
  }()
  
  var moc: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func createBackgroundMoc() -> NSManagedObjectContext {
    let backgroundMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    backgroundMoc.performAndWait {
      backgroundMoc.parent = self.moc
    }
    
    return backgroundMoc
  }
  
  func save() {
    if moc.hasChanges {
      moc.performAndWait {
        do {
          try moc.save()
          Logger.i("Saved main core data context")
        } catch {
          Logger.e("Error while saving main core data context - \(error)")
        }
      }
    }
  }
}
