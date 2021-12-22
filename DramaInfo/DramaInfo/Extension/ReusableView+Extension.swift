//
//  ReusableView+Extension.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/23.
//

import UIKit

protocol ReusableView {
  static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableView {
  static var reuseIdentifier: String {
    self.description()
  }
}

//extension UICollectionViewCell: ReusableView {
//  static var reuseIdentifier: String {
//    self.description()
//  }
//}

extension UICollectionReusableView: ReusableView {
  static var reuseIdentifier: String {
    self.description()
  }
}
