//
//  TableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/27.
//

import UIKit

class BoxOfficeCell: UITableViewCell {

  @IBOutlet weak var rankImageView: UIImageView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  
  let selectedView: UIView = {
    let selectedView = UIView(frame: .zero)
    selectedView.backgroundColor = .white.withAlphaComponent(0.5)
    selectedView.layer.cornerRadius = 8
    return selectedView
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectedBackgroundView = selectedView
    
  }
  
  
  
  func configure(movie: BoxOfficeModel) {
    rankImageView.image = .init(systemName: "\(movie.rank).circle.fill")
    movieTitleLabel.text = movie.title
    releaseDateLabel.text = movie.pubDate
  }
  
}
