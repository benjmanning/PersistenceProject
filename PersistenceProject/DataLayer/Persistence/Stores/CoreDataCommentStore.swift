//
//  CoreDataCommentStore.swift
//  PersistenceProject
//
//  Created by Ben Manning on 26/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataCommentStore: CommentStore {
  
  private let moc: NSManagedObjectContext
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }

  func getAll() -> [Comment] {
    var result: [Comment] = []
    moc.performAndWait {
      let fetch: NSFetchRequest<CoreDataComment> = CoreDataComment.fetchRequest()
      result = (try? moc.fetch(fetch))?.map { $0.convertToModel() } ?? []
    }
    return result
  }
  
  func get(forPostId postId: Int64) -> [Comment] {
    var result: [Comment] = []
    moc.performAndWait {
      let fetch: NSFetchRequest<CoreDataComment> = CoreDataComment.fetchRequest()
      fetch.predicate = NSPredicate(format: "post.id=%d", postId)
      result = (try? moc.fetch(fetch))?.map { $0.convertToModel() } ?? []
    }
    return result
  }
  
  func insert(comment: Comment) {
    moc.performAndWait {
      let newComment = CoreDataComment(context: moc)
      newComment.id = comment.id
      newComment.body = comment.body
      newComment.post = selectPost(with: comment.postId)
    }
  }
  
  func update(comment: Comment) {
    moc.performAndWait {
      let coreDataComment = select(with: comment.id)
      coreDataComment?.body = comment.body
      coreDataComment?.post = selectPost(with: comment.postId)
    }
  }
  
  func delete(id: Int64) {
    moc.performAndWait {
      if let coreDataPost = select(with: id) {
        moc.delete(coreDataPost)
      }
    }
  }
  
  func flush() {
    moc.performAndWait {
      _ = moc.trySave()
    }
    moc.parent?.performAndWait {
      _ = moc.parent?.trySave()
    }
  }
  
  private func select(with id: Int64) -> CoreDataComment? {
    let fetch: NSFetchRequest<CoreDataComment> = CoreDataComment.fetchRequest()
    fetch.predicate = NSPredicate(format: "id=%d", id)
    
    do {
      let result = try moc.fetch(fetch)
      return result.first
    } catch {
      Logger.e("select \(error)")
      return nil
    }
  }
  
  private func selectPost(with id: Int64?) -> CoreDataPost? {
    if let id = id {
      let fetch: NSFetchRequest<CoreDataPost> = CoreDataPost.fetchRequest()
      fetch.predicate = NSPredicate(format: "id=%d", id)
      do {
        let result = try moc.fetch(fetch)
        return result.first
      } catch {
        Logger.e("selectPost \(error)")
      }
    }
    return nil
  }
}
