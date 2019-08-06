//
//  PostStore.swift
//  PersistenceProject
//
//  Created by Ben Manning on 22/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

protocol PostStore {
  func getAll() -> [Post]
  func getAll() -> ObservableList<Post>
  func getWithComments(id: Int64) -> ObservableObj<Post>
  func insert(post: Post)
  func update(post: Post)
  func delete(id: Int64)
  func flush()
}
