//
//  CoreDataResultsObserverTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

class CoreDataResultsObserverTests: XCTestCase {
  
  var sut: CoreDataResultsObserver<CoreDataPost>!
  var coreDataMocker = CoreDataMocker()
  
  var post1: CoreDataPost!
  var post2: CoreDataPost!
  var post3: CoreDataPost!

  override func setUp() {
    coreDataMocker.loadStore()
    setupCoreDataStateForTest()
    coreDataMocker.moc.xctestSave()
    sut = CoreDataResultsObserver(managedObjectContext: coreDataMocker.moc,
                                  includeParentRelations: false,
                                  sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
  }
  
  override func tearDown() {
    coreDataMocker.removeStore()
    sut?.invalidate()
    sut = nil
  }
  
  func setupCoreDataStateForTest() {
    post1 = CoreDataPost(context: coreDataMocker.moc)
    post1.id = 2
    post1.title = "title 1"
    post1.body = "body 1"
    post2 = CoreDataPost(context: coreDataMocker.moc)
    post2.id = 3
    post2.title = "title 2"
    post2.body = "body 2"
    post3 = CoreDataPost(context: coreDataMocker.moc)
    post3.id = 5
    post3.title = "title 3"
    post3.body = "body 3"
  }
  
  func coreDataInsertPostWithId(_ id: Int64) {
    let postx = CoreDataPost(context: coreDataMocker.moc)
    postx.id = id
    postx.title = "title x"
    postx.body = "body x"
  }
  
  func coreDataDeletePost(_ post: CoreDataPost) {
    coreDataMocker.moc.delete(post)
  }
  
  func testThatInitialTestStateIsCorrect() {
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 3, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 5, "Item 2 is incorrect")
  }
  
  func testThatStateIsCorrectAfterInsertingInTheMiddle() {
    coreDataInsertPostWithId(4)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 3, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 4, "Item 2 is incorrect")
    XCTAssertEqual(sut.results[3].id, 5, "Item 3 is incorrect")
  }
  
  func testThatStateIsCorrectAfterInsertingAtTheStart() {
    coreDataInsertPostWithId(1)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 1, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 2, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 3, "Item 2 is incorrect")
    XCTAssertEqual(sut.results[3].id, 5, "Item 3 is incorrect")
  }
  
  func testThatStateIsCorrectAfterInsertingAtTheEnd() {
    coreDataInsertPostWithId(6)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 3, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 5, "Item 2 is incorrect")
    XCTAssertEqual(sut.results[3].id, 6, "Item 3 is incorrect")
  }
  
  func testThatStateIsCorrectAfterDeletingInTheMiddle() {
    coreDataDeletePost(post2)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 5, "Item 1 is incorrect")
  }
  
  func testThatStateIsCorrectAfterDeletingAtTheStart() {
    coreDataDeletePost(post1)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 3, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 5, "Item 1 is incorrect")
  }
  
  func testThatStateIsCorrectAfterDeletingAtTheEnd() {
    coreDataDeletePost(post3)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 3, "Item 1 is incorrect")
  }
  
  func testThatStateIsCorrectAfterInsertAndDelete() {
    coreDataInsertPostWithId(4)
    coreDataDeletePost(post2)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 4, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 5, "Item 2 is incorrect")
  }
  
  func testThatStateIsCorrectAfterMultipleInsertsAndDeletes() {
    coreDataInsertPostWithId(4)
    coreDataInsertPostWithId(6)
    coreDataDeletePost(post2)
    coreDataDeletePost(post3)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 4, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 6, "Item 2 is incorrect")
  }
  
  func testThatStateIsCorrectAfterMultipleInsertsAndDeleteAll() {
    coreDataInsertPostWithId(4)
    coreDataInsertPostWithId(6)
    coreDataDeletePost(post1)
    coreDataDeletePost(post2)
    coreDataDeletePost(post3)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 4, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 6, "Item 1 is incorrect")
  }
  
  func testThatStateIsCorrectAfterUpdate() {
    post1.title = "modded title"
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].title, "modded title", "Item 0 is incorrect")
  }
  
  func testThatItemsBeforeAndAfterUpdatedItemAreNotAffected() {
    post2.title = "modded title"
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[2].id, 5, "Item 2 is incorrect")
  }
  
  func testThatStateIsCorrectAfterDeleteUpdateInsert() {
    coreDataDeletePost(post1)
    post2.title = "modded title"
    coreDataInsertPostWithId(6)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 3, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[0].title, "modded title", "Item 1 is incorrect")
    XCTAssertEqual(sut.results[1].id, 5, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 6, "Item 2 is incorrect")
  }
  
  func testThatStateIsCorrectAfterUpdateInsertDelete() {
    post1.title = "modded title"
    coreDataInsertPostWithId(4)
    coreDataDeletePost(post3)
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 2, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[0].title, "modded title", "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 3, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 4, "Item 2 is incorrect")
  }
  
  func testThatStateIsCorrectAfterInsertDeleteUpdate() {
    coreDataInsertPostWithId(1)
    coreDataDeletePost(post2)
    post3.title = "modded title"
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.results[0].id, 1, "Item 0 is incorrect")
    XCTAssertEqual(sut.results[1].id, 2, "Item 1 is incorrect")
    XCTAssertEqual(sut.results[2].id, 5, "Item 2 is incorrect")
    XCTAssertEqual(sut.results[2].title, "modded title", "Item 2 is incorrect")
  }
  
}
