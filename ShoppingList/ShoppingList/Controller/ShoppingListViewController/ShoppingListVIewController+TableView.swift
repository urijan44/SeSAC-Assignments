//
//  ShoppingListVIewController+TableView.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/02.
//

import UIKit
//MARK: - DataSource
extension ShoppingListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 1 : sortedUserWishs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddListCell", for: indexPath) as? AddListCell else { fatalError() }
      cell.delegate = self
      return cell
      
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as? ShoppingListCell else { fatalError() }
      let wish = sortedUserWishs[indexPath.row]
      
      let checkGesture = CheckGesture(target: self, action: #selector(toggleCheck))
      checkGesture.wish = wish
      checkGesture.indexPath = indexPath
      let favoriteGesture = StarGesture(target: self, action: #selector(toggleStar))
      favoriteGesture.wish = wish
      favoriteGesture.indexPath = indexPath
      
      cell.checkboxImageView.addGestureRecognizer(checkGesture)
      cell.markImageView.addGestureRecognizer(favoriteGesture)
      
      cell.configuration(for: wish)
      return cell
    }
  }
  

  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    indexPath.section == 0 ? false : true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let indexPaths = [indexPath]
      let userWish = sortedUserWishs[indexPath.row]
      
      try! localRealm.write {
        localRealm.delete(userWish)
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
    let task = UserWish(wishDescription: text)
    
    try! localRealm.write{
      tasks.append(task)
    }

    tableView.reloadSections(.init(integer: 1), with: .automatic)
  }
}

class CheckGesture: UITapGestureRecognizer {
  var wish: UserWish?
  var indexPath: IndexPath?
}

class StarGesture: UITapGestureRecognizer {
  var wish: UserWish?
  var indexPath: IndexPath?
}
