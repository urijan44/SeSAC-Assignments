//
//  CategorySupplementaryView.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit
import SnapKit

final class CategorySupplementaryView: UICollectionReusableView {
  
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configure() {
    addSubview(label)
    label.textColor = .white
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.textAlignment = .left
    label.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(5)
    }
  }
}
