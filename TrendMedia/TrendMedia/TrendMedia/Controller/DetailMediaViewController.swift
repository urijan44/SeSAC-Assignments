//
//  DetailMediaViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class DetailMediaViewController: UITableViewController {
  
  let mediaContent: MediaContent!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "출연/제작"
    
    //alert
    if mediaContent.cast.isEmpty {
      let alert = UIAlertController(title: "알림", message: "출연정보가 없습니다.", preferredStyle: .alert)
      let ok = UIAlertAction(title: "확인", style: .default) { _ in
        self.navigationController?.popViewController(animated: true)
      }
      alert.addAction(ok)
      present(alert, animated: true, completion: nil)
    }
    
    //register
    tableView.register(UINib(nibName: Constants.Cells.actorTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.actorTableViewCell)
    tableView.register(UINib(nibName: Constants.Headers.actorTableViewHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.Headers.actorTableViewHeaderView)
    
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
  }
  
  required init?(coder: NSCoder) { fatalError("never be called") }
  
  init?(coder: NSCoder, mediaContent: MediaContent) {
    self.mediaContent = mediaContent
    super.init(coder: coder)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnSwipe = false
  }
  
}


//MARK: - DataSource
extension DetailMediaViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    mediaContent.cast.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.actorTableViewCell, for: indexPath) as? ActorTableViewCell else { fatalError("Cell Load Failure")}
    
    let person = mediaContent.cast[indexPath.row]
    
    cell.configure(with: person)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Headers.actorTableViewHeaderView) as? ActorTableViewHeaderView else { return nil }
    
    header.configure(with: mediaContent)
    
    return header
  }
}


//MARK: - Delegate

extension DetailMediaViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    70
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    250
  }
}
