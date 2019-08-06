//
//  DataSyncableModelObj.swift
//  PersistenceProject
//
//  Created by Ben Manning on 22/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

protocol DataSyncableModelObj {
  associatedtype Store
  var syncableId: Int64 { get }
  func delete(from store: Store)
}

extension Comment: DataSyncableModelObj {
  var syncableId: Int64 {
    return id
  }
  func delete(from store: CommentStore) {
    store.delete(id: id)
  }
}

extension Post: DataSyncableModelObj {
  var syncableId: Int64 {
    return id
  }
  func delete(from store: PostStore) {
    store.delete(id: id)
  }
}

extension User: DataSyncableModelObj {
  var syncableId: Int64 {
    return id
  }
  func delete(from store: UserStore) {
    store.delete(id: id)
  }
}
