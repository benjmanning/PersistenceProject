//
//  StoryboardlessViewController.swift
//  PersistenceProject
//
//  Created by Ben Manning on 24/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class StoryboardlessViewController: UIViewController {
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle? = nil) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  @available(*, unavailable,
  message: "Loading this view controller from a storyboard is unsupported in favor of initializer dependency injection"
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view controller from a storyboard is unsupported in favor of initializer dependency injection")
  }
}
