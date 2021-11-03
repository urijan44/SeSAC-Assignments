//
//  ShoppingListViewController+Actions.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/02.
//

import UIKit
import RealmSwift

extension ShoppingListViewController {
  @objc func dismissKeyboardAnywhereView() {
    view.endEditing(true)
  }
  
  @IBAction func sortByFavorite(sender: UIBarButtonItem) {
    sortedUserWishs = tasks.sorted(byKeyPath: "star", ascending: false)
    
    UserDefaults.standard.set(SortStyle.favorite.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByCheck(sender: UIBarButtonItem) {
    sortedUserWishs = tasks.sorted(byKeyPath: "check", ascending: false)
    UserDefaults.standard.set(SortStyle.check.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @IBAction func sortByName(sender: UIBarButtonItem) {
    sortedUserWishs = tasks.sorted(byKeyPath: "wishDescription", ascending: true)
    UserDefaults.standard.set(SortStyle.name.rawValue, forKey: "\(SortStyle.self)")
    updateTintColorSortButton(tappedButton: sender)
  }
  
  @objc func toggleCheck(_ gesture: CheckGesture) {
    try! localRealm.write {
      gesture.wish?.check.toggle()
    }
    if let _ = gesture.indexPath {
      tableView.reloadData()
    }
  }
  
  @objc func toggleStar(_ gesture: StarGesture) {
    try! localRealm.write {
      gesture.wish?.star.toggle()
    }
    if let _ = gesture.indexPath {
      tableView.reloadData()
    }
  }
}
