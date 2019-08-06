//
//  CommentsRequest.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct CommentsRequest: APIRequest {
  init(postId: Int64) {
    getParams = ["postId": "\(postId)"]
  }
  typealias Response = [CommentDTO]
  let getParams: [String: String]
  let path: String = "/comments"
}
