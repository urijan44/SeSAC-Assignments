//
//  DetailMediaViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class DetailMediaViewController: UITableViewController {
  
  let mediaContent: MediaContent!
  let closedStorylineHeight: CGFloat = 80
  var storylineViewHeight: CGFloat = 80
  var pageScrollState = false
  
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
    tableView.register(UINib(nibName: Constants.Cells.detailMediaStorylineTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.detailMediaStorylineTableViewCell)
    
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
  
  @objc func openStorylineView() {
    
    tableView.performBatchUpdates {
      self.pageScrollState.toggle()
      self.storylineViewHeight = self.pageScrollState ? UITableView.automaticDimension : closedStorylineHeight
    } completion: { [weak self] _ in
      self?.tableView.reloadData()
    }

  }
}


//MARK: - DataSource
extension DetailMediaViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 1 ? mediaContent.cast.count : 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.detailMediaStorylineTableViewCell, for: indexPath) as? DetailMediaStorylineTableViewCell else { fatalError("DetailMediaStorylineTableViewCell Load Failure")}
      
      let storyline = mediaContent.overview
      cell.storylineLabel.text = storyline
      let scrollButtonImage = pageScrollState
      ? UIImage(systemName: "chevron.up")
      : UIImage(systemName: "chevron.down")
      cell.pageScrollButton.setImage(scrollButtonImage, for: .normal)
      cell.pageScrollButton.addTarget(self, action: #selector(openStorylineView), for: .touchUpInside)
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.actorTableViewCell, for: indexPath) as? ActorTableViewCell else { fatalError("Cell Load Failure")}
      
      let person = mediaContent.cast[indexPath.row]
      
      cell.configure(with: person)
      
      return cell
    }
    
    
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Headers.actorTableViewHeaderView) as? ActorTableViewHeaderView else { return nil }
      header.configure(with: mediaContent)
      
      return header
    } else {
      
      return nil
    }
  }
}


//MARK: - Delegate

extension DetailMediaViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.section == 1 ? 70 : storylineViewHeight
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    section == 0 ? 250 : 0
  }
}
