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
  @IBOutlet weak var addListTextField: UITextField! {
    didSet {
      addListTextField.delegate = self
    }
  }
  @IBOutlet weak var addListButton: UIButton! {
    didSet {
      addListButton.layer.cornerRadius = 8
    }
  }
  
  weak var delegate: AddListCellDelegate?
  
  @IBAction func addList() {
    delegate?.addListCell(self, with: addListTextField.text)
    addListTextField.text = ""
  }
}

extension AddListCell: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    addList()
    return true
  }
}
