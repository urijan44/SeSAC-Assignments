//
//  SettingsViewController.swift
//  MyChecklist
//
//  Created by hoseung Lee on 2021/10/13.
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {
  static let reuseIdentifier = "\(SettingsHeaderView.self)"
  @IBOutlet var titleLabel: UILabel!
}

struct Settings {
  let category: Category
  let list: [String]
}

enum Category: String, CaseIterable {
  case 전체설정 = "전체 설정"
  case 개인설정 = "개인 설정"
  case 기타 = "기타"
}


class SettingsViewController: UITableViewController {
  
  let settings = [
    Settings(category: .전체설정, list: ["공지사항", "실험실", "버전 정보"]),
    Settings(category: .개인설정, list: ["개인/보안", "알림", "채팅", "멀티프로필"]),
    Settings(category: .기타, list: ["고객센터/도움말"])
  ]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let headerViewNibName = UINib(nibName: "\(SettingsHeaderView.self)", bundle: nil)
    tableView.register(headerViewNibName, forHeaderFooterViewReuseIdentifier: SettingsHeaderView.reuseIdentifier)
    
  }
}

//MARK: - DataSource
extension SettingsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    settings.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings[section].list.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
    
    guard let textLabel = cell.viewWithTag(1000) as? UILabel else { fatalError("Connect fail UILabel")}
    textLabel.font = .systemFont(ofSize: 13)
    textLabel.text = settings[indexPath.section].list[indexPath.row]
    
    return cell
  }
  
  
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return settings[section].category.rawValue
//  }
    
}

//MARK: - Delegate
extension SettingsViewController {
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 45
  }
  
//  override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//    guard let headerView = view as? UITableViewHeaderFooterView else { return }
//    headerView.textLabel?.textColor = .secondaryLabel
//    headerView.textLabel?.font = .systemFont(ofSize: 15)
//  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsHeaderView.reuseIdentifier) as? SettingsHeaderView else { return nil}
    
    headerView.titleLabel.text = Category.allCases[section].rawValue
    headerView.titleLabel.textColor = .secondaryLabel
    return headerView
  }
}
