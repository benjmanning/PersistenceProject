//
//  CoreDataPost.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import Foundation

extension CoreDataPost: LinkedManagedObject {
  
  func convertToModel(includeParentRelations: Bool, includeChildRelations: Bool) -> Post {
    return Post(
      id: id,
      userId: user?.id,
      title: title ?? "",
      body: body ?? "",
      user: getUser(include: includeParentRelations),
      comments: getComments(include: includeChildRelations))
  }
  
  private func getUser(include: Bool) -> User? {
    guard include else {
      return nil
    }
    return self.user?.convertToModel()
  }
  
  private func getComments(include: Bool) -> [Comment] {
    guard include else {
      return []
    }
    
    let comments = self.comments?.allObjects as? [CoreDataComment]
    return comments?.map { $0.convertToModel() } ?? []
  }
}
