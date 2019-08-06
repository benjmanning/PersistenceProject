//
//  SyncerTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 01/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

import CoreData

class LoggerPostStore: PostStore {
  
  var inserts: [Post] = []
  var updates: [Post] = []
  var deletes: [Int64] = []
  
  func getAll() -> [Post] {
    return []
  }
  
  func getAll() -> ObservableList<Post> {
    return ObservableList()
  }
  
  func getWithComments(id: Int64) -> ObservableObj<Post> {
    return ObservableObj()
  }
  
  func insert(post: Post) {
    inserts.append(post)
  }
  
  func update(post: Post) {
    updates.append(post)
  }
  
  func delete(id: Int64) {
    deletes.append(id)
  }
  
  func flush() { }
  
  func assertEqual(inserts: [Post], updates: [Post], deletes: [Int64]) {
    CustomAsserts.assertPostArrayMatches(testing: "insert", facts: inserts, actuals: self.inserts)
    CustomAsserts.assertPostArrayMatches(testing: "update", facts: updates, actuals: self.updates)
    CustomAsserts.assertIntArrayMatches(testing: "delete", facts: deletes, actuals: self.deletes)
  }
}

class SyncerTests: XCTestCase {
  
  var sut: DataSyncerEngine!
  var store: LoggerPostStore!
  
  let testPostDTO1 = PostDTO(id: 1, userId: 1, title: "title1", body: "body1")
  let testPostDTO2 = PostDTO(id: 2, userId: 1, title: "title2", body: "body2")
  let testPostDTO3 = PostDTO(id: 3, userId: 1, title: "title3", body: "body3")
  
  override func setUp() {
    super.setUp()
    
    sut = DataSyncerEngine()
    store = LoggerPostStore()
  }
  
  override func tearDown() {
    
    super.tearDown()
    
    sut = nil
    store = nil
  }
  
  func storedPostsForTest() -> [Post] {
    return [
      Post(id: 1, userId: 1, title: "title1", body: "body1"),
      Post(id: 2, userId: 1, title: "title2", body: "body2"),
      Post(id: 3, userId: 1, title: "title3", body: "body3")]
  }
  
  func testSyncerWillAddARow() {
    try? sut.performSync(
      dtos: [
        testPostDTO1,
        testPostDTO2,
        testPostDTO3,
        PostDTO(id: 4, userId: 3, title: "title4", body: "body4")
      ],
      modelObjs: storedPostsForTest(),
      store: store)
    
    store.assertEqual(
      inserts: [Post(id: 4, userId: 3, title: "title4", body: "body4")],
      updates: [],
      deletes: [])
  }
  
  func testSyncerWillUpdateARow() {
    try? sut.performSync(
      dtos: [
        testPostDTO1,
        PostDTO(id: 2, userId: 1, title: "modded title", body: "body2"),
        testPostDTO3
      ],
      modelObjs: storedPostsForTest(),
      store: store)
    
    store.assertEqual(
      inserts: [],
      updates: [Post(id: 2, userId: 1, title: "modded title", body: "body2")],
      deletes: [])
  }
  
  func testSyncerWillDeleteARow() {
    try? sut.performSync(
      dtos: [
        testPostDTO2,
        testPostDTO3
      ],
      modelObjs: storedPostsForTest(),
      store: store)
    
    store.assertEqual(
      inserts: [],
      updates: [],
      deletes: [1])
  }
  
  func testSyncerWillAddUpdateDeleteTogether() {
    try? sut.performSync(
      dtos: [
        PostDTO(id: 2, userId: 1, title: "modded title", body: "body2"),
        testPostDTO3,
        PostDTO(id: 4, userId: 3, title: "title4", body: "body4")
      ],
      modelObjs: storedPostsForTest(),
      store: store)
    
    store.assertEqual(
      inserts: [Post(id: 4, userId: 3, title: "title4", body: "body4")],
      updates: [Post(id: 2, userId: 1, title: "modded title", body: "body2")],
      deletes: [1])
  }
}
