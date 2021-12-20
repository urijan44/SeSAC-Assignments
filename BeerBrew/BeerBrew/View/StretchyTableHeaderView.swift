//
//  StretchyTableHeaderView.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import SnapKit

protocol StretchyTableHeaderViewDelegate: AnyObject {
  func stretchyTableHeaderView(_ view: StretchyTableHeaderView, expandedView: Bool)
}

final class StretchyTableHeaderView: UIView {
  
  var beer: Beer? {
    didSet {
      titlelabel.text = beer?.name
      originLabel.text = beer?.origin
      descriptionLabel.text = beer?.description
    }
  }
  
  var beerImage: UIImage? {
    didSet {
      imageView.image = beerImage
    }
  }
  
  weak var delegate: StretchyTableHeaderViewDelegate?
  
  public let imageView: UIImageView = {
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
  
  private let titlelabel = UILabel()
  private let originLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let moreButton = UIButton()
  
  private var imageViewHeight = NSLayoutConstraint()
  private var imageViewBottom = NSLayoutConstraint()
  var containerView = UIView()
  private var containerViewHeight = NSLayoutConstraint()
  
  private var descriptionHeight = NSLayoutConstraint()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    createViews()
    setViewConstraints()
    descriptionViewConfigure()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createViews() {
    addSubview(containerView)
    containerView.addSubview(imageView)
  }
  
  func setViewConstraints() {
//    NSLayoutConstraint.activate([
//      widthAnchor.constraint(equalTo: containerView.widthAnchor),
//      centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//      heightAnchor.constraint(equalTo: containerView.heightAnchor)
//    ])
    containerView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalToSuperview()
    }

    addSubview(descriptionView)
    descriptionView.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.9)
      make.centerX.equalToSuperview()
      make.top.equalTo(snp.centerY)
    }
    
    descriptionHeight = descriptionView.heightAnchor.constraint(equalToConstant: 180)
    descriptionHeight.isActive = true
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    
    imageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.5)
      make.top.equalToSuperview()
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
    
    if let beer = beer {
      titlelabel.text = beer.name
      originLabel.text = beer.origin
      descriptionLabel.text = beer.description
    }
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
    
    if descriptionHeight.constant == 180 {
      descriptionHeight.constant = 350
      delegate?.stretchyTableHeaderView(self, expandedView: true)
    } else {
      print("축소")
      delegate?.stretchyTableHeaderView(self, expandedView: false)
      descriptionHeight.constant = 180
    }
    
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
      self.layoutIfNeeded()
    }

  }
}


#if DEBUG
import SwiftUI
struct StretchyTableHeaderViewRepresentable: UIViewRepresentable {
  typealias UIViewType = StretchyTableHeaderView
  
  func makeUIView(context: UIViewRepresentableContext<StretchyTableHeaderViewRepresentable>) ->  StretchyTableHeaderView {
    StretchyTableHeaderView()
  }
  
  func updateUIView(_ uiView: StretchyTableHeaderView, context: Context) {
    uiView.imageView.image = UIImage(systemName: "circle")
    uiView.beer = Beer(name: "Clown King", origin: "US Style Barley Wine.", description: "A titillating, neurotic, peroxide punk of a Pale Ale. Combining attitude, style, substance, and a little bit of low self esteem for good measure; what would your mother say? The seductive lure of the sassy passion fruit hop proves too much to resist. All that is even before we get onto the fact that there are no additives, preservatives, pasteurization or strings attached. All wrapped up with the customary BrewDog bite and imaginative twist")
  }
  
}

struct StretchyTableHeaderViewPreview: PreviewProvider {
  static var previews: some View {
    StretchyTableHeaderViewRepresentable()
      .frame(width: 340, height: 340 + 180)
      .previewLayout(.sizeThatFits)
  }
}


#endif
