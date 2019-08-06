//
//  UsersRequest.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct UsersRequest: APIRequest {
  
  typealias Response = [UserDTO]
  let path: String = "/users"
}
