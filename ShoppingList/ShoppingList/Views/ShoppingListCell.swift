//
//  ShoppingListCell.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit

class ShoppingListCell: UITableViewCell {
  @IBOutlet weak var backscreenView: UIView! {
    didSet {
      backscreenView.layer.cornerRadius = 15
    }
  }
  @IBOutlet weak var checkboxImageView: UIImageView! {
    didSet {
      checkboxImageView.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var itemNameLabel: UILabel!
  @IBOutlet weak var markImageView: UIImageView! {
    didSet {
      markImageView.isUserInteractionEnabled = true
    }
  }
  
  
  func configuration( for wish: UserWish) {
    checkboxImageView.image = wish.check ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
    itemNameLabel.text = wish.wishDescription
    markImageView.image = wish.star ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
  }
  
}
