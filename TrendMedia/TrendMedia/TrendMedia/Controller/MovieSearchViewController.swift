//
//  MovieSearchViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class MovieSearchViewController: UITableViewController {
  
  let mediaList = MediaManager.shared.mediaList
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: Constants.Cells.movieSearchTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.movieSearchTableViewCell)
  }
}

//MARK: - DataSource
extension MovieSearchViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    mediaList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.movieSearchTableViewCell, for: indexPath)
            as? MovieSearchTableViewCell else { fatalError("Cell load Failure")}
    
    let media = mediaList[indexPath.row]
    cell.configure(with: media)
    return cell
  }
}

//MARK: - Delegate

extension MovieSearchViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    120
  }
}
