//
//  PostDTO.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import Foundation

struct PostDTO: Decodable {
  let id: Int64
  let userId: Int64
  let title: String
  let body: String
}
