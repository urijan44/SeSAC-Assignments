//
//  SearchViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

class SearchViewController: UIViewController {
  
  @IBOutlet weak var searchTabBarItem: UITabBarItem! {
    didSet {
      searchTabBarItem.title = LocalizableStrings.search.localized
    }
  }
  @IBOutlet var searchResultTableView: UITableView!
  
  var dummyDiary: [Diary] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    tableViewSetup()
    
    for index in 1...30 {
      let diary = Diary(title: "\(index)일기", date: Date(), diaryDescription: "\(index)내용", image: "memil")
      dummyDiary.append(diary)
    }
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
}

extension SearchViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}

//MARK: - TableView DataSource, Delegate

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dummyDiary.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
            as? SearchTableViewCell else { fatalError("\(SearchTableViewCell.identifier) load failure")}
    
    let diary = dummyDiary[indexPath.row]
    
    cell.configure(with: diary, image: UIImage(named: "memil")!)
    
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    110
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
