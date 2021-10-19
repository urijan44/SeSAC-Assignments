//
//  DetailMediaStorylineTableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/19.
//

import UIKit

class DetailMediaStorylineTableViewCell: UITableViewCell {
  
  @IBOutlet weak var storylineLabel: UILabel!
  @IBOutlet weak var pageScrollButton: UIButton! {
    didSet {
      pageScrollButton.tintColor = .black
    }
  }
  @IBOutlet weak var shadowContainerView: UIView! {
    didSet {
      shadowContainerView.backgroundColor = .white
      shadowContainerView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
      shadowContainerView.layer.borderWidth = 1
      shadowContainerView.layer.cornerRadius = max(shadowContainerView.frame.height, shadowContainerView.frame.width) / 2
      shadowContainerView.layer.shadowRadius = 3
      shadowContainerView.layer.shadowOffset = .init(width: 0, height: 3)
      shadowContainerView.layer.shadowColor = UIColor.black.cgColor
      shadowContainerView.layer.shadowOpacity = 0.1
    }
  }
  
  var pageScrollState = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  private func setup() {
    selectionStyle = .none
    

  }
}
