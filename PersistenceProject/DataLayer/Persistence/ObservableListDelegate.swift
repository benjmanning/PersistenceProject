//
//  ObservableListDelegate.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import Foundation

enum ObservableListChangeType {
  case insert
  case move
  case update
  case delete
}

protocol ObservableListDelegate: AnyObject {
  func observerBeginChanges()
  func observerEndChanges()
  func observerChange(at indexPath: IndexPath?, operation type: ObservableListChangeType, newIndexPath: IndexPath?)
}
