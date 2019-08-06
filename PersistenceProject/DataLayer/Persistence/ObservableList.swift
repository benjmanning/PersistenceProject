//
//  ObservableList.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class ObservableList<ModelObj> {
  var results: [ModelObj] { return [] }
  weak var delegate: ObservableListDelegate?
}
