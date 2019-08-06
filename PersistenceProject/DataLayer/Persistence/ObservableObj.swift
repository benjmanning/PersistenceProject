//
//  ObservableObj.swift
//  PersistenceProject
//
//  Created by Ben Manning on 25/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class ObservableObj<ModelObj> {
  var result: ModelObj? { return nil }
  weak var delegate: ObservableObjDelegate?
}
