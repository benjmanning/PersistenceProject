//
//  Post.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct Post {
  let id: Int64
  let userId: Int64?
  let title: String
  let body: String
  let user: User?
  let comments: [Comment]

  init(id: Int64, userId: Int64?, title: String, body: String, user: User? = nil, comments: [Comment] = []) {
    self.id = id
    self.userId = userId
    self.title = title
    self.body = body
    self.user = user
    self.comments = comments
  }
}
