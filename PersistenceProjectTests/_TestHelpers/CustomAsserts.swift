//
//  CustomAsserts.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

class CustomAsserts {
  class func assertPostArrayMatches(testing: String, facts: [Post], actuals: [Post]) {
    XCTAssertEqual(actuals.count, facts.count, "There should be \(facts.count) rows for \(testing)")
    
    if facts.count == actuals.count {
      for (i, fact) in facts.enumerated() {
        let actual = actuals[i]
        XCTAssertEqual(actual.id, fact.id, "Row \(i) id incorrect for \(testing)")
        XCTAssertEqual(actual.userId, fact.userId, "Row \(i) userId incorrect for \(testing)")
        XCTAssertEqual(actual.title, fact.title, "Row \(i) title incorrect for \(testing)")
        XCTAssertEqual(actual.body, fact.body, "Row \(i) body incorrect for \(testing)")
      }
    }
  }
  class func assertIntArrayMatches(testing: String, facts: [Int64], actuals: [Int64]) {
    XCTAssertEqual(actuals.count, facts.count, "There should be \(facts.count) rows for \(testing)")
    
    if facts.count == actuals.count {
      for (i, fact) in facts.enumerated() {
        XCTAssertEqual(actuals[i], fact, "Row \(i) id incorrect for \(testing)")
      }
    }
  }
}
