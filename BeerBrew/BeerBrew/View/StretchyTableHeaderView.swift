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
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  private var imageViewHeight = NSLayoutConstraint()
  private var imageViewBottom = NSLayoutConstraint()
  private var containerView = UIView()
  private var containerViewHeight = NSLayoutConstraint()
  
  
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
    addSubview(containerView)
    containerView.addSubview(imageView)
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalTo: containerView.widthAnchor),
      centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      heightAnchor.constraint(equalTo: containerView.heightAnchor)
    ])
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor )
    containerViewHeight.isActive = true
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    imageViewBottom.isActive = true
    imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
    imageViewHeight.isActive = true
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    containerViewHeight.constant = scrollView.contentInset.top
    let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
    containerView.clipsToBounds = offsetY <= 0
    imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
    imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
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
