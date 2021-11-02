//
//  ViewController.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit
import RealmSwift


class ShoppingListViewController: UITableViewController {
  
  
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var checkButton: UIBarButtonItem!
  @IBOutlet weak var nameButton: UIBarButtonItem!
  
  let localRealm = try! Realm()
  var tasks: Results<UserWish>!

  override func viewDidLoad() {
    super.viewDidLoad()
    tasks = localRealm.objects(UserWish.self)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadSections(.init(integer: 1), with: .automatic)
    
  }

  
  func gestureSetup() {
    let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAnywhereView))
    view.addGestureRecognizer(dismissKeyboardGesture)
  }
  
  func updateTintColorSortButton(tappedButton: UIBarButtonItem) {
    [favoriteButton, checkButton, nameButton].forEach { button in
      button.tintColor = button == tappedButton
      ? button.customView?.tintColor
      : .secondaryLabel
    }
    tableView.reloadData()
  }
}

//MARK: - Delegate

extension ShoppingListViewController: ShoppingListCellDelegate {
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedCheckbox wish: Bool, index: Int) {
//    shoppingManager.wishList[index].check.toggle()
//    shoppingManager.sortWish(shoppingManager.currentSortStyle)
    tableView.reloadData()
  }
  
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedStar wish: Bool, index: Int) {
//    shoppingManager.wishList[index].star.toggle()
//    shoppingManager.sortWish(shoppingManager.currentSortStyle)
    tableView.reloadData()
  }
}
