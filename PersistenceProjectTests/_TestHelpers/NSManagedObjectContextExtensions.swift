//
//  NSManagedObjectContextExtensions.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 02/08/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
import CoreData

extension NSManagedObjectContext {
  func xctestSave() {
    do {
      try save()
    } catch {
      XCTFail("Unable to save managed object context - \(error)")
    }
  }
}
