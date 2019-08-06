//
//  LoggerTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 01/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

class MockLogger: Logger {
  
  var lastLogLevel: Logger.Level!
  var lastLogLine: String!
  
  override init() {
    super.init()
  }
  
  override func log(level: Logger.Level, message: String, file: String) {
    
    lastLogLevel = level
    super.log(level: level, message: message, file: file)
  }
  
  override func log(level: Logger.Level, line: String) {
    
    lastLogLine = line
    super.log(level: level, line: line)
  }
}

class LoggerTests: XCTestCase {
  
  var sut: MockLogger!
  
  override func setUp() {
    
    super.setUp()
    
    sut = MockLogger()
  }
  
  override func tearDown() {
    
    super.tearDown()
    
    sut = nil
  }
  
  func testDebugLogIsReportedAsDebug() {
    
    sut.log(level: .info, message: "test message", file: "/var/mobile/Containers/Data/Application/00/PersistenceProject.swift")
    
    XCTAssertEqual(sut.lastLogLine, "[PersistenceProject] - test message", "Log line incorrectly formatted")
    XCTAssertEqual(sut.lastLogLevel, Logger.Level.info, "Incorrect log level reported")
  }
  
  
}
