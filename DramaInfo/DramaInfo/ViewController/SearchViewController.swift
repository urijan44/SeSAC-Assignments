//
//  ViewController.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/21.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
  var viewModel = TVShowViewModel()
  var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
  let searchBar = UISearchBar()
  
  private var dataSource: UICollectionViewDiffableDataSource<Int, TVShow>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchControllerConfigure()
    createView()
    configureDataSource()
    configureSnapshot()
  }
    
  private func createView() {

    view.addSubview(collectionView)
    collectionView.collectionViewLayout = viewModel.configureCollectionViewLayout()
    collectionView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
    collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: SearchViewCell.reuseIdentifier)
    collectionView.register(CategorySupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategorySupplementaryView.reuseIdentifier)
    collectionView.backgroundColor = .black
  }
  
  private func searchControllerConfigure() {
    let container = SearchView(customSearchBar: searchBar)
    container.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
    navigationItem.titleView = container
    searchBar.delegate = self
    searchBar.searchTextField.clearButtonMode = .whileEditing
    searchBar.searchTextField.textColor = .white
    searchBar.tintColor = .lightGray
    searchBar.searchTextField.backgroundColor = .darkGray
    
    definesPresentationContext = true
  }
}

//MARK: - DiffableDataSource
extension SearchViewController {
  typealias TVShowInfoDataSource = UICollectionViewDiffableDataSource<Int, TVShow>
  
  func configureDataSource() {
    dataSource = TVShowInfoDataSource(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.reuseIdentifier, for: indexPath)
              as? SearchViewCell else { return UICollectionViewCell() }
      cell.configure(itemIdentifier)
      return cell
    }
    
    dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
      guard let self = self,
            let categorySupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                            withReuseIdentifier: CategorySupplementaryView.reuseIdentifier,
                                                                                            for: indexPath) as? CategorySupplementaryView else { return UICollectionReusableView() }
      categorySupplementaryView.label.text = self.viewModel.sectionTitle
      return categorySupplementaryView
    }
  }
  
  func configureSnapshot() {
    var currentSnapshot = NSDiffableDataSourceSnapshot<Int, TVShow>()
    
    currentSnapshot.appendSections([0])
    currentSnapshot.appendItems(viewModel.tvShows, toSection: 0)
    
    dataSource.apply(currentSnapshot, animatingDifferences: false)
  }
}

//MARK: - SearchResultsUpdating
extension SearchViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let text = searchBar.text {
      TMDBApiManager.shared.searchTVShow(text: text) { tvShows in
        DispatchQueue.main.async {
          self.viewModel.tvShows = tvShows
          self.configureSnapshot()
        }
      }
    }
    searchBar.searchTextField.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }
}
