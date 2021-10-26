//
//  TableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/17.
//

import UIKit
import Kingfisher

protocol MediaTableViewCellDelegate {
  func mediaTableViewCell(_ mediaTableViewCell: MediaTableViewCell, mediaContent: MediaContent?)
}

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
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var mediaPosterImage: UIImageView! {
    didSet {
      mediaPosterImage.contentMode = .scaleAspectFill
    }
  }
  @IBOutlet weak var mediaRateLabel: UILabel!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var castLabel: UILabel!
  @IBOutlet weak var lineView: LineView!
  @IBOutlet weak var webViewButton: UIImageView! {
    didSet {
      webViewButton.tintColor = .black
      webViewButton.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showWebViewController))
      webViewButton.addGestureRecognizer(tapGesture)
      
      webViewButton.layer.cornerRadius = webViewButton.frame.height / 2
    }
  }
  
  var delegate: MediaTableViewCellDelegate?
  var media: MediaContent?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(_ media: MediaContent) {
    releaseDateLabel.text = media.releaseDate
    genreLabel.text = "#\(media.genre)"
    mediaRateLabel.text = String(format: "%.1f", media.rate)
    movieTitleLabel.text = media.title
    castLabel.text = media.starring
    
    
    let url = URL(string: media.backdropImage)
    let processor = DownsamplingImageProcessor(size: mediaPosterImage.bounds.size)
    mediaPosterImage.kf.indicatorType = .activity
    mediaPosterImage.kf.setImage(
      with: url,
      placeholder: UIImage(),
      options: [
        .processor(processor),
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
    self.media = media
  }
  
  @objc private func showWebViewController() {
    delegate?.mediaTableViewCell(self, mediaContent: media)
  }
  
  private func setup() {
    selectionStyle = .none
  }
}
