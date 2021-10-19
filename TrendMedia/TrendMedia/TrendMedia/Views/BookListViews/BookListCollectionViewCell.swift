//
//  BookListCollectionViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/20.
//

import UIKit
import Kingfisher

class BookListCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var containerView: UIView! {
    didSet {
      
      containerView.backgroundColor = randomColors.randomElement()?.withAlphaComponent(0.5)
      containerView.layer.cornerRadius = 16
    }
  }
  @IBOutlet weak var mediaTitleLabel: UILabel!
  @IBOutlet weak var mediaImageView: UIImageView! {
    didSet {
      mediaImageView.contentMode = .scaleAspectFill
      mediaImageView.layer.cornerRadius = 8
    }
  }
  @IBOutlet weak var rateLabel: UILabel!
  
  private let randomColors: [UIColor] = [.red, .green, .magenta, .orange, .brown, .gray, .lightGray, .purple]
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configure(with media: MediaContent) {
    mediaTitleLabel.text = media.title
    let url = URL(string: media.backdropImage)
    mediaImageView.kf.setImage(with: url)
//    containerView.backgroundColor = mediaImageView.image?.findAverageColor() //너무 느리다
    rateLabel.text = String(format: "%.1f", media.rate)
  }
  
  
}
