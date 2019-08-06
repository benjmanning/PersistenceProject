//
//  PostListViewModelTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

private class FakePostRepository: PostRepository {
  let observable: StaticObservableList<Post>
  init(posts: [Post]) {
    self.observable = StaticObservableList(posts)
  }
  
  func getAll() -> ObservableList<Post> {
    return observable
  }
  
  func getWithComments(id: Int64) -> ObservableObj<Post> {
    return ObservableObj()
  }
}

private class FakeObservableListDelegate: ObservableListDelegate {
  func observerBeginChanges() { }
  func observerEndChanges() { }
  func observerChange(at indexPath: IndexPath?, operation type: ObservableListChangeType, newIndexPath: IndexPath?) { }
}

class PostListViewModelTests: XCTestCase {
  
  var sut: PostListViewModel!
  private var mockRepo: FakePostRepository!
  
  override func setUp() {
    setupWithTestModel()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func setupWithTestModel() {    
    mockRepo = FakePostRepository(posts: modelForTest())
    sut = PostListViewModel(repository: mockRepo)
  }
  
  func modelForTest() -> [Post] {
    return [
      Post(id: 1,
           userId: 1,
           title: "test title 1",
           body: "test body 1"
      ),
      Post(id: 2,
           userId: 1,
           title: "test title 2",
           body: "test body 2"
      ),
      Post(id: 3,
           userId: 1,
           title: "test title 3",
           body: "test body 3"
      )]
  }
  
  func testThatViewModelPostsAreCorrect() {
    CustomAsserts.assertPostArrayMatches(testing: "viewModel posts property", facts: modelForTest(), actuals: sut.posts)
  }
  
  func testViewModelObserverDelegateIsPassedToObservableList() {
    let delegate = FakeObservableListDelegate()
    
    sut.fetchedResultsObserverDelegate = delegate
    
    XCTAssertTrue(delegate === mockRepo.observable.delegate, "Delegate should be passed directly to the internal ObservableList")
  }
}
