//
//  Comment.swift
//  PersistenceProject
//
//  Created by Ben Manning on 26/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct Comment {
  let id: Int64
  let postId: Int64?
  let body: String
  let post: Post?
  
  init(id: Int64, postId: Int64?, body: String, post: Post? = nil) {
    self.id = id
    self.postId = postId
    self.body = body
    self.post = post
  }
}
