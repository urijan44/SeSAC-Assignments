//
//  ParingHeaderView.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import SnapKit

final class ParingHeaderView: UIView {
  
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    return label
  }()
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(snp.centerY)
      make.leading.trailing.equalToSuperview().inset(8)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
}

#if DEBUG
import SwiftUI
struct ParingHeaderViewRepresentable: UIViewRepresentable {
  typealias UIViewType = ParingHeaderView
  
  func makeUIView(context: UIViewRepresentableContext<ParingHeaderViewRepresentable>) ->  ParingHeaderView {
    ParingHeaderView()
  }
  
  func updateUIView(_ uiView: ParingHeaderView, context: Context) {
    uiView.title = "Food - Paring"
  }
  
}

struct ParingHeaderViewPreview: PreviewProvider {
  static var previews: some View {
    ParingHeaderViewRepresentable()
      .frame(width: 340, height: 44)
      .previewLayout(.sizeThatFits)
  }
}


#endif
