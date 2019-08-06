//
//  CoreDataResultObserverAdapter.swift
//  PersistenceProject
//
//  Created by Ben Manning on 25/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataResultObserverAdapter<ManagedObj: LinkedManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
  
  weak var observerDelegate: ObservableObjDelegate?
  var changeNotifier: ((NSFetchedResultsChangeType, ManagedObj) -> Void)?
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    if let managedObj = anObject as? ManagedObj {
      changeNotifier?(type, managedObj)
      
      if type == .delete {
        observerDelegate?.observableObjDelete()
      } else {
        observerDelegate?.observableObjUpdate()
      }
    }
  }
}
