//
//  PostDetailImageView.swift
//  PersistenceProject
//
//  Created by Ben Manning on 07/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

class PostDetailImageView: UIImageView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.darkGray.cgColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = self.bounds.width / 2
  }
}
