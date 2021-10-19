//
//  ViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/15.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet weak var mediaTableView: UITableView! {
    didSet {
      mediaTableView.delegate = self
      mediaTableView.dataSource = self
      mediaTableView.register(UINib(nibName: Constants.Cells.mediaTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.mediaTableViewCell)
      mediaTableView.register(UINib(nibName: Constants.Cells.mainTableViewTopCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.mainTableViewTopCell)
      mediaTableView.separatorStyle = .none
    }
  }
  var mediaList = MediaManager.shared.mediaList
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backButtonTitle = "뒤로"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.searchButtonImage), style: .plain, target: self, action: #selector(pushSearchViewController))
    navigationItem.rightBarButtonItem?.tintColor = .black
  }
  
  //MARK: - Navigation
  
  @objc func pushSearchViewController() {
    performSegue(withIdentifier: Constants.pushSearchViewController, sender: nil)
  }
  
  @objc func pushBookListViewController() {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: Constants.ViewController.bookListViewController) as? BookListViewController else { fatalError("BookListViewController load failure")}
    
    navigationController?.pushViewController(controller, animated: true)
  }
}

//MARK: - DataSource
extension MainViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 1 : mediaList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.mainTableViewTopCell, for: indexPath) as? MainTableViewTopCell else { fatalError("Cant' load Main Top Table View Cell")}
      
      let showBookListTapGesture = UITapGestureRecognizer(target: self, action: #selector(pushBookListViewController))
      cell.showBookListButton.addGestureRecognizer(showBookListTapGesture)
      
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.mediaTableViewCell, for: indexPath) as? MediaTableViewCell else { fatalError("Cant' load Media Table View Cell")}
      let media = mediaList[indexPath.row]
      cell.delegate = self
      cell.configure(media)
      return cell
    default:
      fatalError("section case is invalid value")
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.section == 0 ? 227 : view.frame.height / 2
  }
}


//MARK: - Delegate
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      let controller = storyboard?.instantiateViewController(identifier: "\(DetailMediaViewController.self)") { coder -> DetailMediaViewController? in
        DetailMediaViewController(coder: coder, mediaContent: self.mediaList[indexPath.row])
      }
      
      guard let controller = controller else { fatalError("view controller failure")}
      navigationController?.pushViewController(controller, animated: true)
    default:
      return
    }
  }
}

extension MainViewController: MediaTableViewCellDelegate {
  func mediaTableViewCell(_ mediaTableViewCell: MediaTableViewCell, mediaContent: MediaContent?) {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "\(WebViewController.self)")
            as? WebViewController else { return }
    controller.mediaContent = mediaContent
    controller.modalPresentationStyle = .formSheet
    present(controller, animated: true, completion: nil)
    
  }
}
