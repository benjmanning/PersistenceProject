//
//  PostListViewModel.swift
//  PersistenceProject
//
//  Created by Ben Manning on 11/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class PostListViewModel {

  var posts: [Post] {
    return dataObserver.results
  }
  
  var fetchedResultsObserverDelegate: ObservableListDelegate? {
    get { return dataObserver.delegate }
    set { dataObserver.delegate = newValue }
  }
  
  private var dataObserver: ObservableList<Post>
  
  init(repository: PostRepository) {
    self.dataObserver = repository.getAll()
  }
}
