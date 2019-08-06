//
//  UITableViewFetchedResultsObserverTarget.swift
//  PersistenceProject
//
//  Created by Ben Manning on 09/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

extension UITableView: ObservableListDelegate {
  
  func observerBeginChanges() {
    beginUpdates()
  }
  
  func observerEndChanges() {
    endUpdates()
  }
  
  func observerChange(at indexPath: IndexPath?, operation type: ObservableListChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      if let newIndexPath = newIndexPath {
        insertRows(at: [newIndexPath], with: .automatic)
      }
      
    case .delete:
      if let indexPath = indexPath {
        deleteRows(at: [indexPath], with: .automatic)
      }
      
    case .update:
      if let indexPath = indexPath {
        reloadRows(at: [indexPath], with: .automatic)
      }
      
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        if indexPath == newIndexPath {
          reloadRows(at: [indexPath], with: .automatic)
        } else {
          deleteRows(at: [indexPath], with: .automatic)
          insertRows(at: [newIndexPath], with: .automatic)
        }
      }
    }
  }
}
