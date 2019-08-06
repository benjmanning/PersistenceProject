//
//  CoreDataUserStore.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataUserStore: UserStore {
  
  private let moc: NSManagedObjectContext
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
  
  func getAll() -> [User] {
    var result: [User] = []
    moc.performAndWait {
      let fetch: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
      result = (try? moc.fetch(fetch))?.map { $0.convertToModel() } ?? []
    }
    return result
  }
  
  func insert(user: User) {
    moc.performAndWait {
      let newUser = CoreDataUser(context: moc)
      newUser.id = user.id
      newUser.name = user.name
      newUser.email = user.email
    }
  }
  
  func update(user: User) {
    moc.performAndWait {
      let coreDataUser = select(with: user.id)
      coreDataUser?.name = user.name
      coreDataUser?.email = user.email
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
  
  private func select(with id: Int64) -> CoreDataUser? {
    let fetch: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
    fetch.predicate = NSPredicate(format: "id=%d", id)
    
    do {
      let result = try moc.fetch(fetch)
      return result.first
    } catch {
      Logger.e("select \(error)")
      return nil
    }
  }
}
