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
  
  var mediaCast: [Cast] = [] {
    didSet {
      tableView.reloadSections(.init(integer: 1), with: .automatic)
    }
  }
  var mediaCrew: [Cast] = [] {
    didSet {
      tableView.reloadSections(.init(integer: 2), with: .automatic)
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "출연/제작"
    requestCreditData()
    //alert
//    if mediaContent.cast.isEmpty {
//      let alert = UIAlertController(title: "알림", message: "출연정보가 없습니다.", preferredStyle: .alert)
//      let ok = UIAlertAction(title: "확인", style: .default) { _ in
//        self.navigationController?.popViewController(animated: true)
//      }
//      alert.addAction(ok)
//      present(alert, animated: true, completion: nil)
//    }
    
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
  
  func requestCreditData() {
    
    if let mediaType = MediaType(rawValue: mediaContent.mediaType ?? "") {
      TMDBAPIManager.shared.fetchMediaCredit(mediaID: mediaContent.mediaID ?? 0, mediaType: mediaType) { code, json in
        switch code {
        case 200:
          var tempCast: [Cast] = []
          json["cast"].arrayValue.forEach { credit in
            let cast = Cast(name: credit["name"].stringValue, image: Constants.URLs.tmdbImageBaseURL + credit["profile_path"].stringValue, character: credit["character"].stringValue)
            tempCast.append(cast)
          }
          var tempCrew: [Cast] = []
          json["crew"].arrayValue.forEach { credit in
            let crew = Cast(name: credit["name"].stringValue, image: Constants.URLs.tmdbImageBaseURL + credit["profile_path"].stringValue, character: credit["department"].stringValue)
            tempCrew.append(crew)
          }
          
          DispatchQueue.main.async {
            self.mediaCast = tempCast
            self.mediaCrew = tempCrew
          }
          
        case 400:
          print(code, json)
        default:
          print(code, json)
        }
      }
    }
  }
}


//MARK: - DataSource
extension DetailMediaViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 1:
      return mediaCast.count
    case 2:
      return mediaCrew.count
    default:
      return 1
    }
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
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.actorTableViewCell, for: indexPath) as? ActorTableViewCell else { fatalError("Cell Load Failure")}
      
      let person = mediaCast[indexPath.row]
      
      cell.configure(with: person)
      
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.actorTableViewCell, for: indexPath) as? ActorTableViewCell else { fatalError("Cell Load Failure")}
      
      let person = mediaCrew[indexPath.row]
      
      cell.configure(with: person)
      return cell
      
    }
    
    
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 1:
      return "Cast"
    case 2:
      return "Crew"
    default:
      return ""
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
    switch section {
    case 0:
      return 250
    default:
      return 44
    }
  }
}
