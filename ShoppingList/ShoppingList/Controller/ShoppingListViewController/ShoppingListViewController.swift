//
//  ViewController.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/10/14.
//

import UIKit
import RealmSwift


class ShoppingListViewController: UITableViewController, UIGestureRecognizerDelegate {
  
  static let identifier = "ShoppingListViewController"
  
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var checkButton: UIBarButtonItem!
  @IBOutlet weak var nameButton: UIBarButtonItem!
  
  var categoryTitle: String!
  let localRealm = try! Realm()
  var tasks: List<UserWish>!
  var sortedUserWishs: Results<UserWish>!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = categoryTitle
    loadSortStyle()
    
    swipeBackGesture()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadSections(.init(integer: 1), with: .automatic)
    
  }
  
  func swipeBackGesture() {
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  func loadSortStyle() {
    let currentSortStyle: SortStyle = SortStyle(rawValue: UserDefaults.standard.integer(forKey: "\(SortStyle.self)")) ?? .name
    switch currentSortStyle {
    case .check:
      sortByCheck(sender: checkButton)
    case .favorite:
      sortByFavorite(sender: favoriteButton)
    case .name:
      sortByName(sender: nameButton)
    }
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
    tableView.reloadSections(.init(integer: 1), with: .automatic)
  }
}
