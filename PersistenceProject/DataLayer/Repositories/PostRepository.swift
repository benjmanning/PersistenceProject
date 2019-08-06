//
//  PostRepository.swift
//  PersistenceProject
//
//  Created by Ben Manning on 20/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

protocol PostRepository {
  func getAll() -> ObservableList<Post>
  func getWithComments(id: Int64) -> ObservableObj<Post>
}
