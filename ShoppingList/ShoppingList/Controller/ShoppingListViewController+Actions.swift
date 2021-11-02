//
//  ShoppingListViewController+Actions.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/02.
//

import UIKit

extension ShoppingListViewController {
  @objc func dismissKeyboardAnywhereView() {
    view.endEditing(true)
  }
  
  @IBAction func sortByFavorite(sender: UIBarButtonItem) {
//    tasks = tasks.sor
    UserDefaults.standard.set(SortStyle.favorite.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  
//  func sortWish(_ sortStyle: SortStyle) {
//    switch sortStyle {
//    case .check:
//      wishList.sort { !$0.check && $1.check }
//    case .favorite:
//      wishList.sort { $0.star && !$1.star }
//    case .name:
//      wishList.sort { $0.wishDescription.localizedCaseInsensitiveCompare($1.wishDescription) == .orderedAscending }
//    }
//    saveWishs()
//  }
  
  @IBAction func sortByCheck(sender: UIBarButtonItem) {


    UserDefaults.standard.set(SortStyle.check.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByName(sender: UIBarButtonItem) {
//    shoppingManager.sortWish(.name)
//    shoppingManager.currentSortStyle = .name
    UserDefaults.standard.set(SortStyle.name.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
}
