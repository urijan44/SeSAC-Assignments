//
//  PersonViewController.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/28.
//

import UIKit
import SnapKit

class PersonViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  private var viewModel = PersomViewModel()
  
  fileprivate var tableView = UITableView()
  fileprivate var searchBar = UISearchBar()
  fileprivate var dataSource: UITableViewDiffableDataSource<Section, Result>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewSetup()
    layoutConfigure()
    
    viewModel.person.bind { person in
      self.configureSnapshot()
    }
  }
  
  private func viewSetup() {
    view.addSubview(tableView)
    view.addSubview(searchBar)
    searchBar.delegate = self
    searchBar.showsCancelButton = true
    searchBar.clearsContextBeforeDrawing = false
    tableView.delegate = self
    tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.reuseIdentifier)
    configureDataSource()
    configureSnapshot()
  }
  
  private func layoutConfigure() {
    
    searchBar.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(44)
      make.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    tableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
  }

}


//MARK: - TableView dataSource
extension PersonViewController {
  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, Result>(tableView: tableView) { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell else { return nil }
      cell.nameLabel.text = itemIdentifier.name
      return cell
    }
  }
  
  func configureSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Result>()
    snapshot.appendSections([.main])
    snapshot.appendItems(viewModel.person.value.results, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension PersonViewController: UITableViewDelegate {
  
}

//MARK: - Searchbar delegate
extension PersonViewController: UISearchBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.fetchPerson(query: searchBar.text ?? "", page: 1) { person, error in
      guard let person = person else {
        return
      }
      print(person)

    }
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.resetResult()
  }
}

class PersonCell: UITableViewCell {
  static let reuseIdentifier = "PersonCell"
  let nameLabel = UILabel()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
