//
//  MovieSearchViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class MovieSearchViewController: UIViewController {
  
  @IBOutlet weak var searchFieldBar: UISearchBar! {
    didSet {
      searchFieldBar.delegate = self
      searchFieldBar.frame.size.height = 51
      searchFieldBar.showsScopeBar = true
      searchFieldBar.showsCancelButton = false
      searchFieldBar.showsBookmarkButton = true
      searchFieldBar.showsSearchResultsButton = true
    }
  }
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.prefetchDataSource = self
      tableView.contentInset = .init(top: searchFieldBar.frame.height, left: 0, bottom: 0, right: 0)
      tableView.keyboardDismissMode = .onDrag
      tableView.register(UINib(nibName: Constants.Cells.movieSearchTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.movieSearchTableViewCell)
    }
  }
  var movieList: [MovieModel] = [] {
    didSet {
      if movieList.isEmpty {
//        tableView.reloadSections(.init(integer: 0), with: .automatic)
      }
      tableView.reloadData()
    }
  }
  
  let defaultCellIdentifier = "DefaultCell"
  
  var startPage = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    navigationItem.rightBarButtonItem = .init(title: "박스오피스", style: .plain, target: self, action: #selector(pushBoxOfficeView))
    searchFieldBar.becomeFirstResponder()
  }
  
  @objc func pushBoxOfficeView() {
    performSegue(withIdentifier: "PushBoxOfficeView", sender: nil)
  }
}

//MARK: - DataSource
extension MovieSearchViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    movieList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.movieSearchTableViewCell, for: indexPath) as? MovieSearchTableViewCell else { fatalError("MovieSearchTableViewCell load failure")}
    
    let media = movieList[indexPath.row]
    cell.configure(with: media)
    return cell
  }
  
  
}

extension MovieSearchViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
      
      //마지막 셀에 가까워 졌다면
      if movieList.count - 1 == indexPath.row {
        startPage += 10
        fetchMovieData(searchText: searchFieldBar.text!)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    print("취소\(indexPaths)")
  }
  
}

//MARK: - Delegate

extension MovieSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    120
  }
}

extension MovieSearchViewController: UISearchBarDelegate {
  func fetchMovieData(searchText: String) {
    
    var components = URLComponents(string: "https://openapi.naver.com/v1/search/movie.json")
    let query = URLQueryItem(name: "query", value: searchText)
    let display = URLQueryItem(name: "display", value: "10")
    let start = URLQueryItem(name: "start", value: "1")
//    let
//    print(query)
    //%EC%8A%A4%ED%8C%8C%EC%9D%B4%EB%8D%94%EB%A7%A8
    components?.queryItems = [query, display, start]
    
    //%EC%8A%A4%ED%8C%8C%EC%9D%B4%EB%8D%94%EB%A7%A8
    //%25EC%258A%25A4%25ED%258C%258C%25EC%259D%25B4%25EB%258D%2594%25EB%25A7%25A8
    
    guard let url = components?.url else { fatalError("url build failure")}
//    let encodingString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//    let url = "https://openapi.naver.com/v1/search/movie.json?query=\(encodingString)&display=10&start=\(startPage)"
    
    let key = [Bundle.main.infoDictionary?["NaverAPIID"] as? String, Bundle.main.infoDictionary?["NaverAPISecret"] as? String]
    let idKeys: HTTPHeaders = ["X-Naver-Client-Id": key[0] ?? "Nokey", "X-Naver-Client-Secret": key[1] ?? "Nokey"]
    AF.request(url, method: .get, headers: idKeys).validate().responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        print(json)
//        self.movieList = []
        var tempMovieList: [MovieModel] = []
        for item in json["items"].arrayValue {
          let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
          let subtitle = item["subtitle"].stringValue
          let director = item["director"].stringValue
          let actor = item["actor"].stringValue
          let pubDate = item["pubDate"].stringValue
          let image = item["image"].stringValue
          let userRating = item["userRating"].stringValue
          tempMovieList.append(MovieModel(title: title, subtitle: subtitle, director: director, actor: actor, pubData: pubDate, image: image, userRating: userRating))
        }
        DispatchQueue.main.async {
          self.movieList += tempMovieList
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if !searchFieldBar.text!.isEmpty {
      searchFieldBar.resignFirstResponder()
      startPage = 1
      fetchMovieData(searchText: searchBar.text!)
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    startPage = 1
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    fetchMovieData(searchText: searchText)
    movieList.removeAll()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    
    return true
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}
