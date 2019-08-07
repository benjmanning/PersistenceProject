//
//  DataLayerDependencyContainer.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class DataLayerDependencyContainer {

  private let coreDataContainer: CoreDataContainer
  
  let syncer: DataSyncer
  
  let postRepository: PostRepository
  
  init() {
    let coreDataContainer = CoreDataContainer()
    self.coreDataContainer = coreDataContainer
    
    let dataObserverFactory = { () -> CoreDataResultsObserver<CoreDataPost> in
      return CoreDataResultsObserver<CoreDataPost>(
        managedObjectContext: coreDataContainer.moc,
        includeParentRelations: true)
    }
    
    let postStoreFactory: () -> (PostStore, UserStore) = {
      let moc = coreDataContainer.createBackgroundMoc()
      let userStore = CoreDataUserStore(
        moc: moc)
      let postStore = CoreDataPostStore(
        moc: moc,
        dataObserverFactory: dataObserverFactory)
      return (postStore, userStore)
    }
    
    let commentStoreFactory = {
      CoreDataCommentStore(
        moc: coreDataContainer.createBackgroundMoc())
    }
    
    syncer = DataSyncer(
      syncer: DataSyncerEngine(),
      syncerDataReader: DataSyncerReader(
        apiClient: APIClient(),
        postStoreFactory: postStoreFactory,
        commentStoreFactory: commentStoreFactory))
    
    postRepository = PersistencePostRepository(
      postStore: CoreDataPostStore(
        moc: coreDataContainer.moc,
        dataObserverFactory: dataObserverFactory),
      syncerCoordinator: syncer)
  }
}
