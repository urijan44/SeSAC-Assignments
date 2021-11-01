//
//  UIFont+Extensions.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

extension UIFont {
  static let mainLight = UIFont(name: "S-CoreDream-3Light", size: 17)!
  static let mainExtraBold = UIFont(name: "S-CoreDream-7ExtraBold", size: 17)!
  func mainLight(fontSize: CGFloat) -> UIFont {
    UIFont(name: "S-CoreDream-3Light", size: fontSize)!
  }
  func mainBold(fontSize: CGFloat) -> UIFont {
    UIFont(name: "S-CoreDream-6Bold", size: fontSize)!
  }
}
