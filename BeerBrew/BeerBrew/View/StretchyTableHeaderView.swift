//
//  StretchyTableHeaderView.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import SnapKit

final class StretchyTableHeaderView: UIView {
  
  var beerImage: UIImage? {
    didSet {
      imageView.image = beerImage
    }
  }
  
  public let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  public var containerView = BeerDescriptionView()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    createViews()
    setViewConstraints()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createViews() {
    addSubview(imageView)
    addSubview(containerView)
  }
  
  private func setViewConstraints() {
    imageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(8)
      make.height.equalToSuperview().multipliedBy(0.5)
      make.width.equalTo(snp.height).multipliedBy(0.5)
    }
    
    containerView.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(-60)
      make.centerX.equalToSuperview()
      make.leading.trailing.bottom.equalToSuperview().inset(8)
    }
    containerView.isUserInteractionEnabled = true
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    if offset < 0 {
      imageView.snp.updateConstraints { make in
        make.height.equalToSuperview().multipliedBy(0.5).offset(-offset)
      }
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
    uiView.imageView.image = UIImage(named: "Bundarberg")
    uiView.containerView.beerConfigure(beer: Beer(name: "맥주", origin: "우리집산", description: "매우매우 긴 디테일매우매우 긴 디테일매우매우 긴 디테일매우매우 긴 디테일매우매우 긴 디테일매우매우 긴 디테일매우매우 긴 디테일매우매우 긴 디테일", imageURL: nil, foodPairing: []))
  }
  
}

struct StretchyTableHeaderViewPreview: PreviewProvider {
  static var previews: some View {
    StretchyTableHeaderViewRepresentable()
      .frame(width: 340, height: 340)
      .previewLayout(.sizeThatFits)
  }
}

#endif
