//
//  CoreDataStoreTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 01/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

import CoreData

class CoreDataStoreTests: XCTestCase {
  
  var sut: CoreDataContainer!
  var coreDataMocker = CoreDataMocker()
  
  override func setUp() {
    super.setUp()
    
    coreDataMocker.loadStore()
    sut = CoreDataContainer()
    sut.persistentContainer = CoreDataMocker.container
  }
  
  override func tearDown() {
    super.tearDown()
    
    coreDataMocker.removeStore()
    sut = nil
  }
  
  func testModelObjectContextExistsWhenCoreDataStoreIsInstantiated() {
    
    XCTAssertNotNil(sut.moc, "Persistent container was not created")
  }
  
  func testMocIsCreatedOnTheMainQueue() {
    
    XCTAssertEqual(sut.moc.concurrencyType, .mainQueueConcurrencyType, "The main MOC should be created on the main queue")
  }
  
  func testBackgroundMocIsCreatedOnAPrivateQueue() {
    
    let backgroundMoc = sut.createBackgroundMoc()
    
    XCTAssertEqual(backgroundMoc.concurrencyType, .privateQueueConcurrencyType, "The background MOC should be created on a private queue")
  }
  
  func testBackgroundMocParentIsMainMoc() {
    
    let backgroundMoc = sut.createBackgroundMoc()
    
    if backgroundMoc.parent !== sut.moc {
      
      XCTFail("A background moc must have a parent of the main moc")
    }
  }
}
