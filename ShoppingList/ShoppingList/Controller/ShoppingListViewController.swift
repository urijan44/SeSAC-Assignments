//
//  ViewController.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit



class ShoppingListViewController: UITableViewController {
  
  
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var checkButton: UIBarButtonItem!
  @IBOutlet weak var nameButton: UIBarButtonItem!
  
  
  let shoppingManager = ShoppingList.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAnywhereView))
    view.addGestureRecognizer(dismissKeyboardGesture)
    
    if let previousSort = SortStyle(rawValue: UserDefaults.standard.integer(forKey: "\(SortStyle.self)")) {
      switch previousSort {
      case .check:
        updateTintColorSortButton(tappedButton: checkButton)
      case .favorite:
        updateTintColorSortButton(tappedButton: favoriteButton)
      case .name:
        updateTintColorSortButton(tappedButton: nameButton)
      }
    } else {
      updateTintColorSortButton(tappedButton: nameButton)
    }
    
    shoppingManager.loadWishis()
  }
  
  @objc func dismissKeyboardAnywhereView() {
    view.endEditing(true)
  }
  
  @IBAction func sortByFavorite(sender: UIBarButtonItem) {
    shoppingManager.sortWish(.favorite)
    shoppingManager.currentSortStyle = .favorite
    UserDefaults.standard.set(SortStyle.favorite.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByCheck(sender: UIBarButtonItem) {
    shoppingManager.sortWish(.check)
    shoppingManager.currentSortStyle = .check
    UserDefaults.standard.set(SortStyle.check.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByName(sender: UIBarButtonItem) {
    shoppingManager.sortWish(.name)
    shoppingManager.currentSortStyle = .name
    UserDefaults.standard.set(SortStyle.name.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
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
    shoppingManager.sortWish(shoppingManager.currentSortStyle)
    shoppingManager.addNewWish(wish: wish)
    tableView.reloadData()
  }
}

extension ShoppingListViewController: ShoppingListCellDelegate {
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedCheckbox wish: Bool, index: Int) {
    shoppingManager.wishList[index].check.toggle()
    shoppingManager.sortWish(shoppingManager.currentSortStyle)
    tableView.reloadData()
  }
  
  func shoppingListCell(_ shoppingListCell: ShoppingListCell, tappedStar wish: Bool, index: Int) {
    shoppingManager.wishList[index].star.toggle()
    shoppingManager.sortWish(shoppingManager.currentSortStyle)
    tableView.reloadData()
  }
}
