//
//  JsonDecoderTests.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 01/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import XCTest
@testable import PersistenceProject

class JsonDecoderTests: XCTestCase {
  
  var sut: JsonDecoder!
  
  override func setUp() {
    
    super.setUp()
    
    sut = JsonDecoder()
  }
  
  override func tearDown() {
    
    super.tearDown()
    
    sut = nil
  }
  
  func runDecoder<Out: Decodable>(withJson json: Data, result: (Out) -> Void) {
    
    XCTAssertNoThrow(try sut.decode(data: json) as Out, "JsonDecoder threw an error")
    
    if let decoded = try? sut.decode(data: json) as Out {
      
      result(decoded)
      
    } else {
      
      XCTFail("Decoded was nil")
    }
  }
  
  func testJsonDecodeForCommentDto() {
    
    let jsonData = """
[
    {
        "postId": 1,
        "id": 1,
        "name": "id labore ex et quam laborum",
        "email": "Eliseo@gardner.biz",
        "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium"
    }
]
""".data(using: .utf8)!
    
    let expectedDto = CommentDTO(postId: 1, id: 1, name: "id labore ex et quam laborum", email: "Eliseo@gardner.biz", body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
    
    
    runDecoder(withJson: jsonData) { (decoded: [CommentDTO]) in
      
      XCTAssertEqual(decoded.count, 1, "There should be exactly 1 object in the decoded json")
      XCTAssertEqual(decoded[0].postId, expectedDto.postId, "postId was incorrect")
      XCTAssertEqual(decoded[0].id, expectedDto.id, "id was incorrect")
      XCTAssertEqual(decoded[0].name, expectedDto.name, "name was incorrect")
      XCTAssertEqual(decoded[0].email, expectedDto.email, "email was incorrect")
      XCTAssertEqual(decoded[0].body, expectedDto.body, "body was incorrect")
      
    }
  }
  
  func testJsonDecodeForPostDto() {
    
    let jsonData = """
[
    {
        "userId": 2,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
    }
]
""".data(using: .utf8)!
    
    let expectedDto = PostDTO(
      id: 1, userId: 2, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
      body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
    
    
    runDecoder(withJson: jsonData) { (decoded: [PostDTO]) in
      
      XCTAssertEqual(decoded.count, 1, "There should be exactly 1 object in the decoded json")
      XCTAssertEqual(decoded[0].userId, expectedDto.userId, "postId was incorrect")
      XCTAssertEqual(decoded[0].id, expectedDto.id, "id was incorrect")
      XCTAssertEqual(decoded[0].title, expectedDto.title, "title was incorrect")
      XCTAssertEqual(decoded[0].body, expectedDto.body, "body was incorrect")
      
    }
  }
  
  func testJsonDecodeForUserDto() {
    
    let jsonData = """
[
    {
        "id": 1,
        "name": "Leanne Graham",
        "username": "Bret",
        "email": "Sincere@april.biz",
        "address": {
            "street": "Kulas Light",
            "suite": "Apt. 556",
            "city": "Gwenborough",
            "zipcode": "92998-3874",
            "geo": {
                "lat": "-37.3159",
                "lng": "81.1496"
            }
        },
        "phone": "1-770-736-8031 x56442",
        "website": "hildegard.org",
        "company": {
            "name": "Romaguera-Crona",
            "catchPhrase": "Multi-layered client-server neural-net",
            "bs": "harness real-time e-markets"
        }
    }
]
""".data(using: .utf8)!
    
    let expectedDto = UserDTO(id: 1, name: "Leanne Graham", email: "Sincere@april.biz")
    
    runDecoder(withJson: jsonData) { (decoded: [UserDTO]) in
      
      XCTAssertEqual(decoded.count, 1, "There should be exactly 1 object in the decoded json")
      XCTAssertEqual(decoded[0].id, expectedDto.id, "id was incorrect")
      XCTAssertEqual(decoded[0].name, expectedDto.name, "name was incorrect")
      XCTAssertEqual(decoded[0].email, expectedDto.email, "email was incorrect")
      
    }
  }
  
  func testPrimativeTypeJson() {
    
    let jsonData = "[43]".data(using: .utf8)!
    
    runDecoder(withJson: jsonData) { (decoded: [Int]) in
      
      XCTAssertEqual(decoded.first, 43, "The decoded value was incorrect")
      
    }
  }
  
  func testIncorrectJsonThrowsAnError() {
    
    let jsonData = """
[
    {
        "userId": 2,
        "id": 1,
        "qwe": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "asd": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
    }
]
""".data(using: .utf8)!
    
    XCTAssertThrowsError(try sut.decode(data: jsonData) as [PostDTO], "Incorrect json should throw an error")
  }
  
  func testInvalidJsonThrowsAnError() {
    
    let jsonData = "abcd123".data(using: .utf8)!
    
    XCTAssertThrowsError(try sut.decode(data: jsonData) as [PostDTO], "Invalid json should throw an error")
  }
  
}
