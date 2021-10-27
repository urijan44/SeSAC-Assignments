//
//  ActorTableViewHeaderView.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit
import Kingfisher

class ActorTableViewHeaderView: UITableViewHeaderFooterView {
  
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var verticalImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  func configure(with mediaContent: MediaContent) {
    let imagePath = mediaContent.poster_path ?? ""
    let verticalImageURL = URL(string: imagePath)
    let headerImageURL = URL(string: mediaContent.backdropImage)
    headerImageView.kf.setImage(with: headerImageURL, placeholder: UIImage(named: Constants.VerticalPoster.aliceInBorderland))
    verticalImageView.kf.setImage(with: verticalImageURL, placeholder: UIImage(named: Constants.VerticalPoster.aliceInBorderland))
    
    titleLabel.text = mediaContent.title
  }
  
}
