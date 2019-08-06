//
//  DataSyncableDto.swift
//  PersistenceProject
//
//  Created by Ben Manning on 25/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

protocol DataSyncableDto {
  associatedtype ModelObj: DataSyncableModelObj
  associatedtype Store
  
  var syncableId: Int64 { get }
  
  func needsUpdate(with obj: ModelObj) -> Bool
  func insert(into store: Store)
  func update(with store: Store)
}

extension CommentDTO: DataSyncableDto {
  var syncableId: Int64 {
    return id
  }
  
  func needsUpdate(with comment: Comment) -> Bool {
    return id != comment.id || body != comment.body || postId != comment.postId
  }
  
  func insert(into store: CommentStore) {
    store.insert(comment: Comment(id: id, postId: postId, body: body))
  }
  
  func update(with store: CommentStore) {
    store.update(comment: Comment(id: id, postId: postId, body: body))
  }
}

extension PostDTO: DataSyncableDto {
  var syncableId: Int64 {
    return id
  }
  
  func needsUpdate(with post: Post) -> Bool {
    return id != post.id || title != post.title || body != post.body || userId != post.userId
  }
  
  func insert(into store: PostStore) {
    store.insert(post: Post(id: id, userId: userId, title: title, body: body))
  }
  
  func update(with store: PostStore) {
    store.update(post: Post(id: id, userId: userId, title: title, body: body))
  }
}

extension UserDTO: DataSyncableDto {
  var syncableId: Int64 {
    return id
  }
  
  func needsUpdate(with user: User) -> Bool {
    return id != user.id || name != user.name || email != user.email
  }
  
  func insert(into store: UserStore) {
    store.insert(user: User(id: id, name: name, email: email))
  }
  
  func update(with store: UserStore) {
    store.update(user: User(id: id, name: name, email: email))
  }
}
