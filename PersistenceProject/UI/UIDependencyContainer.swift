//
//  UIDependencyContainer.swift
//  PersistenceProject
//
//  Created by Ben Manning on 09/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
import CoreData

class UIDependencyContainer {
  
  let dataLayerDependencyContainer: DataLayerDependencyContainer

  init(dataLayerDependencyContainer: DataLayerDependencyContainer) {
    self.dataLayerDependencyContainer = dataLayerDependencyContainer
  }
  
  func makePostListViewController() -> PostListViewController {
    let vc = PostListViewController(
      postListViewModel: PostListViewModel(
        repository: dataLayerDependencyContainer.postRepository),
      syncer: dataLayerDependencyContainer.syncer,
      postDetailViewControllerFactory: makePostDetailViewController)
    return vc
  }
  
  func makePostDetailViewController(postId: Int64) -> PostDetailViewController {
    return PostDetailViewController(
      postDetailViewModel: PostDetailViewModel(
        repository: dataLayerDependencyContainer.postRepository,
        postId: postId))
  }
}
