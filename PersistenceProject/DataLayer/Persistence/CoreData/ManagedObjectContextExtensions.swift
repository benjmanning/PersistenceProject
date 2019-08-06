//
//  ManagedObjectContextExtensions.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
  func trySave() -> Bool {
    if hasChanges {
      do {
        try save()
        return true
      } catch {
        Logger.e("Error saving moc")
      }
    }
    return false
  }
}
