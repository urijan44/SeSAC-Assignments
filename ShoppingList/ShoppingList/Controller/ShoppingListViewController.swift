//
//  ViewController.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit

class ShoppingListViewController: UITableViewController {
  
  let shoppingManager = ShoppingList.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    shoppingManager.loadWishis()
  }
}

//MARK: - DataSource
extension ShoppingListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 1 : shoppingManager.wishList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddListCell", for: indexPath) as? AddListCell else { fatalError() }
      cell.delegate = self
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as? ShoppingListCell else { fatalError() }
      let wish = shoppingManager.wishList[indexPath.row]
      cell.delegate = self
      cell.configuration(indexPath.row, for: wish)
      
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    indexPath.section == 0 ? false : true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let indexPaths = [indexPath]
      let wish = shoppingManager.wishList[indexPath.row]
      if shoppingManager.deleteWish(wish: wish) {
        tableView.deleteRows(at: indexPaths, with: .automatic)        
      }
    }
  }
  
}

//MARK: - Delegate
extension ShoppingListViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.section == 0 ? 80 : 55
  }
}

extension ShoppingListViewController: AddListCellDelegate {
  func addListCell(_ addListCell: AddListCell, with text: String?) {
    guard let text = text, !text.isEmpty else { return }
    let wish = Wish(wishDescription: text, check: false, star: false)
    shoppingManager.addNewWish(wish: wish)
    tableView.reloadData()
  }
}

extension ShoppingListViewController: ShoppingListCellDelegate {
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedCheckbox wish: Bool, index: Int) {
    shoppingManager.wishList[index].check.toggle()
    shoppingManager.saveWishs()
    tableView.reloadData()
  }
  
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedStar wish: Bool, index: Int) {
    shoppingManager.wishList[index].star.toggle()
    shoppingManager.saveWishs()
    tableView.reloadData()
  }
}
