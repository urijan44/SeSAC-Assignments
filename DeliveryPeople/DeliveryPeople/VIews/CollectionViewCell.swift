//
//  CollectionViewCell.swift
//  DeliveryPeople
//
//  Created by hoseung Lee on 2021/09/28.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var categoryLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    image.isUserInteractionEnabled = true
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    image.addGestureRecognizer(gesture)
  }
  
  @objc func tapped() {
    print("\(categoryLabel.text ?? "tap")")
  }
  
  
}
