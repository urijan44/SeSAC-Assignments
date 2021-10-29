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
      mediaTableView.prefetchDataSource = self
      mediaTableView.register(UINib(nibName: Constants.Cells.mediaTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.mediaTableViewCell)
      mediaTableView.register(UINib(nibName: Constants.Cells.mainTableViewTopCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.mainTableViewTopCell)
      mediaTableView.separatorStyle = .none
    }
  }
  var mediaList: [MediaContent] = [] {
    didSet {
      mediaTableView.reloadData()
    }
  }
  
  var searchMovieBarButton: UIBarButtonItem!
  
  var dayWeekChangeBarButton: UIBarButtonItem!
  
  var dayWeekPattern = 1
  
  var page = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backButtonTitle = "뒤로"
    searchMovieBarButton = UIBarButtonItem(image: UIImage(systemName: Constants.searchButtonImage), style: .plain, target: self, action: #selector(pushSearchViewController))
    searchMovieBarButton.tintColor = .label

    dayWeekChangeBarButton = UIBarButtonItem(image: UIImage(systemName: "d.circle.fill"), style: .plain, target: self, action: #selector(dayWeekToggleButton))
    dayWeekChangeBarButton.tintColor = .label
    
    navigationItem.rightBarButtonItems = [searchMovieBarButton, dayWeekChangeBarButton]
    
    fetchTrandMediaData(page: 1)
  }
  
  @objc func dayWeekToggleButton() {
    print(#function)
    if dayWeekPattern == 1 {
      dayWeekPattern = 7
      dayWeekChangeBarButton.image = UIImage(systemName: "w.circle.fill")
    } else {
      dayWeekPattern = 1
      dayWeekChangeBarButton.image = UIImage(systemName: "d.circle.fill")
    }
  }
  
  //MARK: - Navigation
  
  @objc func pushSearchViewController() {
    performSegue(withIdentifier: Constants.pushSearchViewController, sender: nil)
  }
  
  @objc func pushBookListViewController() {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: Constants.ViewController.bookListViewController) as? BookListViewController else { fatalError("BookListViewController load failure")}
    
    navigationController?.pushViewController(controller, animated: true)
  }
  
  func fetchTrandMediaData(page: Int) {
    TMDBAPIManager.shared.fetchTrendMovieData(page: page, mediaType: .movie, timeWindow: .day) {[ unowned self ] code, json in
      switch code {
      case 200:
        print(code)
        var tempMediaList: [MediaContent] = []
        json["results"].arrayValue.forEach { result in
          if result["media_type"].stringValue == "movie" || result["media_type"].stringValue == "tv" {
            let media = MediaContent(title: result["title"].stringValue,
                         releaseDate: result["release_date"].stringValue,
                                     genre: result["genre_ids"].arrayObject as? [Int] ?? [],
                         region: result["original_language"].stringValue,
                         overview: result["overview"].stringValue,
                         rate: result["vote_average"].doubleValue,
                         starring: "",
                                     backdropImage: Constants.URLs.tmdbImageBaseURL + result["backdrop_path"].stringValue,
                                     poster_path: Constants.URLs.tmdbImageBaseURL + result["poster_path"].stringValue,
                                     mediaID: result["id"].intValue,
                                     mediaType: result["media_type"].stringValue)
                
              
            tempMediaList.append(media)
          }
        }
        self.mediaList += tempMediaList
      case 400:
        print(code, json)
      default:
        print(code, json)
      }
    }
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
}

extension MainViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
      if mediaList.count - 1 == indexPath.row {
        page += 1
        fetchTrandMediaData(page: page)
      }
    }
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.section == 0 ? 227 : view.frame.height / 2
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
