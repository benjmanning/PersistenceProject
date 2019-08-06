//
//  BaseManagedObject.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

protocol LinkedManagedObject: NSManagedObject {
  associatedtype LinkedModel
  func convertToModel(includeParentRelations: Bool, includeChildRelations: Bool) -> LinkedModel
}

extension LinkedManagedObject {
  func convertToModel() -> LinkedModel {
    return convertToModel(includeParentRelations: false, includeChildRelations: false)
  }
  func convertToModelWithParents() -> LinkedModel {
    return convertToModel(includeParentRelations: true, includeChildRelations: false)
  }
  func convertToModelWithChildren() -> LinkedModel {
    return convertToModel(includeParentRelations: false, includeChildRelations: true)
  }
}
