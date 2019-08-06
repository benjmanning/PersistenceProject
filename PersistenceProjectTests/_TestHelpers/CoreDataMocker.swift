//
//  CoreDataMocker.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 03/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
import CoreData
@testable import PersistenceProject

class CoreDataMocker: NSObject {
  
  static let container: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "CoreDataModel")
    
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    
    container.persistentStoreDescriptions = [description]
    
    return container
  }()
  
  var moc: NSManagedObjectContext {
    
    return CoreDataMocker.container.viewContext
  }
  
  func removeStore() {
    
    for store in CoreDataMocker.container.persistentStoreCoordinator.persistentStores {
      do {
        try CoreDataMocker.container.persistentStoreCoordinator.remove(store)
      } catch {
        print("Failed to remove store \(error)")
      }
    }
  }
  
  func loadStore() {
    
    CoreDataMocker.container.viewContext.reset()
    
    CoreDataMocker.container.loadPersistentStores(completionHandler: { (_, error) in
      
      if let error = error {
        
        XCTFail("Failed to create in memory persistent store \(error)")
      }
    })
    
  }
  
  func createInitialState() {
    
    func insertPost(id: Int64, title: String, body: String) {
      
      let post = CoreDataPost(context: moc)
      post.id = id
      post.title = title
      post.body = body
    }
    
    insertPost(id: 1, title: "title1", body: "body1")
    insertPost(id: 2, title: "title2", body: "body2")
    insertPost(id: 3, title: "title3", body: "body3")
    
    do {
      try moc.save()
    } catch {
      print("create fakes error \(error)")
    }
  }
  
  func fetchOrderedPosts() -> [CoreDataPost] {
    
    let fetchRequest = CoreDataPost.fetchRequest() as NSFetchRequest<CoreDataPost>
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    guard let results = try? moc.fetch(fetchRequest) else {
      
      XCTFail("Could not test the initial state, the fetch failed")
      return []
    }
    
    return results
  }
  
  func assertCoreDataPostCount(count: Int, message: String) {
    
    let results = try? moc.fetch(CoreDataPost.fetchRequest())
    
    XCTAssertEqual(results?.count ?? -1, count, message)
  }
  
  func assertInitialState() {
    
    let results = fetchOrderedPosts()
    
    XCTAssertEqual(results.count, 3, "CoreData should contain 3 rows after setup")
    
    for (i, mo) in results.enumerated() {
      
      let n = Int64(i + 1)
      XCTAssertEqual(mo.id, n, "The first row's id should be \(n) after setup")
      XCTAssertEqual(mo.title ?? "[nil]", "title\(n)", "The first row's title should be \"title\(n)\" after setup")
      XCTAssertEqual(mo.body ?? "[nil]", "body\(n)", "The first row's body should be \"body\(n)\" after setup")
    }
  }
  
  func assertStateMatchesDTOs(dtos: [PostDTO]) {
    
    let results = fetchOrderedPosts()
    
    XCTAssertEqual(results.count, dtos.count, "CoreData should contain \(dtos.count) rows after sync")
    
    if results.count == dtos.count {
      
      for (i, mo) in results.enumerated() {
        
        let dto = dtos[i]
        XCTAssertEqual(mo.id, dto.id, "The first row's id should be \(dto.id) after setup")
        XCTAssertEqual(mo.title ?? "[nil]", dto.title, "The first row's title should be \"\(dto.title)\" after setup")
        XCTAssertEqual(mo.body ?? "[nil]", dto.body, "The first row's body should be \"\(dto.body)\" after setup")
      }
    }
  }
}
