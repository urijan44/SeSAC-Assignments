//
//  LabelCell.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import UIKit

class LabelCell: UICollectionViewCell {
  
  static let identifier = "LabelCell"
  
  @IBOutlet private var backgroundStackView: UIStackView! {
    didSet {
      backgroundStackView.layer.cornerRadius = 8
    }
  }
  
  @IBOutlet private var descriptionLabel: UILabel!
  
  func configure(description: String) {
    descriptionLabel.text = description
  }
}
