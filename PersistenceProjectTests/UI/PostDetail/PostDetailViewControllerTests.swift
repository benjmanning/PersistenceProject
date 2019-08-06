//
//  PostDetailViewControllerTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

private class MockObservableObj: ObservableObj<Post> {
  let post: Post
  override var result: Post? {
    return post
  }
  init(post: Post) {
    self.post = post
  }
}

private class MockPostRepository: PostRepository {
  func getAll() -> ObservableList<Post> {
    return ObservableList()
  }
  
  func getWithComments(id: Int64) -> ObservableObj<Post> {
    return MockObservableObj(
      post: Post(
        id: 1,
        userId: 2,
        title: "test title",
        body: "test body",
        user: User(
          id: 3,
          name: "test user name",
          email: "test user email"),
        comments: [
          Comment(
            id: 4,
            postId: 1,
            body: "test comment 1"),
          Comment(
            id: 5,
            postId: 1,
            body: "test comment 2")
        ]))
  }
}

class PostDetailViewControllerTests: XCTestCase {
  
  var sut: PostDetailViewController!
  
  override func setUp() {
    sut = PostDetailViewController(
      postDetailViewModel: PostDetailViewModel(
        repository: MockPostRepository(),
        postId: 1))
    sut.loadViewIfNeeded()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func testTitleAccessibilityLabelsIsCorrect() {
    XCTAssertEqual(sut.titleLabel.accessibilityIdentifier, "PostDetailTitle", "Incorrect AccessibilityIdentifier on titleLabel")
  }
  
  func testBodyAccessibilityLabelsIsCorrect() {
    XCTAssertEqual(sut.bodyLabel.accessibilityIdentifier, "PostDetailBody", "Incorrect AccessibilityIdentifier on bodyLabel")
  }
  
  func testAuthorAccessibilityLabelsIsCorrect() {
    XCTAssertEqual(sut.authorLabel.accessibilityIdentifier, "PostDetailAuthor", "Incorrect AccessibilityIdentifier on authorLabel")
  }
  
  func testTitleLabelIsSetAfterAppear() {
    sut.viewWillAppear(true)
    XCTAssertEqual(sut.titleLabel.text, "test title", "Incorrect titleLabel")
  }
  
  func testBodyLabelIsSetAfterAppear() {
    sut.viewWillAppear(true)
    XCTAssertEqual(sut.bodyLabel.text, "test body", "Incorrect bodyLabel")
  }
  
  func testAuthorLabelIsSetAfterAppear() {
    sut.viewWillAppear(true)
    XCTAssertEqual(sut.authorLabel.text, "test user name", "Incorrect authorLabel")
  }
  
  func testEmailLabelIsSetAfterAppear() {
    sut.viewWillAppear(true)
    XCTAssertEqual(sut.emailLabel.text, "test user email", "Incorrect emailLabel")
  }
  
  func testCommentLabelIsSetAfterAppear() {
    sut.viewWillAppear(true)
    XCTAssertEqual(sut.commentsLabel.text, "(2 comments)", "Incorrect commentsLabel")
  }
}
