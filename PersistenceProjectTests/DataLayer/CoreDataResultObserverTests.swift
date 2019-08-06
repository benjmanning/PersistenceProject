//
//  CoreDataResultObserverTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

private class MockObserverDelegate: ObservableObjDelegate {
  var updated: Bool = false
  var deleted: Bool = false
  func observableObjUpdate() {
    updated = true
  }
  func observableObjDelete() {
    deleted = true
  }
}

class CoreDataResultObserverTests: XCTestCase {
  
  var sut: CoreDataResultObserver<CoreDataPost>!
  var coreDataMocker = CoreDataMocker()
  
  var post1: CoreDataPost!
  var post2: CoreDataPost!
  var post3: CoreDataPost!

  override func setUp() {
    coreDataMocker.loadStore()
    setupCoreDataStateForTest()
    coreDataMocker.moc.xctestSave()
    sut = CoreDataResultObserver(managedObjectContext: coreDataMocker.moc,
                                 predicate: NSPredicate(format: "id=%d", 3),
                                 includeChildRelations: true,
                                 includeParentRelations: true)
  }
  
  override func tearDown() {
    coreDataMocker.removeStore()
    sut?.invalidate()
    sut = nil
  }

  func setupCoreDataStateForTest() {
    let comment1 = CoreDataComment(context: coreDataMocker.moc)
    comment1.id = 1
    comment1.body = "comment body 1"
    let comment2 = CoreDataComment(context: coreDataMocker.moc)
    comment2.id = 2
    comment2.body = "comment body 2"
    post1 = CoreDataPost(context: coreDataMocker.moc)
    post1.id = 2
    post1.title = "title 1"
    post1.body = "body 1"
    post2 = CoreDataPost(context: coreDataMocker.moc)
    post2.id = 3
    post2.title = "title 2"
    post2.body = "body 2"
    post2.user = CoreDataUser(context: coreDataMocker.moc)
    post2.user?.id = 1
    post2.user?.name = "test user 1"
    post2.comments = NSSet(array: [comment1, comment2])
    post3 = CoreDataPost(context: coreDataMocker.moc)
    post3.id = 5
    post3.title = "title 3"
    post3.body = "body 3"
  }
  
  func testThatResultIsCorrectAfterSetup() {
    XCTAssertEqual(sut.result?.id, 3, "Result is incorrect")
  }
  
  func testThatResultIsNilAfterDeletion() {
    coreDataMocker.moc.delete(post2)
    coreDataMocker.moc.xctestSave()
    XCTAssertNil(sut.result, "Result should be nit after deletion")
  }
  
  func testThatResultUpdatedAfterChange() {
    post2.title = "new title"
    coreDataMocker.moc.xctestSave()
    XCTAssertEqual(sut.result?.title, "new title", "Result title should update")
  }
  
  func testThatDelegateDeleteIsCalled() {
    let delegate = MockObserverDelegate()
    sut.delegate = delegate
    coreDataMocker.moc.delete(post2)
    coreDataMocker.moc.xctestSave()
    XCTAssertTrue(delegate.deleted, "Delegate delete method should be called")
  }
  
  func testThatDelegateUpdateIsCalled() {
    let delegate = MockObserverDelegate()
    sut.delegate = delegate
    post2.title = "new title"
    coreDataMocker.moc.xctestSave()
    XCTAssertTrue(delegate.updated, "Delegate update method should be called")
  }
  
}
