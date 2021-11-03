//
//  SearchViewController+Setup.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/03.
//

import UIKit

extension SearchViewController {
  func tableViewSetup() {
    searchResultTableView.delegate = self
    searchResultTableView.dataSource = self
    searchResultTableView.register(.init(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
  }
  
  func navigationBarSetup() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    let navigationBar = UINavigationBar(frame: .init(x: 0, y: 44, width: view.frame.width, height: 44))
    navigationBar.delegate = self
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mainExtraBold]
    view.addSubview(navigationBar)

    let customNavigationItem = UINavigationItem(title: LocalizableStrings.search.localized)
    navigationBar.setItems([customNavigationItem], animated: false)
  }
}
