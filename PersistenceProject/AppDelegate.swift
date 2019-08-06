//
//  AppDelegate.swift
//  PersistenceProject
//
//  Created by Ben Manning on 20/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let appDependencyContainer = AppDependencyContainer()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let mainVC = appDependencyContainer.makeMainViewController()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = mainVC

    return true
  }
}
