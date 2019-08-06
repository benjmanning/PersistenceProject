//
//  StaticObservableObj.swift
//  PersistenceProjectTests
//
//  Created by Ben Manning on 28/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
@testable import PersistenceProject

class StaticObservableObj<Obj>: ObservableObj<Obj> {
  var obj: Obj?
  override var result: Obj? {
    return obj
  }
  init(_ obj: Obj) {
    self.obj = obj
  }
}
