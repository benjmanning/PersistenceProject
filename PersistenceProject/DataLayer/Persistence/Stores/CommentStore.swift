//
//  CommentStore.swift
//  PersistenceProject
//
//  Created by Ben Manning on 26/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

protocol CommentStore {
  func getAll() -> [Comment]
  func get(forPostId: Int64) -> [Comment]
  func insert(comment: Comment)
  func update(comment: Comment)
  func delete(id: Int64)
  func flush()
}
