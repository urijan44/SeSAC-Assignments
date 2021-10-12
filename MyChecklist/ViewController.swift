//
//  ViewController.swift
//  MyChecklist
//
//  Created by hoseung Lee on 2021/10/12.
//

import UIKit

class ViewController: UITableViewController {

  @IBOutlet weak var addListTextfield: UITextField!
  @IBOutlet weak var selectListSegmentControl: UISegmentedControl!
  
  @IBOutlet weak var contentView: UIView!
  var checklists = [
    "밥 먹기",
    "공부하기",
    "운동하기",
    "자전거 등록하기",
    "정처기 취소하기"
  ]
  
  var donotList = [
    "유튜브 보지말기",
    "낮잠 자지 말기",
    "휴대폰 보지 말기"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentView.layer.cornerRadius = 15
    
    selectListSegmentControl.selectedSegmentIndex = 0

  }
  
  @IBAction func enterContent() {
    guard let text = addListTextfield.text else { return }
    if !text.isEmpty {
      switch selectListSegmentControl.selectedSegmentIndex {
      case 0:
        checklists.append(text)
      default:
        donotList.append(text)
      }
    }
    tableView.reloadData()
    view.endEditing(true)
  }
  
}

//Data Source
extension ViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return checklists.count
    default:
      return donotList.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
    let textLabel = cell.viewWithTag(1000) as! UILabel
    textLabel.font = .systemFont(ofSize: 17)
    
    switch indexPath.section {
    case 0:
      textLabel.text = checklists[indexPath.row]
      return cell
    default:
      textLabel.text = donotList[indexPath.row]
      textLabel.font = .italicSystemFont(ofSize: 17)
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "할일목록"
    default:
      return "하지말아야할목록"
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    indexPath.section == 0 ? false : true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let indexPaths = [indexPath]
    switch indexPath.section {
    case 0:
      checklists.remove(at: indexPath.row)
    default:
      donotList.remove(at: indexPath.row)
    }
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
}

//Delegate
extension ViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      print(checklists[indexPath.row])
    default:
      print(donotList[indexPath.row])
    }
  }
}
