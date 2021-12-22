//
//  SearchView.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit

class SearchView: UIView {
  
  let searchBar: UISearchBar
  
  init(customSearchBar: UISearchBar) {
    searchBar = customSearchBar
    super.init(frame: .zero)
    addSubview(searchBar)
  }
  
  override convenience init(frame: CGRect) {
    self.init(customSearchBar: UISearchBar())
    self.frame = frame
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    searchBar.frame = bounds
  }
}
