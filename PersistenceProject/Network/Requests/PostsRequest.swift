//
//  PostsRequest.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct PostsRequest: APIRequest {
  
  typealias Response = [PostDTO]
  let path: String = "/posts"
}
