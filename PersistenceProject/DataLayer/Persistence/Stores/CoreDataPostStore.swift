//
//  CoreDataPostStore.swift
//  PersistenceProject
//
//  Created by Ben Manning on 22/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataPostStore: PostStore {
  
  private let moc: NSManagedObjectContext
  private let dataObserverFactory: () -> CoreDataResultsObserver<CoreDataPost>
  
  init(moc: NSManagedObjectContext,
       dataObserverFactory: @escaping () -> CoreDataResultsObserver<CoreDataPost>) {
    self.moc = moc
    self.dataObserverFactory = dataObserverFactory
  }
  
  func getAll() -> [Post] {
    var result: [Post] = []
    moc.performAndWait {
      let fetch: NSFetchRequest<CoreDataPost> = CoreDataPost.fetchRequest()
      do {
        result = (try? moc.fetch(fetch))?.map { $0.convertToModel() } ?? []
      }
    }
    return result
  }
  
  func getAll() -> ObservableList<Post> {
    var result: ObservableList<Post>?
    moc.performAndWait {
      result = dataObserverFactory()
    }
    return result ?? ObservableList()
  }
  
  func getWithComments(id: Int64) -> ObservableObj<Post> {
    var result: ObservableObj<Post>?
    moc.performAndWait {
      result = CoreDataResultObserver<CoreDataPost>(
        managedObjectContext: moc,
        predicate: predicate(for: id))
    }
    return result ?? ObservableObj()
  }
  
  func insert(post: Post) {
    moc.performAndWait {
      let newPost = CoreDataPost(context: moc)
      newPost.id = post.id
      newPost.title = post.title
      newPost.body = post.body
      newPost.user = selectUser(with: post.userId)
    }
  }
  
  func update(post: Post) {
    moc.performAndWait {
      let coreDataPost = select(with: post.id)
      coreDataPost?.title = post.title
      coreDataPost?.body = post.body
      coreDataPost?.user = selectUser(with: post.userId)
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
  
  private func select(with id: Int64) -> CoreDataPost? {
    let fetch: NSFetchRequest<CoreDataPost> = CoreDataPost.fetchRequest()
    fetch.predicate = predicate(for: id)
    
    do {
      let result = try moc.fetch(fetch)
      return result.first
    } catch {
      Logger.e("select \(error)")
      return nil
    }
  }
  
  private func predicate(for id: Int64) -> NSPredicate {
    return NSPredicate(format: "id=%d", id)
  }
  
  private func selectUser(with id: Int64?) -> CoreDataUser? {
    if let id = id {
      let fetch: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
      fetch.predicate = NSPredicate(format: "id=%d", id)
      do {
        let result = try moc.fetch(fetch)
        return result.first
      } catch {
        Logger.e("selectUser \(error)")
      }
    }
    return nil
  }
}
