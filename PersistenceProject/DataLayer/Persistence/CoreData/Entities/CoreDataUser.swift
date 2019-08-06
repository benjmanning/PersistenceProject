//
//  CoreDataUser.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

extension CoreDataUser: LinkedManagedObject {
  func convertToModel(includeParentRelations: Bool, includeChildRelations: Bool) -> User {
    return User(
      id: id,
      name: name ?? "",
      email: email ?? "")
  }
}
