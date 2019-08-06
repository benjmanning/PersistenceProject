//
//  CoreDataResultsObserverAdapter.swift
//  PersistenceProject
//
//  Created by Ben Manning on 25/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataResultsObserverAdapter<ManagedObj: LinkedManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
  
  weak var delegate: ObservableListDelegate?
  var changeNotifier: ((ManagedObj?, IndexPath?, NSFetchedResultsChangeType, IndexPath?) -> Void)?
  var beginNotifier: (() -> Void)?
  var endNotifier: (() -> Void)?
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    beginNotifier?()
    delegate?.observerBeginChanges()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    endNotifier?()
    delegate?.observerEndChanges()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    changeNotifier?(anObject as? ManagedObj, indexPath, type, newIndexPath)
    
    if let type = ObservableListChangeType.from(type) {
      delegate?.observerChange(at: indexPath,
                               operation: type,
                               newIndexPath: newIndexPath)
    }
  }
}

extension ObservableListChangeType {
  static func from(_ changeType: NSFetchedResultsChangeType) -> ObservableListChangeType? {
    switch changeType {
    case .insert: return .insert
    case .move: return .move
    case .update: return .update
    case .delete: return .delete
    @unknown default:
      Logger.e("Unknown NSFetchedResultsChangeType: \(changeType)")
    }
    return nil
  }
}
