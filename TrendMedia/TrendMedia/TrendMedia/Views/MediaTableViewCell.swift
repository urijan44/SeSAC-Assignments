//
//  TableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/17.
//

import UIKit
import Kingfisher

class MediaTableViewCell: UITableViewCell {
  
  @IBOutlet weak var shadowView: UIView! {
    didSet {
      shadowView.clipsToBounds = false
      shadowView.backgroundColor = .clear
      shadowView.layer.shadowOpacity = 0.3
      shadowView.layer.shadowOffset = .init(width: 0, height: 2)
      shadowView.layer.shadowRadius = 6
    }
  }
  @IBOutlet weak var containerView: UIView! {
    didSet {
      containerView.layer.cornerRadius = 8
      containerView.clipsToBounds = true
      
    }
  }
  @IBOutlet weak var tagLineLabel: UILabel!
  @IBOutlet weak var englishTitleLabel: UILabel!
  @IBOutlet weak var mediaPosterImage: UIImageView! {
    didSet {
      mediaPosterImage.contentMode = .scaleAspectFill
    }
  }
  @IBOutlet weak var mediaRateLabel: UILabel!
  @IBOutlet weak var koreanTitleLabel: UILabel!
  @IBOutlet weak var mediaDateLabel: UILabel!
  @IBOutlet weak var lineView: LineView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(_ media: MediaContent) {
    englishTitleLabel.text = media.title
    mediaRateLabel.text = String(format: "%.1f", media.rate)
    koreanTitleLabel.text = media.title
    mediaDateLabel.text = media.releaseDate
    let url = URL(string: media.backdropImage)
    mediaPosterImage.kf.setImage(with: url, placeholder: UIImage(), options: nil, completionHandler: nil)
  }
  
  private func setup() {
    selectionStyle = .none
  }
}
