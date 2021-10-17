//
//  MovieSearchTableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

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
    // Initialization code
  }
  
  
  func configure(with media: MediaContent) {
    posterImageView.image = UIImage(named: "h_a_tale_dark_grimm")
    titleLabel.text = media.title
    mediaDate = media.releaseDate
    languageLabel.text = media.region
    storylineLabel.text = media.overview
  }
  
}
