//
//  ShoppingListCell.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit

protocol ShoppingListCellDelegate: AnyObject {
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedCheckbox check: Bool, index: Int)
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedStar star: Bool, index: Int)
}

class ShoppingListCell: UITableViewCell {
  @IBOutlet weak var backscreenView: UIView! {
    didSet {
      backscreenView.layer.cornerRadius = 15
    }
  }
  @IBOutlet weak var checkboxImageView: UIImageView! {
    didSet {
      checkboxImageView.isUserInteractionEnabled = true
      let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox(sender:)))
      checkboxImageView.addGestureRecognizer(tap)
    }
  }
  @IBOutlet weak var itemNameLabel: UILabel!
  @IBOutlet weak var markImageView: UIImageView! {
    didSet {
      markImageView.isUserInteractionEnabled = true
      let tap = UITapGestureRecognizer(target: self, action: #selector(toggleStar(sender:)))
      markImageView.addGestureRecognizer(tap)
    }
  }
  
  var check: Bool = false
  var star: Bool = false
  var idx: Int = 0
  
  weak var delegate: ShoppingListCellDelegate?
  
  func configuration(_ idx: Int, for wish: UserWish) {
    check = wish.check
    star = wish.star
    self.idx = idx
    
    checkboxImageView.image = wish.check ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
    itemNameLabel.text = wish.wishDescription
    markImageView.image = wish.star ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
  }
  
  
  @objc func toggleCheckBox(sender: UITapGestureRecognizer) {
    delegate?.shoppingListCell(self, tappedCheckbox: check, index: idx)
  }
  
  @objc func toggleStar(sender: UITapGestureRecognizer) {
    delegate?.shoppingListCell(self, tappedStar: star, index: idx)
  }
  
}
