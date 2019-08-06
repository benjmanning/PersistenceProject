//
//  User.swift
//  PersistenceProject
//
//  Created by Ben Manning on 23/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct User {
  let id: Int64
  let name: String
  let email: String
  
  init(id: Int64, name: String, email: String) {
    self.id = id
    self.name = name
    self.email = email
  }
}
