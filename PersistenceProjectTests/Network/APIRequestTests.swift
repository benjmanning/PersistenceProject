//
//  APIRequestTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 30/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest

@testable import PersistenceProject

struct MockAPIRequest: APIRequest {
  
  typealias Response = Int
  typealias Decoder = JsonDecoder
  
  var path: String {
    return "somepath"
  }
}

class APIRequestTests: XCTestCase {
  
  var sut: MockAPIRequest!
  
  override func setUp() {
    
    super.setUp()
    
    sut = MockAPIRequest()
  }
  
  override func tearDown() {
    
    super.tearDown()
    
    sut = nil
  }
  
  func testDefaultRequestMethodIsGet() {
    
    XCTAssertEqual(sut.method, "GET", "Default method is not \"GET\"")
  }
  
}
