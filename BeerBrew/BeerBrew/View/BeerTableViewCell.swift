//
//  BeerTableViewCell.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import SwiftUI

class BeerTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "BeerTableViewCell"
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17)
    label.textColor = .black
    return label
  }()
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func layoutConfigure() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(snp.leading).inset(18)
      make.trailing.equalTo(snp.trailing).inset(18)
    }
  }
}


#if DEBUG
import SwiftUI
struct BeerTableViewCellRepresentable: UIViewRepresentable {
  typealias UIViewType = BeerTableViewCell
  
  func makeUIView(context: UIViewRepresentableContext<BeerTableViewCellRepresentable>) ->  BeerTableViewCell {
    BeerTableViewCell()
  }
  
  func updateUIView(_ uiView: BeerTableViewCell, context: Context) {
    uiView.title = "BundarBerg"
  }
  
}

struct BeerTableViewCellPreview: PreviewProvider {
  static var previews: some View {
    BeerTableViewCellRepresentable()
      .frame(width: 340, height: 44)
      .previewLayout(.sizeThatFits)
  }
}


#endif
