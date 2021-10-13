//
//  AddListCell.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit

protocol AddListCellDelegate: AnyObject {
  func addListCell(_ addListCell: AddListCell, with text: String?)
}

class AddListCell: UITableViewCell {
  @IBOutlet weak var addListTextField: UITextField!
  @IBOutlet weak var addListButton: UIButton!
  
  weak var delegate: AddListCellDelegate?
  
  @IBAction func addList() {
    delegate?.addListCell(self, with: addListTextField.text)
    addListTextField.text = ""
  }
}
