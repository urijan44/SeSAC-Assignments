//
//  BoardMainView.swift
//  SeSAC_AuthPractice
//
//  Created by hoseung Lee on 2021/12/29.
//

import UIKit
import SnapKit
import SkeletonView

class BoardMainView: UIView, ViewRepresenable {

  lazy var textLable: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 42, weight: .bold)
    return label
  }()
  
  lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()
  
  lazy var emailLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()
  
  lazy var logoutButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("Logout", for: .normal)
    bt.setTitleColor(.systemGray, for: .normal)
    return bt
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemTeal
    setupView()
    setupConstrains()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func setupView() {
    [textLable, usernameLabel, emailLabel, logoutButton].forEach { views in
      addSubview(views)
      views.isSkeletonable = true
      (views as? UILabel)?.skeletonTextLineHeight = .fixed(17)
    }
  }
  
  func setupConstrains() {
    textLable.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(44)
    }
    
    usernameLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    emailLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(usernameLabel.snp.bottom).offset(16)
    }
    
    logoutButton.snp.makeConstraints { make in
      make.width.equalTo(120)
      make.trailing.equalTo(snp.trailing).inset(20)
      make.bottom.equalTo(snp.bottom).inset(20)
    }
  }
}
