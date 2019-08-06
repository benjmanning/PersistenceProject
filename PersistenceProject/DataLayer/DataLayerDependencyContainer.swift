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
    
    let backgroundMoc = coreDataContainer.createBackgroundMoc()
    
    syncer = DataSyncer(
      syncer: DataSyncerEngine(),
      syncerDataReader: DataSyncerReader(
        apiClient: APIClient(),
        userStore: CoreDataUserStore(
          moc: backgroundMoc),
        postStore: CoreDataPostStore(
          moc: backgroundMoc,
          dataObserverFactory: dataObserverFactory),
        commentStore: CoreDataCommentStore(
          moc: backgroundMoc)))
    
    postRepository = PersistencePostRepository(
      postStore: CoreDataPostStore(
        moc: coreDataContainer.moc,
        dataObserverFactory: dataObserverFactory),
      syncerCoordinator: syncer)
  }
}
