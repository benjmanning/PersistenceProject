//
//  DataSyncer.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class DataSyncer {
  private let syncer: DataSyncerEngine
  private let syncerDataReader: DataSyncerReader

  let downloadAndSyncQueue: DispatchQueue = DispatchQueue(
    label: "DownloadAndSync",
    qos: .utility,
    attributes: [])
  
  init(syncer: DataSyncerEngine, syncerDataReader: DataSyncerReader) {
    self.syncer = syncer
    self.syncerDataReader = syncerDataReader
  }
  
  func refreshPostsWithUsersAsync() {
    refreshPostsWithUsersAsync(completion: nil)
  }
  
  func refreshPostsWithUsersAsync(completion: ((Bool) -> Void)? = nil) {
    downloadAndSyncQueue.async {
      let result = self.refreshPostsWithUsers()
      completion?(result)
    }
  }
  
  func refreshCommentsAsync(forPostId postId: Int64) {
    downloadAndSyncQueue.async {
      self.refreshComments(forPostId: postId)
    }
  }
  
  private func refreshComments(forPostId postId: Int64) {
    syncerDataReader.readDataForComments(forPostId: postId) { (commentData) in
      syncWithDataStore(
        dtos: commentData.dtos,
        modelObjs: commentData.modelObjs,
        store: commentData.store)
      commentData.store.flush()
    }
  }
  
  private func refreshPostsWithUsers() -> Bool {
    return syncerDataReader.readDataForPostsWithUsers { (postData, userData) in
      syncWithDataStore(
        dtos: userData.dtos,
        modelObjs: userData.modelObjs,
        store: userData.store)
      userData.store.flush()
      
      syncWithDataStore(
        dtos: postData.dtos,
        modelObjs: postData.modelObjs,
        store: postData.store)
      postData.store.flush()
    }
  }
  
  private func syncWithDataStore<Dto: DataSyncableDto>(
    dtos: [Dto],
    modelObjs: [Dto.ModelObj],
    store: Dto.Store) where Dto.ModelObj.Store == Dto.Store {
    
    do {
      try syncer.performSync(
        dtos: dtos,
        modelObjs: modelObjs,
        store: store)
    } catch {
      Logger.e("Error syncing users - \(error)")
    }
  }
}
