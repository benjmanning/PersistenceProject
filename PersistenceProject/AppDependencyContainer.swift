//
//  AppDependencyContainer.swift
//  PersistenceProject
//
//  Created by Ben Manning on 09/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class AppDependencyContainer {
  
  private let dataLayerDependencyContainer: DataLayerDependencyContainer
  private let uiDependencyContainer: UIDependencyContainer
    
  init() {
    dataLayerDependencyContainer = DataLayerDependencyContainer()
    
    uiDependencyContainer = UIDependencyContainer(
      dataLayerDependencyContainer: dataLayerDependencyContainer)
  }
    
  func makeMainViewController() -> UIViewController {
    let navController = UINavigationController(
      rootViewController: uiDependencyContainer.makePostListViewController())
    return navController
  }
}
