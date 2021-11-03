//
//  CategoryViewController.swift
//  ShoppingList
//
//  Created by hoseung Lee on 2021/11/03.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
  
  let localRealm = try! Realm()
  var categories: Results<Category>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    categories = localRealm.objects(Category.self)
    print(localRealm.configuration.fileURL!)
    navigationBarConfigure()
  }
  
  func navigationBarConfigure() {
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
  }
  
  
  //MARK: - Actions
  @objc func addCategory() {
    let alert = UIAlertController(title: "카테고리", message: "카테고리를 추가하세요", preferredStyle: .alert)
    alert.addTextField { textfield in
      textfield.placeholder = "카테고리 입력"
    }
    
    let ok = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
      guard let self = self else { return }
      guard let text = alert.textFields?[0].text, !text.isEmpty else { return }
      let category = Category(category: text)
      
      try! self.localRealm.write {
        self.localRealm.add(category)
        self.tableView.reloadSections(.init(integer: 0), with: .fade)
      }
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    
    [ok, cancel].forEach { action in
      alert.addAction(action)
    }
    
    present(alert, animated: true)
  }
  
}


//MARK: - DataSource
extension CategoryViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    categories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)
    
    let categoryTitle = cell.viewWithTag(1000) as! UILabel
    let listCount = cell.viewWithTag(1001) as! UILabel
    let category = categories[indexPath.row]
    
    categoryTitle.text = category.category
    listCount.text = "\(category.wishList.filter("check == false").count)개 남음"
    
    return cell
  }
}

//MARK: - Delegate
extension CategoryViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let category = categories[indexPath.row]
    
    guard let controller = storyboard?.instantiateViewController(withIdentifier: ShoppingListViewController.identifier)
            as? ShoppingListViewController else { return }
    controller.categoryTitle = category.category
    controller.tasks = category.wishList
    
    navigationController?.pushViewController(controller, animated: true)
    
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    tableView.deleteRows(at: [indexPath], with: .automatic)
    let category = categories[indexPath.row]
    try! localRealm.write {
      localRealm.delete(category)
    }
    
    
    
  }
}
