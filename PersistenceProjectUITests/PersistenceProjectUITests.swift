//
//  PersistenceProjectUITests.swift
//  PersistenceProjectUITests
//
//  Created by Ben Manning on 20/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest

class PersistenceProjectUITests: XCTestCase {
  
  override func setUp() {
    
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    
  }
  
  func testThatPostDetailsMatchPostList() {
    
    let app = XCUIApplication()
    
    // Check the first 4 cells
    for i in 0...3 {
      
      let cell = app.tables.cells.element(boundBy: i)
      
      // Get the details from the cell on the list screen
      let postItemTitle = cell.staticTexts.element(matching: .staticText, identifier: "PostItemTitle").label
      let postItemPreview = cell.staticTexts.element(matching: .staticText, identifier: "PostItemPreview").label
      let postItemAuthor = cell.staticTexts.element(matching: .staticText, identifier: "PostItemAuthor").label
      
      
      cell.tap()
      
      // Get the details from the details screen
      let postDetailTitle = app.staticTexts.element(matching: .staticText, identifier: "PostDetailTitle").label
      let postDetailBody = app.staticTexts.element(matching: .staticText, identifier: "PostDetailBody").label
      let postDetailAuthor = app.staticTexts.element(matching: .staticText, identifier: "PostDetailAuthor").label
      
      // Compare the results
      XCTAssertEqual(postItemTitle, postDetailTitle, "The title of the post on the list screen does not match that on the detail screen")
      XCTAssertEqual(postItemPreview, postDetailBody.replacingOccurrences(of: "\n", with: " "), "The preview of the post on the list screen does not match the body on the detail screen")
      XCTAssertEqual(postItemAuthor, postDetailAuthor, "The author of the post on the list screen does not match that on the detail screen")
      
      // Tap the back button
      app.navigationBars.buttons.element(boundBy: 0).tap()
    }
  }
}
