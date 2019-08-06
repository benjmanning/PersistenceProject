//
//  PostListItemViewModel.swift
//  PersistenceProject
//
//  Created by Ben Manning on 07/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class PostListItemViewModel {
  
  private let post: Post
  
  let title: String
  let preview: String
  let author: String
  
  init(post: Post) {
    
    self.post = post
    
    title = post.title
    preview = post.body.replacingOccurrences(of: "\n", with: " ")
    author = post.user?.name ?? ""
  }
}
