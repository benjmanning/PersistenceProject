//
//  PostListItemViewModelTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 08/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

class PostListItemViewModelTests: XCTestCase {
  
  var sut: PostListItemViewModel!
  
  override func setUp() {
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func setupWithModel() {
    setupWithModel(andBody: "test body")
  }
  
  func setupWithModel(andBody body: String) {
    let post = Post(
      id: 1,
      userId: 1,
      title: "test title",
      body: body,
      user: User(
        id: 1,
        name: "test username",
        email: "test email"),
      comments: [])
    
    sut = PostListItemViewModel(post: post)
  }
  
  
  func testViewModelTitleIsCorrect() {
    setupWithModel()
    
    XCTAssertEqual(sut.title, "test title", "The view model's title attribute is incorrect")
  }
  
  func testViewModelPreviewIsCorrect() {
    setupWithModel()
    
    XCTAssertEqual(sut.preview, "test body", "The view model's preview attribute is incorrect")
  }
  
  func testViewModelPreviewWithNewLineIsCorrect() {
    setupWithModel(andBody: "test\nbody")
    
    XCTAssertEqual(sut.preview, "test body", "The view model's preview attribute is incorrect")
  }
  
  func testViewModelAuthorIsCorrect() {
    setupWithModel()
    
    XCTAssertEqual(sut.author, "test username", "The view model's author attribute is incorrect")
  }
}
