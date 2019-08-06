//
//  UserStore.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

protocol UserStore {
  func getAll() -> [User]
  func insert(user: User)
  func update(user: User)
  func delete(id: Int64)
  func flush()
}
