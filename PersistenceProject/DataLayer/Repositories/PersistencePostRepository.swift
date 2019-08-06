//
//  PersistencePostRepository.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class PersistencePostRepository: PostRepository {
  
  private let postStore: PostStore
  private let syncer: DataSyncer
  
  init(
    postStore: PostStore,
    syncerCoordinator: DataSyncer) {
    
    self.postStore = postStore
    self.syncer = syncerCoordinator
  }
  
  func getAll() -> ObservableList<Post> {
    Logger.i("Fetching all posts...")
    syncer.refreshPostsWithUsersAsync()
    return postStore.getAll()
  }
  
  func getWithComments(id: Int64) -> ObservableObj<Post> {
    syncer.refreshCommentsAsync(forPostId: id)
    return postStore.getWithComments(id: id)
  }
}
