//
//  CoreDataResultsObserverUpdater.swift
//  PersistenceProject
//
//  Created by Ben Manning on 28/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import Foundation

class CoreDataResultsObserverUpdater<Result> {
  
  private let results: [Result]
  
  private var additions: [Int: Result] = [:]
  private var updates: [Int: Result] = [:]
  private var deletions: [Int] = []
  
  private var orderedAdditions: [Int] {
    return self.additions.keys.sorted()
  }
  
  private var orderedDeletions: [Int] {
    return self.deletions.sorted(by: >)
  }
  
  init(results: [Result]) {
    self.results = results
  }
  
  func addResult(result: Result, at index: Int) {
    additions.updateValue(result, forKey: index)
  }
  
  func updateResult(result: Result, at index: Int) {
    updates.updateValue(result, forKey: index)
  }
  
  func deleteResult(at index: Int) {
    deletions.append(index)
  }
  
  func buildResults() -> [Result] {
    
    var output = self.results
    
    for deletion in orderedDeletions {
      output.remove(at: deletion)
    }
    
    for addition in orderedAdditions {
      output.insert(additions[addition]!, at: addition)
    }
    
    for update in updates {
      output[update.key] = update.value
    }
    
    return output
  }
}
