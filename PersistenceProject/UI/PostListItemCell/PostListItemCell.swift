//
//  PostListItemCell.swift
//  PersistenceProject
//
//  Created by Ben Manning on 22/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class PostListItemCell: UITableViewCell {
  
  public static let reuseIdentifier = "PostListItemCell"
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var previewLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Set accessibilityIdentifier's
    titleLabel.accessibilityIdentifier = "PostItemTitle"
    previewLabel.accessibilityIdentifier = "PostItemPreview"
    authorLabel.accessibilityIdentifier = "PostItemAuthor"
  }
  
  public func setData(viewModel: PostListItemViewModel) {
    
    titleLabel.text = viewModel.title
    previewLabel.text = viewModel.preview
    authorLabel.text = viewModel.author
  }
}
