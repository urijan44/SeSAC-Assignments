//
//  HexColorConvert.swift
//  AnniversaryCounter
//
//  Created by hoseung Lee on 2021/10/07.
//

import UIKit

///HEX 값으로 UIColor를 생성하는 생성자 오버로딩
///패턴은 #부터 시작해서 총 7글자여야 한다.
///예 #EC007F (대소문자는 상관하지 않음)
extension UIColor {
  convenience init(hexString: String, alpha: CGFloat = 1.0) {
    var validate = hexString
    if validate.first != "#"  {
      validate = "#000000"
    }
    
    var cutting = validate.map{$0}
    cutting.removeFirst()
    
    let r = String(cutting[0...1])
    let g = String(cutting[2...3])
    let b = String(cutting[4...5])
    
    let redInt = CGFloat(Int(r, radix: 16) ?? 0) / 255.0
    let greenInt = CGFloat(Int(g, radix: 16) ?? 0) / 255.0
    let blueInt = CGFloat(Int(b, radix: 16) ?? 0) / 255.0
    
    self.init(red: redInt, green: greenInt, blue: blueInt, alpha: alpha)
  }
}
