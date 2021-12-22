//
//  BottomTabBar.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/21.
//

import UIKit
import SnapKit

class BottomTabBar: UIView {
  
  private var refreshButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.layer.borderColor = UIColor.systemMint.cgColor
    button.layer.borderWidth = 3
    button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
    button.addTarget(self, action: #selector(activateRefreshButton), for: .touchUpInside)
    return button
  }()
  
  private var shareButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.systemMint
    button.layer.cornerRadius = 8
    button.setTitle("Share BEER", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
    button.addTarget(self, action: #selector(activateShareButton), for: .touchUpInside)
    return button
  }()
  
  var refreshButtonHandler: (() -> ())?
  var shareButtonHandler: (() -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layoutConfigure()
  }
  
  private func layoutConfigure() {
    addSubview(refreshButton)
    addSubview(shareButton)
    
    refreshButton.snp.makeConstraints { make in
      make.width.height.equalTo(snp.height).multipliedBy(0.9)
      make.centerY.equalToSuperview()
      make.leading.equalTo(snp.leading).inset(8)
    }
    
    shareButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(refreshButton.snp.trailing).offset(16)
      make.trailing.equalTo(snp.trailing).inset(16)
      make.height.equalTo(refreshButton.snp.height)
    }
  }
  
  @objc private func activateRefreshButton() {
    refreshButtonHandler?()
  }
  
  @objc private func activateShareButton() {
    shareButtonHandler?()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}


import SwiftUI
struct BottomTabBarPresentable: UIViewRepresentable {
  typealias UIViewType = BottomTabBar
  
  func makeUIView(context: UIViewRepresentableContext<BottomTabBarPresentable>) -> UIViewType {
    return UIViewType()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
}

struct BottomTabBarPreview: PreviewProvider {
  static var previews: some View {
    BottomTabBarPresentable()
      .frame(width: 340, height: 66)
      .previewLayout(.sizeThatFits)
  }
}
