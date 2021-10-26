//
//  MovieSearchTableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit
import Kingfisher

class MovieSearchTableViewCell: UITableViewCell {
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var storylineLabel: UILabel!
  
  var mediaDate: String = ""
  
  private var releaseDate: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    
    let printOutDateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = formatter.date(from: mediaDate) else { return nil }
    
    return printOutDateFormatter.string(from: date)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  private func setup() {
    selectionStyle = .none
  }
  
  func configure(with media: MovieModel) {
    titleLabel.text = media.title
    mediaDate = media.pubData
    languageLabel.text = "미-국"
    storylineLabel.text = media.actor
    
    let url = URL(string: media.image)
    let processor = DownsamplingImageProcessor(size: posterImageView.bounds.size)
    posterImageView.kf.indicatorType = .activity
    posterImageView.kf.setImage(
      with: url,
      placeholder: UIImage(systemName: "film"),
      options: [
        .processor(processor),
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
  }
  
}


