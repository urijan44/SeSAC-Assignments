//
//  SearchViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
  
  @IBOutlet weak var searchTabBarItem: UITabBarItem! {
    didSet {
      searchTabBarItem.title = LocalizableStrings.search.localized
    }
  }
  @IBOutlet var searchResultTableView: UITableView!
  
  // Get all tasks in the realm
  let localRealm = try! Realm()
  var tasks: Results<UserDiary>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    tableViewSetup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tasks = localRealm.objects(UserDiary.self)
    searchResultTableView.reloadData()
  }
  
  func tableViewSetup() {
//    let tableViewFrame = CGRect(x: 0, y: 44, width: view.bounds.width, height: view.bounds.height + 44)
//    searchResultTableView = UITableView(frame: tableViewFrame, style: .insetGrouped)
    searchResultTableView.delegate = self
    searchResultTableView.dataSource = self
    searchResultTableView.register(.init(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
  }
  
  func navigationBarSetup() {
    let navigationBar = UINavigationBar(frame: .init(x: 0, y: 44, width: view.frame.width, height: 44))
    navigationBar.delegate = self
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mainExtraBold]
    view.addSubview(navigationBar)
    
    let customNavigationItem = UINavigationItem(title: "검색")
    
    navigationBar.setItems([customNavigationItem], animated: false)
  }
  
  func loadImageFromDocumentDirectory(imageName: String) -> UIImage {
    
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("image", isDirectory: true) else { fatalError("App Directory Access Denied")}
    let url = URL(fileURLWithPath: imageName,
                        relativeTo: documentDirectory)
    
    do {
      let data = try Data(contentsOf: url)
      let image = UIImage(data: data) ?? UIImage()
      return image
    } catch let error {
      print(error)
      return UIImage()
    }
  }
}

extension SearchViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}

//MARK: - TableView DataSource, Delegate

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
            as? SearchTableViewCell else { fatalError("\(SearchTableViewCell.identifier) load failure")}
    
    let result = tasks[indexPath.row]

    cell.configure(with: result, image: loadImageFromDocumentDirectory(imageName: "\(result._id)"))
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("image", isDirectory: true) else { fatalError("App Directory Access Denied")}
    let url = URL(fileURLWithPath: "\(task._id)", relativeTo: documentDirectory)
    try? FileManager.default.removeItem(at: url)
    try! localRealm.write {
      localRealm.delete(tasks[indexPath.row])
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    110
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    //View Transition
//    let taskToUpdate = tasks[indexPath.row]
    
//    try! localRealm.write {
//      taskToUpdate.title = "New Title"
//      taskToUpdate.content = "New Content"
//      tableView.reloadRows(at: [indexPath], with: .fade)
//    }
//    try! localRealm.write {
//      tasks.setValue(Date(timeIntervalSinceNow: -60 * 60 * 24 * 3), forKey: "writeDate")
//      tableView.reloadSections(.init(integer: 0), with: .automatic)
//    }
    
    //pk 기준으로 수정할때 권장 X
    //아래 코드 기준으로는 title 값 제외하고는 다른값이 다 초기화 되어버림
//    try! localRealm.write {
//      let update = UserDiary(value: ["_id": taskToUpdate._id, "title": "바뀌어라 얍"])
//      localRealm.add(update, update: .modified)
//      tableView.reloadSections(.init(integer: 0), with: .automatic)
//    }
    
//    try! localRealm.write {
//      localRealm.create(UserDiary.self, value: ["_id": taskToUpdate._id, "title": "또 바뀌어라!"], update: .modified)
//      tableView.reloadSections(.init(integer: 0), with: .automatic)
//    }
    
  }
  
}
