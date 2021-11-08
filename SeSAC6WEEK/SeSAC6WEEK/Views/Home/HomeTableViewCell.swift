//
//  HomeTableViewCell.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/08.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  static let identifier = "HomeTableViewCell"
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var contentCollectionView: UICollectionView! {
    didSet {
//      contentCollectionView.delegate = self
//      contentCollectionView.dataSource = self
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
}
