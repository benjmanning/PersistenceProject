//
//  UserDTO.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import Foundation

struct UserDTO: Decodable {
  let id: Int64
  let name: String
  let email: String
}
