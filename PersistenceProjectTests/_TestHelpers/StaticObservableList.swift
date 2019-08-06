//
//  StaticObservableList.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 29/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
@testable import PersistenceProject

class StaticObservableList<Obj>: ObservableList<Obj> {
  var objs: [Obj]
  override var results: [Obj] {
    return objs
  }
  init(_ objs: [Obj]) {
    self.objs = objs
  }
}
