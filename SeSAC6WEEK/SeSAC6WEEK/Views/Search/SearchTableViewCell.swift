//
//  SearchTableViewCell.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
  
  static let identifier = "SearchTableViewCell"
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = UIFont().mainBold(fontSize: 17)
    }
  }
  @IBOutlet weak var dateLabel: UILabel! {
    didSet {
      dateLabel.font = UIFont().mainLight(fontSize: 14)
    }
  }
  @IBOutlet weak var diaryDescriptionLabel: UILabel! {
    didSet {
      diaryDescriptionLabel.font = UIFont().mainLight(fontSize: 14)
    }
  }
  @IBOutlet weak var diaryImageView: UIImageView! {
    didSet {
      diaryImageView.layer.cornerRadius = 8
      diaryImageView.backgroundColor = .blue
    }
  }
  
  let selectedView: UIView = {
    let selectedView = UIView(frame: .zero)
    selectedView.backgroundColor = .gray.withAlphaComponent(0.5)
    selectedView.layer.cornerRadius = 8
    return selectedView
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectedBackgroundView = selectedView
    
  }
  
  func configure(with diary: UserDiary, image: UIImage) {
    titleLabel.text = diary.title
    dateLabel.text = diary.writeDate.dateString
    diaryDescriptionLabel.text = diary.content
    diaryImageView.image = image
  }

  
}
