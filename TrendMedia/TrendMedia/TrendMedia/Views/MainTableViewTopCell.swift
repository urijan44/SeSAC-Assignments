//
//  MainTableViewHeaderView.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class MainTableViewTopCell: UITableViewCell {
  
  @IBOutlet weak var filterView: UIView! {
    didSet {
      filterView.layer.cornerRadius = 8
      filterView.layer.shadowOffset = .init(width: 0, height: 2)
      filterView.layer.shadowOpacity = 0.3
      filterView.layer.shadowRadius = 5
    }
  }
}
