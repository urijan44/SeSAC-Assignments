//
//  ShowEpisodeListView.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit

class ShowEpisodeListView: UIViewController {
    
  let viewModel = EpisodeListViewModel()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(EpisodeListViewCell.self, forCellReuseIdentifier: EpisodeListViewCell.reuseIdentifier)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationConfigure()
  }
  
  private func viewConfigure() {
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func navigationConfigure() {
    navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "x.mark"), style: .done, target: self, action: #selector(popThisView))
    navigationItem.leftBarButtonItem?.tintColor = .white
    title = viewModel.title
  }
  
  @objc func popThisView() {
    navigationController?.popViewController(animated: true)
  }
}

extension ShowEpisodeListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeListViewCell.reuseIdentifier, for: indexPath) as? EpisodeListViewCell else { return UITableViewCell() }
    cell.configure(viewModel.episodeList[indexPath.row])
    return cell
  }
}

extension ShowEpisodeListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    viewModel.cellHeight
  }
}
