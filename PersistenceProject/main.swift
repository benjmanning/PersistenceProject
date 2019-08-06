//
//  main.swift
//  PersistenceProject
//
//  Created by Ben Manning on 02/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass = isRunningTests ? nil : NSStringFromClass(AppDelegate.self)

UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  nil,
  appDelegateClass
)
