//
//  PostDetailViewModelTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 08/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

private class FakePostRepository: PostRepository {
  let observable: StaticObservableObj<Post>
  init(post: Post) {
    self.observable = StaticObservableObj(post)
  }
  
  func getAll() -> ObservableList<Post> {
    return ObservableList()
  }
  
  func getWithComments(id: Int64) -> ObservableObj<Post> {
    return observable
  }
}

class PostDetailViewModelTests: XCTestCase {
  
  var sut: PostDetailViewModel!
  private var mockRepo: FakePostRepository!
  
  override func setUp() {
    setupWithTestModel()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func setupWithTestModel() {
    let post = Post(id: 1,
                    userId: 1,
                    title: "test title",
                    body: "test body",
                    user: User(
                      id: 1,
                      name: "test username",
                      email: "test email"),
                    comments: [
                      Comment(
                        id: 1,
                        postId: 1,
                        body: "comment 1"),
                      Comment(
                        id: 2,
                        postId: 1,
                        body: "comment 2")
      ])
    
    mockRepo = FakePostRepository(post: post)
    
    sut = PostDetailViewModel(repository: mockRepo, postId: 1)
  }
  
  
  var title: String = ""
  var body: String = ""
  var author: String = ""
  var email: String = ""
  var commentCount: String = ""
  
  func testViewModelTitleIsCorrect() {
    XCTAssertEqual(sut.title, "test title", "The view model's title attribute is incorrect")
  }
  
  func testViewModelBodyIsCorrect() {
    XCTAssertEqual(sut.body, "test body", "The view model's body attribute is incorrect")
  }
  
  func testViewModelAuthorIsCorrect() {
    XCTAssertEqual(sut.author, "test username", "The view model's author attribute is incorrect")
  }
  
  func testViewModelEmailIsCorrect() {
    XCTAssertEqual(sut.email, "test email", "The view model's email attribute is incorrect")
  }
  
  func testViewModelCommentCountIsCorrect() {
    XCTAssertEqual(sut.commentCount, "(2 comments)", "The view model's comment count attribute is incorrect")
  }
  
  func testWhenObserverDeletesObjectViewModelCallsDeleteObserver() {
    var deleteCalled = false
    
    sut.deleteObsever = {
      deleteCalled = true
    }
    
    mockRepo.observable.delegate?.observableObjDelete()
    
    XCTAssertTrue(deleteCalled, "deleteObsever should be called when object is deleted")
  }
  
  func testWhenObserverUpdatesObjectViewModelCallsDataObserver() {
    var dataObserverCalled = false
    
    sut.viewDataObserver = {
      dataObserverCalled = true
    }
    
    mockRepo.observable.delegate?.observableObjDelete()
    
    XCTAssertTrue(dataObserverCalled, "viewDataObserver should be called when object is updated")
  }
}
