//
//  AccessibilityLabel.swift
//  PersistenceProject
//
//  Created by Ben Manning on 28/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

@IBDesignable class AccessibilityLabel: UILabel {
  
  @IBInspectable var footnoteScale: Bool = false
  @IBInspectable var bodyScale: Bool = false
  
  var originalFont: UIFont?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    originalFont = font
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
      scaleFont()
    }
  }
  
  private func scaleFont() {
    guard let originalFont = originalFont else {
      return
    }
    
    guard let textStyle = chosenTextStyle() else {
      return
    }
    
    let fontMetrics: UIFontMetrics = UIFontMetrics(forTextStyle: textStyle)
    font = fontMetrics.scaledFont(for: originalFont)
  }
  
  private func chosenTextStyle() -> UIFont.TextStyle? {
    if footnoteScale {
      return .footnote
    } else if bodyScale {
      return .body
    }
    
    return nil
  }
}
