//
//  BeerMainView.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/29.
//

import UIKit
import SnapKit

class RandomBeerMainView: UIView {
  
  let tableView: UITableView = {
    let tv = UITableView()
    tv.separatorStyle = .none
    tv.backgroundColor = .clear
    return tv
  }()
  
  var bottomTabBar: BottomTabBar = {
    let bar = BottomTabBar()
    bar.backgroundColor = .white
    return bar
  }()
  
  let header = StretchyTableHeaderView()
  
  var headerHeight: CGFloat = UIScreen.main.bounds.width
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    setupView()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setupView() {
    addSubview(tableView)
    addSubview(bottomTabBar)
    
    tableView.tableHeaderView = header
  }
  
  private func layoutConfigure() {
    tableView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(bottomTabBar.snp.top)
    }
    
    bottomTabBar.snp.makeConstraints { make in
      make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(8)
      make.height.equalTo(66)
    }
    
    header.frame = .init(x: bounds.midX, y: 0, width: bounds.width, height: headerHeight)
  }
  
  
}
