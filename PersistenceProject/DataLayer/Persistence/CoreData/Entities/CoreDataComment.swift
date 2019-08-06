//
//  CoreDataComment.swift
//  PersistenceProject
//
//  Created by Ben Manning on 26/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

extension CoreDataComment: LinkedManagedObject {
  
  func convertToModel(includeParentRelations: Bool, includeChildRelations: Bool) -> Comment {
    return Comment(
      id: id,
      postId: post?.id,
      body: body ?? "",
      post: getPost(include: includeParentRelations))
  }
  
  private func getPost(include: Bool) -> Post? {
    guard include else {
      return nil
    }
    
    return self.post?.convertToModel()
  }
}
