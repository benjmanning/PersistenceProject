//
//  PostDetailViewController.swift
//  PersistenceProject
//
//  Created by Ben Manning on 30/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
import CoreData

class PostDetailViewController: StoryboardlessViewController {
  
  private var viewModel: PostDetailViewModel
  
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var emailLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var bodyLabel: UILabel!
  @IBOutlet var commentsLabel: UILabel!
  
  init(postDetailViewModel: PostDetailViewModel) {
    viewModel = postDetailViewModel
    super.init(nibName: "PostDetail")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Post Detail"
    
    // Set accessibilityIdentifier's
    titleLabel.accessibilityIdentifier = "PostDetailTitle"
    bodyLabel.accessibilityIdentifier = "PostDetailBody"
    authorLabel.accessibilityIdentifier = "PostDetailAuthor"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    weak var weakSelf = self
    
    viewModel.viewDataObserver = {
      
      if let self = weakSelf {
        self.titleLabel.text = self.viewModel.title
        self.bodyLabel.text = self.viewModel.body
        self.authorLabel.text = self.viewModel.author
        self.emailLabel.text = self.viewModel.email
        self.commentsLabel.text = self.viewModel.commentCount
      }
    }
    
    viewModel.deleteObsever = {
      
      if let self = weakSelf {
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
}
