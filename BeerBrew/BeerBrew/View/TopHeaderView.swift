//
//  TopHeaderView.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/21.
//

import UIKit

protocol TopHeaderViewDelegate: AnyObject {
  func topHeaderView(_ view: TopHeaderView, expandedView: Bool)
}


class TopHeaderView: UIView {
  
  let beerImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  private let descriptionView: UIView = {
    let uiView = UIView()
    uiView.layer.cornerRadius = 8
    uiView.backgroundColor = .white
    return uiView
  }()
  
  var imageHeight = 160
  var descriptionHeight = 160
  var beerImage = UIImage(named: "Bundarberg")
  
  private let titlelabel = UILabel()
  private let originLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let moreButton = UIButton()
  
  weak var delegate: TopHeaderViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    viewCreate()
    layoutConfigure()
    beerImageView.image = beerImage
    descriptionViewConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func viewCreate() {
    addSubview(beerImageView)
    addSubview(descriptionView)
  }
  
  private func layoutConfigure() {
    beerImageView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
      make.top.equalTo(snp.top)
      make.height.equalTo(imageHeight)
    }
    
    descriptionView.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.9)
      make.centerX.equalToSuperview()
      make.height.equalTo(descriptionHeight)
      make.top.equalTo(beerImageView.snp.bottom).offset(60)
    }
  }
  
  private func descriptionViewConfigure() {
    descriptionView.layer.shadowRadius = 2
    descriptionView.layer.shadowOffset = .init(width: 1, height: 1)
    descriptionView.layer.shadowOpacity = 0.4

    
    descriptionView.addSubview(titlelabel)
    descriptionView.addSubview(originLabel)
    descriptionView.addSubview(descriptionLabel)
    descriptionView.addSubview(moreButton)
    
    moreButton.setTitle("more", for: .normal)
    
    titlelabel.textAlignment = .center
    titlelabel.font = .systemFont(ofSize: 22, weight: .bold)
    titlelabel.textColor = .black
    titlelabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(descriptionView.snp.top).inset(15)
      make.leading.trailing.equalToSuperview().inset(10)
    }
    
    moreButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(5)
    }
    
    moreButton.addTarget(self, action: #selector(descriptionExpend), for: .touchUpInside)
    moreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    moreButton.setTitleColor(.black, for: .normal)
    
    originLabel.snp.makeConstraints { make in
      make.top.equalTo(titlelabel.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
    originLabel.textAlignment = .center
    originLabel.font = .systemFont(ofSize: 14)
    
    descriptionLabel.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.9)
      make.centerX.equalToSuperview()
      make.top.equalTo(originLabel.snp.bottom).offset(10)
    }
    descriptionLabel.font = .systemFont(ofSize: 15)
    descriptionLabel.numberOfLines = 4
  }
  
  @objc private func descriptionExpend() {
    print(#function)
    if descriptionLabel.numberOfLines == 4 {
      descriptionLabel.numberOfLines = 0
    } else {
      descriptionLabel.numberOfLines = 4
    }
    
    if descriptionHeight == 180 {
      descriptionHeight = 350
      descriptionView.snp.updateConstraints { make in
        make.height.equalTo(descriptionHeight)
      }
      delegate?.topHeaderView(self, expandedView: true)
    } else {
      descriptionView.snp.updateConstraints { make in
        make.height.equalTo(descriptionHeight)
      }
      descriptionHeight = 180
      delegate?.topHeaderView(self, expandedView: false)
    }
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
      self.layoutIfNeeded()
    }

  }
}

#if DEBUG
import SwiftUI
struct TopHeaderViewRepresentable: UIViewRepresentable {
  typealias UIViewType = TopHeaderView
  
  func makeUIView(context: UIViewRepresentableContext<TopHeaderViewRepresentable>) ->  TopHeaderView {
    TopHeaderView()
  }
  
  func updateUIView(_ uiView: TopHeaderView, context: Context) {

  }
  
}

struct TopHeaderViewRepresentablePreview: PreviewProvider {
  static var previews: some View {
    TopHeaderViewRepresentable()
      .frame(width: 340, height: 340 + 180)
      .previewLayout(.sizeThatFits)
  }
}

#endif
