//
//  ImageCell.swift
//  HeyWeather
//
//  Created by hoseung Lee on 2021/10/25.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
  
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var weatherStateImageView: UIImageView! {
    didSet {
      weatherStateImageView.layer.cornerRadius = 8
    }
  }
   
  static let identifier = "ImageCell"
  
  func configure(imageURL: String) {
    let url = URL(string: imageURL)
    let processor = DownsamplingImageProcessor(size: weatherStateImageView.bounds.size)
    weatherStateImageView.kf.indicatorType = .activity
    weatherStateImageView.kf.setImage(
      with: url,
      placeholder: nil,
      options: [
        .processor(processor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ]) { result in
        switch result {
        case .success(let value):
          print("Task done for: \(value.source.url?.absoluteString ?? "")")
        case .failure(let error):
          print("Job failed: \(error.localizedDescription)")
        }
      }
  }
  
}
